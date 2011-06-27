From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] killing requests for dead queue
Date: Mon, 27 Jun 2011 18:33:30 GMT
Message-ID: <201106271833.p5RIXU4u016203@demeter2.kernel.org>
References: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:51261 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1F0Sdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 14:33:31 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p5RIXUDr016204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 18:33:30 GMT
In-Reply-To: <bug-35682-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682


rpansky@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rpansky@gmail.com




--- Comment #3 from rpansky@gmail.com  2011-06-27 18:33:18 ---
I have encountered a similar issue. A panic happens immediately after a USB
stick insertion (sometimes). The message "scsi: killing requests for dead
queue" is also present. However, in some cases the message was not accompanied
with panic.
Notably, I could not reproduce the problem with 2.6.39.2 although that message
was there too.

I hereby provide a panic trace for 2.6.39.1

(Please note that "Tainted: W" is due to this probably harmless warning:
WARNING: at kernel/printk.c:293 do_syslog+0xbf/0x4f0()
Hardware name: GA-MA770-UD3
Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
)

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff811a64eb>] blk_dequeue_request+0x1b/0x60
PGD 226d7f067 PUD 226e77067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/virtual/bdi/8:48/uevent
CPU 3 
Modules linked in: usb_storage snd_seq snd_seq_device nfsd nfs lockd sunrpc
bridge stp llc iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state iptable_filter xt_DSCP xt_dscp xt_owner xt_multiport
xt_mark xt_connmark nf_conntrack ip_tables x_tables netconsole tun it87
hwmon_vid hwmon snd_hda_codec_realtek snd_hda_intel snd_hda_codec ohci_hcd
snd_pcm r8169 snd_timer snd ehci_hcd soundcore usbcore snd_page_alloc i2c_core
mii

Pid: 16, comm: ksoftirqd/3 Tainted: G        W   2.6.39.1 #1 Gigabyte
Technology Co., Ltd. GA-MA770-UD3/GA-MA770-UD3
RIP: 0010:[<ffffffff811a64eb>]  [<ffffffff811a64eb>]
blk_dequeue_request+0x1b/0x60
RSP: 0018:ffff88022e8afc98  EFLAGS: 00010046
RAX: ffff88022d503408 RBX: ffff88022d502e40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88022d502e40 RDI: ffff88022d502e40
RBP: ffff88022d502e40 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000400 R12: ffff88022d502878
R13: ffff88022d502b40 R14: ffff880224d90040 R15: 0000000000000246
FS:  00007f0465c7c700(0000) GS:ffff88022fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000226d7e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ksoftirqd/3 (pid: 16, threadinfo ffff88022e8ae000, task
ffff88022e86e2d0)
Stack:
 ffffffff811a6ef9 ffff88022d502e40 ffffffff811a7d45 0000000000000808
 0000000000000000 0000000000000286 ffff88022d502878 ffff88022d502878
 ffffffff8125192c ffff880224d90000 ffff880224d93800 ffff880224d90000
Call Trace:
 [<ffffffff811a6ef9>] ? blk_start_request+0x9/0x40
 [<ffffffff811a7d45>] ? blk_peek_request+0xd5/0x1d0
 [<ffffffff8125192c>] ? scsi_request_fn+0x3ec/0x4a0
 [<ffffffff811a67e8>] ? blk_run_queue+0x28/0x50
 [<ffffffff81250df1>] ? scsi_run_queue+0xd1/0x270
 [<ffffffff810c500a>] ? kmem_cache_free+0x9a/0xb0
 [<ffffffff81251bfb>] ? scsi_next_command+0x3b/0x60
 [<ffffffff812527e7>] ? scsi_io_completion+0x2c7/0x5b0
 [<ffffffff811ad3cd>] ? blk_done_softirq+0x6d/0x80
 [<ffffffff8103f491>] ? __do_softirq+0x91/0x120
 [<ffffffff8103f5c5>] ? run_ksoftirqd+0xa5/0x150
 [<ffffffff8103f520>] ? __do_softirq+0x120/0x120
 [<ffffffff8103f520>] ? __do_softirq+0x120/0x120
 [<ffffffff81054136>] ? kthread+0x96/0xa0
 [<ffffffff8134be94>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810540a0>] ? kthread_worker_fn+0x120/0x120
 [<ffffffff8134be90>] ? gs_change+0xb/0xb
Code: 02 00 00 5b c3 31 d2 e9 fb fe ff ff 0f 1f 40 00 48 8b 07 48 8b 4f 38 48
39 c7 74 46 48 83 7f 78 00 75 3b 48 8b 57 08 48 89 50 08 
 89 02 8b 47 40 48 89 3f 48 89 7f 08 f6 c4 40 74 1f 83 7f 44 
RIP  [<ffffffff811a64eb>] blk_dequeue_request+0x1b/0x60
 RSP <ffff88022e8afc98>
CR2: 0000000000000000
---[ end trace 9658ff6466e3ea44 ]---

Of some interest might also be the following (tainted by nvidia proprietary
module) trace:

kernel BUG at block/blk-core.c:1935!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/virtual/bdi/8:48/uevent
CPU 0 
Modules linked in: usb_storage nfsd nfs lockd sunrpc bridge stp llc
iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
iptable_filter xt_DSCP xt_dscp xt_owner xt_multiport xt_mark xt_connmark
nf_conntrack ip_tables x_tables snd_seq snd_seq_device netconsole tun it87
hwmon_vid hwmon snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm
snd_timer snd ohci_hcd ehci_hcd r8169 soundcore usbcore snd_page_alloc i2c_core
mii [last unloaded: nvidia]

Pid: 3, comm: ksoftirqd/0 Tainted: P        W   2.6.39.1 #1 Gigabyte Technology
Co., Ltd. GA-MA770-UD3/GA-MA770-UD3
RIP: 0010:[<ffffffff811a651e>]  [<ffffffff811a651e>]
blk_dequeue_request+0x4e/0x60
RSP: 0018:ffff88022e881c98  EFLAGS: 00010086
RAX: ffff88022daea2b0 RBX: ffff88022dae9ce8 RCX: 0000000000000002
RDX: 000000008102d46e RSI: ffff88022dae9720 RDI: ffff88022dae9ce8
RBP: 0000000000000286 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000400 R12: ffff88022dae9720
R13: ffff88022dae9ce8 R14: ffff880224112840 R15: 0000000000000246
FS:  00007f6f93b08700(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fff561bc188 CR3: 00000002257ee000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ksoftirqd/0 (pid: 3, threadinfo ffff88022e880000, task
ffff88022e868ba0)
Stack:
 ffffffff811a6ef9 ffffffff8111e5ef ffffffff812513cb 0000000000000000
 0000000000000286 ffff88022dae9720 ffff88022dae9720 ffff880224112840
 ffffffff81251924 ffff88022fc11500 0000000000000086 ffff88022fc11500
Call Trace:
 [<ffffffff811a6ef9>] ? blk_start_request+0x9/0x40
 [<ffffffff8111e5ef>] ? proc_flush_task+0xff/0x1f0
 [<ffffffff812513cb>] ? scsi_kill_request+0x2b/0x1a0
 [<ffffffff81251924>] ? scsi_request_fn+0x3e4/0x4a0
 [<ffffffff811a67e8>] ? blk_run_queue+0x28/0x50
 [<ffffffff81250df1>] ? scsi_run_queue+0xd1/0x270
 [<ffffffff810c500a>] ? kmem_cache_free+0x9a/0xb0
 [<ffffffff81251bfb>] ? scsi_next_command+0x3b/0x60
 [<ffffffff812527e7>] ? scsi_io_completion+0x2c7/0x5b0
 [<ffffffff811ad3cd>] ? blk_done_softirq+0x6d/0x80
 [<ffffffff8103f491>] ? __do_softirq+0x91/0x120
 [<ffffffff8103f5c5>] ? run_ksoftirqd+0xa5/0x150
 [<ffffffff8103f520>] ? __do_softirq+0x120/0x120
 [<ffffffff8103f520>] ? __do_softirq+0x120/0x120
 [<ffffffff81054136>] ? kthread+0x96/0xa0
 [<ffffffff8134be94>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810540a0>] ? kthread_worker_fn+0x120/0x120
 [<ffffffff8134be90>] ? gs_change+0xb/0xb
sd 6:0:0:0: [sdd] Assuming drive cache: write through
Code: 3f 48 89 7f 08 f6 c4 40 74 1f 83 7f 44 01 74 04 a8 40 74 15 83 e0 11 ff
c8 0f 95 c0 83 e0 01 48 05 d8 00 00 00 ff 44 81 0c 
 sdd: sdd1
f3 c3 <0f> 0b eb fe 0f 0b eb fe 66 2e 0f 1f 84 00 00 00 00 00 8b 4f 40 
RIP  [<ffffffff811a651e>] blk_dequeue_request+0x4e/0x60
 RSP <ffff88022e881c98>
---[ end trace 1be76b42f53e92c7 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
