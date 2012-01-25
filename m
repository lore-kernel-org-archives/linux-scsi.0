From: Borislav Petkov <bp@alien8.de>
Subject: BUG: unable to handle kernel NULL pointer dereference at
 scsi_prep_state_check+0x9/0x90
Date: Wed, 25 Jan 2012 17:27:49 +0100
Message-ID: <20120125162748.GA2715@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:60361 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab2AYQ1y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 11:27:54 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTP id 028EF1D95E9
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2012 17:27:50 +0100 (CET)
Received: from mail.skyhub.de ([127.0.0.1])
	by localhost (door.skyhub.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWec6w7soE1u for <linux-scsi@vger.kernel.org>;
	Wed, 25 Jan 2012 17:27:50 +0100 (CET)
Received: from x1.localdomain (ip-2-201-21-16.web.vodafone.de [2.201.21.16])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2012 17:27:50 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

this is the oopsie I'm getting on 3.3-rc1 when inserting a Nokia
internet stick CS-19 which has obviously a CD-ROM interface which
is addressed through the SCSI layer. However, the blk request gets
killed prematurely, causing a scsi_device * ptr to be NULL in
scsi_prep_state_check(), which, IMHO, shouldn't happen, no matter
whether the request is killed or not. Here's the relevant dmesg text and
follow-up oops:

[ 6073.913465] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 6073.918596] sd 0:0:0:0: [sda] Stopping disk
[ 6060.635897] scsi 10:0:0:0: CD-ROM            Nokia    Datacard CD-ROM  0001 PQ: 0 ANSI: 0
[ 6060.641365] scsi 10:0:0:1: Direct-Access     Nokia    Datacard CD-ROM  0001 PQ: 0 ANSI: 0
[ 6060.654274] sr0: scsi3-mmc drive: 0x/0x caddy
[ 6060.660131] sr 10:0:0:0: Attached scsi CD-ROM sr0
[ 6060.661130] sr 10:0:0:0: Attached scsi generic sg1 type 5
[ 6060.671066] sd 10:0:0:1: [sdb] Attached SCSI removable disk
[ 6060.673711] sd 10:0:0:1: Attached scsi generic sg2 type 0
[ 6061.239039] sr0: CDROM (ioctl) error, command: Get event status notification 4a 01 00 00 10 00 00 00 08 00
[ 6061.239296] sr: Sense Key : Hardware Error [current] 
[ 6061.239345] sr: Add. Sense: No additional sense information
[ 6061.370317] sr0: CDROM (ioctl) error, command: Xpwrite, Read disk info 51 00 00 00 00 00 00 00 02 00
[ 6061.370579] sr: Sense Key : Hardware Error [current] 
[ 6061.370628] sr: Add. Sense: No additional sense information
[ 6061.720495] scsi 10:0:0:0: killing request
[ 6061.721654] BUG: unable to handle kernel NULL pointer dereference at 00000000000009e8
[ 6061.722065] IP: [<ffffffff812de9f9>] scsi_prep_state_check+0x9/0x90
[ 6061.722342] PGD 114d78067 PUD 113d3a067 PMD 0 
[ 6061.722612] Oops: 0000 [#1] PREEMPT SMP 
[ 6061.722749] CPU 0 
[ 6061.722858] Modules linked in: aes_generic cbc nls_iso8859_1 nls_cp437 ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc powernow_k8 mperf cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_userspace binfmt_misc uinput kvm_amd kvm fuse dm_crypt dm_mod ipv6 vfat fat loop usbhid snd_hda_codec_conexant snd_hda_codec_hdmi cdc_ncm usbnet cdc_wdm arc4 rtlwifi mac80211 usb_storage cdc_acm snd_hda_intel snd_hda_codec cfg80211 thinkpad_acpi snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device evdev snd ohci_hcd pcspkr radeon k10temp ehci_hcd snd_page_alloc soundcore rfkill nvram ttm thermal drm_kms_helper processor video battery ac thermal_sys button [last unloaded: rtl8192c_common]
[ 6061.724027] 
[ 6061.724027] Pid: 3767, comm: kworker/0:1 Not tainted 3.3.0-rc1 #36 LENOVO 30515QG/30515QG
[ 6061.724027] RIP: 0010:[<ffffffff812de9f9>]  [<ffffffff812de9f9>] scsi_prep_state_check+0x9/0x90
[ 6061.724027] RSP: 0018:ffff880118d67860  EFLAGS: 00010082
[ 6061.724027] RAX: ffffffff812df120 RBX: ffff88010943f4a0 RCX: 0000000000004443
[ 6061.724027] RDX: 0000000000000001 RSI: ffff88010943f4a0 RDI: 0000000000000000
[ 6061.724027] RBP: ffff880118d67860 R08: ffe8cf4bc6d68156 R09: 0000000000000000
[ 6061.724027] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880116bb68b0
[ 6061.724027] R13: 0000000000000000 R14: ffff880118d67fd8 R15: ffffffff811e7f80
[ 6061.724027] FS:  00007f8c5ae0d700(0000) GS:ffff88011ec00000(0000) knlGS:0000000000000000
[ 6061.724027] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6061.724027] CR2: 00000000000009e8 CR3: 0000000113d8e000 CR4: 00000000000006f0
[ 6061.724027] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6061.724027] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6061.724027] Process kworker/0:1 (pid: 3767, threadinfo ffff880118d66000, task ffff880119f72cd0)
[ 6061.724027] Stack:
[ 6061.724027]  ffff880118d67890 ffffffff812df024 ffff880119f732b8 ffff88010943f4a0
[ 6061.724027]  ffff880116bb68b0 ffff880118d67fd8 ffff880118d678b0 ffffffff812df16d
[ 6061.724027]  ffff88010943f4a0 ffff880116bb68b0 ffff880118d67900 ffffffff811e36a2
[ 6061.724027] Call Trace:
[ 6061.724027]  [<ffffffff812df024>] scsi_setup_blk_pc_cmnd+0x24/0x120
[ 6061.724027]  [<ffffffff812df16d>] scsi_prep_fn+0x4d/0x60
[ 6061.724027]  [<ffffffff811e36a2>] blk_peek_request+0xd2/0x260
[ 6061.724027]  [<ffffffff811e800d>] ? blk_execute_rq_nowait+0x4d/0x100
[ 6061.724027]  [<ffffffff811e7f80>] ? blk_rq_map_user+0x260/0x260
[ 6061.724027]  [<ffffffff812df680>] scsi_request_fn+0xf0/0x490
[ 6061.724027]  [<ffffffff811e7f80>] ? blk_rq_map_user+0x260/0x260
[ 6061.724027]  [<ffffffff811dcc9e>] __blk_run_queue+0x1e/0x20
[ 6061.724027]  [<ffffffff811e803e>] blk_execute_rq_nowait+0x7e/0x100
[ 6061.724027]  [<ffffffff811e8188>] blk_execute_rq+0xc8/0x180
[ 6061.724027]  [<ffffffff812de5dd>] scsi_execute+0xed/0x180
[ 6061.724027]  [<ffffffff812dfc0d>] scsi_execute_req+0xbd/0x130
[ 6061.724027]  [<ffffffff812dfd14>] scsi_test_unit_ready+0x94/0x140
[ 6061.724027]  [<ffffffff812edb15>] sr_check_events+0x135/0x2d0
[ 6061.724027]  [<ffffffff8106629c>] ? finish_task_switch+0x4c/0x1b0
[ 6061.724027]  [<ffffffff813289dc>] cdrom_check_events+0x1c/0x40
[ 6061.724027]  [<ffffffff812edf19>] sr_block_check_events+0x19/0x20
[ 6061.724027]  [<ffffffff811eb042>] disk_events_workfn+0x62/0x150
[ 6061.724027]  [<ffffffff81051c8b>] process_one_work+0x18b/0x570
[ 6061.724027]  [<ffffffff81051c1f>] ? process_one_work+0x11f/0x570
[ 6061.724027]  [<ffffffff81052515>] ? worker_thread+0x235/0x340
[ 6061.724027]  [<ffffffff811eafe0>] ? __disk_unblock_events+0x130/0x130
[ 6061.724027]  [<ffffffff81433807>] ? _raw_spin_lock_irq+0x17/0x50
[ 6061.724027]  [<ffffffff8105209c>] process_scheduled_works+0x2c/0x40
[ 6061.724027]  [<ffffffff81052554>] worker_thread+0x274/0x340
[ 6061.724027]  [<ffffffff810522e0>] ? rescuer_thread+0x230/0x230
[ 6061.724027]  [<ffffffff81056e6e>] kthread+0xae/0xc0
[ 6061.724027]  [<ffffffff81435f44>] kernel_thread_helper+0x4/0x10
[ 6061.724027]  [<ffffffff810662d9>] ? finish_task_switch+0x89/0x1b0
[ 6061.724027]  [<ffffffff814344a1>] ? retint_restore_args+0xe/0xe
[ 6061.724027]  [<ffffffff81056dc0>] ? __init_kthread_worker+0x70/0x70
[ 6061.724027]  [<ffffffff81435f40>] ? gs_change+0xb/0xb
[ 6061.724027] Code: c2 50 e3 2d 81 31 f6 e8 f6 94 ff ff 48 83 c4 08 5b 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 <8b> 87 e8 09 00 00 83 f8 02 75 04 31 c0 5d c3 83 e8 04 83 f8 04 
[ 6061.724027] RIP  [<ffffffff812de9f9>] scsi_prep_state_check+0x9/0x90
[ 6061.724027]  RSP <ffff880118d67860>
[ 6061.724027] CR2: 00000000000009e8
[ 6061.813681] ---[ end trace 59887ccfb270e805 ]---

HTH.

/me is willing to test patches :-)

-- 
Regards/Gruss,
Boris.
