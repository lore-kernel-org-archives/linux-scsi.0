From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] New: Kernel Oops when disconnecting a mounted ext4 usb
 stick
Date: Sun, 05 Jul 2015 20:17:08 +0000
Message-ID: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52854 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbbGEURN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 16:17:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8C36820641
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 20:17:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 599142063C
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 20:17:09 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

            Bug ID: 101011
           Summary: Kernel Oops when disconnecting a mounted ext4 usb
                    stick
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.1.1-040101-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: konradsa@gmail.com
        Regression: No

I am running Linux Mint Mate 17.2 with an update Ubuntu mainline kernel
downloaded from here:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.1-unstable/

When I disconnect a mounted ext4 USB stick without properly unmounting it
first, the kernel crashes and I need to reboot. Here the relevant logs, I can
reproduce this every time I try:

Jul  4 22:26:52 Lenny kernel: [  807.592356]  sdb: sdb1
Jul  4 22:26:52 Lenny kernel: [  807.595350] sd 3:0:0:0: [sdb] Attached SCSI
removable disk
Jul  4 22:26:53 Lenny kernel: [  807.826241] EXT4-fs (sdb1): mounted filesystem
with ordered data mode. Opts: (null)
Jul  4 22:27:02 Lenny kernel: [  817.461405] usb 2-2: USB disconnect, device
number 2
Jul  4 22:27:02 Lenny kernel: [  817.490648] Buffer I/O error on dev sdb1,
logical block 15237120, lost sync page write
Jul  4 22:27:02 Lenny kernel: [  817.490655] JBD2: Error -5 detected when
updating journal superblock for sdb1-8.
Jul  4 22:27:02 Lenny kernel: [  817.490873] BUG: unable to handle kernel
paging request at 34beb000
Jul  4 22:27:02 Lenny kernel: [  817.490929] IP: [<c136ce88>]
__percpu_counter_add+0x18/0xc0
Jul  4 22:27:02 Lenny kernel: [  817.490977] *pdpt = 0000000023db9001 *pde =
0000000000000000 
Jul  4 22:27:02 Lenny kernel: [  817.491024] Oops: 0000 [#1] SMP 
Jul  4 22:27:02 Lenny kernel: [  817.491056] Modules linked in: uas usb_storage
ctr ccm msr snd_hda_codec_analog snd_hda_codec_generic dm_multipath scsi_dh
pcmcia coretemp kvm_intel kvm snd_seq_midi snd_seq_midi_event snd_rawmidi arc4
snd_seq yenta_socket iwl3945 serio_raw thinkpad_acpi iwlegacy mac80211
snd_hda_intel nvram snd_hda_controller snd_seq_device snd_hda_codec
snd_hda_core snd_hwdep pcmcia_rsrc lpc_ich btusb pcmcia_core cfg80211 snd_pcm
btbcm btintel rfcomm snd_timer shpchp bnep bluetooth snd soundcore 8250_fintek
parport_pc ppdev tp_smapi(OE) thinkpad_ec(OE) mac_hid lp parport dm_mirror
dm_region_hash dm_log i915 e1000e i2c_algo_bit sdhci_pci psmouse drm_kms_helper
ahci ptp libahci sdhci drm pps_core video
Jul  4 22:27:02 Lenny kernel: [  817.491694] CPU: 0 PID: 4083 Comm: umount
Tainted: G     U     OE   4.1.1-040101-generic #201507011435
Jul  4 22:27:02 Lenny kernel: [  817.491761] Hardware name: LENOVO
7675CTO/7675CTO, BIOS 7NETC2WW (2.22 ) 03/22/2011
Jul  4 22:27:02 Lenny kernel: [  817.491814] task: ebf06b50 ti: ebebc000
task.ti: ebebc000
Jul  4 22:27:02 Lenny kernel: [  817.491853] EIP: 0060:[<c136ce88>] EFLAGS:
00010082 CPU: 0
Jul  4 22:27:02 Lenny kernel: [  817.491894] EIP is at
__percpu_counter_add+0x18/0xc0
Jul  4 22:27:02 Lenny kernel: [  817.491931] EAX: f21c8e88 EBX: f21c8e88 ECX:
00000000 EDX: 00000001
Jul  4 22:27:02 Lenny kernel: [  817.491975] ESI: 00000001 EDI: 00000000 EBP:
ebebde60 ESP: ebebde40
Jul  4 22:27:02 Lenny kernel: [  817.492018]  DS: 007b ES: 007b FS: 00d8 GS:
00e0 SS: 0068
Jul  4 22:27:02 Lenny kernel: [  817.492057] CR0: 8005003b CR2: 34beb000 CR3:
33354200 CR4: 000007f0
Jul  4 22:27:02 Lenny kernel: [  817.492100] Stack:
Jul  4 22:27:02 Lenny kernel: [  817.492117]  c1abe100 edcb0098 edcb00ec
ffffffff f21c8e68 ffffffff f21c8e68 f286d160
Jul  4 22:27:02 Lenny kernel: [  817.492198]  ebebde84 c1160454 00000010
00000282 f72a77f8 00000984 f72a77f8 f286d160
Jul  4 22:27:02 Lenny kernel: [  817.492277]  f286d170 ebebdea0 c11e613f
00000000 00000282 f72a77f8 edd7f4d0 00000000
Jul  4 22:27:02 Lenny kernel: [  817.492355] Call Trace:
Jul  4 22:27:02 Lenny kernel: [  817.492379]  [<c1160454>]
account_page_dirtied+0x74/0x110
Jul  4 22:27:02 Lenny kernel: [  817.492420]  [<c11e613f>]
__set_page_dirty+0x3f/0xb0
Jul  4 22:27:02 Lenny kernel: [  817.492459]  [<c11e6203>]
mark_buffer_dirty+0x53/0xc0
Jul  4 22:27:02 Lenny kernel: [  817.492497]  [<c124a0cb>]
ext4_commit_super+0x17b/0x250
Jul  4 22:27:02 Lenny kernel: [  817.492535]  [<c124ac71>]
ext4_put_super+0xc1/0x320
Jul  4 22:27:02 Lenny kernel: [  817.492572]  [<c11f04ba>] ?
fsnotify_unmount_inodes+0x1aa/0x1c0
Jul  4 22:27:02 Lenny kernel: [  817.492615]  [<c11cfeda>] ?
evict_inodes+0xca/0xe0
Jul  4 22:27:02 Lenny kernel: [  817.492653]  [<c11b925a>]
generic_shutdown_super+0x6a/0xe0
Jul  4 22:27:02 Lenny kernel: [  817.492695]  [<c10a1df0>] ?
prepare_to_wait_event+0xd0/0xd0
Jul  4 22:27:02 Lenny kernel: [  817.492736]  [<c1165a50>] ?
unregister_shrinker+0x40/0x50
Jul  4 22:27:02 Lenny kernel: [  817.492775]  [<c11b92f6>]
kill_block_super+0x26/0x70
Jul  4 22:27:02 Lenny kernel: [  817.492815]  [<c11b94f5>]
deactivate_locked_super+0x45/0x80
Jul  4 22:27:02 Lenny kernel: [  817.492854]  [<c11ba007>]
deactivate_super+0x47/0x60
Jul  4 22:27:02 Lenny kernel: [  817.492892]  [<c11d2b39>]
cleanup_mnt+0x39/0x80
Jul  4 22:27:02 Lenny kernel: [  817.492925]  [<c11d2bc0>]
__cleanup_mnt+0x10/0x20
Jul  4 22:27:02 Lenny kernel: [  817.492960]  [<c1080b51>]
task_work_run+0x91/0xd0
Jul  4 22:27:02 Lenny kernel: [  817.492996]  [<c1011e3c>]
do_notify_resume+0x7c/0x90
Jul  4 22:27:02 Lenny kernel: [  817.493035]  [<c1720da5>] work_notify
ul  4 22:27:02 Lenny kernel: [  817.493071] Code: 8b 55 e8 e9 f4 fe ff ff 90 90
90 90 90 90 90 90 90 90 90 55 89 e5 83 ec 20 89 5d f4 89 c3 89 75 f8 89 d6 89
7d fc 89 cf 8b 48 14 <64> 8b 01 89 45 ec 89 c2 8b 45 08 c1 fa 1f 01 75 ec 89 55
f0 89
Jul  4 22:27:02 Lenny kernel: [  817.493401] EIP: [<c136ce88>]
__percpu_counter_add+0x18/0xc0 SS:ESP 0068:ebebde40
Jul  4 22:27:02 Lenny kernel: [  817.493462] CR2: 0000000034beb000
Jul  4 22:27:02 Lenny kernel: [  817.494516] ---[ end trace dd564a7bea834ecd
]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
