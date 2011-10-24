From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port configfs attribute
Date: Mon, 24 Oct 2011 05:33:40 +0000
Message-ID: <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the srp_max_rdma_size module parameter into a per
endpoint configfs attribute.  This includes adding the necessary bits
for show + store attributes w/ min/max bounds checking, and updating
srpt_get_ioc() to accept a struct srpt_port parameter.

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   60 ++++++++++++++++++++++++++++-----
 drivers/infiniband/ulp/srpt/ib_srpt.h |   10 +++++
 2 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5c61ba4..80ef5af 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -78,11 +78,6 @@ static u64 srpt_service_guid;
 static spinlock_t srpt_dev_lock;       /* Protects srpt_dev_list. */
 static struct list_head srpt_dev_list; /* List of srpt_device structures. */
 
-static unsigned srp_max_rdma_size = DEFAULT_MAX_RDMA_SIZE;
-module_param(srp_max_rdma_size, int, 0744);
-MODULE_PARM_DESC(srp_max_rdma_size,
-		 "Maximum size of SRP RDMA transfers for new connections.");
-
 static unsigned srp_max_req_size = DEFAULT_MAX_REQ_SIZE;
 module_param(srp_max_req_size, int, 0444);
 MODULE_PARM_DESC(srp_max_req_size,
@@ -342,9 +337,10 @@ static void srpt_get_iou(struct ib_dm_mad *mad)
  * Architecture Specification. See also section B.7, table B.7 in the SRP
  * r16a document.
  */
-static void srpt_get_ioc(struct srpt_device *sdev, u32 slot,
+static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 			 struct ib_dm_mad *mad)
 {
+	struct srpt_device *sdev = sport->sdev;
 	struct ib_dm_ioc_profile *iocp;
 
 	iocp = (struct ib_dm_ioc_profile *)mad->data;
@@ -376,7 +372,7 @@ static void srpt_get_ioc(struct srpt_device *sdev, u32 slot,
 	iocp->send_queue_depth = cpu_to_be16(sdev->srq_size);
 	iocp->rdma_read_depth = 4;
 	iocp->send_size = cpu_to_be32(srp_max_req_size);
-	iocp->rdma_size = cpu_to_be32(min(max(srp_max_rdma_size, 256U),
+	iocp->rdma_size = cpu_to_be32(min(sport->port_attrib.srp_max_rdma_size,
 					  1U << 24));
 	iocp->num_svc_entries = 1;
 	iocp->op_cap_mask = SRP_SEND_TO_IOC | SRP_SEND_FROM_IOC |
@@ -445,7 +441,7 @@ static void srpt_mgmt_method_get(struct srpt_port *sp, struct ib_mad *rq_mad,
 		break;
 	case DM_ATTR_IOC_PROFILE:
 		slot = be32_to_cpu(rq_mad->mad_hdr.attr_mod);
-		srpt_get_ioc(sp->sdev, slot, rsp_mad);
+		srpt_get_ioc(sp, slot, rsp_mad);
 		break;
 	case DM_ATTR_SVC_ENTRIES:
 		slot = be32_to_cpu(rq_mad->mad_hdr.attr_mod);
@@ -3297,6 +3293,7 @@ static void srpt_add_one(struct ib_device *device)
 		sport = &sdev->port[i - 1];
 		sport->sdev = sdev;
 		sport->port = i;
+		sport->port_attrib.srp_max_rdma_size = DEFAULT_MAX_RDMA_SIZE;
 		INIT_WORK(&sport->work, srpt_refresh_port_work);
 		INIT_LIST_HEAD(&sport->port_acl_list);
 		spin_lock_init(&sport->port_acl_lock);
@@ -3700,6 +3697,51 @@ static void srpt_drop_nodeacl(struct se_node_acl *se_nacl)
 	srpt_release_fabric_acl(NULL, se_nacl);
 }
 
+static ssize_t srpt_tpg_attrib_show_srp_max_rdma_size(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+
+	return sprintf(page, "%u\n", sport->port_attrib.srp_max_rdma_size);
+}
+
+static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	unsigned long val;
+	int ret;
+	
+	ret = strict_strtoul(page, 0, &val);
+	if (ret < 0) {
+		pr_err("strict_strtoul() failed with ret: %d\n", ret);
+		return -EINVAL;
+	}
+	if (val > MAX_SRPT_RDMA_SIZE) {
+		pr_err("val: %lu exceeds MAX_SRPT_RDMA_SIZE: %d\n", val,
+			MAX_SRPT_RDMA_SIZE);
+		return -EINVAL;
+	}
+	if (val < DEFAULT_MAX_RDMA_SIZE) {
+		pr_err("val: %lu smaller than DEFAULT_MAX_RDMA_SIZE: %d\n",
+			val, DEFAULT_MAX_RDMA_SIZE);
+		return -EINVAL;
+	}
+	sport->port_attrib.srp_max_rdma_size = val;
+	
+	return count;
+}
+
+TF_TPG_ATTRIB_ATTR(srpt, srp_max_rdma_size, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *srpt_tpg_attrib_attrs[] = {
+	&srpt_tpg_attrib_srp_max_rdma_size.attr,
+	NULL,
+};
+
 static ssize_t srpt_tpg_show_enable(
 	struct se_portal_group *se_tpg,
 	char *page)
@@ -3937,7 +3979,7 @@ static int __init srpt_init_module(void)
 	 */
 	srpt_target->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = srpt_wwn_attrs;
 	srpt_target->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = srpt_tpg_attrs;
-	srpt_target->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	srpt_target->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = srpt_tpg_attrib_attrs;
 	srpt_target->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	srpt_target->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
 	srpt_target->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 59ee2d7..c9caa90 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -114,6 +114,7 @@ enum {
 	MIN_SRPT_SRQ_SIZE = 4,
 	DEFAULT_SRPT_SRQ_SIZE = 4095,
 	MAX_SRPT_SRQ_SIZE = 65535,
+	MAX_SRPT_RDMA_SIZE = 256U,
 
 	MIN_MAX_REQ_SIZE = 996,
 	DEFAULT_MAX_REQ_SIZE
@@ -326,6 +327,14 @@ struct srpt_rdma_ch {
 };
 
 /**
+ * struct srpt_port_attib - Attributes for SRPT port
+ * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
+ */
+struct srpt_port_attrib {
+	u32			srp_max_rdma_size;
+};
+
+/**
  * struct srpt_port - Information associated by SRPT with a single IB port.
  * @sdev:      backpointer to the HCA information.
  * @mad_agent: per-port management datagram processing information.
@@ -355,6 +364,7 @@ struct srpt_port {
 	struct se_portal_group	port_tpg_1;
 	struct se_wwn		port_wwn;
 	struct list_head	port_acl_list;
+	struct srpt_port_attrib port_attrib;
 };
 
 /**
-- 
1.7.2.5
