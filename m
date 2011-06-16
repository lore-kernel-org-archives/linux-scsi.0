From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Thu, 16 Jun 2011 12:37:55 -0400
Message-ID: <1308242275.2436.56.camel@mulgrave>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
	 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55985 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067Ab1FPQh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 12:37:58 -0400
In-Reply-To: <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, 2011-06-16 at 18:01 +0200, Heiko Carstens wrote:
> cc'ing Jens (full quote of the original bug report at the end).
> 
> I patched the SLUB debugging code so that it includes full call traces
> instead of just the address of the caller of kfree/kmalloc. So here is
> yet another incarnation of what I think is the same use-after-free bug:
> 
> What we can see here: while scsi_dispatch_cmd() operates on a scsi_cmnd
> it gets freed via blk_done_softirq().
> In this specific case scsi_send_log() crashes while trying to dereference
> the SLAB/SLUB poison value.

But you're crashing in the submit path, not the completion path.
scsi_send_log() is called *before* we dispatch the command, so how on
earth did the command get freed in the completion (softirq) path?

James

> [  952.532025] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
> [  952.532031] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  952.532038] Modules linked in: dm_round_robin dm_multipath scsi_dh sunrpc qeth_l3 binfmt_misc dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
> [  952.532055] CPU: 0 Not tainted 2.6.39.1-50.0slubdbg.20110616-s390xdefault #1
> [  952.532058] Process flush-252:1 (pid: 3993, task: 00000000b837a558, ksp: 000000009f1934f0)
> [  952.532062] Krnl PSW : 0704100180000000 0000000000426dfc (scsi_print_command+0x44/0xf8)
> [  952.532071]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
> [  952.532075] Krnl GPRS: 0000000000000799 6b6b6b6b6b6b6b6b 000000008ac7c800 0000000000000001
> [  952.532078]            00000000005a1c8e 00000000005b95b0 00000000af005ba8 00000000afc9f57f
> [  952.532082]            000000008ac7c800 00000000afc9efa8 000000008ac7c800 000000008ac7c800
> [  952.532085]            0000000000000004 00000000005f1bb0 000000009f1938a0 000000009f193870
> [  952.532097] Krnl Code: 0000000000426dea: f0b80004ebbf        srp	4(12,%r0),3007(%r14),8
> [  952.532102]            0000000000426df0: f0a0000407f4        srp	4(11,%r0),2036,0
> [  952.532106]            0000000000426df6: e31020800004        lg	%r1,128(%r2)
> [  952.532111]           >0000000000426dfc: e31010b00004        lg	%r1,176(%r1)
> [  952.532115]            0000000000426e02: b9020011            ltgr	%r1,%r1
> [  952.532118]            0000000000426e06: a7840032            brc	8,426e6a
> [  952.532122]            0000000000426e0a: e33020000004        lg	%r3,0(%r2)
> [  952.532127]            0000000000426e10: c04000165e8b        larl	%r4,6f2b26
> [  952.532131] Call Trace:
> [  952.532133] ([<000000008ac7c800>] 0x8ac7c800)
> [  952.532136]  [<0000000000424f0c>] scsi_log_send+0xf0/0x130
> [  952.532140]  [<0000000000425230>] scsi_dispatch_cmd+0xc8/0x29c
> [  952.532144]  [<000000000042cf78>] scsi_request_fn+0x3b8/0x480
> [  952.532149]  [<00000000003a78be>] blk_insert_cloned_request+0x72/0xcc
> [  952.532154]  [<000003c0023f3466>] dm_dispatch_request+0x5a/0x94 [dm_mod]
> [  952.532166]  [<000003c0023f5b0c>] dm_request_fn+0x1e4/0x208 [dm_mod]
> [  952.532174]  [<00000000003aa512>] queue_unplugged.clone.27+0x3e/0x6c
> [  952.532178]  [<00000000003ab284>] blk_flush_plug_list+0x1fc/0x290
> [  952.532182]  [<00000000003ab342>] blk_finish_plug+0x2a/0x58
> [  952.532185]  [<00000000001e9410>] generic_writepages+0x6c/0x94
> [  952.532192]  [<000000000026abe0>] writeback_single_inode+0xf8/0x268
> [  952.532198]  [<000000000026b13a>] writeback_sb_inodes+0xd2/0x18c
> [  952.532202]  [<000000000026bcc0>] writeback_inodes_wb+0x80/0x168
> [  952.532206]  [<000000000026c04e>] wb_writeback+0x2a6/0x320
> [  952.532210]  [<000000000026c2f4>] wb_do_writeback+0x22c/0x270
> [  952.532213]  [<000000000026c3ec>] bdi_writeback_thread+0xb4/0x1c0
> [  952.532217]  [<0000000000169b3e>] kthread+0xa6/0xb0
> [  952.532223]  [<00000000005a73ea>] kernel_thread_starter+0x6/0xc
> [  952.532228]  [<00000000005a73e4>] kernel_thread_starter+0x0/0xc
> [  952.532231] INFO: lockdep is turned off.
> [  952.532233] Last Breaking-Event-Address:
> [  952.532235]  [<0000000000426de4>] scsi_print_command+0x2c/0xf8
> 
> Debug call traces from the freed object:
> 
> free (on cpu 1):
> 000000000011bd5e save_stack_trace
> 00000000002290b4 process_slab
> 0000000000229514 free_debug_processing
> 00000000002298a8 __slab_free
> 0000000000229c30 kmem_cache_free
> 000000000042d400 scsi_next_command
> 000000000042d628 scsi_io_completion
> 00000000003b0238 blk_done_softirq
> 000000000014c110 __do_softirq
> 000000000010e2ce do_softirq
> 000000000014c570 irq_exit
> 00000000004689b8 do_IRQ
> 00000000005a7e70 io_return
> 
> alloc ([flush-252:1]):
> 000000000011bd82 save_stack_trace
> 00000000002290b4 process_slab
> 00000000002292e4 alloc_debug_processing
> 000000000022a574 new_slab
> 000000000022a926 kmem_cache_alloc
> 000000000042475e scsi_pool_alloc_command
> 000000000042490a scsi_host_alloc_command
> 000000000042499e __scsi_get_command
> 0000000000424a8e scsi_get_command
> 000000000042bda6 scsi_setup_fs_cmnd
> 0000000000440662 sd_prep_fn
> 00000000003aa97e blk_peek_request
> 000000000042cc28 scsi_request_fn
> 00000000003a78be blk_insert_cloned_request
> 000003c0023f3466 dm_dispatch_request
> 000003c0023f5b0c dm_request_fn
> 00000000003aa512 blk_end_request_cur
> 00000000003ab284 blk_flush_plug_list
> 00000000003ab342 blk_finish_plug
> 00000000001e9410 generic_writepages
> 000000000026abe0 writeback_single_inode
> 000000000026b13a writeback_sb_inodes
> 000000000026bcc0 writeback_inodes_wb
> 000000000026c04e wb_writeback
> 000000000026c2f4 wb_do_writeback
> 000000000026c3ec bdi_writeback_thread
> 0000000000169b3e kthread
> 00000000005a73ea kernel_thread_starter
> 
> On Wed, Jun 15, 2011 at 01:20:16PM +0200, Heiko Carstens wrote:
> > Hi James,
> > 
> > while running some error recovery tests we encountered the following bug:
> > 
> > [23710.196446] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
> > [23710.196453] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [23710.196460] Modules linked in: dm_round_robin sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 vmur qeth ccwgroup [last unloaded: scsi_wait_scan]
> > [23710.196477] CPU: 0 Not tainted 2.6.39.1-49.x.20110609-s390xdefault #1
> > [23710.196480] Process kworker/u:5 (pid: 18534, task: 000000002f4d2368, ksp: 000000002f48f268)
> > [23710.196483] Krnl PSW : 0704000180000000 000000000042407c (scsi_dispatch_cmd+0xd4/0x29c)
> > [23710.196492]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> > [23710.196496] Krnl GPRS: 0280000000000000 6b6b6b6b6b6b6b6b 0000000000000060 0000000000006b6b
> > [23710.196499]            00000000005a0ab2 000000002f4d2af0 00000000390d8090 000000002f611ac7
> > [23710.196502]            000000003a764600 000000002f6114f0 000000003a764600 0000000000000000
> > [23710.196505]            000000003a78e1b0 00000000005f0638 0000000000424070 000000002f48f530
> > [23710.196516] Krnl Code: 000000000042406a: c0e5fffffdf9        brasl   %r14,423c5c
> > [23710.196520]            0000000000424070: e310a0000004        lg      %r1,0(%r10)
> > [23710.196525]            0000000000424076: e330a04a0091        llgh    %r3,74(%r10)
> > [23710.196529]           >000000000042407c: e31010000004        lg      %r1,0(%r1)
> > [23710.196533]            0000000000424082: e34012480091        llgh    %r4,584(%r1)
> > [23710.196537]            0000000000424088: 1534                clr     %r3,%r4
> > [23710.196541]            000000000042408a: a7240033            brc     2,4240f0
> > [23710.196546]            000000000042408e: d503d008c2c0        clc     8(4,%r13),704(%r12)
> > [23710.196549] Call Trace:
> > [23710.196551] ([<0000000000424070>] scsi_dispatch_cmd+0xc8/0x29c)
> > [23710.196555]  [<000000000042bdb8>] scsi_request_fn+0x3b8/0x480
> > [23710.196560]  [<00000000003adfb6>] blk_execute_rq_nowait+0x76/0xd0
> > [23710.196565]  [<00000000003ae0a6>] blk_execute_rq+0x96/0xe8
> > [23710.196569]  [<000000000042af84>] scsi_execute+0x124/0x22c
> > [23710.196573]  [<000000000042b1cc>] scsi_execute_req+0x140/0x148
> > [23710.196577]  [<0000000000422f0c>] scsi_vpd_inquiry+0x80/0xac
> > [23710.196580]  [<0000000000422f80>] scsi_get_vpd_page+0x48/0x108
> > [23710.196584]  [<000000000043e240>] sd_revalidate_disk+0x984/0x1a6c
> > [23710.196590]  [<00000000002b898e>] rescan_partitions+0xc6/0x594
> > [23710.196596]  [<000000000027b1ca>] __blkdev_get+0x2f6/0x43c
> > [23710.196602]  [<000000000027b358>] blkdev_get+0x48/0x38c
> > [23710.196606]  [<00000000003b463e>] register_disk+0x182/0x19c
> > [23710.196610]  [<00000000003b4758>] add_disk+0x100/0x2ac
> > [23710.196614]  [<00000000004402bc>] sd_probe_async+0x118/0x1c8
> > [23710.196618]  [<0000000000173168>] async_run_entry_fn+0x98/0x188
> > [23710.196624]  [<000000000015ec5e>] process_one_work+0x1f6/0x4ec
> > [23710.196630]  [<0000000000162a48>] worker_thread+0x17c/0x370
> > [23710.196633]  [<0000000000168b7e>] kthread+0xa6/0xb0
> > [23710.196637]  [<00000000005a61fa>] kernel_thread_starter+0x6/0xc
> > [23710.196643]  [<00000000005a61f4>] kernel_thread_starter+0x0/0xc
> > [23710.196646] INFO: lockdep is turned off.
> > [23710.196648] Last Breaking-Event-Address:
> > [23710.196650]  [<00000000005a0abc>] printk+0x5c/0x60
> > 
> > Testcase is multipath setup (dm) where I/O happens to these SCSI devices and
> > while doing so randomly the channel paths to adapters get switched on and off.
> > Each time a channel path to a adapter gets switched off this results into a
> > call to fc_remote_port_delete() for each connected port of an adapter.
> > 
> > A short analysis for the call trace above: we use SLUB and have all debugging
> > options turned on. The system crashed within scsi_dispatch_cmd() when it tried
> > to derefence cmd->device in order to get the host pointer within this short
> > code snippet:
> > 
> >         /*
> >          * Before we queue this command, check if the command
> >          * length exceeds what the host adapter can handle.
> >          */
> >         if (cmd->cmd_len > cmd->device->host->max_cmd_len) {
> >                 SCSI_LOG_MLQUEUE(3,
> > 
> > The struct scsi_cmnd contains 0x6b which means it got freed and we have a
> > use after free bug here. The interesting thing is that the code got so far
> > into this function without crashing. Since there are several other places
> > where derefencing happened before in the function (without crashing) this
> > means that this piece of memory got freed while this function got executed
> > (well, preemption is turned on, so maybe it got freed while being preempted).
> > 
> > SLUB caller tracking is turned on, which reveals that this piece of memory
> > got freed by __scsi_put_command().
> > 
> > As far as I can tell, in this case the device driver cannot be blamed since
> > the request in question didn't even reach the driver before it got freed and
> > the system crashed.
> > But of course I could be entirely wrong :)
> > 
> > Would you happen to have any ideas what could cause this bug?
> > 
> > FWIW, this is 2.6.39.1 which in addition contains
> > e73e079bf128d68284efedeba1fbbc18d78610f9 "[SCSI] Fix oops caused by queue
> > refcounting failure"
> > 
> > Thanks,
> > Heiko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


