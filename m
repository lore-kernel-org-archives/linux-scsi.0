From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35282] BUG() in 2.6.38.6
Date: Thu, 19 May 2011 19:44:31 GMT
Message-ID: <201105191944.p4JJiVVm029690@demeter1.kernel.org>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46944 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934412Ab1ESToc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2011 15:44:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4JJiVov029691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 19 May 2011 19:44:32 GMT
In-Reply-To: <bug-35282-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35282





--- Comment #2 from Fabio Coatti <fabio.coatti@gmail.com>  2011-05-19 19:44:30 ---
Thanks for your answer :)

Just tried (patch applied, compiled with make mrproper beforehand), but the
result is pretty much the same.
Interesting enough, If I reboot after using 2.6.38.5 for a while, the first
boot on .6 is successful; following boots fails as shown so I guess that some
hardware status can have a role into this, even if I don't know what happens.
Here you can find the last capture with netconsole, with patch applied. (btw,
how I can 100% sure to have applied it properly, besides checking the kernel
date?)

May 19 21:33:12 192.168.42.2 ACPI: PCI Interrupt Link [AE1B] (IRQs 16) *0,
disabled.
May 19 21:33:12 192.168.42.2 ACPI: PCI Interrupt Link [AE1C] (IRQs 16) *0,
disabled.
May 19 21:33:12 192.168.42.2 ACPI: PCI Interrupt Link [AE1D] (IRQs 16) *0
May 19 21:33:12 192.168.42.2 ACPI: PCI Interrupt Link [AE2A] (IRQs 16) *0,
disabled.
May 19 21:33:13 192.168.42.2 BUG: unable to handle kernel 
May 19 21:33:13 192.168.42.2 paging request
May 19 21:33:13 192.168.42.2 at 0000000001000000
May 19 21:33:13 192.168.42.2 sd 9:0:0:0: [sde] No Caching mode page present
May 19 21:33:13 192.168.42.2 sd 9:0:0:0: [sde] Assuming drive cache: write
through
May 19 21:33:13 192.168.42.2 sd 9:0:0:0: [sde] No Caching mode page present
May 19 21:33:13 192.168.42.2 sd 9:0:0:0: [sde] Assuming drive cache: write
through
May 19 21:33:13 192.168.42.2 IP:
May 19 21:33:13 192.168.42.2 [<0000000001000000>] 0x1000000
May 19 21:33:13 192.168.42.2 PGD 22e527067 
May 19 21:33:13 192.168.42.2 PUD 22e528067 
May 19 21:33:13 192.168.42.2 PMD 0 
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 Oops: 0010 [#1] 
May 19 21:33:13 192.168.42.2 PREEMPT 
May 19 21:33:13 192.168.42.2 SMP 
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 sde: sde1
May 19 21:33:13 192.168.42.2 last sysfs file:
/sys/devices/virtual/bdi/8:64/uevent
May 19 21:33:13 192.168.42.2 CPU 1 
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 Modules linked in:
May 19 21:33:13 192.168.42.2 snd_hda_codec_hdmi
May 19 21:33:13 192.168.42.2 snd_hda_codec_analog
May 19 21:33:13 192.168.42.2 usbhid
May 19 21:33:13 192.168.42.2 usb_storage
May 19 21:33:13 192.168.42.2 usb_libusual
May 19 21:33:13 192.168.42.2 uas
May 19 21:33:13 192.168.42.2 snd_hda_intel
May 19 21:33:13 192.168.42.2 snd_hda_codec
May 19 21:33:13 192.168.42.2 snd_hwdep
May 19 21:33:13 192.168.42.2 snd_pcm
May 19 21:33:13 192.168.42.2 i2c_nforce2
May 19 21:33:13 192.168.42.2 snd_timer
May 19 21:33:13 192.168.42.2 asus_atk0110
May 19 21:33:13 192.168.42.2 snd
May 19 21:33:13 192.168.42.2 soundcore
May 19 21:33:13 192.168.42.2 snd_page_alloc
May 19 21:33:13 192.168.42.2 k10temp
May 19 21:33:13 192.168.42.2 ohci_hcd
May 19 21:33:13 192.168.42.2 ehci_hcd
May 19 21:33:13 192.168.42.2 usbcore
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 Pid: 9, comm: ksoftirqd/1 Not tainted 2.6.38.6 #2
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 System manufacturer System Product Name
May 19 21:33:13 192.168.42.2 /
May 19 21:33:13 192.168.42.2 M3N-HT DELUXE
May 19 21:33:13 192.168.42.2 
May 19 21:33:13 192.168.42.2 RIP: 0010:[<0000000001000000>] 
May 19 21:33:13 192.168.42.2 [<0000000001000000>] 0x1000000
May 19 21:33:13 192.168.42.2 RSP: 0018:ffff8800afc83df0  EFLAGS: 00010006
May 19 21:33:13 192.168.42.2 RAX: 0000000000000001 RBX: ffff88022e228c20 RCX:
ffff8802288b5848
May 19 21:33:13 192.168.42.2 RDX: 0000000001000000 RSI: 0000000000000000 RDI:
ffff88022e228c20
May 19 21:33:13 192.168.42.2 RBP: 0000000000000200 R08: 0000000000000000 R09:
ffff8802288b5848
May 19 21:33:13 192.168.42.2 R10: ffff88022e228c20 R11: ffff88022fd63938 R12:
ffff88022d75b040
May 19 21:33:13 192.168.42.2 R13: ffff88022e228c20 R14: 0000000000000000 R15:
0000000000000246
May 19 21:33:13 192.168.42.2 FS:  00007fafe7466700(0000)
GS:ffff8800afc80000(0000) knlGS:0000000000000000
May 19 21:33:13 192.168.42.2 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 19 21:33:13 192.168.42.2 CR2: 0000000001000000 CR3: 000000022e525000 CR4:
00000000000006e0
May 19 21:33:13 192.168.42.2 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
May 19 21:33:13 192.168.42.2 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
May 19 21:33:13 192.168.42.2 Process ksoftirqd/1 (pid: 9, threadinfo
ffff88022fcf4000, task ffff88022fccb100)
May 19 21:33:13 192.168.42.2 Stack:
May 19 21:33:13 192.168.42.2 ffffffff812160eb
May 19 21:33:13 192.168.42.2 ffff88022e228c20
May 19 21:33:14 192.168.42.2 ffff88022e228c20
May 19 21:33:14 192.168.42.2 0000000000000296
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 ffffffff81216167
May 19 21:33:14 192.168.42.2 ffff88022fd63938
May 19 21:33:14 192.168.42.2 ffff88022d75b000
May 19 21:33:14 192.168.42.2 ffff8800afc83e58
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 ffffffff812b2ffe
May 19 21:33:14 192.168.42.2 ffff88023f8026c0
May 19 21:33:14 192.168.42.2 ffff8800afc83e58
May 19 21:33:14 192.168.42.2 ffff88022de0c800
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 Call Trace:
May 19 21:33:14 192.168.42.2 <IRQ> 
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
May 19 21:33:14 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
May 19 21:33:14 192.168.42.2 [<ffffffff812b2ffe>] ? scsi_run_queue+0x2ce/0x36d
May 19 21:33:14 192.168.42.2 [<ffffffff812b3a0f>] ? scsi_next_command+0x2d/0x39
May 19 21:33:14 192.168.42.2 [<ffffffff812b42a9>] ?
scsi_io_completion+0x1ca/0x3fd
May 19 21:33:14 192.168.42.2 [<ffffffff813cb268>] ? _raw_spin_unlock+0x1e/0x2b
May 19 21:33:14 192.168.42.2 [<ffffffff813cb295>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 19 21:33:14 192.168.42.2 [<ffffffff8121a83b>] ? blk_done_softirq+0x5f/0x6c
May 19 21:33:14 192.168.42.2 [<ffffffff810326f9>] ? __do_softirq+0x7b/0x11a
May 19 21:33:14 192.168.42.2 [<ffffffff81002f4c>] ? call_softirq+0x1c/0x28
May 19 21:33:14 192.168.42.2 <EOI> 
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 [<ffffffff81004761>] ? do_softirq+0x31/0x63
May 19 21:33:14 192.168.42.2 [<ffffffff810323c2>] ? run_ksoftirqd+0x9c/0x180
May 19 21:33:14 192.168.42.2 [<ffffffff81032326>] ? run_ksoftirqd+0x0/0x180
May 19 21:33:14 192.168.42.2 [<ffffffff81042a95>] ? kthread+0x7a/0x82
May 19 21:33:14 192.168.42.2 [<ffffffff81002e54>] ?
kernel_thread_helper+0x4/0x10
May 19 21:33:14 192.168.42.2 [<ffffffff81042a1b>] ? kthread+0x0/0x82
May 19 21:33:14 192.168.42.2 [<ffffffff81002e50>] ?
kernel_thread_helper+0x0/0x10
May 19 21:33:14 192.168.42.2 Code: 
May 19 21:33:14 192.168.42.2 Bad RIP value.
May 19 21:33:14 192.168.42.2 
May 19 21:33:14 192.168.42.2 RIP 
May 19 21:33:14 192.168.42.2 [<0000000001000000>] 0x1000000
May 19 21:33:14 192.168.42.2 RSP <ffff8800afc83df0>
May 19 21:33:14 192.168.42.2 CR2: 0000000001000000
May 19 21:33:14 192.168.42.2 ---[ end trace e611b077bd16448b ]---
May 19 21:33:14 192.168.42.2 Kernel panic - not syncing: Fatal exception in
interrupt
May 19 21:33:14 192.168.42.2 Pid: 9, comm: ksoftirqd/1 Tainted: G      D    
2.6.38.6 #2
May 19 21:33:14 192.168.42.2 Call Trace:
May 19 21:33:14 192.168.42.2 <IRQ> 
May 19 21:33:14 192.168.42.2 [<ffffffff813c94ba>] ? panic+0xa1/0x199
May 19 21:33:14 192.168.42.2 [<ffffffff8102e12c>] ? kmsg_dump+0xde/0xed
May 19 21:33:14 192.168.42.2 [<ffffffff8100586a>] ? oops_end+0x7e/0x8b
May 19 21:33:14 192.168.42.2 [<ffffffff8101b236>] ? no_context+0x1f4/0x201
May 19 21:33:14 192.168.42.2 [<ffffffff8101b718>] ? do_page_fault+0x150/0x2e8
May 19 21:33:14 192.168.42.2 [<ffffffff81022def>] ?
check_preempt_curr+0x36/0x68
May 19 21:33:14 192.168.42.2 [<ffffffff810294e1>] ?
ttwu_post_activation+0x18/0xa5
May 19 21:33:14 192.168.42.2 [<ffffffff813cb295>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 19 21:33:14 192.168.42.2 [<ffffffff8102b101>] ? try_to_wake_up+0x197/0x1b2
May 19 21:33:14 192.168.42.2 [<ffffffff813cba0f>] ? page_fault+0x1f/0x30
May 19 21:33:14 192.168.42.2 [<ffffffff812160eb>] ? __blk_run_queue+0x24/0x7e
May 19 21:33:14 192.168.42.2 [<ffffffff81216167>] ? blk_run_queue+0x22/0x34
May 19 21:33:14 192.168.42.2 [<ffffffff812b2ffe>] ? scsi_run_queue+0x2ce/0x36d
May 19 21:33:14 192.168.42.2 [<ffffffff812b3a0f>] ? scsi_next_command+0x2d/0x39
May 19 21:33:14 192.168.42.2 [<ffffffff812b42a9>] ?
scsi_io_completion+0x1ca/0x3fd
May 19 21:33:14 192.168.42.2 [<ffffffff813cb268>] ? _raw_spin_unlock+0x1e/0x2b
May 19 21:33:14 192.168.42.2 [<ffffffff813cb295>] ?
_raw_spin_unlock_irqrestore+0x20/0x2e
May 19 21:33:14 192.168.42.2 [<ffffffff8121a83b>] ? blk_done_softirq+0x5f/0x6c
May 19 21:33:14 192.168.42.2 [<ffffffff810326f9>] ? __do_softirq+0x7b/0x11a
May 19 21:33:14 192.168.42.2 [<ffffffff81002f4c>] ? call_softirq+0x1c/0x28
May 19 21:33:14 192.168.42.2 <EOI> 
May 19 21:33:14 192.168.42.2 [<ffffffff81004761>] ? do_softirq+0x31/0x63
May 19 21:33:14 192.168.42.2 [<ffffffff810323c2>] ? run_ksoftirqd+0x9c/0x180
May 19 21:33:14 192.168.42.2 [<ffffffff81032326>] ? run_ksoftirqd+0x0/0x180
May 19 21:33:14 192.168.42.2 [<ffffffff81042a95>] ? kthread+0x7a/0x82
May 19 21:33:14 192.168.42.2 [<ffffffff81002e54>] ?
kernel_thread_helper+0x4/0x10
May 19 21:33:14 192.168.42.2 [<ffffffff81042a1b>] ? kthread+0x0/0x82
May 19 21:33:14 192.168.42.2 [<ffffffff81002e50>] ?
kernel_thread_helper+0x0/0x10

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
