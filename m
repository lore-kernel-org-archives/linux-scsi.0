From: Saran Neti <sarannmr@gmail.com>
Subject: Kernel BUG() in block/blk-tag.c:89 causing panic.
Date: Thu, 19 Jun 2014 00:53:01 -0400
Message-ID: <CAE6A3M1UUJWL4ZoUsLdtSjaWb92kdB7MvzHVeAgA+3ewBRG=LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45943 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbaFSExB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 00:53:01 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so1595066igb.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2014 21:53:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[ Copied. First sent to linux-hotplug ]

Hi,

I have a many identical looking USB drives in two btrfs multi-device
configurations. I was unplugging and replugging a few devices to
identify which physical device belonged to which btrfs filesystem.
Running "btrfs fi show" during this unplugging/replugging business
produced the BUG() stack trace shown below. "btrfs fi show" wouldn't
return and neither would "fdisk -l". When I tried to reboot the
computer, it panicked forcing me to do a hard reset.

All hard disks are run-of-the-mill Seagate Expansion or Backup Plus
drives. They all work fine (data and SMART) when kernel
detects them at the start. I hit the BUG() twice during
unplugging/replugging them randomly and I think it could've been when
I swapped USB ports for identical drives (model/version etc.)

If more lspci/lsusb information if needed, let me know. I should be
able to reproduce it again and if needed insert printks and debug on
mainline.

# uname -a
Linux godel 3.15.1-1-ARCH #1 SMP PREEMPT Tue Jun 17 09:32:20 CEST 2014
x86_64 GNU/Linux

------------[ cut here ]------------
kernel BUG at block/blk-tag.c:89!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: bridge stp llc tun nct6775 hwmon_vid hid_microsoft
uas usb_storage joydev hid_generic ir_lirc_codec mousedev lirc_dev
ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder
ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_rc6_mce
usbhid mceusb rc_core hid snd_hda_codec_hdmi coretemp hwmon
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm iTCO_wdt
iTCO_vendor_support ppdev mxm_wmi evdev mac_hid ext4 crc16 mbcache
jbd2 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd
microcode snd_hda_codec_realtek i915 snd_hda_codec_generic psmouse
serio_raw pcspkr snd_hda_intel snd_hda_controller drm_kms_helper drm
snd_hda_codec snd_hwdep parport_pc i2c_i801 snd_pcm lpc_ich r8169 mii
parport mei_me thermal fan wmi battery tpm_infineon tpm_tis tpm
 mei snd_timer video shpchp intel_gtt snd i2c_algo_bit button i2c_core
soundcore processor btrfs xor atkbd libps2 c
rc32c_intel ehci_pci ehci_hcd xhci_hcd usbcore usb_common raid6_pq
i8042 serio sd_mod crc_t10dif crct10dif_common ahci libahci libata
scsi_mod
CPU: 0 PID: 821 Comm: systemd-udevd Not tainted 3.15.1-1-ARCH #1
Hardware name: MSI MS-7850/Z87-G41 PC Mate(MS-7850), BIOS V1.6 02/21/2014
task: ffff88020a369460 ti: ffff8801f4ff8000 task.ti: ffff8801f4ff8000
RIP: 0010:[<ffffffff8126b188>]  [<ffffffff8126b188>] blk_free_tags+0x18/0x20
RSP: 0018:ffff8801f4ffbbb0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8801f2845000 RCX: 0000000000340780
RDX: 0000000000000000 RSI: ffff880037d1a600 RDI: ffff8802112a3a00
RBP: ffff8801f4ffbbb0 R08: 000000000001b760 R09: ffff880214873800
R10: ffff88021fa1b760 R11: ffffea0000df4680 R12: ffff88020629f030
R13: ffff8800b65ca480 R14: ffff8801f28451a0 R15: ffff8800b65c4120
FS:  00007f4256c9f7c0(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2ba863e038 CR3: 00000001f4fe0000 CR4: 00000000000407f0
Stack:
 ffff8801f4ffbbd8 ffffffffa0003230 ffff8801f28451a0 ffff8801f2845190
 ffff8800b65ca480 ffff8801f4ffbc00 ffffffff8138c552 ffff8801f28451d8
 ffffffff8189e2c0 ffff8802106f8ac0 ffff8801f4ffbc30 ffffffff8129466a
Call Trace:
 [<ffffffffa0003230>] scsi_host_dev_release+0xb0/0xf0 [scsi_mod]
 [<ffffffff8138c552>] device_release+0x32/0xa0
 [<ffffffff8129466a>] kobject_release+0x7a/0x1c0
 [<ffffffff812947dd>] kobject_put+0x2d/0x60
 [<ffffffff8138c997>] put_device+0x17/0x20
 [<ffffffffa000af7f>] scsi_target_dev_release+0x1f/0x30 [scsi_mod]
 [<ffffffff8138c552>] device_release+0x32/0xa0
 [<ffffffff8129466a>] kobject_release+0x7a/0x1c0
 [<ffffffff812947dd>] kobject_put+0x2d/0x60
 [<ffffffff8138c997>] put_device+0x17/0x20
 [<ffffffffa000e435>] scsi_device_dev_release_usercontext+0x195/0x1a0 [scsi_mod]
 [<ffffffff81085257>] execute_in_process_context+0x67/0x70
 [<ffffffffa000e29c>] scsi_device_dev_release+0x1c/0x20 [scsi_mod]
 [<ffffffff8138c552>] device_release+0x32/0xa0
 [<ffffffff8129466a>] kobject_release+0x7a/0x1c0
 [<ffffffff812947dd>] kobject_put+0x2d/0x60
 [<ffffffff8138c997>] put_device+0x17/0x20
 [<ffffffffa000180a>] scsi_device_put+0x3a/0x50 [scsi_mod]
 [<ffffffffa00a4810>] scsi_disk_put+0x30/0x50 [sd_mod]
 [<ffffffffa00a5821>] sd_release+0x31/0x70 [sd_mod]
 [<ffffffff811ef642>] __blkdev_put+0x182/0x1c0
 [<ffffffff811f000c>] blkdev_put+0x4c/0x150
 [<ffffffff811f01c5>] blkdev_close+0x25/0x30
 [<ffffffff811b609c>] __fput+0x9c/0x200
 [<ffffffff811b624e>] ____fput+0xe/0x10
 [<ffffffff8108a35f>] task_work_run+0x9f/0xe0
 [<ffffffff81014c55>] do_notify_resume+0x95/0xa0
 [<ffffffff81515be0>] int_signal+0x12/0x17
Code: c3 66 90 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 55 48 89 e5 e8 82 ff ff ff 85 c0 74 0
6 5d c3 0f 1f 40 00 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89
e5 53 48 89 fb
RIP  [<ffffffff8126b188>] blk_free_tags+0x18/0x20
 RSP <ffff8801f4ffbbb0>
---[ end trace bc3cb23eb685d10a ]---
systemd-udevd[185]: worker [821] terminated by signal 11 (Segmentation fault)


-- 
Saran
