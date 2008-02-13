From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2] gdth: bugfix for the at-exit problems
Date: Wed, 13 Feb 2008 18:35:07 +0200
Message-ID: <47B31C3B.3060008@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com> <1202917468.3109.5.camel@localhost.localdomain> <47B312B3.3010200@panasas.com> <47B31BDE.2030408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933481AbYBMQg6@vger.kernel.org>
In-Reply-To: <47B31BDE.2030408@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
List-Id: linux-scsi@vger.kernel.org


gdth_exit would first remove all cards then stop the timer
and would not sync with the timer function. This caused a crash
in gdth_timer() when module was unloaded.
So del_timer_sync the timer before we delete the cards.

also a reboot notifier function was registered but is
not needed anymore. And would crash. So remove gdth_halt
and the reboot notifier registration.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   64 +++++++-------------------------------------------
 1 files changed, 9 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8eb78be..8469fe6 100644
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
@@ -3793,6 +3786,8 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    BUG_ON(list_empty(&gdth_instances));
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -4668,45 +4663,6 @@ static void gdth_flush(gdth_ha_str *ha)
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
@@ -5141,13 +5097,13 @@ static void gdth_remove_one(gdth_ha_str *ha)
 
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
 
@@ -5235,8 +5191,6 @@ static int __init gdth_init(void)
 	add_timer(&gdth_timer);
 #endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
-	notifier_disabled = 0;
-	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
 }
@@ -5245,14 +5199,14 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major,"gdth");
 
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
