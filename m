From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 19:12:07 +0200
Message-ID: <47B324E7.9040502@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>	 <1202917468.3109.5.camel@localhost.localdomain>	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>	 <1202921122.3109.31.camel@localhost.localdomain>	 <47B31FC2.4040206@panasas.com> <1202922226.3109.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4111 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932899AbYBMRNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 12:13:40 -0500
In-Reply-To: <1202922226.3109.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Wed, Feb 13 2008 at 19:03 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-02-13 at 18:50 +0200, Boaz Harrosh wrote:
>> On Wed, Feb 13 2008 at 18:45 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>> On Wed, 2008-02-13 at 18:33 +0200, Boaz Harrosh wrote:
>>>> On Wed, Feb 13 2008 at 17:54 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>> On Wed, Feb 13 2008 at 17:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>>>>> On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
>>>>>>> -	gdth_flush(ha);
>>>>>>> -
>>>>>> This piece doesn't look right.  gdth_flush() forces the internal cache
>>>>>> to disk backing.  If you remove it, you're taking the chance that the
>>>>>> machine will be powered off without a writeback which can cause data
>>>>>> corruption.
>>>>>>
>>>>>> James
>>>>>>
>>>>> Yes. 
>>>>> I have more problems reported, with exit, and am just sending one more patch that puts
>>>>> this back in. Which was tested.
>>>>>
>>>>> So I will resend this one plus one new one.
>>>>>
>>>>> Boaz
>>>>>
>>>> The gdth driver would do a register_reboot_notifier(&gdth_notifier);
>>>> to a gdth_halt() function, which would then redo half of what gdth_exit
>>>> does, and wrongly so, and crash.  
>>>>
>>>> Are we guaranteed in todays kernel that modules .exit function be called
>>>> on an halt or reboot? If so then there is no need for duplications and
>>>> the gdth_halt() should go.
>>> No.  The __exit section is actually discardable if you promise never to
>>> remove the module.
>>>
>> I don't understand please explain. 
>> What does a driver need to do if it needs a consistent shutdown retine?
>> module or built in? unload or shutdown?
> 
> It needs to register a reboot notifier, which gdth does.
> 
> However, the notifier is only called on reboot, so it also needs to
> clean up correctly on module exit as well.
> 
> The alternative for GDTH would be to process the SCSI SYNCHRONIZE CACHE
> command.  That's done by a shutdown notifier from sd, so the correct
> thing would always get done; however it does mean the driver has to be
> in a condition to process the last sync cache command.
> 
> For the quick fix, just keep the current infrastructure and put back the
> gdth_flush() command where it can be effective.
> 
> James
> 
> 
Totally untested.

---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] gdth: bugfix for the at-exit problems

gdth_exit would first remove all cards then stop the timer
and would not sync with the timer function. This caused a crash
in gdth_timer() when module was unloaded.
So del_timer_sync the timer before we delete the cards.

also the reboot notifier function would crash. So unify
the exit and halt functions with a gdth_shutdown() that's
called by both.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   99 ++++++++++++++++++++------------------------------
 1 files changed, 40 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8eb78be..7bb9b45 100644
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
 
@@ -5173,6 +5129,40 @@ static void gdth_remove_one(gdth_ha_str *ha)
 	scsi_host_put(shp);
 }
 
+static void gdth_shutdown(void);
+static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
+{
+	TRACE2(("gdth_halt() event %d\n",(int)event));
+	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
+		return NOTIFY_DONE;
+
+	gdth_shutdown();
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gdth_notifier = {
+    gdth_halt, NULL, 0
+};
+
+bool gdth_shutdown_done;
+static void gdth_shutdown()
+{
+	gdth_ha_str *ha;
+	if (gdth_shutdown_done)
+		return;
+
+	gdth_shutdown_done = true;
+	unregister_chrdev(major,"gdth");
+	unregister_reboot_notifier(&gdth_notifier);
+
+#ifdef GDTH_STATISTICS
+	del_timer_sync(&gdth_timer);
+#endif
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
+}
+
 static int __init gdth_init(void)
 {
 	if (disable) {
@@ -5185,6 +5175,7 @@ static int __init gdth_init(void)
 	       GDTH_VERSION_STR);
 
 	/* initializations */
+	gdth_shutdown_done = false;
 	gdth_polling = TRUE;
 	gdth_clear_events();
 
@@ -5235,7 +5226,6 @@ static int __init gdth_init(void)
 	add_timer(&gdth_timer);
 #endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
-	notifier_disabled = 0;
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
@@ -5243,16 +5233,7 @@ static int __init gdth_init(void)
 
 static void __exit gdth_exit(void)
 {
-	gdth_ha_str *ha;
-
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
-
-#ifdef GDTH_STATISTICS
-	del_timer(&gdth_timer);
-#endif
-	unregister_chrdev(major,"gdth");
-	unregister_reboot_notifier(&gdth_notifier);
+	gdth_shutdown();
 }
 
 module_init(gdth_init);
-- 
1.5.3.3


