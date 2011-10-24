From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 9/9] ib_srpt: Convert srpt_sq_size into per port configfs attribute
Date: Mon, 24 Oct 2011 05:33:42 +0000
Message-ID: <1319434422-15354-10-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59599 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1JXFfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 01:35:31 -0400
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the srpt_sq_size module parameter into a per
port configfs attribute.  This includes adding the necessary bits for
show + store attributes w/ min/max bounds checking, and dropping the
legacy srp_max_rsp_size module parameter checks in srpt_init_module().

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   63 ++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    2 +
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f4a900b..9e1c5e0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -88,11 +88,6 @@ module_param(srpt_srq_size, int, 0444);
 MODULE_PARM_DESC(srpt_srq_size,
 		 "Shared receive queue (SRQ) size.");
 
-static int srpt_sq_size = DEF_SRPT_SQ_SIZE;
-module_param(srpt_sq_size, int, 0444);
-MODULE_PARM_DESC(srpt_sq_size,
-		 "Per-channel send queue (SQ) size.");
-
 static int srpt_get_u64_x(char *buffer, struct kernel_param *kp)
 {
 	return sprintf(buffer, "0x%016llx", *(u64 *)kp->arg);
@@ -2133,7 +2128,8 @@ static int srpt_compl_thread(void *arg)
 static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 {
 	struct ib_qp_init_attr *qp_init;
-	struct srpt_device *sdev = ch->sport->sdev;
+	struct srpt_port *sport = ch->sport;
+	struct srpt_device *sdev = sport->sdev;
 	int ret;
 
 	WARN_ON(ch->rq_size < 1);
@@ -2144,11 +2140,11 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
-			      ch->rq_size + srpt_sq_size, 0);
+			      ch->rq_size + sport->port_attrib.srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		printk(KERN_ERR "failed to create CQ cqe= %d ret= %d\n",
-		       ch->rq_size + srpt_sq_size, ret);
+		       ch->rq_size + sport->port_attrib.srp_sq_size, ret);
 		goto out;
 	}
 
@@ -2160,7 +2156,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	qp_init->srq = sdev->srq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_init->qp_type = IB_QPT_RC;
-	qp_init->cap.max_send_wr = srpt_sq_size;
+	qp_init->cap.max_send_wr = sport->port_attrib.srp_sq_size;
 	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
@@ -3289,6 +3285,7 @@ static void srpt_add_one(struct ib_device *device)
 		sport->port = i;
 		sport->port_attrib.srp_max_rdma_size = DEFAULT_MAX_RDMA_SIZE;
 		sport->port_attrib.srp_max_rsp_size = DEFAULT_MAX_RSP_SIZE;
+		sport->port_attrib.srp_sq_size = DEF_SRPT_SQ_SIZE;
 		INIT_WORK(&sport->work, srpt_refresh_port_work);
 		INIT_LIST_HEAD(&sport->port_acl_list);
 		spin_lock_init(&sport->port_acl_lock);
@@ -3772,9 +3769,50 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
 
 TF_TPG_ATTRIB_ATTR(srpt, srp_max_rsp_size, S_IRUGO | S_IWUSR);
 
+static ssize_t srpt_tpg_attrib_show_srp_sq_size(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+
+	return sprintf(page, "%u\n", sport->port_attrib.srp_sq_size);
+}
+
+static ssize_t srpt_tpg_attrib_store_srp_sq_size(
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
+	if (val > MAX_SRPT_SRQ_SIZE) {
+		pr_err("val: %lu exceeds MAX_SRPT_SRQ_SIZE: %d\n", val,
+			MAX_SRPT_SRQ_SIZE);
+		return -EINVAL;
+	}
+	if (val < MIN_SRPT_SRQ_SIZE) {
+		pr_err("val: %lu smaller than MIN_SRPT_SRQ_SIZE: %d\n", val,
+			MIN_SRPT_SRQ_SIZE);
+		return -EINVAL;
+	}
+	sport->port_attrib.srp_sq_size = val;
+
+	return count;
+}
+
+TF_TPG_ATTRIB_ATTR(srpt, srp_sq_size, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *srpt_tpg_attrib_attrs[] = {
 	&srpt_tpg_attrib_srp_max_rdma_size.attr,
 	&srpt_tpg_attrib_srp_max_rsp_size.attr,
+	&srpt_tpg_attrib_srp_sq_size.attr,
 	NULL,
 };
 
@@ -3981,13 +4019,6 @@ static int __init srpt_init_module(void)
 		goto out;
 	}
 
-	if (srpt_sq_size < MIN_SRPT_SQ_SIZE) {
-		printk(KERN_ERR "invalid value %d for kernel module parameter"
-		       " srpt_sq_size -- must be at least %d.\n", srpt_srq_size,
-		       MIN_SRPT_SQ_SIZE);
-		goto out;
-	}
-
 	spin_lock_init(&srpt_dev_lock);
 	INIT_LIST_HEAD(&srpt_dev_list);
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 27b1027..1b607ae 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -331,10 +331,12 @@ struct srpt_rdma_ch {
  * struct srpt_port_attib - Attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
  * @srp_max_rsp_size: Maximum size of SRP response messages in bytes.
+ * @srp_sq_size: Shared receive queue (SRQ) size.
  */
 struct srpt_port_attrib {
 	u32			srp_max_rdma_size;
 	u32			srp_max_rsp_size;
+	u32			srp_sq_size;
 };
 
 /**
-- 
1.7.2.5

