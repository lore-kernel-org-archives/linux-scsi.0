From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Tue, 29 Nov 2011 13:00:48 +0100
Message-ID: <20111129120047.GA2456@osiris.boeblingen.de.ibm.com>
References: <1318955380.5169.15.camel@dabdike.int.hansenpartnership.com>
 <20111031100557.GA2621@osiris.boeblingen.de.ibm.com>
 <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EBA49C2.1000704@suse.de>
 <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
 <20111117162919.GA3812@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40087 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1K2MCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2011 07:02:07 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Tue, 29 Nov 2011 12:02:00 -0000
Content-Disposition: inline
In-Reply-To: <20111117162919.GA3812@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com

> > > Hmm. Just to be on the safe side, could you try this one:
> > > 
> > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > index 5e0090e..e6fad46 100644
> > > --- a/drivers/md/dm-mpath.c
> > > +++ b/drivers/md/dm-mpath.c
> > > @@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti,
> > > struct reque
> > > st *clone,
> > >         map_context->ptr = mpio;
> > >         clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
> > >         r = map_io(m, clone, mpio, 0);
> > > -       if (r < 0 || r == DM_MAPIO_REQUEUE)
> > > +       if (r < 0 || r == DM_MAPIO_REQUEUE) {
> > >                 mempool_free(mpio, m->mpio_pool);
> > > +               map_context->ptr = NULL;
> > > +       }
> > > 
> > >         return r;
> > >  }
> > 
> > With your patch we haven't been able to reproduce the kernel crash until now.
> > Now we "only" run into I/O stalls, which before your patch we also did. But
> > repeatedly rebooting and retrying and ignoring the I/O stalls always lead to
> > a crash.
> > Gonzalo will run a couple of extra rounds so we can have a feeling if at least
> > one of the bugs could be fixed with your patch ;)
> 
> Hi,
> 
> Any update after further testing with Hannes' patch?

Sorry for the late update, our internal IBM IMAP servers have been down
for nearly a week :/

So, we were unable to reproduce the original bug with the patch applied
during various runs.
However, we ran into this one instead, which is yet another use-after-free bug
(I need to double check, but I'm quite sure that a freed struct scsi_cmnd
caused this).

[ 4906.683654] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
[ 4906.683662] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 4906.683672] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [last unloaded: scsi_wait_scan]
[ 4906.683696] CPU: 3 Not tainted 3.1.0-52.x.20111111-s390xdefault #1
[ 4906.683700] Process flush-252:12 (pid: 2489, task: 0000000072b4a490, ksp: 0000000072f8fb48)
[ 4906.683705] Krnl PSW : 0404200180000000 000000000052a98c (zfcp_fsf_fcp_handler_common+0x3c/0x2f4)
[ 4906.683719]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
[ 4906.683728] Krnl GPRS: 0000000000000000 00000000726dc800 0000000037e1c4e8 0400043100d78e40
[ 4906.683733]            0000000070ccc000 0000000000000010 0700000074b4dcd0 00000000726dc800
[ 4906.683738]            0000000037e1c4e8 070000000d427960 0000000074b4dcd0 0000000070ccc000
[ 4906.683743]            6b6b6b6b6b6b6b6b 0000000000688560 000000000d427980 000000000d427920
[ 4906.683761] Krnl Code: 000000000052a97c: 58502090            l       %r5,144(%r2)
[ 4906.683767]            000000000052a980: e3c010000004        lg      %r12,0(%r1)
[ 4906.683773]            000000000052a986: e34020980004        lg      %r4,152(%r2)
[ 4906.683780]           >000000000052a98c: e330c0000004        lg      %r3,0(%r12)
[ 4906.683786]            000000000052a992: a7510008            tmll    %r5,8
[ 4906.683792]            000000000052a996: e33032080004        lg      %r3,520(%r3)
[ 4906.683798]            000000000052a99c: 58303204            l       %r3,516(%r3)
[ 4906.683803]            000000000052a9a0: a774001c            brc     7,52a9d8
[ 4906.683809] Call Trace:
[ 4906.683811] ([<000000000d427980>] 0xd427980)
[ 4906.683817]  [<000000000052aff2>] zfcp_fsf_fcp_cmnd_handler+0x52/0x448
[ 4906.683824]  [<000000000052c3f8>] zfcp_fsf_req_complete+0x1d8/0x7e4
[ 4906.683829]  [<000000000052ef2c>] zfcp_fsf_reqid_check+0xc4/0x13c
[ 4906.683835]  [<000000000052fe92>] zfcp_qdio_int_resp+0x72/0x1a4
[ 4906.683841]  [<00000000004eb6fe>] qdio_kick_handler+0x12e/0x2e0
[ 4906.683848]  [<00000000004ecfb2>] __tiqdio_inbound_processing+0xea/0xd98
[ 4906.683854]  [<00000000001552f2>] tasklet_action+0xd2/0x29c
[ 4906.683862]  [<00000000001563e2>] __do_softirq+0xda/0x398
[ 4906.683868]  [<000000000010f47e>] do_softirq+0xe2/0xe8
[ 4906.683876]  [<0000000000156a4c>] irq_exit+0xc8/0xcc
[ 4906.683881]  [<00000000004d79fa>] do_IRQ+0x20e/0x320
[ 4906.683889]  [<000000000061de8c>] io_return+0x0/0x16
[ 4906.683897]  [<000000000061cf78>] _raw_spin_unlock_irqrestore+0x98/0xa8
[ 4906.683904] ([<000000000061cf6e>] _raw_spin_unlock_irqrestore+0x8e/0xa8)
[ 4906.683910]  [<0000000000218262>] test_set_page_writeback+0x10e/0x248
[ 4906.683919]  [<00000000002b9254>] __block_write_full_page+0x310/0x5cc
[ 4906.683926]  [<00000000002b9628>] block_write_full_page_endio+0x118/0x168
[ 4906.683932]  [<000000000031050e>] ext3_writeback_writepage+0x1fa/0x28c
[ 4906.683940]  [<0000000000218006>] __writepage+0x2e/0x88
[ 4906.683945]  [<0000000000218be0>] write_cache_pages+0x224/0x600
[ 4906.683951]  [<000000000021901c>] generic_writepages+0x60/0x94
[ 4906.683957]  [<00000000002ace14>] writeback_single_inode+0x13c/0x53c
[ 4906.683964]  [<00000000002adb80>] writeback_sb_inodes+0x1d4/0x2e4
[ 4906.683970]  [<00000000002ae44c>] __writeback_inodes_wb+0xa0/0xec
[ 4906.683976]  [<00000000002ae926>] wb_writeback+0x48e/0x5f8
[ 4906.683981]  [<00000000002af03a>] wb_do_writeback+0x302/0x3ac
[ 4906.683987]  [<00000000002af194>] bdi_writeback_thread+0xb0/0x4e0
[ 4906.683993]  [<000000000017a3ea>] kthread+0xa6/0xb0
[ 4906.683999]  [<000000000061d436>] kernel_thread_starter+0x6/0xc
[ 4906.684005]  [<000000000061d430>] kernel_thread_starter+0x0/0xc
[ 4906.684010] INFO: lockdep is turned off.
[ 4906.684013] Last Breaking-Event-Address:
[ 4906.684016]  [<000000000052afec>] zfcp_fsf_fcp_cmnd_handler+0x4c/0x448

Gonzalo also tried 2.6.38.8 as suggested and ran into this one:

[  292.877936] ------------[ cut here ]------------
[  292.877939] Kernel BUG at 6b6b6b6b6b6b6b6d [verbose debug info unavailable]
[  292.877947] specification exception: 0006 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  292.877956] Modules linked in: dm_round_robin sunrpc ipv6 qeth_l2 binfmt_misc dm_multipath scsi_dh dm_mod qeth ccwgroup [last unloaded: scsi_wait_scan]
[  292.877979] CPU: 1 Not tainted 2.6.38.8 #1
[  292.877982] Process multipathd (pid: 352, task: 000000007bab8000, ksp: 000000007ba3ba00)
[  292.877988] Krnl PSW : 0704000180000000 6b6b6b6b6b6b6b6d (0x6b6b6b6b6b6b6b6d)
[  292.877997]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[  292.878003] Krnl GPRS: 17c0000000000000 6b6b6b6b6b6b6b6b 0000000078dc49f0 0000000000000000
[  292.878008]            000003c001f6a728 00000000005ec230 00000000738e2910 00000000756d4aa0
[  292.878013]            000003c000000001 000000007ba3bc58 00000000738e2910 00000000738e2a08
[  292.878018]            000003c001f63000 0000000078dc49f0 00000000003e6c0a 000000007ba3bb80
[  292.878024] Krnl Code: Bad PSW.
[  292.878027] Call Trace:
[  292.878030] ([<00000000003e6c0a>] blk_unplug+0x42/0x150)
[  292.878040]  [<000003c001f6a728>] dm_table_unplug_all+0x60/0x10c [dm_mod]
[  292.878060]  [<000003c001f65926>] dm_unplug_all+0x86/0xa8 [dm_mod]
[  292.878069]  [<000003c001f68508>] dm_suspend+0x1a4/0x394 [dm_mod]
[  292.878078]  [<000003c001f6dce6>] dev_suspend+0x21e/0x250 [dm_mod]
[  292.878087]  [<000003c001f6eaa8>] ctl_ioctl+0x1c8/0x28c [dm_mod]
[  292.878096]  [<000003c001f6eb96>] dm_ctl_ioctl+0x2a/0x38 [dm_mod]
[  292.878105]  [<000000000027df74>] do_vfs_ioctl+0x94/0x5b8
[  292.878112]  [<000000000027e52c>] SyS_ioctl+0x94/0xac
[  292.878117]  [<00000000005d8f5e>] sysc_noemu+0x16/0x1c
[  292.878125]  [<000003fffd2097ca>] 0x3fffd2097ca
[  292.878130] INFO: lockdep is turned off.
[  292.878133] Last Breaking-Event-Address:
[  292.878136]  [<00000000003e6c08>] blk_unplug+0x40/0x150

