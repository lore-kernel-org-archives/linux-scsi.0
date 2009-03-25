From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] [Target_Core_Mod/ConfigFS]: Add emulated_tas
	READ/WRITE device attribute
Date: Tue, 24 Mar 2009 22:53:31 -0700
Message-ID: <1237960411.4138.398.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:49070 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753134AbZCYFxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 01:53:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>From bc587053a97f5cb21688dcf770d806202c8f0066 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 23 Mar 2009 22:30:11 -0700
Subject: [PATCH 3/5] [Target_Core_Mod/ConfigFS]: Add emulated_tas READ/WRITE device attribute

This patch adds support for setting TASK_ABORTED status via configfs in
/sys/kernel/config/target/core/$HBA/$DEV/attrib/emulated_tas.  This currently
requires that no active symlinks into $FABRIC_MOD code exists in order to be
changed.  But default, this value has been set to ENABLED via
target_core_base.h:DA_EMULATE_TAS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |    4 ++++
 drivers/lio-core/target_core_device.c   |   21 +++++++++++++++++++++
 drivers/lio-core/target_core_device.h   |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 4909caf..5473d4c 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -478,6 +478,9 @@ SE_DEV_ATTR(status_thread, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(status_thread_tur);
 SE_DEV_ATTR(status_thread_tur, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_tas);
+SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -504,6 +507,7 @@ CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib_s, da_group);
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_status_thread.attr,
 	&target_core_dev_attrib_status_thread_tur.attr,
+	&target_core_dev_attrib_emulate_tas.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 6183ba0..a1c5c95 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -869,6 +869,7 @@ void se_dev_set_default_attribs(se_device_t *dev)
 {
 	DEV_ATTRIB(dev)->status_thread = DA_STATUS_THREAD;
 	DEV_ATTRIB(dev)->status_thread_tur = DA_STATUS_THREAD_TUR;
+	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	/*
@@ -969,6 +970,26 @@ int se_dev_set_status_thread_tur(se_device_t *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_emulate_tas(se_device_t *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return 1;
+	}
+
+	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device TAS while"
+			" dev_export_obj: %d count exists\n", dev,
+			DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_tas = flag;
+	printk(KERN_INFO "dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
+		dev, (DEV_ATTRIB(dev)->emulate_tas) ? "Enabled" : "Disabled");
+
+	return 0;
+}
+
 /*
  * Note, this can only be called on unexported SE Device Object.
  */
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index f8d3016..3b46ef1 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -62,6 +62,7 @@ extern void se_dev_set_default_attribs(se_device_t *);
 extern int se_dev_set_task_timeout(se_device_t *, u32);
 extern int se_dev_set_status_thread(se_device_t *, int);
 extern int se_dev_set_status_thread_tur(se_device_t *, int);
+extern int se_dev_set_emulate_tas(se_device_t *, int);
 extern int se_dev_set_queue_depth(se_device_t *, u32);
 extern int se_dev_set_max_sectors(se_device_t *, u32);
 extern int se_dev_set_block_size(se_device_t *, u32);
-- 
1.5.4.1



