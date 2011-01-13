From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Convert remaining usage of simple_strtoul -> strict_strtoul
Date: Wed, 12 Jan 2011 16:28:01 -0800
Message-ID: <1294878481-6746-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:36529 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756402Ab1AMA2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 19:28:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the three remaining simple_strtoul() calls into
strict_strtoul() within target_core_fabric_configfs.c code for TPG LUN,
MappedLUN groups, and MappedLUN/write_protect attribute.  This patch
also includes one minor fix in target_fabric_make_lun() for TPG LUN
to explictly check for a 'lun_' needle.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   41 +++++++++++--------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 5d1a81d..c7d5873 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -188,14 +188,14 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 {
 	struct se_node_acl *se_nacl = lacl->se_lun_nacl;
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
-	char *endptr;
-	u32 op;
+	unsigned long op;
 
-	op = simple_strtoul(page, &endptr, 0);
-	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for access: %u\n", op);
+	if (strict_strtoul(page, 0, &op))
 		return -EINVAL;
-	}
+
+	if ((op != 1) && (op != 0))
+		return -EINVAL;
+
 	core_update_device_list_access(lacl->mapped_lun, (op) ?
 			TRANSPORT_LUNFLAGS_READ_ONLY :
 			TRANSPORT_LUNFLAGS_READ_WRITE,
@@ -284,8 +284,8 @@ static struct config_group *target_fabric_make_mappedlun(
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 	struct se_lun_acl *lacl;
 	struct config_item *acl_ci;
-	char *buf, *endptr, *ptr;
-	u32 mapped_lun;
+	char *buf;
+	unsigned long mapped_lun;
 	int ret = 0;
 
 	acl_ci = &group->cg_item;
@@ -303,22 +303,20 @@ static struct config_group *target_fabric_make_mappedlun(
 	/*
 	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
 	 */
-	ptr = strstr(buf, "lun_");
-	if (!(ptr)) {
+	if (strstr(buf, "lun_") != buf) {
 		printk(KERN_ERR "Unable to locate \"lun_\" from buf: %s"
 			" name: %s\n", buf, name);
 		ret = -EINVAL;
 		goto out;
 	}
-	ptr += 3; /* Skip to "_" */
-	*ptr = '\0'; /* Terminate the string */
-	ptr++; /* Advance pointer to next characater */
-
 	/*
 	 * Determine the Mapped LUN value.  This is what the SCSI Initiator
 	 * Port will actually see.
 	 */
-	mapped_lun = simple_strtoul(ptr, &endptr, 0);
+	if (strict_strtoul(buf + 4, 0, &mapped_lun) || mapped_lun > UINT_MAX) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
 			config_item_name(acl_ci), &ret);
@@ -748,18 +746,15 @@ static struct config_group *target_fabric_make_lun(
 	struct se_portal_group *se_tpg = container_of(group,
 			struct se_portal_group, tpg_lun_group);
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
-	
-	char *str, *endptr;
-	u32 unpacked_lun;
+	unsigned long unpacked_lun;
 
-	str = strstr(name, "_");
-	if (!(str)) {
+	if (strstr(name, "lun_") != name) {
 		printk(KERN_ERR "Unable to locate \'_\" in"
 				" \"lun_$LUN_NUMBER\"\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
-	str++; /* Advance over _ delim.. */
-	unpacked_lun = simple_strtoul(str, &endptr, 0);
+	if (strict_strtoul(name + 4, 0, &unpacked_lun) || unpacked_lun > UINT_MAX)
+		return ERR_PTR(-EINVAL);
 
 	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
 	if (!(lun))
-- 
1.7.3.5

