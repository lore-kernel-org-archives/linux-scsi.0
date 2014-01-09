From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 11/11] Target/configfs: Expose iSCSI network portal group T10-PI support
Date: Thu,  9 Jan 2014 18:40:58 +0200
Message-ID: <1389285658-7037-12-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57729 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755498AbaAIQlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 11:41:12 -0500
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com

User may enable T10-PI support per network portal group. any connection
established on top of it, will be required to serve protected transactions.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c |    6 ++++++
 drivers/target/iscsi/iscsi_target_tpg.c      |   19 +++++++++++++++++++
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index e3318ed..8f3f585 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1051,6 +1051,11 @@ TPG_ATTR(demo_mode_discovery, S_IRUGO | S_IWUSR);
  */
 DEF_TPG_ATTRIB(default_erl);
 TPG_ATTR(default_erl, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_t10_pi
+ */
+DEF_TPG_ATTRIB(t10_pi);
+TPG_ATTR(t10_pi, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_authentication.attr,
@@ -1063,6 +1068,7 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_prod_mode_write_protect.attr,
 	&iscsi_tpg_attrib_demo_mode_discovery.attr,
 	&iscsi_tpg_attrib_default_erl.attr,
+	&iscsi_tpg_attrib_t10_pi.attr,
 	NULL,
 };
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 80ae14c..d95a5f2 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -860,3 +860,22 @@ int iscsit_ta_default_erl(
 
 	return 0;
 }
+
+int iscsit_ta_t10_pi(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
+
+	if ((flag != 0) && (flag != 1)) {
+		pr_err("Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->t10_pi = flag;
+	pr_debug("iSCSI_TPG[%hu] - T10 Protection information bit:"
+		" %s\n", tpg->tpgt, (a->t10_pi) ?
+		"ON" : "OFF");
+
+	return 0;
+}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 213c0fc..0a182f2 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -39,5 +39,6 @@ extern int iscsit_ta_demo_mode_write_protect(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_prod_mode_write_protect(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_demo_mode_discovery(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_default_erl(struct iscsi_portal_group *, u32);
+extern int iscsit_ta_t10_pi(struct iscsi_portal_group *, u32);
 
 #endif /* ISCSI_TARGET_TPG_H */
-- 
1.7.1

