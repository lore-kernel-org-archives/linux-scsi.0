From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [Target_Core_Mod/ConfigFS]: Add res_pr_holder_tg_port
	attribute
Date: Fri, 30 Jan 2009 01:33:14 -0800
Message-ID: <1233307994.6442.252.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:42573 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752175AbZA3JeW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 04:34:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, "Lawrence E. Rosen" <lrosen@pyxtechnologies.com>, Arne Redlich <agr@powerkom-dd.de>, Ming Zhang <blackmagic02881@gmail.com>

>From a0cdb125c6a79e4a638e54dba7d80d18e423a926 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 29 Jan 2009 19:18:45 -0800
Subject: [PATCH 2/4] [Target_Core_Mod/ConfigFS]: Add res_pr_holder_tg_port attribute

This patch adds /sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/pr/res_pr_holder_tg_port

This attribute is used when a SPC-3 compliant PR RESERVE Service Action has
been successfully executed, and will contain information about the target node fabric
and endpoint.  For LIO-Target v3.0 ports using PERSISTENT_RESERVATIONS, the output
looks like:

target# /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/res_pr_holder_tg_port
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
SPC-3 Reservation: Portal Identifer Tag: 1 Logical Unit: 0

This patch basically moves this logic from the existing ConfigFS attribute
res_pr_all_tgt_pts to its own seperate RO attribute.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |   76 +++++++++++++++++++++---------
 1 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 3dd7dbd..3af6cb1 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -797,7 +797,7 @@ static ssize_t target_core_dev_pr_show_spc3_res (
 		return(*len);	
 	}
 	se_nacl = pr_reg->pr_reg_nacl;
-	*len += sprintf(page+*len, "SPC-3 Reservation FABRIC[%s]: Initiator: %s\n",
+	*len += sprintf(page+*len, "SPC-3 Reservation: %s Initiator: %s\n",
 		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
 		se_nacl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
@@ -818,7 +818,7 @@ static ssize_t target_core_dev_pr_show_spc2_res (
 		spin_unlock(&dev->dev_reservation_lock);
 		return(*len);
 	}
-	*len += sprintf(page+*len, "SPC-2 Reservation FABRIC[%s]: Initiator: %s\n",
+	*len += sprintf(page+*len, "SPC-2 Reservation: %s Initiator: %s\n",
 		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
 		se_nacl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
@@ -865,8 +865,6 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts (
 	char *page)
 {
 	se_device_t *dev;
-	se_node_acl_t *se_nacl;
-	se_portal_group_t *se_tpg;
 	t10_pr_registration_t *pr_reg;
 	ssize_t len = 0;
 
@@ -887,25 +885,11 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts (
 	 * Basic PERSISTENT RESERVER OUT parameter list, page 290
 	 */
 	if (pr_reg->pr_reg_all_tg_pt)
-		len = sprintf(page, "SPC-3 Reservation holder: All Target"
-			" Ports reserved\n");
-	else {
-		se_lun_t *lun = dev->dev_pr_tg_port_res_lun;
-		struct target_core_fabric_ops *tfo;
-
-		se_nacl = pr_reg->pr_reg_nacl;
-		se_tpg = se_nacl->se_tpg;
-		tfo = TPG_TFO(se_tpg);
-
-		len = sprintf(page, "SPC-3 Reservation holder: Single Target"
-			" Port reserved\n");	
-		len += sprintf(page+len, "SPC-3 Reservation holder: Fabric: "
-			" %s Node Endpoint: %s\n", tfo->get_fabric_name(),
-			tfo->tpg_get_wwn(se_tpg));	
-		len += sprintf(page+len, "SPC-3 Reservation holder: Portal"
-			" Identifer Tag: %hu Logical Unit: %u\n",
-			tfo->tpg_get_tag(se_tpg), lun->unpacked_lun);
-	}
+		len = sprintf(page, "SPC-3 Reservation: All Target"
+			" Ports registration\n");
+	else 
+		len = sprintf(page, "SPC-3 Reservation: Single"
+			" Target Port registration\n");
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return(len);
@@ -932,6 +916,51 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_generation (
 SE_DEV_PR_ATTR_RO(res_pr_generation);
 
 /*
+ * res_pr_holder_tg_port
+ */
+static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port (
+	struct se_subsystem_dev_s *su_dev,
+	char *page)
+{
+	se_device_t *dev;
+	se_node_acl_t *se_nacl;
+	se_lun_t *lun;
+	se_portal_group_t *se_tpg;
+	t10_pr_registration_t *pr_reg;
+	struct target_core_fabric_ops *tfo;
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
+	se_nacl = pr_reg->pr_reg_nacl;
+	se_tpg = se_nacl->se_tpg;
+	lun = pr_reg->pr_reg_tg_pt_lun;
+	tfo = TPG_TFO(se_tpg);
+
+	len += sprintf(page+len, "SPC-3 Reservation: %s"
+		" Target Node Endpoint: %s\n", tfo->get_fabric_name(),
+		tfo->tpg_get_wwn(se_tpg));      
+	len += sprintf(page+len, "SPC-3 Reservation: Portal"
+		" Identifer Tag: %hu Logical Unit: %u\n",
+		tfo->tpg_get_tag(se_tpg), lun->unpacked_lun);
+	spin_unlock(&dev->dev_reservation_lock);
+
+	return(len);
+}
+
+SE_DEV_PR_ATTR_RO(res_pr_holder_tg_port);
+
+/*
  * res_pr_registered_i_pts
  */
 static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts (
@@ -1049,6 +1078,7 @@ static struct configfs_attribute *target_core_dev_pr_attrs[] = {
 	&target_core_dev_pr_res_holder.attr,
 	&target_core_dev_pr_res_pr_all_tgt_pts.attr,
 	&target_core_dev_pr_res_pr_generation.attr,
+	&target_core_dev_pr_res_pr_holder_tg_port.attr,
 	&target_core_dev_pr_res_pr_registered_i_pts.attr,
 	&target_core_dev_pr_res_pr_type.attr,
 	&target_core_dev_pr_res_type.attr,
-- 
1.5.4.1



