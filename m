From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Mon, 31 Oct 2011 11:05:57 +0100
Message-ID: <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
References: <4E832A55.30709@kernel.dk>
 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>
 <4E832BD2.50409@kernel.dk>
 <4E96E2FF.6070601@linux.vnet.ibm.com>
 <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>
 <4E9BEB68.1050707@ce.jp.nec.com>
 <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
 <4E9D7FA8.9000000@ce.jp.nec.com>
 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:33690 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1JaKHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 06:07:06 -0400
Content-Disposition: inline
In-Reply-To: <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Mike Snitzer <snitzer@redhat.com>, gmuelas@de.ibm.com

On Tue, Oct 18, 2011 at 11:29:40AM -0500, James Bottomley wrote:
> On Tue, 2011-10-18 at 17:45 +0200, Heiko Carstens wrote:
> > On Tue, Oct 18, 2011 at 10:31:20PM +0900, Jun'ichi Nomura wrote:
> > > On 10/17/11 23:06, James Bottomley wrote:
> > > > On Mon, 2011-10-17 at 17:46 +0900, Jun'ichi Nomura wrote:
> > > >> On 10/15/11 01:03, James Bottomley wrote:
> > > >>> On Thu, 2011-10-13 at 15:09 +0200, Steffen Maier wrote:
> > > >>>> Initially, we encountered use-after-free bugs in
> > > >>>> scsi_print_command / scsi_dispatch_cmd
> > > >>>> http://marc.info/?l=linux-scsi&m=130824013229933&w=2
> > > >>
> > > >> It is interesting that both this and the older report
> > > >> got oopsed in scsi_log_send(), while there are other
> > > >> dereferences of 'cmd' around scsi_dispatch_cmd().
> > > >> Are there any reason they are special? Just by accident?
> > > > 
> > > > Right, that's why it looks like the command area got freed rather than
> > > > the command pointer was bogus (6b is a poison free pattern).  Perhaps if
> > > > the reporter could pin down the failing source line, we'd know better
> > > > what was going on?
> > > 
> > > Yeah, that might be useful.
> > 
> > The struct scsi_cmnd that was passed to scsi_log_send() was already freed
> > (contents completely 6b6b6b...).
> > Since SLUB debugging was turned on we can see that it was freed from
> > __scsi_put_command(). Not too much of a surprise.
> 
> But it does tell us the put must be racing with dispatch, since
> dereferencing the command to find the device worked higher up in
> scsi_dispatch_cmd().
> 
> There is one way to invalidate the theory that we cloned something with
> an attached command, and that's to put 
> 
> BUG_ON(rq->special)
> 
> in blk_insert_cloned_request().  I think we're careful about clearing
> it, so it should work (perhaps a warn on just in case).

It _looks_ like we do not hit the BUG_ON() that. This time we get this instead:

[ 4024.937870] Unable to handle kernel pointer dereference at virtual kernel address 000003e004d41000
[ 4024.937886] Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 4024.937899] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [las
t unloaded: scsi_wait_scan]
[ 4024.937925] CPU: 1 Not tainted 3.0.7-50.x.20111021-s390xdefault #1
[ 4024.937930] Process ksoftirqd/1 (pid: 1942, task: 0000000079c6c750, ksp: 0000000073adfc50)
[ 4024.937936] Krnl PSW : 0704000180000000 000003e00126263a (dm_softirq_done+0x72/0x140 [dm_mod])
[ 4024.937959]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[ 4024.937966] Krnl GPRS: 000000007b9156b0 000003e004d41100 000000000e14b600 000000000000006d
[ 4024.937971]            00000000715332b0 000000000c140ce8 000000000090d2ef 0000000000000005
[ 4024.937977]            0000000000000001 0000000000000101 000000000c140d00 0000000000000000
[ 4024.937983]            000003e001260000 000003e00126f098 0000000073adfd08 0000000073adfcb8
[ 4024.938001] Krnl Code: 000003e00126262a: f0a0000407f1        srp     4(11,%r0),2033,0
[ 4024.938009]            000003e001262630: e31050080004        lg      %r1,8(%r5)
[ 4024.938017]            000003e001262636: 58b05180            l       %r11,384(%r5)
[ 4024.938024]           >000003e00126263a: e31010080004        lg      %r1,8(%r1)
[ 4024.938031]            000003e001262640: e31010500004        lg      %r1,80(%r1)
[ 4024.938038]            000003e001262646: b9020011            ltgr    %r1,%r1
[ 4024.938045]            000003e00126264a: a784ffdf            brc     8,3e001262608
[ 4024.938053]            000003e00126264e: e32050080004        lg      %r2,8(%r5)
[ 4024.938060] Call Trace:
[ 4024.938063] ([<070000000040716c>] 0x70000000040716c)
[ 4024.938069]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
[ 4024.938080]  [<00000000001587c2>] __do_softirq+0xda/0x398
[ 4024.938088]  [<0000000000158ba0>] run_ksoftirqd+0x120/0x23c
[ 4024.938095]  [<000000000017c2aa>] kthread+0xa6/0xb0
[ 4024.938102]  [<000000000061970e>] kernel_thread_starter+0x6/0xc
[ 4024.938112]  [<0000000000619708>] kernel_thread_starter+0x0/0xc
[ 4024.938118] INFO: lockdep is turned off.
[ 4024.938121] Last Breaking-Event-Address:
[ 4024.938124]  [<000003e001262600>] dm_softirq_done+0x38/0x140 [dm_mod]
[ 4024.938135]  
[ 4024.938139] Kernel panic - not syncing: Fatal exception in interrupt
[ 4024.938144] CPU: 1 Tainted: G      D     3.0.7-50.x.20111021-s390xdefault #1
[ 4024.938150] Process ksoftirqd/1 (pid: 1942, task: 0000000079c6c750, ksp: 0000000073adfc50)
[ 4024.938155] 0000000073adf958 0000000073adf8d8 0000000000000002 0000000000000000 
[ 4024.938164]        0000000073adf978 0000000073adf8f0 0000000073adf8f0 000000000061386a 
[ 4024.938174]        0000000000000000 0000000000000000 0000000000000005 0000000000100ec6 
[ 4024.938184]        000000000000000d 000000000000000c 0000000073adf940 0000000000000000 
[ 4024.938194]        0000000000000000 0000000000100a18 0000000073adf8d8 0000000073adf918 
[ 4024.938205] Call Trace:
[ 4024.938208] ([<0000000000100926>] show_trace+0xee/0x144)
[ 4024.938216]  [<0000000000613694>] panic+0xb0/0x234
[ 4024.938224]  [<0000000000100ec6>] die+0x15a/0x168
[ 4024.938230]  [<000000000011fb9e>] do_no_context+0xba/0xf8
[ 4024.938306]  [<000000000061c074>] do_dat_exception+0x378/0x3e4
[ 4024.938314]  [<0000000000619e02>] pgm_exit+0x0/0x4
[ 4024.938319]  [<000003e00126263a>] dm_softirq_done+0x72/0x140 [dm_mod]
[ 4024.938329] ([<070000000040716c>] 0x70000000040716c)
[ 4024.938334]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
[ 4024.938341]  [<00000000001587c2>] __do_softirq+0xda/0x398
[ 4024.938347]  [<0000000000158ba0>] run_ksoftirqd+0x120/0x23c
[ 4024.938354]  [<000000000017c2aa>] kthread+0xa6/0xb0
[ 4024.938360]  [<000000000061970e>] kernel_thread_starter+0x6/0xc
[ 4024.938366]  [<0000000000619708>] kernel_thread_starter+0x0/0xc
[ 4024.938373] INFO: lockdep is turned off.

So we thought we might as well upgrade to 3.1 but immediately got a

kernel BUG at block/blk-flush.c:323!

which was handled here https://lkml.org/lkml/2011/10/4/105 and
here https://lkml.org/lkml/2011/10/12/408 .

But no patches for that one went upstream AFAICS.
