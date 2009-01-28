From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Updates for
	PERSISTENT_RESERVE
Date: Tue, 27 Jan 2009 23:43:08 -0800
Message-ID: <1233128588.6442.154.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39531 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752279AbZA1HoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 02:44:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joel Becker <joel.becker@oracle.com>, Hannes Reinecke <hare@suse.de>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>From ab56467bfab7716f932362e17afd913ad4fce7a9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 23:16:18 -0800
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Updates for PERSISTENT_RESERVE

This patch adds /sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/pr/res_pr_type,
as well as adds functionality for other SPC-3 PERSISTENT_RESERVE output
of existing reservations.  It has been tested with sg_persist, here is what it
looks like with tree /sys/kernel/config

`-- target
    |-- core
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
	<SNIP>
    |   |       |-- pr
    |   |       |   |-- res_holder
    |   |       |   |-- res_pr_all_tgt_pts
    |   |       |   |-- res_pr_generation
    |   |       |   |-- res_pr_registered_i_pts
    |   |       |   |-- res_pr_type
    |   |       |   `-- res_type
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial

cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
SPC-3 Reservation FABRIC[iSCSI]: Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation holder: All Target Ports reserved
0x00000002
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000001
SPC-3 Reservation Type: Write Exclusive Access
SPC3_PERSISTENT_RESERVATIONS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |  116 ++++++++++++++++++++++++++----
 1 files changed, 100 insertions(+), 16 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 68763cc..3dd7dbd 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -40,6 +40,7 @@
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
 #include <target_core_transport.h>
+#include <target_core_pr.h>
 
 #ifdef SNMP_SUPPORT
 #include <linux/proc_fs.h>
@@ -786,7 +787,21 @@ static ssize_t target_core_dev_pr_show_spc3_res (
 	char *page,
 	ssize_t *len)
 {
-	*len += sprintf(page+*len, "Not Implemented yet\n");
+	se_node_acl_t *se_nacl;
+	t10_pr_registration_t *pr_reg;
+
+	spin_lock(&dev->dev_reservation_lock);
+	if (!(pr_reg = dev->dev_pr_res_holder)) {
+		*len += sprintf(page+*len, "No SPC-3 Reservation holder\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		return(*len);	
+	}
+	se_nacl = pr_reg->pr_reg_nacl;
+	*len += sprintf(page+*len, "SPC-3 Reservation FABRIC[%s]: Initiator: %s\n",
+		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
+		se_nacl->initiatorname);
+	spin_unlock(&dev->dev_reservation_lock);
+
 	return(*len);
 }
 
@@ -799,11 +814,11 @@ static ssize_t target_core_dev_pr_show_spc2_res (
 
 	spin_lock(&dev->dev_reservation_lock);
 	if (!(se_nacl = dev->dev_reserved_node_acl)) {
-		*len += sprintf(page+*len, "None\n");
+		*len += sprintf(page+*len, "No SPC-2 Reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		return(*len);
 	}
-	*len += sprintf(page+*len, "FABRIC[%s]: Initiator: %s\n",
+	*len += sprintf(page+*len, "SPC-2 Reservation FABRIC[%s]: Initiator: %s\n",
 		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
 		se_nacl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
@@ -849,17 +864,50 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts (
 	struct se_subsystem_dev_s *su_dev,
 	char *page)
 {
+	se_device_t *dev;
+	se_node_acl_t *se_nacl;
+	se_portal_group_t *se_tpg;
+	t10_pr_registration_t *pr_reg;
 	ssize_t len = 0;
 
-	if (!(su_dev->se_dev_ptr))
+	if (!(dev = su_dev->se_dev_ptr))
 		return(-ENODEV);
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
-		return(sprintf(page, "res_pr_all_tgt_pts only valid for"
-			" SPC3_PERSISTENT_RESERVATIONS\n"));
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) 
+		return(len);
+
+	spin_lock(&dev->dev_reservation_lock);
+        if (!(pr_reg = dev->dev_pr_res_holder)) {
+		len = sprintf(page, "No SPC-3 Reservation holder\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		return(len);
 	}
+	/*
+	 * See All Target Ports (ALL_TG_PT) bit in spcr17, section 6.14.3
+	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
+	 */
+	if (pr_reg->pr_reg_all_tg_pt)
+		len = sprintf(page, "SPC-3 Reservation holder: All Target"
+			" Ports reserved\n");
+	else {
+		se_lun_t *lun = dev->dev_pr_tg_port_res_lun;
+		struct target_core_fabric_ops *tfo;
+
+		se_nacl = pr_reg->pr_reg_nacl;
+		se_tpg = se_nacl->se_tpg;
+		tfo = TPG_TFO(se_tpg);
+
+		len = sprintf(page, "SPC-3 Reservation holder: Single Target"
+			" Port reserved\n");	
+		len += sprintf(page+len, "SPC-3 Reservation holder: Fabric: "
+			" %s Node Endpoint: %s\n", tfo->get_fabric_name(),
+			tfo->tpg_get_wwn(se_tpg));	
+		len += sprintf(page+len, "SPC-3 Reservation holder: Portal"
+			" Identifer Tag: %hu Logical Unit: %u\n",
+			tfo->tpg_get_tag(se_tpg), lun->unpacked_lun);
+	}
+	spin_unlock(&dev->dev_reservation_lock);
 
-	len = sprintf(page, "Not Implemented yet\n");
 	return(len);
 }
 
@@ -875,10 +923,8 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_generation (
 	if (!(su_dev->se_dev_ptr))
 		return(-ENODEV);
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
-		return(sprintf(page, "res_pr_generation only valid for"
-			" SPC3_PERSISTENT_RESERVATIONS\n"));
-	}
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return(0);
 
 	return(sprintf(page, "0x%08x\n", T10_RES(su_dev)->pr_generation));
 }
@@ -896,15 +942,16 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts (
 	t10_pr_registration_t *pr_reg;
 	unsigned char buf[384];
 	ssize_t len = 0;
+	int reg_count = 0;
 
 	if (!(su_dev->se_dev_ptr))
 		return(-ENODEV);
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS) {
-		len = sprintf(page, "res_pr_registered_i_pts only valid for"
-			" SPC3_PERSISTENT_RESERVATIONS\n");
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return(len);
-	}
+
+	len += sprintf(page+len, "SPC-3 PR Registrations:\n");
+
 	spin_lock(&T10_RES(su_dev)->registration_lock);
 	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
 			pr_reg_list) {
@@ -920,15 +967,51 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts (
 			break;
 
 		len += sprintf(page+len, "%s", buf);	
+		reg_count++;
 	}
 	spin_unlock(&T10_RES(su_dev)->registration_lock);
 
+	if (!(reg_count))
+		len += sprintf(page+len, "None\n");
+
 	return(len);
 }
 
 SE_DEV_PR_ATTR_RO(res_pr_registered_i_pts);
 
 /*
+ * res_pr_type
+ */
+static ssize_t target_core_dev_pr_show_attr_res_pr_type (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	se_device_t *dev;
+	t10_pr_registration_t *pr_reg;
+	ssize_t len = 0;
+
+	if (!(dev = su_dev->se_dev_ptr))
+		return(-ENODEV);
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return(len);
+
+	spin_lock(&dev->dev_reservation_lock);
+	if (!(pr_reg = dev->dev_pr_res_holder)) {
+		len = sprintf(page, "No SPC-3 Reservation holder\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		return(len);
+	}
+	len = sprintf(page, "SPC-3 Reservation Type: %s\n",
+		core_scsi3_pr_dump_type(pr_reg->pr_res_type));
+	spin_unlock(&dev->dev_reservation_lock);
+
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_pr_type);
+
+/*
  * res_type
  */
 static ssize_t target_core_dev_pr_show_attr_res_type (
@@ -967,6 +1050,7 @@ static struct configfs_attribute *target_core_dev_pr_attrs[] = {
 	&target_core_dev_pr_res_pr_all_tgt_pts.attr,
 	&target_core_dev_pr_res_pr_generation.attr,
 	&target_core_dev_pr_res_pr_registered_i_pts.attr,
+	&target_core_dev_pr_res_pr_type.attr,
 	&target_core_dev_pr_res_type.attr,
 	NULL,
 };
-- 
1.5.4.1



