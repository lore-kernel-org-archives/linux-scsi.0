From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Fri, 4 Nov 2011 10:12:41 +0100
Message-ID: <20111104091240.GA2397@osiris.boeblingen.de.ibm.com>
References: <4E9D7FA8.9000000@ce.jp.nec.com>
 <20111018154542.GB3869@osiris.boeblingen.de.ibm.com>
 <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <4EB13972.30308@ce.jp.nec.com>
 <20111102134730.GA2490@osiris.boeblingen.de.ibm.com>
 <4EB36519.5010003@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB36519.5010003@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Mike Snitzer <snitzer@redhat.com>, gmuelas@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 04, 2011 at 01:07:53PM +0900, Jun'ichi Nomura wrote:
> Thanks, ok it was ti which was invalid. Not tio.
> ti is a pointer to dm table entry, which is vmalloc-ed.
> So it means the dm table was replaced while I/O was in-flight.
> 
> dm has a machanism to prevent it: in dm_suspend(),
> stop_queue() is called to stop block queue processing
> and no new I/O becomes in-flight after that.
> Then all in-flight I/Os are waited to be completed or requeued
> (dm_wait_for_completion()).
> If the wait was successful, the table can become "suspended",
> i.e. ready to be replaced.
> 
> So ti should be always valid.
> Hmm..

Here is another one (crash at same place in code). Might be of interest
since userspace triggered a call to dm_suspend(). While executing an irq
arrives and the same crash as observed before happened:

[96875.876768] Unable to handle kernel pointer dereference at virtual kernel address 000003e004bcf000
[96875.876773] Oops: 0011 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[96875.876780] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [last unloaded: scsi_wait_scan]
[96875.876800] CPU: 0 Tainted: G      D W   3.0.7-50.x.20111024-s390xdefault #1
[96875.876804] Process kpartx (pid: 36986, task: 0000000058754750, ksp: 000000005874b318)
[96875.876808] Krnl PSW : 0704000180000000 000003e0012e363a (dm_softirq_done+0x72/0x140 [dm_mod])
[96875.876819]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[96875.876825] Krnl GPRS: 000000007b9156b0 000003e004bcf100 00000000586f2f40 0000000000000065
[96875.876829]            00000000586f3610 00000000717a9f58 0000000000000002 0000000000000005
[96875.876834]            0000000000000000 0400000000000102 00000000717a9f70 0000000000000000
[96875.876838]            000003e0012e1000 000003e0012f0098 000000007a9c7c40 000000007a9c7bf0
[96875.876852] Krnl Code: 000003e0012e362a: f0a0000407f1        srp     4(11,%r0),2033,0
[96875.876858]            000003e0012e3630: e31050080004        lg      %r1,8(%r5)
[96875.876864]            000003e0012e3636: 58b05180            l       %r11,384(%r5)
[96875.876869]           >000003e0012e363a: e31010080004        lg      %r1,8(%r1)
[96875.876875]            000003e0012e3640: e31010500004        lg      %r1,80(%r1)
[96875.876880]            000003e0012e3646: b9020011            ltgr    %r1,%r1
[96875.876885]            000003e0012e364a: a784ffdf            brc     8,3e0012e3608
[96875.876891]            000003e0012e364e: e32050080004        lg      %r2,8(%r5)
[96875.876895] Call Trace:
[96875.876898] ([<070000000040716c>] 0x70000000040716c)
[96875.876902]  [<000000000040d29c>] blk_done_softirq+0xd4/0xf0
[96875.876909]  [<00000000001587c2>] __do_softirq+0xda/0x398
[96875.876914]  [<000000000010f47e>] do_softirq+0xe2/0xe8
[96875.876919]  [<0000000000158e2c>] irq_exit+0xc8/0xcc
[96875.876924]  [<00000000004ceb48>] do_IRQ+0x910/0x1bfc
[96875.876930]  [<000000000061a164>] io_return+0x0/0x16
[96875.876935]  [<000000000061c2a0>] sub_preempt_count+0x34/0xd4
[96875.876941] ([<000000005874ba38>] 0x5874ba38)
[96875.876945]  [<000000000061918c>] _raw_spin_unlock_irq+0x50/0x7c
[96875.876951]  [<00000000001729ea>] flush_workqueue_prep_cwqs+0x222/0x4dc
[96875.876959]  [<0000000000174718>] flush_workqueue+0x1e8/0x4c0
[96875.876964]  [<000003e0012e63e8>] dm_suspend+0x174/0x384 [dm_mod]
[96875.876973]  [<000003e0012ebe1e>] dev_suspend+0x21e/0x250 [dm_mod]
[96875.876983]  [<000003e0012eccb6>] ctl_ioctl+0x1e2/0x2f4 [dm_mod]
[96875.876992]  [<000003e0012ecdf2>] dm_ctl_ioctl+0x2a/0x38 [dm_mod]
[96875.877000]  [<0000000000291c98>] do_vfs_ioctl+0x94/0x588
[96875.877005]  [<0000000000292220>] SyS_ioctl+0x94/0xac
[96875.877010]  [<0000000000619af2>] sysc_noemu+0x16/0x1c
[96875.877015]  [<000003fffd32f7ca>] 0x3fffd32f7ca
[96875.877019] INFO: lockdep is turned off.
[96875.877022] Last Breaking-Event-Address:
[96875.877025]  [<000003e0012e3600>] dm_softirq_done+0x38/0x140 [dm_mod]
