From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 18/24] target: Remove unnecessary se_clear_dev_ports legacy code
Date: Sat, 29 Jan 2011 10:36:18 -0800
Message-ID: <1296326184-16664-19-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.246]:30989 "HELO
	nm28-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780Ab1A2ShF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:05 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the legacy se_clear_dev_ports() function, which is
left-over pre-configfs shutdown logic for when se_free_virtual_device()
was responsible for walking struct se_device->dev_sep_list and calling
core_dev_del_lun() for each individual active struct se_port->se_lun.

The reason this can be removed is because all struct se_device->dev_sep_list
-> struct se_port communication is done via configfs symlinks, which
means that an target fabric module's endpoints containg active struct
se_port(s) will have to be released via target_core_fabric_configfs.c:
target_fabric_port_unlink() via:

	unlink /sys/kernel/config/target/$FABRIC_MOD/$ENDPOINT/tpgt_$TPGT/lun/lun_$LUN_ID/<symlink>

before rmdir release of struct se_device in target_core_configfs.c:
target_core_drop_subdev() -> se_free_virtual_device() can happen via:

	rmdir /sys/kernel/config/target/core/$HBA/*

to release struct se_subsystem_dev in target_core_drop_subdev()

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 164416680c9715f9aac9afa0c2cf809efb710e85)
---
 drivers/target/target_core_device.c |   41 +---------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 02b835f..ec7f582 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -776,51 +776,14 @@ void se_release_vpd_for_dev(struct se_device *dev)
 	return;
 }
 
-/*
- * Called with struct se_hba->device_lock held.
- */
-void se_clear_dev_ports(struct se_device *dev)
-{
-	struct se_hba *hba = dev->se_hba;
-	struct se_lun *lun;
-	struct se_portal_group *tpg;
-	struct se_port *sep, *sep_tmp;
-
-	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list) {
-		spin_unlock(&dev->se_port_lock);
-		spin_unlock(&hba->device_lock);
-
-		lun = sep->sep_lun;
-		tpg = sep->sep_tpg;
-		spin_lock(&lun->lun_sep_lock);
-		if (lun->lun_se_dev == NULL) {
-			spin_unlock(&lun->lun_sep_lock);
-			spin_lock(&hba->device_lock);
-			spin_lock(&dev->se_port_lock);
-			continue;
-		}
-		spin_unlock(&lun->lun_sep_lock);
-
-		core_dev_del_lun(tpg, lun->unpacked_lun);
-
-		spin_lock(&hba->device_lock);
-		spin_lock(&dev->se_port_lock);
-	}
-	spin_unlock(&dev->se_port_lock);
-
-	return;
-}
-
 /*	se_free_virtual_device():
  *
  *	Used for IBLOCK, RAMDISK, and FILEIO Transport Drivers.
  */
 int se_free_virtual_device(struct se_device *dev, struct se_hba *hba)
 {
-	spin_lock(&hba->device_lock);
-	se_clear_dev_ports(dev);
-	spin_unlock(&hba->device_lock);
+	if (!list_empty(&dev->dev_sep_list))
+		dump_stack();
 
 	core_alua_free_lu_gp_mem(dev);
 	se_release_device_for_hba(dev);
-- 
1.7.3.5

