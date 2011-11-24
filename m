From: Huajun Li <huajun.li.lee@gmail.com>
Subject: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Thu, 24 Nov 2011 22:30:24 +0800
Message-ID: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1KXOa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Nov 2011 09:30:26 -0500
Received: by bke11 with SMTP id 11so3008695bke.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Nov 2011 06:30:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Huajun Li <huajun.li.lee@gmail.com>

  While unplugging usb disk, scsi_disk(disk)->device  may be released
before sd_revalidate_disk() is called, then there will occur Oops as
shown below:

  [  285.988055] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
  [  285.988112] IP: [<ffffffffa0111bb9>]
sd_revalidate_disk+0x49/0x23b0 [sd_mod]
  [  285.988158] PGD 60ea1067 PUD 6442c067 PMD 0
  [  285.988196] Oops: 0000 [#1] SMP
  [  285.988226] CPU 0
  [  285.988239] Modules linked in: usb_storage usb_libusual uas
bluetooth dm_crypt snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_hwdep
  [  285.988329] PM: Removing info for scsi:host16
  [  285.988361]  snd_pcm snd_seq_midi snd_rawmidi hp_wmi
snd_seq_midi_event snd_seq sparse_keymap ppdev snd_timer i915
snd_seq_device binfmt_misc snd psmouse serio_raw soundcore
snd_page_alloc tpm_infineon tpm_tis drm_kms_helper
  [  285.988518] bus: 'scsi': remove device host16
  [  285.988549]  tpm parport_pc tpm_bios drm i2c_algo_bit video lp
parport usbhid hid sg sr_mod sd_mod floppy uhci_hcd ehci_hcd usbcore
e1000e usb_common
  [  285.988682]
  [  285.990007] Pid: 2890, comm: blkid Tainted: G          I
3.2.0-rc3+ #1 Hewlett-Packard HP Compaq dc7800p Convertible
Minitower/0AACh
  [  285.990007] RIP: 0010:[<ffffffffa0111bb9>]  [<ffffffffa0111bb9>]
sd_revalidate_disk+0x49/0x23b0 [sd_mod]
  [  285.990007] RSP: 0018:ffff880060ebfa48  EFLAGS: 00010206
  [  285.990007] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
000000005ab95ab8
  [  285.990007] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000202
  [  285.990007] RBP: ffff880060ebfb08 R08: 0000000000000002 R09:
0000000000000000
  [  285.990007] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff88006e2f37b0
  [  285.999544] R13: ffff88006e2f37b0 R14: ffff8800022032d8 R15:
ffff88006e2f37b0
  [  285.999544] FS:  00007f71eab70760(0000) GS:ffff88007a200000(0000)
knlGS:0000000000000000
  [  285.999544] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  [  285.999544] CR2: 0000000000000008 CR3: 0000000064c19000 CR4:
00000000000006f0
  [  285.999544] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
  [  285.999544] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
  [  285.999544] Process blkid (pid: 2890, threadinfo
ffff880060ebe000, task ffff88005bbdc800)
  [  285.999544] Stack:
  [  285.999544]  0000000000000000 ffffffff81490c80 ffffffff00000000
ffff8800022032c0
  [  285.999544]  ffff880060ebfab8 0000000000000206 ffffffff81e311e0
0000000000000206
  [  285.999544]  ffffffff81e311e0 ffff880060ebfb40 0000000000000000
0000000000000002
  [  285.999544] Call Trace:
  [  285.999544]  [<ffffffff81490c80>] ? disk_part_iter_next+0x360/0x360
  [  285.999544]  [<ffffffff81490ae0>] ? disk_part_iter_next+0x1c0/0x360
  [  285.999544]  [<ffffffff8149096b>] ? disk_part_iter_next+0x4b/0x360
  [  285.999544]  [<ffffffff81490c80>] ? disk_part_iter_next+0x360/0x360
  [  285.999544]  [<ffffffff812f73ca>] rescan_partitions+0xfa/0x7b0
  [  285.999544]  [<ffffffff812a4f06>] __blkdev_get+0x436/0x690
  [  285.999544]  [<ffffffff812a51c3>] blkdev_get+0x63/0x590
  [  285.999544]  [<ffffffff814c77f0>] ? do_raw_spin_unlock+0x70/0x110
  [  285.999544]  [<ffffffff8192a3c3>] ? _raw_spin_unlock+0x43/0x60
  [  285.999544]  [<ffffffff812a5784>] blkdev_open+0x94/0xd0
  [  285.999544]  [<ffffffff8124a044>] __dentry_open+0x3f4/0x630
  [  285.999544]  [<ffffffff814c77f0>] ? do_raw_spin_unlock+0x70/0x110
  [  285.999544]  [<ffffffff812a56f0>] ? blkdev_get+0x590/0x590
  [  285.999544]  [<ffffffff8124c0a4>] nameidata_to_filp+0x94/0xb0
  [  285.999544]  [<ffffffff812639a8>] do_last+0x3e8/0xe70
  [  285.999544]  [<ffffffff81267183>] path_openat+0x103/0x5c0
  [  285.999544]  [<ffffffff812677ca>] do_filp_open+0x4a/0xd0
  [  285.999544]  [<ffffffff8192a3c3>] ? _raw_spin_unlock+0x43/0x60
  [  285.999544]  [<ffffffff8127c5e2>] ? alloc_fd+0x202/0x350
  [  285.999544]  [<ffffffff8124c214>] do_sys_open+0x154/0x280
  [  285.999544]  [<ffffffff8124c368>] sys_open+0x28/0x40
  [  285.999544]  [<ffffffff81937202>] system_call_fastpath+0x16/0x1b
  [  285.999544] Code: 00 00 48 83 05 80 84 00 00 01 65 48 8b 04 25 28
00 00 00 48 89 45 c8 31 c0 49 89 fd 48 85 db 0f 84 7a 20 00 00 8b 05
87 85 45 e3 <4c> 8b 63 08 c1 e8 15 83 e0 07 83 f8 03 0f 87 1b 20 00 00
41 8b
  [  286.051169] RIP  [<ffffffffa0111bb9>]
sd_revalidate_disk+0x49/0x23b0 [sd_mod]
  [  286.051169]  RSP <ffff880060ebfa48>
  [  286.051169] CR2: 0000000000000008


Signed-off-by: Huajun Li <huajun.li.lee@gmail.com>
---
 drivers/scsi/sd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..06d874d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2354,10 +2354,15 @@ static int sd_try_extended_inquiry(struct
scsi_device *sdp)
 static int sd_revalidate_disk(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
+	struct scsi_device *sdp;
 	unsigned char *buffer;
 	unsigned flush = 0;

+	if (sdkp)
+		sdp = sdkp->device;
+	else
+		goto out;
+
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));

-- 
1.7.4.1
