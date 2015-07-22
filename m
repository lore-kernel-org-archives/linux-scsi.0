From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Wed, 22 Jul 2015 17:39:41 +0000
Message-ID: <bug-101011-11613-QFaoNJfGwY@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbbGVRjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 13:39:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 177AE206B6
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2015 17:39:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 00F1520673
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2015 17:39:43 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

taz-007@latribu.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |taz-007@latribu.com

--- Comment #5 from taz-007@latribu.com ---
Can also reproduce on a non-tainted kernel (4.1.2) on an old laptop:

jui 21 10:19:15 Aspire kernel: usb 3-3.3.4.1.1: USB disconnect, device number
15
jui 21 10:19:15 Aspire kernel: BUG: unable to handle kernel paging request at
34943000
jui 21 10:19:16 Aspire kernel: IP: [<c127cd7b>] __percpu_counter_add+0x1b/0xd0
jui 21 10:19:16 Aspire kernel: *pde = 00000000 
jui 21 10:19:17 Aspire kernel: Oops: 0000 [#1] PREEMPT SMP 
jui 21 10:19:17 Aspire kernel: Modules linked in: joydev psmouse
snd_hda_codec_hdmi pcspkr serio_raw iTCO_wdt iTCO_vendor_support i2c_i801 evdev
mousedev mac_hid i915 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
ipw2200 snd_hda_controller snd_hda_codec drm_kms_helper 8139too libipw
snd_hda_core drm 8139cp lib80211 snd_hwdep cfg80211 snd_pcm pcmcia i2c_algo_bit
i2c_core mii rfkill snd_timer lpc_ich intel_agp yenta_socket intel_gtt agpgart
pcmcia_rsrc pcmcia_core snd rng_core soundcore thermal battery shpchp video ac
button acpi_cpufreq processor sch_fq_codel ip_tables x_tables ext4 crc16
mbcache jbd2 hid_generic usbhid hid uas usb_storage sr_mod cdrom sd_mod
ata_generic pata_acpi atkbd libps2 ata_piix libata scsi_mod ehci_pci uhci_hcd
ehci_hcd usbcore usb_common i8042 serio
jui 21 10:19:17 Aspire kernel: CPU: 0 PID: 616 Comm: umount Not tainted
4.1.2-2-ARCH #1
jui 21 10:19:17 Aspire kernel: Hardware name: Acer, inc. Aspire 1640Z   
/Lugano3         , BIOS 3A24 10/30/06
jui 21 10:19:17 Aspire kernel: task: f4183fc0 ti: f1a7c000 task.ti: f1a7c000
jui 21 10:19:17 Aspire kernel: EIP: 0060:[<c127cd7b>] EFLAGS: 00010082 CPU: 0
jui 21 10:19:17 Aspire kernel: EIP is at __percpu_counter_add+0x1b/0xd0
jui 21 10:19:17 Aspire kernel: EAX: c1cee508 EBX: c1cee508 ECX: 00000000 EDX:
00000001
jui 21 10:19:17 Aspire kernel: ESI: ffffffff EDI: 00000000 EBP: f1a7de70 ESP:
f1a7de50
jui 21 10:19:17 Aspire kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
jui 21 10:19:17 Aspire kernel: CR0: 8005003b CR2: 34943000 CR3: 31aa0000 CR4:
000007d0
jui 21 10:19:17 Aspire kernel: Stack:
jui 21 10:19:17 Aspire kernel:  00000285 00000285 c166f540 00000001 00000000
c1cee4e8 ffffffff f53a635c
jui 21 10:19:17 Aspire kernel:  f1a7de8c c1138904 00000010 f6879660 f6879660
f53a635c f53a636c f1a7dea8
jui 21 10:19:18 Aspire kernel:  c11bd549 00000000 00000282 f6879660 f521bc78
f2f5c400 f1a7deb8 c11bd6a3
jui 21 10:19:18 Aspire kernel: Call Trace:
jui 21 10:19:18 Aspire kernel:  [<c1138904>] account_page_dirtied+0x74/0x120
jui 21 10:19:18 Aspire kernel:  [<c11bd549>] __set_page_dirty+0x39/0xb0
jui 21 10:19:19 Aspire kernel:  [<c11bd6a3>] mark_buffer_dirty+0x53/0xd0
jui 21 10:19:19 Aspire kernel:  [<f828cf48>] ext4_commit_super+0x158/0x230
[ext4]
jui 21 10:19:19 Aspire kernel:  [<f8059785>] ? mb_cache_shrink+0x55/0x250
[mbcache]
jui 21 10:19:19 Aspire kernel:  [<f828dc87>] ext4_put_super+0xc7/0x320 [ext4]
jui 21 10:19:19 Aspire kernel:  [<c11a7c02>] ? dispose_list+0x32/0x40
jui 21 10:19:20 Aspire kernel:  [<c11a88a2>] ? evict_inodes+0xf2/0x110
jui 21 10:19:20 Aspire kernel:  [<c1190d34>] generic_shutdown_super+0x64/0xe0
jui 21 10:19:20 Aspire kernel:  [<c113fb30>] ? unregister_shrinker+0x40/0x50
jui 21 10:19:20 Aspire kernel:  [<c119104f>] kill_block_super+0x1f/0x70
jui 21 10:19:20 Aspire kernel:  [<c119134d>] deactivate_locked_super+0x3d/0x70
jui 21 10:19:21 Aspire kernel:  [<c1191737>] deactivate_super+0x57/0x60
jui 21 10:19:21 Aspire kernel:  [<c11abb79>] cleanup_mnt+0x39/0x90
jui 21 10:19:21 Aspire kernel:  [<c11abc10>] __cleanup_mnt+0x10/0x20
jui 21 10:19:21 Aspire kernel:  [<c106ffe9>] task_work_run+0xc9/0xe0
jui 21 10:19:21 Aspire kernel:  [<c1002625>] do_notify_resume+0x75/0x80
jui 21 10:19:22 Aspire kernel:  [<c14b15fd>] work_notifysig+0x30/0x37
jui 21 10:19:22 Aspire kernel: Code: 39 c7 77 de eb da 8d 76 00 8d bc 27 00 00
00 00 55 89 e5 57 56 53 89 c3 83 ec 14 89 55 ec 89 4d f0 64 ff 05 44 17 71 c1
8b 7b 14 <64> 8b 37 89 7d e0 89 f7 c1 ff 1f 01 d6 8b 55 08 11 cf 89 d1 c1
jui 21 10:19:22 Aspire kernel: EIP: [<c127cd7b>] __percpu_counter_add+0x1b/0xd0
SS:ESP 0068:f1a7de50
jui 21 10:19:22 Aspire kernel: CR2: 0000000034943000
jui 21 10:19:22 Aspire kernel: ---[ end trace 4bafb307c38dbc3e ]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
