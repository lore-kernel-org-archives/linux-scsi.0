From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: rdac and aac
Date: Wed, 16 Jul 2008 13:17:22 -0500
Message-ID: <1216232242.3358.48.camel@localhost.localdomain>
References: <86802c440807161051r7632c1d3qeb73c3cc1a124ed6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47290 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYGPSR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 14:17:26 -0400
In-Reply-To: <86802c440807161051r7632c1d3qeb73c3cc1a124ed6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-07-16 at 10:51 -0700, Yinghai Lu wrote:
> calling  aac_init+0x0/0x9a
> Adaptec aacraid driver 1.1-5[2456]-ms
> vendor=10de device=005d
> ACPI: PCI Interrupt 0000:86:00.0[A] -> Link [LN2C] -> GSI 42 (level,
> low) -> IRQ 42
> PCI: Setting latency timer of device 0000:86:00.0 to 64
> AAC0: kernel 5.2-0[15535] Oct 11 2007
> AAC0: monitor 5.2-0[15535]
> AAC0: bios 5.2-0[15535]
> AAC0: serial 00721EC0115
> AAC0: Non-DASD support enabled.
> AAC0: 64bit support enabled.
> AAC0: 64 Bit DAC enabled
> scsi0 : aacraid
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> IP: [<ffffffff8051f024>] strncmp+0x1b/0x54
> PGD 0
> Oops: 0000 [1] SMP
> CPU 28
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-tip-00047-g69a6a3e-dirty #394
> RIP: 0010:[<ffffffff8051f024>]  [<ffffffff8051f024>] strncmp+0x1b/0x54
> RSP: 0018:ffff883824c579f0  EFLAGS: 00010206
> RAX: 0000000000000000 RBX: ffffffff80ad2190 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: ffffffff80cfe351 RDI: 0000000000000003
> RBP: ffff883824c57a00 R08: 0000000000000000 R09: ffffe200e0774440
> R10: 00000000f6f3ecb9 R11: 00000000f6f3ecb9 R12: ffff88402206c050
> R13: ffff88402206c170 R14: 0000000000000000 R15: ffffffffffffffff
> FS:  0000000000000000(0000) GS:ffff884024c3b600(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000003 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff883824c56000, task ffff883024c58000)
> Stack:  ffffffff80e705d0 00000000f6f3ecb9 ffff883824c57a50 ffffffff806ab127
>  ffffe200e0774440 00000000f6f3ecb9 00000000f6f3ecb9 0000000000000000
>  00000000ffffffff 0000000000000000 ffff88402206c170 0000000000000001
> Call Trace:
>  [<ffffffff806ab127>] rdac_bus_notify+0x68/0x235
>  [<ffffffff80a4f7c6>] notifier_call_chain+0x45/0x84
>  [<ffffffff802835f1>] __blocking_notifier_call_chain+0x61/0x92
>  [<ffffffff80283649>] blocking_notifier_call_chain+0x27/0x3d
>  [<ffffffff805b5f36>] device_add+0xf5/0x4fd
>  [<ffffffff80682811>] ? scsi_setup_command_freelist+0x6c/0xc6
>  [<ffffffff80683477>] scsi_add_host+0xc5/0x20f
>  [<ffffffff80a28269>] aac_probe_one+0x3ef/0x4ba
>  [<ffffffff8053014e>] pci_device_probe+0xd5/0x142
>  [<ffffffff805b8a01>] driver_probe_device+0xd4/0x199
>  [<ffffffff802830da>] ? down+0x4b/0x68
>  [<ffffffff805b8b29>] __driver_attach+0x63/0xa4
>  [<ffffffff805b8ac6>] ? __driver_attach+0x0/0xa4
>  [<ffffffff805b8009>] bus_for_each_dev+0x63/0xb1
>  [<ffffffff805b87cb>] driver_attach+0x34/0x4a
>  [<ffffffff805b7779>] bus_add_driver+0xcb/0x22b
>  [<ffffffff8051ae5a>] ? kset_find_obj+0x4c/0x96
>  [<ffffffff805b8e4e>] driver_register+0xbc/0x153
>  [<ffffffff802313bd>] ? read_tsc+0x9/0x1c
>  [<ffffffff8053046f>] __pci_register_driver+0x67/0xb8
>  [<ffffffff80f71e34>] ? aac_init+0x0/0x9a
>  [<ffffffff80f71e7f>] aac_init+0x4b/0x9a
>  [<ffffffff80f409e4>] kernel_init+0x1de/0x346
>  [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
>  [<ffffffff80262df7>] ? finish_task_switch+0x14/0xe3
>  [<ffffffff8022b589>] child_rip+0xa/0x11
>  [<ffffffff80f40806>] ? kernel_init+0x0/0x346
>  [<ffffffff8022b57f>] ? child_rip+0x0/0x11

Great ... I think this is another "we added targets to the scsi bus and
now it doesn't work" problem.  To test the theory, does this fix the
problem?

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 6fff077..fdf34b0 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -608,12 +608,17 @@ static int rdac_bus_notify(struct notifier_block *nb,
 			    unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
 	struct scsi_dh_data *scsi_dh_data;
 	struct rdac_dh_data *h;
 	int i, found = 0;
 	unsigned long flags;
 
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		for (i = 0; rdac_dev_list[i].vendor; i++) {
 			if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,


