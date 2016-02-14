From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 13/34] iscsi-target: add new transport type
Date: Sun, 14 Feb 2016 23:12:07 +0530
Message-ID: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

add new transport type ISCSI_TCP_CXGB4.

This transport has following features
1. TCP/IP offload.
2. iSCSI PDU recovery by reassembling
   TCP segments.
3. Header and Data digest offload.
4. iSCSI segmentation offload(ISO).
5. Direct Data Placement(DDP).

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 79 ++++++++++++++++++++++++++++
 include/target/iscsi/iscsi_target_core.h     |  1 +
 2 files changed, 80 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 2f821de..e09c891 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -182,12 +182,91 @@ out:
 	return rc;
 }
 
+static ssize_t lio_target_np_cxgb4_show(struct config_item *item, char *page)
+{
+	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
+	struct iscsi_tpg_np *tpg_np_cxgb4;
+	ssize_t rb;
+
+	tpg_np_cxgb4 = iscsit_tpg_locate_child_np(tpg_np, ISCSI_TCP_CXGB4);
+	if (tpg_np_cxgb4)
+		rb = sprintf(page, "1\n");
+	else
+		rb = sprintf(page, "0\n");
+
+	return rb;
+}
+
+static ssize_t lio_target_np_cxgb4_store(struct config_item *item,
+					 const char *page, size_t count)
+{
+	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
+	struct iscsi_np *np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np_cxgb4 = NULL;
+	u32 op;
+	int rc = 0;
+
+	rc = kstrtou32(page, 0, &op);
+	if (rc)
+		return rc;
+
+	if ((op != 1) && (op != 0)) {
+		pr_err("Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+
+	np = tpg_np->tpg_np;
+	if (!np) {
+		pr_err("Unable to locate struct iscsi_np from"
+				" struct iscsi_tpg_np\n");
+		return -EINVAL;
+	}
+
+	tpg = tpg_np->tpg;
+	if (iscsit_get_tpg(tpg) < 0)
+		return -EINVAL;
+
+	if (op) {
+		rc = request_module("cxgbit");
+		if (rc != 0) {
+			pr_warn("Unable to request_module for cxgbit\n");
+			rc = 0;
+		}
+
+		tpg_np_cxgb4 = iscsit_tpg_add_network_portal(tpg,
+							     &np->np_sockaddr,
+							     tpg_np,
+							     ISCSI_TCP_CXGB4);
+		if (IS_ERR(tpg_np_cxgb4)) {
+			rc = PTR_ERR(tpg_np_cxgb4);
+			goto out;
+		}
+	} else {
+		tpg_np_cxgb4 = iscsit_tpg_locate_child_np(tpg_np,
+							  ISCSI_TCP_CXGB4);
+		if (tpg_np_cxgb4) {
+			rc = iscsit_tpg_del_network_portal(tpg, tpg_np_cxgb4);
+			if (rc < 0)
+				goto out;
+		}
+	}
+
+	iscsit_put_tpg(tpg);
+	return count;
+out:
+	iscsit_put_tpg(tpg);
+	return rc;
+}
+
 CONFIGFS_ATTR(lio_target_np_, sctp);
 CONFIGFS_ATTR(lio_target_np_, iser);
+CONFIGFS_ATTR(lio_target_np_, cxgb4);
 
 static struct configfs_attribute *lio_target_portal_attrs[] = {
 	&lio_target_np_attr_sctp,
 	&lio_target_np_attr_iser,
+	&lio_target_np_attr_cxgb4,
 	NULL,
 };
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 373d334..0edf18b 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -74,6 +74,7 @@ enum iscsit_transport_type {
 	ISCSI_IWARP_TCP				= 3,
 	ISCSI_IWARP_SCTP			= 4,
 	ISCSI_INFINIBAND			= 5,
+	ISCSI_TCP_CXGB4				= 6,
 };
 
 /* RFC-3720 7.1.4  Standard Connection State Diagram for a Target */
-- 
2.0.2
