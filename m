From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/3] gdth: bugfix for the at-exit problems
Date: Wed, 27 Feb 2008 15:27:16 -0800
Message-ID: <47C5F1D4.1090804@panasas.com>
References: <47C5EF80.4080600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:48911 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761923AbYB0W1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 17:27:53 -0500
Received: by el-out-1112.google.com with SMTP id v27so2691919ele.23
        for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 14:27:52 -0800 (PST)
In-Reply-To: <47C5EF80.4080600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>


gdth_exit would first remove all cards then stop the timer
and would not sync with the timer function. This caused a crash
in gdth_timer() when module was unloaded.
So del_timer_sync the timer before we delete the cards.

also the reboot notifier function would crash. So clean
that up and fix the crashes.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
---
 drivers/scsi/gdth.c |   82 +++++++++++++++++---------------------------------
 1 files changed, 28 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4959037..0979553 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -183,7 +183,6 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                       unsigned int cmd, unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
@@ -418,12 +417,6 @@ static inline void gdth_set_sglist(struct scsi_cmnd *cmd,
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
-/* notifier block to get a notify on system shutdown/halt/reboot */
-static struct notifier_block gdth_notifier = {
-    gdth_halt, NULL, 0
-};
-static int notifier_disabled = 0;
-
 static gdth_ha_str *gdth_find_ha(int hanum)
 {
 	gdth_ha_str *ha;
@@ -3796,6 +3789,8 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    BUG_ON(list_empty(&gdth_instances));
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -4671,45 +4666,6 @@ static void gdth_flush(gdth_ha_str *ha)
     }
 }
 
-/* shutdown routine */
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
-{
-    gdth_ha_str *ha;
-#ifndef __alpha__
-    gdth_cmd_str    gdtcmd;
-    char            cmnd[MAX_COMMAND_SIZE];   
-#endif
-
-    if (notifier_disabled)
-        return NOTIFY_OK;
-
-    TRACE2(("gdth_halt() event %d\n",(int)event));
-    if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
-        return NOTIFY_DONE;
-
-    notifier_disabled = 1;
-    printk("GDT-HA: Flushing all host drives .. ");
-    list_for_each_entry(ha, &gdth_instances, list) {
-        gdth_flush(ha);
-
-#ifndef __alpha__
-        /* controller reset */
-        memset(cmnd, 0xff, MAX_COMMAND_SIZE);
-        gdtcmd.BoardNode = LOCALBOARD;
-        gdtcmd.Service = CACHESERVICE;
-        gdtcmd.OpCode = GDT_RESET;
-        TRACE2(("gdth_halt(): reset controller %d\n", ha->hanum));
-        gdth_execute(ha->shost, &gdtcmd, cmnd, 10, NULL);
-#endif
-    }
-    printk("Done.\n");
-
-#ifdef GDTH_STATISTICS
-    del_timer(&gdth_timer);
-#endif
-    return NOTIFY_OK;
-}
-
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5144,13 +5100,13 @@ static void gdth_remove_one(gdth_ha_str *ha)
 
 	scsi_remove_host(shp);
 
+	gdth_flush(ha);
+
 	if (ha->sdev) {
 		scsi_free_host_dev(ha->sdev);
 		ha->sdev = NULL;
 	}
 
-	gdth_flush(ha);
-
 	if (shp->irq)
 		free_irq(shp->irq,ha);
 
@@ -5176,6 +5132,24 @@ static void gdth_remove_one(gdth_ha_str *ha)
 	scsi_host_put(shp);
 }
 
+static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
+{
+	gdth_ha_str *ha;
+
+	TRACE2(("gdth_halt() event %d\n", (int)event));
+	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
+		return NOTIFY_DONE;
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_flush(ha);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gdth_notifier = {
+    gdth_halt, NULL, 0
+};
+
 static int __init gdth_init(void)
 {
 	if (disable) {
@@ -5238,7 +5212,6 @@ static int __init gdth_init(void)
 	add_timer(&gdth_timer);
 #endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
-	notifier_disabled = 0;
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
@@ -5248,14 +5221,15 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major, "gdth");
+	unregister_reboot_notifier(&gdth_notifier);
 
 #ifdef GDTH_STATISTICS
-	del_timer(&gdth_timer);
+	del_timer_sync(&gdth_timer);
 #endif
-	unregister_chrdev(major,"gdth");
-	unregister_reboot_notifier(&gdth_notifier);
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
 }
 
 module_init(gdth_init);
-- 
1.5.3.3

