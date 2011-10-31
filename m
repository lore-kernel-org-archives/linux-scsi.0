From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Mon, 31 Oct 2011 10:01:43 -0400
Message-ID: <20111031140142.GC14393@redhat.com>
References: <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>
 <4E9BEB68.1050707@ce.jp.nec.com>
 <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
 <4E9D7FA8.9000000@ce.jp.nec.com>
 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <20111031132158.GB14393@redhat.com>
 <20111031134050.GC4768@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111031134050.GC4768@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31 2011 at  9:40am -0400,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Oct 31, 2011 at 09:21:58AM -0400, Mike Snitzer wrote:
> > > > It _looks_ like we do not hit the BUG_ON() that. This time we get this instead:
> > > > 
> > > > [ 4024.937870] Unable to handle kernel pointer dereference at virtual kernel address 000003e004d41000
> > > > [ 4024.937886] Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > > > [ 4024.937899] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [las
> > > > t unloaded: scsi_wait_scan]
> > > > [ 4024.937925] CPU: 1 Not tainted 3.0.7-50.x.20111021-s390xdefault #1
> > > > [ 4024.937930] Process ksoftirqd/1 (pid: 1942, task: 0000000079c6c750, ksp: 0000000073adfc50)
> > > > [ 4024.937936] Krnl PSW : 0704000180000000 000003e00126263a (dm_softirq_done+0x72/0x140 [dm_mod])
> > > > [ 4024.937959]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> > > > [ 4024.937966] Krnl GPRS: 000000007b9156b0 000003e004d41100 000000000e14b600 000000000000006d
> > > > [ 4024.937971]            00000000715332b0 000000000c140ce8 000000000090d2ef 0000000000000005
> > > > [ 4024.937977]            0000000000000001 0000000000000101 000000000c140d00 0000000000000000
> > > > [ 4024.937983]            000003e001260000 000003e00126f098 0000000073adfd08 0000000073adfcb8
> > > > [ 4024.938001] Krnl Code: 000003e00126262a: f0a0000407f1        srp     4(11,%r0),2033,0
> > > > [ 4024.938009]            000003e001262630: e31050080004        lg      %r1,8(%r5)
> > > > [ 4024.938017]            000003e001262636: 58b05180            l       %r11,384(%r5)
> > > > [ 4024.938024]           >000003e00126263a: e31010080004        lg      %r1,8(%r1)
> > > > [ 4024.938031]            000003e001262640: e31010500004        lg      %r1,80(%r1)
> > > > [ 4024.938038]            000003e001262646: b9020011            ltgr    %r1,%r1
> > > > [ 4024.938045]            000003e00126264a: a784ffdf            brc     8,3e001262608
> > > > [ 4024.938053]            000003e00126264e: e32050080004        lg      %r2,8(%r5)
> > > > [ 4024.938060] Call Trace:
> > > > [ 4024.938063] ([<070000000040716c>] 0x70000000040716c)
> > > > [ 4024.938069]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
> > > > [ 4024.938080]  [<00000000001587c2>] __do_softirq+0xda/0x398
> > > > [ 4024.938088]  [<0000000000158ba0>] run_ksoftirqd+0x120/0x23c
> > > > [ 4024.938095]  [<000000000017c2aa>] kthread+0xa6/0xb0
> > > > [ 4024.938102]  [<000000000061970e>] kernel_thread_starter+0x6/0xc
> > > > [ 4024.938112]  [<0000000000619708>] kernel_thread_starter+0x0/0xc
> > > > [ 4024.938118] INFO: lockdep is turned off.
> > > > [ 4024.938121] Last Breaking-Event-Address:
> > > > [ 4024.938124]  [<000003e001262600>] dm_softirq_done+0x38/0x140 [dm_mod]
> > > > [ 4024.938135]  
> > > > [ 4024.938139] Kernel panic - not syncing: Fatal exception in interrupt
> > > > [ 4024.938144] CPU: 1 Tainted: G      D     3.0.7-50.x.20111021-s390xdefault #1
> > > > [ 4024.938150] Process ksoftirqd/1 (pid: 1942, task: 0000000079c6c750, ksp: 0000000073adfc50)
> > > > [ 4024.938155] 0000000073adf958 0000000073adf8d8 0000000000000002 0000000000000000 
> > > > [ 4024.938164]        0000000073adf978 0000000073adf8f0 0000000073adf8f0 000000000061386a 
> > > > [ 4024.938174]        0000000000000000 0000000000000000 0000000000000005 0000000000100ec6 
> > > > [ 4024.938184]        000000000000000d 000000000000000c 0000000073adf940 0000000000000000 
> > > > [ 4024.938194]        0000000000000000 0000000000100a18 0000000073adf8d8 0000000073adf918 
> > > > [ 4024.938205] Call Trace:
> > > > [ 4024.938208] ([<0000000000100926>] show_trace+0xee/0x144)
> > > > [ 4024.938216]  [<0000000000613694>] panic+0xb0/0x234
> > > > [ 4024.938224]  [<0000000000100ec6>] die+0x15a/0x168
> > > > [ 4024.938230]  [<000000000011fb9e>] do_no_context+0xba/0xf8
> > > > [ 4024.938306]  [<000000000061c074>] do_dat_exception+0x378/0x3e4
> > > > [ 4024.938314]  [<0000000000619e02>] pgm_exit+0x0/0x4
> > > > [ 4024.938319]  [<000003e00126263a>] dm_softirq_done+0x72/0x140 [dm_mod]
> > > > [ 4024.938329] ([<070000000040716c>] 0x70000000040716c)
> > > > [ 4024.938334]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
> > > > [ 4024.938341]  [<00000000001587c2>] __do_softirq+0xda/0x398
> > > > [ 4024.938347]  [<0000000000158ba0>] run_ksoftirqd+0x120/0x23c
> > > > [ 4024.938354]  [<000000000017c2aa>] kthread+0xa6/0xb0
> > > > [ 4024.938360]  [<000000000061970e>] kernel_thread_starter+0x6/0xc
> > > > [ 4024.938366]  [<0000000000619708>] kernel_thread_starter+0x0/0xc
> > > > [ 4024.938373] INFO: lockdep is turned off.
> > > > 
> > > > So we thought we might as well upgrade to 3.1 but immediately got a
> > > > 
> > > > kernel BUG at block/blk-flush.c:323!
> > > > 
> > > > which was handled here https://lkml.org/lkml/2011/10/4/105 and
> > > > here https://lkml.org/lkml/2011/10/12/408 .
> > > > 
> > > > But no patches for that one went upstream AFAICS.
> > > 
> > > Well, all I can say is "hm".  You put only a BUG_ON() in the code, which
> > > wasn't triggered, but now we get a completely different oops.  However,
> > > I think it does point to the dm barrier handling code.  Can you turn off
> > > barriers and see if all oopses go away?
> > 
> > There are two 3.1-stable fixes from Jeff Moyer that Jens staged for
> > Linus to pick up (but seems Jens hasn't sent his 3.2 pull to Linus yet):
> > 
> > http://git.kernel.dk/?p=linux-block.git;a=commit;h=8f02b3a09b1b7d2a4d24b8cd7008f2a441f19a14
> > http://git.kernel.dk/?p=linux-block.git;a=commit;h=f26d8f0562da76731cb049943a0e9d9fa81d946a
> 
> Those two fixes would only address the "kernel BUG at block/blk-flush.c:323!" but not the
> crash report above, right?

Right.

> Since looking at the changelog they refer to a patch that went in with 3.1-rc1 while the
> crash report above is with 3.0.7. Oh well...

Good data point.  This is the second request-based DM report I've seen
now with 3.0 (first was with fedora on btrfs and request-based DM).

Will look closer but it should be noted that DM didn't change
significantly in 3.0.  So it is likely a lingering oversight from the
block changes introduced for onstack plugging (from 2.6.39) or some
other change.
