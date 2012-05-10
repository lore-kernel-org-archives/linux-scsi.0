From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: [PATCH][SCSI] panic within ses.ko during insmod
Date: Thu, 10 May 2012 16:48:00 -0400
Message-ID: <8A8902EE-82F3-4CBA-82D6-D689B49C28BC@xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com> <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com> <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com> <1329667370.2806.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: multipart/mixed; boundary="Apple-Mail=_7003268C-1A94-4F47-89C8-DB7C5A011DA5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:36641 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756938Ab2EJUsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 16:48:08 -0400
In-Reply-To: <1329667370.2806.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>


--Apple-Mail=_7003268C-1A94-4F47-89C8-DB7C5A011DA5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Rarely, ses.ko load while scanning was taking place resulted in a panic. =
Discovered that the panic occurred while the inquiry field for a scsi =
device was NULL and an unprotected call to scsi_device_enclosure() =
occurred. Suggest that the inline function scsi_device_enclosure be =
modified, but for this panic, we can address this specific issue as =
outlined at the bottom of this patch submission.

device BUG: unable to handle kernel NULL pointer dereference at =
0000000000000006
IP: [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
PGD 80e354067 PUD 805f3c067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb1/idVendor
CPU 0
Modules linked in: ses(+) enclosure mlx4_ib ib_mad ib_core mlx4_en =
mlx4_core ext4 mbcache jbd2 usb_storage sd_mod crc_t10dif ahci isci =
libsas mpt2sas scsi_transport_sas raid_class dm_mod

Modules linked in: ses(+) enclosure mlx4_ib ib_mad ib_core mlx4_en =
mlx4_core ext4 mbcache jbd2 usb_storage sd_mod crc_t10dif ahci isci =
libsas mpt2sas scsi_transport_sas raid_class dm_mod
Pid: 1757, comm: modprobe Tainted: G        W  ----------------
RIP: 0010:[<ffffffffa00230f1>]  [<ffffffffa00230f1>] =
ses_intf_add+0x2f1/0x5e0 [ses]
RSP: 0018:ffff8807ed73be38  EFLAGS: 00010246
RAX: ffff8808081dd000 RBX: ffff880809d59000 RCX: 000000000000007f
RDX: 0000000000000000 RSI: ffffffff812654a0 RDI: 0000000000000000
RBP: ffff8807ed73be98 R08: ffffffff81bfdec8 R09: 0000000000000040
R10: 0000000000000000 R11: 0000000000000026 R12: ffff8808053259a0
R13: 0000000000000530 R14: ffff88080b640000 R15: ffff8808051c8540
FS:  00007f337c0cd700(0000) GS:ffff880047e00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000006 CR3: 0000000807403000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1757, threadinfo ffff8807ed73a000, task =
ffff88080c542040)
Stack:
 ffff8807ed73be78 ffffffff814be88f ffff8808081d0000 ffff880809d59358
<0> ffff880809d59138 ffff88080dfb5000 0000000000000000 ffffffffa0023660
<0> ffffffff81b00fe0 ffff8807ed73bea8 0000000000000000 0000000000000000

Call Trace:
 [<ffffffff814be88f>] ? klist_next+0x7f/0xf0
 [<ffffffff813383b9>] class_interface_register+0xa9/0xe0
 [<ffffffffa00fe000>] ? ses_init+0x0/0x3c [ses]
 [<ffffffff81357f16>] scsi_register_interface+0x16/0x20
 [<ffffffffa00fe014>] ses_init+0x14/0x3c [ses]
 [<ffffffff8100204c>] do_one_initcall+0x3c/0x1d0
 [<ffffffff810aca7f>] sys_init_module+0xdf/0x250
 [<ffffffff8100b172>] system_call_fastpath+0x16/0x1b
Code: 32 e1 48 85 c0 75 13 eb 51 90 48 8b 3b 48 89 c6 e8 45 6d 32 e1 48 =
85 c0 74 40 8b b8 84 00 00 00 85 ff 75 e6 48 8b 90 a8 00 00 00 <f6> 42 =
06 40 75 d9 48 89 c6 4c 89 f7 48 89 45 b0 e8 aa fa ff ff
RIP  [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
 RSP <ffff8807ed73be38>
CR2: 0000000000000006
---[ end trace 766a927d5bc5e5f3 ]---
Kernel panic - not syncing: Fatal exception
Pid: 1757, comm: modprobe Tainted: G      D W  ----------------=20
Call Trace:
 [<ffffffff814d65a8>] ? panic+0x78/0x143
 [<ffffffff814da5f4>] ? oops_end+0xe4/0x100
 [<ffffffff81040c9b>] ? no_context+0xfb/0x260
 [<ffffffff81040f25>] ? __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff8104104e>] ? bad_area+0x4e/0x60
 [<ffffffff81041773>] ? __do_page_fault+0x3c3/0x480
 [<ffffffff811e745c>] ? sysfs_add_one+0x2c/0x130
 [<ffffffff811e7988>] ? sysfs_do_create_link+0xd8/0x170
 [<ffffffff811e7a53>] ? sysfs_create_link+0x13/0x20
 [<ffffffffa00e2617>] ? enclosure_add_device+0x137/0x160 [enclosure]
 [<ffffffff814dc5de>] ? do_page_fault+0x3e/0xa0
 [<ffffffff814d9965>] ? page_fault+0x25/0x30
 [<ffffffff812654a0>] ? kobject_release+0x0/0x240
 [<ffffffffa00230f1>] ? ses_intf_add+0x2f1/0x5e0 [ses]
 [<ffffffffa0023115>] ? ses_intf_add+0x315/0x5e0 [ses]
 [<ffffffff814be88f>] ? klist_next+0x7f/0xf0
 [<ffffffff813383b9>] ? class_interface_register+0xa9/0xe0
 [<ffffffffa00fe000>] ? ses_init+0x0/0x3c [ses]
 [<ffffffff81357f16>] ? scsi_register_interface+0x16/0x20
 [<ffffffffa00fe014>] ? ses_init+0x14/0x3c [ses]
 [<ffffffff8100204c>] ? do_one_initcall+0x3c/0x1d0
 [<ffffffff810aca7f>] ? sys_init_module+0xdf/0x250
 [<ffffffff8100b172>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Mark Salyzyn <Mark_Salyzyn@xyratex.com>

 drivers/scsi/ses.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eba183c..0e69cf9 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -628,7 +628,9 @@ static int ses_intf_add(struct device *cdev,
 	/* see if there are any devices matching before
 	 * we found the enclosure */
 	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->lun !=3D 0 || =
scsi_device_enclosure(tmp_sdev))
+		if (tmp_sdev->lun !=3D 0
+		 || tmp_sdev->inquiry !=3D NULL
+		 || scsi_device_enclosure(tmp_sdev))
 			continue;
 		ses_match_to_enclosure(edev, tmp_sdev);
 	}


--Apple-Mail=_7003268C-1A94-4F47-89C8-DB7C5A011DA5
Content-Disposition: attachment;
	filename=ses-panic.patch
Content-Type: application/octet-stream;
	name="ses-panic.patch"
Content-Transfer-Encoding: 7bit

ses.ko load while scanning was taking place resulted in a panic. Discovered
that the panic occurred while the inquiry field for a scsi device was NULL
and an unprotected call to scsi_device_enclosure() occurred. Suggest that
the inline function scsi_device_enclosure be modified, but for this panic, we
can address this specific issue as outlined at the bottom of this
patch submission.

device BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
IP: [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
PGD 80e354067 PUD 805f3c067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb1/idVendor
CPU 0
Modules linked in: ses(+) enclosure mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext4 mbcache jbd2 usb_storage sd_mod crc_t10dif ahci isci libsas mpt2sas scsi_transport_sas raid_class dm_mod

Modules linked in: ses(+) enclosure mlx4_ib ib_mad ib_core mlx4_en mlx4_core ext4 mbcache jbd2 usb_storage sd_mod crc_t10dif ahci isci libsas mpt2sas scsi_transport_sas raid_class dm_mod
Pid: 1757, comm: modprobe Tainted: G        W  ----------------
RIP: 0010:[<ffffffffa00230f1>]  [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
RSP: 0018:ffff8807ed73be38  EFLAGS: 00010246
RAX: ffff8808081dd000 RBX: ffff880809d59000 RCX: 000000000000007f
RDX: 0000000000000000 RSI: ffffffff812654a0 RDI: 0000000000000000
RBP: ffff8807ed73be98 R08: ffffffff81bfdec8 R09: 0000000000000040
R10: 0000000000000000 R11: 0000000000000026 R12: ffff8808053259a0
R13: 0000000000000530 R14: ffff88080b640000 R15: ffff8808051c8540
FS:  00007f337c0cd700(0000) GS:ffff880047e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000006 CR3: 0000000807403000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1757, threadinfo ffff8807ed73a000, task ffff88080c542040)
Stack:
 ffff8807ed73be78 ffffffff814be88f ffff8808081d0000 ffff880809d59358
<0> ffff880809d59138 ffff88080dfb5000 0000000000000000 ffffffffa0023660
<0> ffffffff81b00fe0 ffff8807ed73bea8 0000000000000000 0000000000000000

Call Trace:
 [<ffffffff814be88f>] ? klist_next+0x7f/0xf0
 [<ffffffff813383b9>] class_interface_register+0xa9/0xe0
 [<ffffffffa00fe000>] ? ses_init+0x0/0x3c [ses]
 [<ffffffff81357f16>] scsi_register_interface+0x16/0x20
 [<ffffffffa00fe014>] ses_init+0x14/0x3c [ses]
 [<ffffffff8100204c>] do_one_initcall+0x3c/0x1d0
 [<ffffffff810aca7f>] sys_init_module+0xdf/0x250
 [<ffffffff8100b172>] system_call_fastpath+0x16/0x1b
Code: 32 e1 48 85 c0 75 13 eb 51 90 48 8b 3b 48 89 c6 e8 45 6d 32 e1 48 85 c0 74 40 8b b8 84 00 00 00 85 ff 75 e6 48 8b 90 a8 00 00 00 <f6> 42 06 40 75 d9 48 89 c6 4c 89 f7 48 89 45 b0 e8 aa fa ff ff
RIP  [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
 RSP <ffff8807ed73be38>
CR2: 0000000000000006
---[ end trace 766a927d5bc5e5f3 ]---
Kernel panic - not syncing: Fatal exception
Pid: 1757, comm: modprobe Tainted: G      D W  ---------------- 
Call Trace:
 [<ffffffff814d65a8>] ? panic+0x78/0x143
 [<ffffffff814da5f4>] ? oops_end+0xe4/0x100
 [<ffffffff81040c9b>] ? no_context+0xfb/0x260
 [<ffffffff81040f25>] ? __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff8104104e>] ? bad_area+0x4e/0x60
 [<ffffffff81041773>] ? __do_page_fault+0x3c3/0x480
 [<ffffffff811e745c>] ? sysfs_add_one+0x2c/0x130
 [<ffffffff811e7988>] ? sysfs_do_create_link+0xd8/0x170
 [<ffffffff811e7a53>] ? sysfs_create_link+0x13/0x20
 [<ffffffffa00e2617>] ? enclosure_add_device+0x137/0x160 [enclosure]
 [<ffffffff814dc5de>] ? do_page_fault+0x3e/0xa0
 [<ffffffff814d9965>] ? page_fault+0x25/0x30
 [<ffffffff812654a0>] ? kobject_release+0x0/0x240
 [<ffffffffa00230f1>] ? ses_intf_add+0x2f1/0x5e0 [ses]
 [<ffffffffa0023115>] ? ses_intf_add+0x315/0x5e0 [ses]
 [<ffffffff814be88f>] ? klist_next+0x7f/0xf0
 [<ffffffff813383b9>] ? class_interface_register+0xa9/0xe0
 [<ffffffffa00fe000>] ? ses_init+0x0/0x3c [ses]
 [<ffffffff81357f16>] ? scsi_register_interface+0x16/0x20
 [<ffffffffa00fe014>] ? ses_init+0x14/0x3c [ses]
 [<ffffffff8100204c>] ? do_one_initcall+0x3c/0x1d0
 [<ffffffff810aca7f>] ? sys_init_module+0xdf/0x250
 [<ffffffff8100b172>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Mark Salyzyn <Mark_Salyzyn@xyratex.com>

 drivers/scsi/ses.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eba183c..0e69cf9 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -628,7 +628,9 @@ static int ses_intf_add(struct device *cdev,
 	/* see if there are any devices matching before
 	 * we found the enclosure */
 	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->lun != 0 || scsi_device_enclosure(tmp_sdev))
+		if (tmp_sdev->lun != 0
+		 || tmp_sdev->inquiry != NULL
+		 || scsi_device_enclosure(tmp_sdev))
 			continue;
 		ses_match_to_enclosure(edev, tmp_sdev);
 	}

--Apple-Mail=_7003268C-1A94-4F47-89C8-DB7C5A011DA5--
