From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 09:16:38 +1100
Message-ID: <20161221221638.GD4758@dastard>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29449 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757564AbcLUWS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 17:18:27 -0500
Content-Disposition: inline
In-Reply-To: <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Leech <cleech@redhat.com>, linux-kernel@vger.kernel.org, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Dec 16, 2016 at 10:59:06AM -0800, Chris Leech wrote:
> Thanks Dave,
> 
> I'm hitting a bug at scatterlist.h:140 before I even get any iSCSI
> modules loaded (virtio block) so there's something else going on in the
> current merge window.  I'll keep an eye on it and make sure there's
> nothing iSCSI needs fixing for.

OK, so before this slips through the cracks.....

Linus - your tree as of a few minutes ago still panics immediately
when starting xfstests on iscsi devices. It appears to be a
scatterlist corruption and not an iscsi problem, so the iscsi guys
seem to have bounced it and no-one is looking at it.

I'm disappearing for several months at the end of tomorrow, so I
thought I better make sure you know about it.  I've also added
linux-scsi, linux-block to the cc list....

Cheers,

Dave.

> On Thu, Dec 15, 2016 at 09:29:53AM +1100, Dave Chinner wrote:
> > On Thu, Dec 15, 2016 at 09:24:11AM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > Just updated my test boxes from 4.9 to a current Linus 4.10 merge
> > > window kernel to test the XFS merge I am preparing for Linus.
> > > Unfortunately, all my test VMs using iscsi failed pretty much
> > > instantly on the first mount of an iscsi device:
> > > 
> > > [  159.372704] XFS (sdb): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> > > [  159.374612] XFS (sdb): Mounting V5 Filesystem
> > > [  159.425710] XFS (sdb): Ending clean mount
> > > [  160.274438] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> > > [  160.275851] IP: iscsi_tcp_segment_done+0x20d/0x2e0
> > 
> > FYI, crash is here:
> > 
> > (gdb) l *(iscsi_tcp_segment_done+0x20d)
> > 0xffffffff81b950bd is in iscsi_tcp_segment_done (drivers/scsi/libiscsi_tcp.c:102).
> > 97	iscsi_tcp_segment_init_sg(struct iscsi_segment *segment,
> > 98				  struct scatterlist *sg, unsigned int offset)
> > 99	{
> > 100		segment->sg = sg;
> > 101		segment->sg_offset = offset;
> > 102		segment->size = min(sg->length - offset,
> > 103				    segment->total_size - segment->total_copied);
> > 104		segment->data = NULL;
> > 105	}
> > 106	
> > 
> > So it looks to be sg = NULL, which means there's probably an issue
> > with the scatterlist...
> > 
> > -Dave.
> > 
> > > [  160.276565] PGD 336ed067 [  160.276885] PUD 31b0d067
> > > PMD 0 [  160.277309]
> > > [  160.277523] Oops: 0000 [#1] PREEMPT SMP
> > > [  160.278004] Modules linked in:
> > > [  160.278407] CPU: 0 PID: 16 Comm: kworker/u2:1 Not tainted 4.9.0-dgc #18
> > > [  160.279224] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> > > [  160.280314] Workqueue: iscsi_q_2 iscsi_xmitworker
> > > [  160.280919] task: ffff88003e280000 task.stack: ffffc90000080000
> > > [  160.281647] RIP: 0010:iscsi_tcp_segment_done+0x20d/0x2e0
> > > [  160.282312] RSP: 0018:ffffc90000083c38 EFLAGS: 00010206
> > > [  160.282980] RAX: 0000000000000000 RBX: ffff880039061730 RCX: 0000000000000000
> > > [  160.283854] RDX: 0000000000001e00 RSI: 0000000000000000 RDI: ffff880039061730
> > > [  160.284738] RBP: ffffc90000083c90 R08: 0000000000000200 R09: 00000000000005a8
> > > [  160.285627] R10: 000000009835607d R11: 0000000000000000 R12: 0000000000000200
> > > [  160.286495] R13: 0000000000000000 R14: ffff8800390615a0 R15: ffff880039061730
> > > [  160.287362] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
> > > [  160.288340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  160.289113] CR2: 000000000000000c CR3: 0000000031a8d000 CR4: 00000000000006f0
> > > [  160.290084] Call Trace:
> > > [  160.290429]  ? inet_sendpage+0x4d/0x140
> > > [  160.290957]  iscsi_sw_tcp_xmit_segment+0x89/0x110
> > > [  160.291597]  iscsi_sw_tcp_pdu_xmit+0x56/0x180
> > > [  160.292190]  iscsi_tcp_task_xmit+0xb8/0x280
> > > [  160.292771]  iscsi_xmit_task+0x53/0xc0
> > > [  160.293282]  iscsi_xmitworker+0x274/0x310
> > > [  160.293835]  process_one_work+0x1de/0x4d0
> > > [  160.294388]  worker_thread+0x4b/0x4f0
> > > [  160.294889]  kthread+0x10c/0x140
> > > [  160.295333]  ? process_one_work+0x4d0/0x4d0
> > > [  160.295898]  ? kthread_create_on_node+0x40/0x40
> > > [  160.296525]  ret_from_fork+0x25/0x30
> > > [  160.297015] Code: 43 18 00 00 00 00 e9 ad fe ff ff 48 8b 7b 30 e8 da e7 ca ff 8b 53 10 44 89 ee 48 89 df 2b 53 14 48 89 43 30 c7 43 40 00 00 00 00 <8b
> > > [  160.300674] RIP: iscsi_tcp_segment_done+0x20d/0x2e0 RSP: ffffc90000083c38
> > > [  160.301584] CR2: 000000000000000c
> > > 
> > > 
> > > Known problem, or something new?
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

-- 
Dave Chinner
david@fromorbit.com
