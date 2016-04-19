From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 09/13] iscsi-target: add new offload transport type
Date: Wed, 20 Apr 2016 00:00:16 +0530
Message-ID: <7807301091ebef9c10a95120e7f089501cf89436.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add new transport type ISCSI_HW_OFFLOAD,
hw offload transport drivers will use
this transport type.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 76 ++++++++++++++++++++++++++++
 include/target/iscsi/iscsi_target_core.h     |  1 +
 2 files changed, 77 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 97e5b69..3565e07 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -182,12 +182,88 @@ out:
 	return rc;
 }
 
+static ssize_t lio_target_np_hw_offload_show(struct config_item *item,
+					     char *page)
+{
+	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
+	struct iscsi_tpg_np *tpg_np_hw_offload;
+	ssize_t rb;
+
+	tpg_np_hw_offload = iscsit_tpg_locate_child_np(tpg_np,
+						       ISCSI_HW_OFFLOAD);
+	if (tpg_np_hw_offload)
+		rb = sprintf(page, "1\n");
+	else
+		rb = sprintf(page, "0\n");
+
+	return rb;
+}
+
+static ssize_t lio_target_np_hw_offload_store(struct config_item *item,
+					      const char *page, size_t count)
+{
+	struct iscsi_tpg_np *tpg_np = to_iscsi_tpg_np(item);
+	struct iscsi_np *np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np *tpg_np_hw_offload = NULL;
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
+		       " struct iscsi_tpg_np\n");
+		return -EINVAL;
+	}
+
+	tpg = tpg_np->tpg;
+	if (iscsit_get_tpg(tpg) < 0)
+		return -EINVAL;
+
+	if (op) {
+		tpg_np_hw_offload = iscsit_tpg_add_network_portal(tpg,
+				&np->np_sockaddr, tpg_np, ISCSI_HW_OFFLOAD);
+
+		if (IS_ERR(tpg_np_hw_offload)) {
+			rc = PTR_ERR(tpg_np_hw_offload);
+			goto out;
+		}
+	} else {
+		tpg_np_hw_offload = iscsit_tpg_locate_child_np(tpg_np,
+				ISCSI_HW_OFFLOAD);
+
+		if (tpg_np_hw_offload) {
+			rc = iscsit_tpg_del_network_portal(tpg,
+							   tpg_np_hw_offload);
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
+CONFIGFS_ATTR(lio_target_np_, hw_offload);
 
 static struct configfs_attribute *lio_target_portal_attrs[] = {
 	&lio_target_np_attr_sctp,
 	&lio_target_np_attr_iser,
+	&lio_target_np_attr_hw_offload,
 	NULL,
 };
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 01c41f2..110c1fd 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -74,6 +74,7 @@ enum iscsit_transport_type {
 	ISCSI_IWARP_TCP				= 3,
 	ISCSI_IWARP_SCTP			= 4,
 	ISCSI_INFINIBAND			= 5,
+	ISCSI_HW_OFFLOAD			= 6,
 };
 
 /* RFC-3720 7.1.4  Standard Connection State Diagram for a Target */
-- 
2.0.2
