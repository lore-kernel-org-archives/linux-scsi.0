From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: gdth oops
Date: Sun, 04 May 2008 12:32:51 -0500
Message-ID: <1209922371.16283.33.camel@localhost.localdomain>
References: <263955236@web.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40160 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbYEDRc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 13:32:56 -0400
In-Reply-To: <263955236@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devzero@web.de
Cc: achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2008-05-04 at 00:52 +0200, devzero@web.de wrote:
> hi,  
> 
> thanks again for the pointer to kerneloops search.
> 
> i have probably found another - and for this i can`t find anything on lkml or elsewhere.
> 
> while doing some module load/unload tests, i noticed that "modprobe gdth;modprobe -r gdth" seems to leak something - i`m getting 
> 
> Error: Driver 'gdth' is already registered, aborting...
> 
> on next modprobe .
> 
> i checked, if module is unloaded correctly before, and lsmod doesn`t list it - so this looks like an issue to me.
> 
> furthermore, i can reproduce the oops below very easily - just load/unload gdth in a loop and load/unload some other modules - this reproduceably oopses with the message below:
> 
> this is on a system WITHOUT such controller, so not a big issue - but maybe worth reporting, though !?
> 
> regards
> roland
> 
> 
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> Error: Driver 'gdth' is already registered, aborting...
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> Error: Driver 'gdth' is already registered, aborting...
> GDT-HA: Storage RAID Controller Driver. Version: 3.05
> BUG: unable to handle kernel paging request at 839845ab
> IP: [<c01d9dc1>] kobject_put+0xa/0x41
> *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: gdth(+) kafs af_rxrpc ipv6 button battery ac loop dm_mod e100 uhci_hcd ehci_hcd mii ide_pci_generic i2c_i801 intel_agp usbcore ide_core i2c_core agpgart rng_core parport_pc lp parport reiserfs edd fan thermal processor sg megaraid_mbox megaraid_mm sd_mod scsi_mod [last unloaded: bfs]
> 
> Pid: 4732, comm: modprobe Not tainted (2.6.25-default  #1)
> EIP: 0060:[<c01d9dc1>] EFLAGS: 00010286 CPU: 0
> EIP is at kobject_put+0xa/0x41
> EAX: 8398458b EBX: 8398458b ECX: f8e3eb55 EDX: f8c5f150
> ESI: f8e41150 EDI: f8e41150 EBP: f6575de4 ESP: f6575de0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 4732, ti=f6574000 task=f713cd90 task.ti=f6574000)
> Stack: f8e41120 f6575dec c023dc44 f6575e08 c023dc99 f8e41280 f8e41280 f8e41120
>        f8e41280 f8e41150 f6575e1c c01e6da7 f8e41280 f8e41280 f8e3ea14 f6575e4c
>        f8bee251 00000013 f7105b20 00000001 f8e41280 0000001e f8e32878 f6575e4c
> Call Trace:
>  [<c023dc44>] ? put_driver+0xb/0xd
>  [<c023dc99>] ? driver_register+0x53/0xcd
>  [<c01e6da7>] ? __pci_register_driver+0x35/0x62
>  [<f8bee251>] ? gdth_init+0x5f7/0x68a [gdth]
>  [<c0142f6f>] ? sys_init_module+0x17e2/0x193c
>  [<c015403c>] ? generic_file_aio_read+0x489/0x4c1
>  [<f885259c>] ? scsi_get_host_dev+0x0/0x78 [scsi_mod]
>  [<c01c595d>] ? security_file_permission+0xf/0x11
>  [<c016f156>] ? do_sync_read+0x0/0xe9
>  [<c0104891>] ? sysenter_past_esp+0x6a/0x99
>  [<c02d0000>] ? wait_for_common+0xb1/0x13e
>  =======================
> Code: 00 55 89 e5 53 31 db e8 0d 28 f9 ff 85 c0 74 0c ba 34 9e 3c c0 89 c3 e8 81 ff ff ff 89 d8 5b 5d c3 55 85 c0 89 e5 53 89 c3 74 32 <f6> 40 20 01 75 1f 50 ff 30 68 10 c5 37 c0 e8 77 be f4 ff ba 47
> EIP: [<c01d9dc1>] kobject_put+0xa/0x41 SS:ESP 0068:f6575de0
> ---[ end trace 2bee9a2892ac67fa ]---

Yes, the problem is that the driver doesn't unregister it's PCI driver
if it fails in gdth_init, leaving a registered PCI driver in free'd
memory.

This is probably the best fix:  a modern driver should never die in init
unless there's some failure because soft binding or hotplug can come
along later with the actual device.

I could make the remain in place conditional on CONFIG_PCI, but that
would produce a strange driver that would behave differently depending
on how you compile it.

So, try this as the fix.

James

---

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8e2e964..46771d4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -550,7 +550,6 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static bool gdth_pci_registered;
 
 static bool gdth_search_vortex(ushort device)
 {
@@ -3724,6 +3723,8 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
 }
 
 #ifdef GDTH_STATISTICS
+static unchar	gdth_timer_running;
+
 static void gdth_timeout(ulong data)
 {
     ulong32 i;
@@ -3731,7 +3732,10 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
-    BUG_ON(list_empty(&gdth_instances));
+    if(unlikely(list_empty(&gdth_instances))) {
+	    gdth_timer_running = 0;
+	    return;
+    }
 
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -3751,6 +3755,22 @@ static void gdth_timeout(ulong data)
     add_timer(&gdth_timer);
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
+
+static void gdth_timer_init(void)
+{
+	if (gdth_timer_running)
+		return;
+	gdth_timer_running = 1;
+	TRACE2(("gdth_detect(): Initializing timer !\n"));
+	gdth_timer.expires = jiffies + HZ;
+	gdth_timer.data = 0L;
+	gdth_timer.function = gdth_timeout;
+	add_timer(&gdth_timer);
+}
+#else
+static inline void gdth_timer_init(void)
+{
+}
 #endif
 
 static void __init internal_setup(char *str,int *ints)
@@ -4735,6 +4755,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -4865,6 +4886,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5011,6 +5033,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	list_add_tail(&ha->list, &gdth_instances);
 
 	pci_set_drvdata(ha->pdev, ha);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5110,6 +5133,7 @@ static int __init gdth_init(void)
 	/* initializations */
 	gdth_polling = TRUE;
 	gdth_clear_events();
+	init_timer(&gdth_timer);
 
 	/* As default we do not probe for EISA or ISA controllers */
 	if (probe_eisa_isa) {
@@ -5132,23 +5156,17 @@ static int __init gdth_init(void)
 
 #ifdef CONFIG_PCI
 	/* scanning for PCI controllers */
-	if (pci_register_driver(&gdth_pci_driver) == 0)
-		gdth_pci_registered = true;
+	if (pci_register_driver(&gdth_pci_driver)) {
+		gdth_ha_str *ha;
+
+		list_for_each_entry(ha, &gdth_instances, list)
+			gdth_remove_one(ha);
+		return -ENODEV;
+	}
 #endif /* CONFIG_PCI */
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
 
-	if (list_empty(&gdth_instances))
-		return -ENODEV;
-
-#ifdef GDTH_STATISTICS
-	TRACE2(("gdth_detect(): Initializing timer !\n"));
-	init_timer(&gdth_timer);
-	gdth_timer.expires = jiffies + HZ;
-	gdth_timer.data = 0L;
-	gdth_timer.function = gdth_timeout;
-	add_timer(&gdth_timer);
-#endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
@@ -5167,8 +5185,7 @@ static void __exit gdth_exit(void)
 #endif
 
 #ifdef CONFIG_PCI
-	if (gdth_pci_registered)
-		pci_unregister_driver(&gdth_pci_driver);
+	pci_unregister_driver(&gdth_pci_driver);
 #endif
 
 	list_for_each_entry(ha, &gdth_instances, list)


