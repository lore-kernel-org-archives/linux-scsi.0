From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/14] target: Remove unnecessary hba_dev_list walk and se_clear_dev_ports legacy code
Date: Fri, 25 Feb 2011 11:49:58 -0800
Message-ID: <1298663406-5118-7-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:20951 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:32 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

This patch removes a legacy struct se_hba->hba_dev_list -> se_release_device_for_hba()
list walk in core_delete_hba(), which is no longer required while using configfs
VFS level parent/child struct config_group dependency referencing.  The reason
is because any struct se_hba->hba_dev_list-> struct se_device members are going
to have to be released via:

	rmdir /sys/kernel/config/target/core/$HBA/*

before rmdir release of struct se_hba via target_core_configfs.c:
target_core_call_delhbafromtarget() -> core_delete_hba()

	rmdir /sys/kernel/config/target/core/$HBA

to release struct se_hba in core_delete_hba().

This patch also removes the legacy se_clear_dev_ports() function, which is
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
Reported-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |   39 +---------------------------------
 drivers/target/target_core_hba.c    |   15 +-----------
 2 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5da051a..c9085e3 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -780,49 +780,14 @@ void se_release_vpd_for_dev(struct se_device *dev)
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
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..d0d2ecc 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -153,19 +153,8 @@ out_free_hba:
 int
 core_delete_hba(struct se_hba *hba)
 {
-	struct se_device *dev, *dev_tmp;
-
-	spin_lock(&hba->device_lock);
-	list_for_each_entry_safe(dev, dev_tmp, &hba->hba_dev_list, dev_list) {
-
-		se_clear_dev_ports(dev);
-		spin_unlock(&hba->device_lock);
-
-		se_release_device_for_hba(dev);
-
-		spin_lock(&hba->device_lock);
-	}
-	spin_unlock(&hba->device_lock);
+	if (!list_empty(&hba->hba_dev_list))
+		dump_stack();
 
 	hba->transport->detach_hba(hba);
 
-- 
1.7.4.1

