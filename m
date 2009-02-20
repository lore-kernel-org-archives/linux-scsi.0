From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/7] [Target_Core_Mod]: Add hw_block_size and block_size
	device attributes
Date: Fri, 20 Feb 2009 00:00:06 -0800
Message-ID: <1235116806.12375.1034.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:21885 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753040AbZBTIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:01:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From 3961522f53880310d7e6e1cd45f79b800109b3f3 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:27:31 -0800
Subject: [PATCH 1/7] [Target_Core_Mod]: Add hw_block_size and block_size device attributes

This patch adds structure members hw_block_size and block_size to
se_dev_attrib_t, adds their default setting using se_subsystem_api_t->get_blocksize()
in se_dev_set_default_attribs(), and adds se_dev_set_block_size for usage with
Target_Core_Mod/ConfigFS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h   |    2 +
 drivers/lio-core/target_core_device.c |   37 +++++++++++++++++++++++++++++++++
 drivers/lio-core/target_core_device.h |    1 +
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 58d78bf..32a35de 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -569,6 +569,8 @@ typedef struct se_dev_attrib_s {
         int             status_thread_tur;
 	int		emulate_reservations;
 	int		emulate_alua;
+	u32		hw_block_size;
+	u32		block_size;
 	u32		hw_max_sectors;
         u32             max_sectors;
 	u32		hw_queue_depth;
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 2822fc9..6385d74 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -871,6 +871,11 @@ extern void se_dev_set_default_attribs (se_device_t *dev)
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	/*
+	 * block_size is based on subsystem plugin dependent requirements.
+	 */
+	DEV_ATTRIB(dev)->hw_block_size = TRANSPORT(dev)->get_blocksize(dev);
+	DEV_ATTRIB(dev)->block_size = TRANSPORT(dev)->get_blocksize(dev);
+	/*
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
 	DEV_ATTRIB(dev)->hw_max_sectors = TRANSPORT(dev)->get_max_sectors(dev);
@@ -1058,6 +1063,38 @@ extern int se_dev_set_max_sectors (se_device_t *dev, u32 max_sectors)
 	return(0);
 }
 
+extern int se_dev_set_block_size (se_device_t *dev, u32 block_size)
+{
+	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device block_size"
+			" while dev_export_obj: %d count exists\n", dev,
+			DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
+		return(-1);
+	}
+
+	if ((block_size != 512) &&
+	    (block_size != 1024) &&
+	    (block_size != 2048) &&
+	    (block_size != 4096)) {
+		printk(KERN_ERR "dev[%p]: Illegal value for block_device: %u"
+			" for SE device, must be 512, 1024, 2048 or 4096\n",
+			dev, block_size);
+		return(-1);
+	}
+
+	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+		printk(KERN_ERR "dev[%p]: Not allowed to change block_size for"
+			" Physical Device, use for Linux/SCSI to change block_size"
+			" for underlying hardware\n", dev);
+		return(-1);
+	}
+
+	DEV_ATTRIB(dev)->block_size = block_size;
+	printk("dev[%p]: SE Device block_size changed to %u\n",
+			dev, block_size);
+	return(0);
+}
+
 extern se_lun_t *core_dev_add_lun (
 	se_portal_group_t *tpg,
 	se_hba_t *hba,
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 0f0af8c..99a3efd 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -57,6 +57,7 @@ extern int se_dev_set_status_thread (se_device_t *, int);
 extern int se_dev_set_status_thread_tur (se_device_t *, int);
 extern int se_dev_set_queue_depth (se_device_t *, u32);
 extern int se_dev_set_max_sectors (se_device_t *, u32);
+extern int se_dev_set_block_size (se_device_t *, u32);
 extern se_lun_t *core_dev_add_lun (se_portal_group_t *, se_hba_t *, se_device_t *, u32, int *);
 extern int core_dev_del_lun (se_portal_group_t *, u32);
 extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *, u32);
-- 
1.5.4.1



