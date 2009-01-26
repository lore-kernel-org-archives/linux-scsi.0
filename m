From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add res_pr_all_tgt_pts,
	res_pr_generation and res_pr_registered_i_pts
Date: Mon, 26 Jan 2009 01:11:43 -0800
Message-ID: <1232961103.24642.135.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:28223 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750978AbZAZJMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:12:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>, Linus Torvalds <torvalds@linux-foundation.org>

>From 45345eb366caa5f823cc3177e36fc80a356e0ab8 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:49:29 -0800
Subject: [PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add res_pr_all_tgt_pts, res_pr_generation and res_pr_registered_i_pts

This patch adds support for the following Target_Core_Mod/ConfigFS attributes on a *PER*
/sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT basis:

|-- pscsi_0
|   |-- hba_info
|   `-- sdd
|       |-- attrib
|       |   |-- hw_max_sectors
|       |   |-- hw_queue_depth
|       |   |-- max_sectors
|       |   |-- queue_depth
|       |   |-- status_thread
|       |   |-- status_thread_tur
|       |   `-- task_timeout
<SNIP>
|       |-- pr
|       |   |-- res_holder
|       |   |-- res_pr_all_tgt_pts
|       |   |-- res_pr_generation
|       |   |-- res_pr_registered_i_pts
|       |   `-- res_type
|       `-- wwn
|           |-- evpd_assoc_logical_unit
|           |-- evpd_assoc_scsi_target_device
|           |-- evpd_assoc_target_port
|           |-- evpd_protocol_identifier
|           `-- evpd_unit_serial

This patch also renames PR ConfigFS attribute res_active -> res_holder to better
reflect language in >= SPC-3 NCITS T10 Standards Documents.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |  107 +++++++++++++++++++++++++++++--
 1 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 1788fbb..1a3f754 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -779,7 +779,7 @@ static struct target_core_dev_pr_attribute target_core_dev_pr_##_name =		\
 	target_core_dev_pr_show_attr_##_name);					\
 
 /*
- * res_active
+ * res_holder
  */
 static ssize_t target_core_dev_pr_show_spc3_res (
 	struct se_device_s *dev,
@@ -811,12 +811,15 @@ static ssize_t target_core_dev_pr_show_spc2_res (
 	return(*len);
 }
 
-static ssize_t target_core_dev_pr_show_attr_res_active (
+static ssize_t target_core_dev_pr_show_attr_res_holder (
 	struct se_subsystem_dev_s *su_dev,
 	char *page)
 {
 	ssize_t len = 0;
 
+	if (!(su_dev->se_dev_ptr))
+		return(-ENODEV);
+
 	switch (T10_RES(su_dev)->res_type) {
 	case SPC3_PERSISTENT_RESERVATIONS:
 		target_core_dev_pr_show_spc3_res(su_dev->se_dev_ptr,
@@ -827,7 +830,7 @@ static ssize_t target_core_dev_pr_show_attr_res_active (
 				page, &len);
 		break;
 	case SPC_PASSTHROUGH:
-		len += sprintf(page+len, "None\n");
+		len += sprintf(page+len, "Passthrough\n");
 		break;
 	default:
 		len += sprintf(page+len, "Unknown\n");
@@ -837,7 +840,93 @@ static ssize_t target_core_dev_pr_show_attr_res_active (
 	return(len);
 }
 
-SE_DEV_PR_ATTR_RO(res_active);
+SE_DEV_PR_ATTR_RO(res_holder);
+
+/*
+ * res_pr_all_tgt_pts
+ */
+static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	ssize_t len = 0;
+
+	if (!(su_dev->se_dev_ptr))
+		return(-ENODEV);
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
+		return(sprintf(page, "res_pr_generation only valid for"
+			" SPC3_PERSISTENT_RESERVATIONS\n"));
+	}
+
+	len = sprintf(page, "Not Implemented yet\n");
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_pr_all_tgt_pts);
+
+/*
+ * res_pr_generation
+ */
+static ssize_t target_core_dev_pr_show_attr_res_pr_generation (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	if (!(su_dev->se_dev_ptr))
+		return(-ENODEV);
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
+		return(sprintf(page, "res_pr_generation only valid for"
+			" SPC3_PERSISTENT_RESERVATIONS\n"));
+	}
+
+	return(sprintf(page, "0x%08x\n", T10_RES(su_dev)->pr_generation));
+}
+
+SE_DEV_PR_ATTR_RO(res_pr_generation);
+
+/*
+ * res_pr_registered_i_pts
+ */
+static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	struct target_core_fabric_ops *tfo;
+	t10_pr_registration_t *pr_reg;
+	unsigned char buf[384];
+	ssize_t len = 0;
+
+	if (!(su_dev->se_dev_ptr))
+		return(-ENODEV);
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
+		len = sprintf(page, "res_pr_registered_i_pts only valid for"
+			" SPC3_PERSISTENT_RESERVATIONS\n");
+		return(len);
+	}
+	spin_lock(&T10_RES(su_dev)->registration_lock);
+	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+			pr_reg_list) {
+
+		memset(buf, 0, 384);
+		tfo = pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
+		sprintf(buf, "%s Node: %s Key: 0x%016Lx PRgen: 0x%08x\n",
+			tfo->get_fabric_name(),
+			pr_reg->pr_reg_nacl->initiatorname,
+			pr_reg->pr_res_key, pr_reg->pr_res_generation);
+
+		if ((len + strlen(buf) > PAGE_SIZE))
+			break;
+
+		len += sprintf(page+len, "%s", buf);	
+	}
+	spin_unlock(&T10_RES(su_dev)->registration_lock);
+
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_pr_registered_i_pts);
 
 /*
  * res_type
@@ -847,6 +936,9 @@ static ssize_t target_core_dev_pr_show_attr_res_type (
 	char *page)
 {
 	ssize_t len = 0;
+
+	if (!(su_dev->se_dev_ptr))
+		return(-ENODEV);
 	
 	switch (T10_RES(su_dev)->res_type) {
 	case SPC3_PERSISTENT_RESERVATIONS:
@@ -871,7 +963,10 @@ SE_DEV_PR_ATTR_RO(res_type);
 CONFIGFS_EATTR_OPS(target_core_dev_pr, se_subsystem_dev_s, se_dev_pr_group);
 
 static struct configfs_attribute *target_core_dev_pr_attrs[] = {
-	&target_core_dev_pr_res_active.attr,
+	&target_core_dev_pr_res_holder.attr,
+	&target_core_dev_pr_res_pr_all_tgt_pts.attr,
+	&target_core_dev_pr_res_pr_generation.attr,
+	&target_core_dev_pr_res_pr_registered_i_pts.attr,
 	&target_core_dev_pr_res_type.attr,
 	NULL,
 };
@@ -1128,6 +1223,8 @@ static struct config_group *target_core_call_createdev (
 	}
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_evpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_evpd_lock);
+	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
+	spin_lock_init(&se_dev->t10_reservation.registration_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
 
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
-- 
1.5.4.1



