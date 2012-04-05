From: Tomas Henzl <thenzl@redhat.com>
Subject: [RFC] How to fix an async scan - rmmod race?
Date: Thu, 05 Apr 2012 15:58:16 +0200
Message-ID: <4F7DA4F8.90104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2DEN6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2012 09:58:18 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q35DwIg2032521
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 5 Apr 2012 09:58:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>

When a rmmod is tried then in some cases the kernel is not able to handle a paging request:
[  727.154296] BUG: unable to handle kernel paging request at ffffffffa01874b8
[  727.161473] IP: [<ffffffff8141d1e1>] do_scsi_scan_host+0x61/0xa0
[  727.167637] PGD 1c07067 PUD 1c0b063 PMD 178d9ed067 PTE 0
[  727.173369] Oops: 0000 [#1] SMP
[  727.176808] CPU 0
[  727.178691] Modules linked in: ses enclosure mlx4_ib mlx4_en microcode serio_raw joydev i2c_i801 iTCO_wdt i2c_core iTCO_vendor_support ioatdma mlx4_core scsi_transport_sas igb raid_class i7core_edac dca edac_core ib_ipoib ib_cm ib_addr ib_sa ib_uverbs ib_umad ib_mad ib_core ipmi_poweroff ipmi_watchdog ipmi_devintf ipmi_si ipmi_msghandler [last unloaded: mpt2sas]
[  727.213474]
[  727.215065] Pid: 2439, comm: scsi_scan_6 Tainted: G        W    3.2.3-2.fc16.x86_64.debug #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
[  727.226690] RIP: 0010:[<ffffffff8141d1e1>]  [<ffffffff8141d1e1>] do_scsi_scan_host+0x61/0xa0
[  727.235334] RSP: 0018:ffff88178b2abe40  EFLAGS: 00010246
[  727.240736] RAX: ffffffffa0187420 RBX: ffff881775f74290 RCX: 0000000000000001
[  727.247962] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000282
[  727.255188] RBP: ffff88178b2abe50 R08: 0000000000000000 R09: 0000000000000001
[  727.262413] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000100067e40
[  727.269638] R13: ffffffff8141d220 R14: ffff88178c3d28f8 R15: 0000000000000000
[  727.276857] FS:  0000000000000000(0000) GS:ffff8817de600000(0000) knlGS:0000000000000000
[  727.285094] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  727.290936] CR2: ffffffffa01874b8 CR3: 0000000001c05000 CR4: 00000000000006f0
[  727.298163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  727.305388] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  727.312607] Process scsi_scan_6 (pid: 2439, threadinfo ffff88178b2aa000, task ffff88178a552450)
[  727.321439] Stack:
[  727.323548]  ffff881775f74290 ffff88178c3d28f8 ffff88178b2abe90 ffffffff8141d245
[  727.331336]  ffff88178c3d28f8 ffff8817745cbcf8 ffff88178c3d28f8 ffffffff8141d220
[  727.339131]  0000000000000000 0000000000000000 ffff88178b2abf40 ffffffff810a33e0
[  727.346928] Call Trace:
[  727.349472]  [<ffffffff8141d245>] do_scan_async+0x25/0x160
[  727.355049]  [<ffffffff8141d220>] ? do_scsi_scan_host+0xa0/0xa0
[  727.362260]  [<ffffffff810a33e0>] kthread+0xb0/0xc0
[  727.367228]  [<ffffffff8167ec04>] kernel_thread_helper+0x4/0x10
[  727.373244]  [<ffffffff816744b4>] ? retint_restore_args+0x13/0x13
[  727.379432]  [<ffffffff810a3330>] ? __init_kthread_worker+0x70/0x70
[  727.385792]  [<ffffffff8167ec00>] ? gs_change+0x13/0x13
[  727.391105] Code: d2 48 8b 83 00 02 00 00 48 8b 80 98 00 00 00 eb 21 66 0f 1f 84 00 00 00 00 00 bf 0a 00 00 00 e8 a6 1b c7 ff 48 8b 83 00 02 00 00 <48> 8b 80 98 00 00 00 48 8b 35 11 4e 8d 00 48 89 df 4c 29 e6 ff
[  727.414105] RIP  [<ffffffff8141d1e1>] do_scsi_scan_host+0x61/0xa0
[  727.420355]  RSP <ffff88178b2abe40>
[  727.423933] CR2: ffffffffa01874b8
[  727.427340] ---[ end trace 87ef4ae7ab723385 ]---
>From what I observerved it happens when when we call the rmmod only a while after a modprobe
(in this case it is the mpt2sas driver). More accurately said, it happens when rmmod is called
while scsi async is still at work. The driver is removed but the scsi_host_template is still filled
with now invalid pointers, in this case it is most likely the hostt->scan_finished which causes the BUG.

A logical step is to wait in scsi_remove_host until the async scan ends.
@@ -172,6 +173,9 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	
+	while (shost->async_scan)
+		msleep(10);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))

And a change in scsi_finish_async_scan is needed too - moving the 'async_scan = 0;' so it is
after other functions which could touch a shost.
@@ -1800,9 +1795,6 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	scsi_sysfs_add_devices(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	mutex_unlock(&shost->scan_mutex);
 
@@ -1816,7 +1808,11 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	spin_unlock(&async_scan_lock);
 
 	scsi_autopm_put_host(shost);
-	scsi_host_put(shost);
+	
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->async_scan = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	
 	kfree(data);
 }

When the async scan is protected this way a further protection via ref. count is no more needed
so remove it
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 29c4c04..be9e6fe 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1743,10 +1743,9 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		goto err;
-	data->shost = scsi_host_get(shost);
-	if (!data->shost)
-		goto err;
+		return NULL;
+
+	data->shost = shost;
 	init_completion(&data->prev_finished);
 
 	mutex_lock(&shost->scan_mutex);

And tune the do_scsi_scan_host so it ends faster in case the host is being removed
@@ -1827,8 +1823,14 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
 		if (shost->hostt->scan_start)
 			shost->hostt->scan_start(shost);
 
-		while (!shost->hostt->scan_finished(shost, jiffies - start))
+		while (!shost->hostt->scan_finished(shost, jiffies - start)) {
 			msleep(10);
+			if (!scsi_host_scan_allowed(shost)) {
+				printk (KERN_INFO "scsi: host not in proper a "
+					"state, async scan aborted ...\n");
+				break;
+			}
+		}
 	} else {
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
------------------
Is the above solution good enough? I can imagine a ref counting object created after
a new device is attached would solve this better, if it already exists please advice.
Tomas

