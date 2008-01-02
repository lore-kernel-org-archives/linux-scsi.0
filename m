From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 9674] New: Oops during rmmod'ing modeuls
	sdhci, sr_mod, ricoh_mmc, mmc_core
Date: Wed, 02 Jan 2008 09:41:29 -0600
Message-ID: <1199288489.3258.10.camel@localhost.localdomain>
References: <bug-9674-10286@http.bugzilla.kernel.org/>
	 <20080101181026.38298e13.akpm@linux-foundation.org>
	 <1199244283.3252.13.camel@localhost.localdomain>
	 <200801021321.32039.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42131 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYABPlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 10:41:36 -0500
In-Reply-To: <200801021321.32039.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>, bugme-daemon@bugzilla.kernel.org


On Wed, 2008-01-02 at 13:21 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 2 of January 2008, James Bottomley wrote:
> > 
> > On Tue, 2008-01-01 at 18:10 -0800, Andrew Morton wrote:
> > > On Tue,  1 Jan 2008 14:55:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > > 
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=9674
> > > > 
> > > >            Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
> > > >                     mmc_core
> > > 
> > > Guys, this is a very recent regression.  Could you please take a look, see
> > > if it's due to mmc, block or scsi changes?
> > 
> > There's not a lot of information to go on.  The stack trace looks bogus,
> > so I guess the kernel is compiled without a frame pointer.
> 
> The bug report has been updated with a stack trace from a kernel compiled
> with a frame pointer.  Please have a look.

Please, please don't do this.  Filing something in bugzilla is
tantamount to putting it in the file and forget folder.  The reason I
cc'd the SCSI mailing list and asked for more details is so that we get
the email flow that might trigger direct interaction between the
reporter and someone on the list who recognised the symptoms.  

Let me say again, catagorically, that if you want to give a bug the best
chance of being fixed, the correct flow of information is:

file a bugzilla and note the bugid.
Then email a complete report to the relevant list, but add [BUG <bugid>]
to the subject line and cc bugme-daemon@bugzilla.kernel.org  If you do
this, bugzilla will keep track of the entire discussion as it progresses
and allow those who track bugs through bugzilla to get a pretty accurate
idea of the status.  You should never need to touch bugzilla again once
the initial bug report is filed: all future information flow is via the
mailing lists.

Also, using urls unless for historical purposes is also a killer.  Many
people travel, and their MO is to download the email and read it on the
plane/train/whatever.  If you embed a url containing critical
information, the email gets marked as read, but since I can't get to the
information, nothing happens.  Then it gets forgotten.

This is the relevant piece of information that should have been on the
mailing list:


[  101.359083] Unable to handle kernel paging request at ffffffff88021cc0 RIP:
[  101.359092]  [<ffffffff88021cc0>]
[  101.359099] PGD 203067 PUD 207063 PMD 3d34a067 PTE 0
[  101.359108] Oops: 0010 [1] PREEMPT SMP
[  101.359115] CPU 0
[  101.359118] Modules linked in: sr_mod tcp_westwood ipt_REJECT xt_state
iptable_filter ipt_owner ipt_MASQUERADE xt_tcpudp xt_multiport iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables iwl3945 ricoh_mmc
cdrom
[  101.359150] Pid: 4496, comm: modprobe Not tainted 2.6.24-rc6-git7 #5
[  101.359154] RIP: 0010:[<ffffffff88021cc0>]  [<ffffffff88021cc0>]
[  101.359159] RSP: 0018:ffff81002b457970  EFLAGS: 00010086
[  101.359163] RAX: ffffffff88021cc0 RBX: ffff81003f1627e0 RCX:
ffff81003f023b38
[  101.359167] RDX: 0000000000000000 RSI: ffff810030efd000 RDI:
ffff81003f1627e0
[  101.359171] RBP: ffff81002b4579b8 R08: 0000000000000001 R09:
0000000000000001
[  101.359175] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff810030efd000
[  101.359179] R13: ffff81002b457988 R14: ffffffff00000010 R15:
0000000100000010
[  101.359185] FS:  00002adcf7ea0b00(0000) GS:ffffffff80733000(0000)
knlGS:0000000000000000
[  101.359189] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  101.359193] CR2: ffffffff88021cc0 CR3: 000000002b497000 CR4:
00000000000006e0
[  101.359197] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  101.359201] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  101.359206] Process modprobe (pid: 4496, threadinfo ffff81002b456000, task
ffff81003de1ef50)
[  101.359210] Stack:  ffffffff80333a98 0000000000000086 ffff81003f023af8
ffff810030efd000
[  101.359221]  ffff81003f1627e0 ffff81003f023800 ffff81003e31c000
ffff81003f1627e0
[  101.359230]  0000000000000000 ffff81002b457a08 ffffffff803fe7e1
ffff81003f023b38
[  101.359237] Call Trace:
[  101.359248]  [<ffffffff80333a98>] elv_next_request+0xe8/0x180
[  101.359256]  [<ffffffff803fe7e1>] scsi_request_fn+0x71/0x380
[  101.359264]  [<ffffffff803375b8>] __generic_unplug_device+0x28/0x30
[  101.359270]  [<ffffffff80337623>] blk_execute_rq_nowait+0x63/0xb0
[  101.359276]  [<ffffffff80339113>] blk_execute_rq+0x73/0xe0
[  101.359283]  [<ffffffff80337775>] get_request_wait+0x25/0x120
[  101.359288]  [<ffffffff80337896>] blk_get_request+0x26/0x80
[  101.359296]  [<ffffffff803fe5b2>] scsi_execute+0xe2/0x110
[  101.359301]  [<ffffffff803fe661>] scsi_execute_req+0x81/0xf0
[  101.359312]  [<ffffffff8800d713>] :sr_mod:sr_probe+0x1e3/0x630
[  101.359323]  [<ffffffff803c8d01>] driver_probe_device+0xa1/0x1c0
[  101.359329]  [<ffffffff803c8ff5>] __driver_attach+0xe5/0xf0
[  101.359334]  [<ffffffff803c8f10>] __driver_attach+0x0/0xf0
[  101.359342]  [<ffffffff803c7ee3>] bus_for_each_dev+0x53/0x80
[  101.359348]  [<ffffffff803c8b3c>] driver_attach+0x1c/0x20
[  101.359353]  [<ffffffff803c8305>] bus_add_driver+0xa5/0x210
[  101.359360]  [<ffffffff803c922a>] driver_register+0x4a/0x80
[  101.359367]  [<ffffffff80402241>] scsi_register_driver+0x11/0x20
[  101.359374]  [<ffffffff8801303c>] :sr_mod:init_sr+0x3c/0x5c
[  101.359382]  [<ffffffff80268a23>] sys_init_module+0x153/0x1a80
[  101.359395]  [<ffffffff8020bdee>] system_call+0x7e/0x83
[  101.359399]
[  101.359401]
[  101.359402] Code:  Bad RIP value.
[  101.359409] RIP  [<ffffffff88021cc0>]
[  101.359414]  RSP <ffff81002b457970>
[  101.359416] CR2: ffffffff88021cc0
[  101.359425] ---[ end trace c303fca3a91ba9a8 ]---
[  101.359429] note: modprobe[4496] exited with preempt_count 1
[  101.359438] BUG: sleeping function called from invalid context at
kernel/rwsem.c:21
[  101.359451] in_atomic():1, irqs_disabled():0
[  101.359460] INFO: lockdep is turned off.
[  101.359469] Pid: 4496, comm: modprobe Tainted: G      D 2.6.24-rc6-git7 #5
[  101.359480]
[  101.359482] Call Trace:
[  101.359494]  [<ffffffff80232ee2>] __might_sleep+0xc2/0xf0
[  101.359509]  [<ffffffff8056f56d>] down_read+0x1d/0x50
[  101.359521]  [<ffffffff8023cb80>] exit_mm+0x30/0x110
[  101.359532]  [<ffffffff8023e6d7>] do_exit+0x1c7/0x950
[  101.359546]  [<ffffffff802268b8>] do_page_fault+0x5a8/0x860
[  101.359564]  [<ffffffff805712ad>] error_exit+0x0/0xa9
[  101.359578]  [<ffffffff80333a98>] elv_next_request+0xe8/0x180
[  101.359591]  [<ffffffff803fe7e1>] scsi_request_fn+0x71/0x380
[  101.359606]  [<ffffffff803375b8>] __generic_unplug_device+0x28/0x30
[  101.359619]  [<ffffffff80337623>] blk_execute_rq_nowait+0x63/0xb0
[  101.359633]  [<ffffffff80339113>] blk_execute_rq+0x73/0xe0
[  101.359647]  [<ffffffff80337775>] get_request_wait+0x25/0x120
[  101.359660]  [<ffffffff80337896>] blk_get_request+0x26/0x80
[  101.359674]  [<ffffffff803fe5b2>] scsi_execute+0xe2/0x110
[  101.359688]  [<ffffffff803fe661>] scsi_execute_req+0x81/0xf0
[  101.359703]  [<ffffffff8800d713>] :sr_mod:sr_probe+0x1e3/0x630
[  101.359719]  [<ffffffff803c8d01>] driver_probe_device+0xa1/0x1c0
[  101.359731]  [<ffffffff803c8ff5>] __driver_attach+0xe5/0xf0
[  101.359742]  [<ffffffff803c8f10>] __driver_attach+0x0/0xf0
[  101.359756]  [<ffffffff803c7ee3>] bus_for_each_dev+0x53/0x80
[  101.359768]  [<ffffffff803c8b3c>] driver_attach+0x1c/0x20
[  101.359780]  [<ffffffff803c8305>] bus_add_driver+0xa5/0x210
[  101.359793]  [<ffffffff803c922a>] driver_register+0x4a/0x80
[  101.359807]  [<ffffffff80402241>] scsi_register_driver+0x11/0x20
[  101.359821]  [<ffffffff8801303c>] :sr_mod:init_sr+0x3c/0x5c
[  101.359834]  [<ffffffff80268a23>] sys_init_module+0x153/0x1a80
[  101.359853]  [<ffffffff8020bdee>] system_call+0x7e/0x83
[  101.359865]

This is clearly showing it was in the request function and probably
indirected via a bad pointer.

I think something in the remove chain triggered a reinsertion of the
module (this would be something in the user land hotplug scripts or
something in the kernel triggering it).  Now, for the second time of
asking, what is the underlying driver or HBA the cdrom is attached to?

James


