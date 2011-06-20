From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Mon, 20 Jun 2011 17:30:21 +0200
Message-ID: <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
 <1308242275.2436.56.camel@mulgrave>
 <20110616184023.GA2362@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:56799 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1FTPad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2011 11:30:33 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p5KFUNL3018707
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 15:30:23 GMT
Received: from d06av08.portsmouth.uk.ibm.com (d06av08.portsmouth.uk.ibm.com [9.149.37.249])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5KFUNVF2351248
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 16:30:23 +0100
Received: from d06av08.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5KFUMtx025180
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 16:30:22 +0100
Content-Disposition: inline
In-Reply-To: <20110616184023.GA2362@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, Jun 16, 2011 at 08:40:23PM +0200, Heiko Carstens wrote:
> On Thu, Jun 16, 2011 at 12:37:55PM -0400, James Bottomley wrote:
> > On Thu, 2011-06-16 at 18:01 +0200, Heiko Carstens wrote:
> > > cc'ing Jens (full quote of the original bug report at the end).
> > > 
> > > I patched the SLUB debugging code so that it includes full call traces
> > > instead of just the address of the caller of kfree/kmalloc. So here is
> > > yet another incarnation of what I think is the same use-after-free bug:
> > > 
> > > What we can see here: while scsi_dispatch_cmd() operates on a scsi_cmnd
> > > it gets freed via blk_done_softirq().
> > > In this specific case scsi_send_log() crashes while trying to dereference
> > > the SLAB/SLUB poison value.
> > 
> > But you're crashing in the submit path, not the completion path.
> > scsi_send_log() is called *before* we dispatch the command, so how on
> > earth did the command get freed in the completion (softirq) path?

Here is another one:

In this case it crashed in elv_drain_elevator() while trying to get the ops
pointer of the struct elevator_queue in this line:

while (q->elevator->ops->elevator_dispatch_fn(q, 1))

The queue_flags field of the corresponding request_queue has the
QUEUE_FLAG_DEAD bit set, if I'm not mistaken (see below). That looks like
blk_cleanup_queue() got called which in turn called elevator_exit() which
freed the struct. Does it even make sense to have QUEUE_FLAG_DEAD set with
having QUEUE_FLAG_STOPPED not set?

The refcount of the embedded kobj of the request_queue however is still 1.

In addition the piece of memory got used and freed by the zfcp driver, but
this doesn't look like the real cause of the bug.
It more looks like an unexpected call to blk_cleanup_queue(), no?

[ 3081.573315] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
[ 3081.573320] Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 3081.573324] Modules linked in: dm_round_robin sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
[ 3081.573333] CPU: 0 Not tainted 2.6.39.1-50.0slubdbg.20110617-s390xdefault #1
[ 3081.573335] Process multipathd (pid: 633, task: 0000000074c90000, ksp: 0000000072467888)
[ 3081.573337] Krnl PSW : 0404200180000000 00000000003a6430 (elv_drain_elevator+0x34/0x94)
[ 3081.573346]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
[ 3081.573348] Krnl GPRS: 0e40000000000000 6b6b6b6b6b6b6b6b 00000000602bca70 0000000000000001
[ 3081.573350]            0000000000000002 0000000074c90750 0000000061aa923f 000000001f89a1c0
[ 3081.573352]            000000006fc6e250 0000000073131ea8 0000000061aa8c68 000000006fc6e268
[ 3081.573354]            00000000602bca70 00000000602bca70 0000000072467b58 0000000072467b38
[ 3081.573364] Krnl Code: 00000000003a6422: b904002d            lgr     %r2,%r13
[ 3081.573368]            00000000003a6426: e31010000004        lg      %r1,0(%r1)
[ 3081.573370]            00000000003a642c: a7390001            lghi    %r3,1
[ 3081.573373]           >00000000003a6430: e31010280004        lg      %r1,40(%r1)
[ 3081.573375]            00000000003a6436: 0de1                basr    %r14,%r1
[ 3081.573377]            00000000003a6438: 1222                ltr     %r2,%r2
[ 3081.573379]            00000000003a643a: a774fff1            brc     7,3a641c
[ 3081.573382]            00000000003a643e: bf4fd6b0            icm     %r4,15,1712(%r13)
[ 3081.573384] Call Trace:
[ 3081.573385] ([<0000000061aa8c68>] 0x61aa8c68)
[ 3081.573387]  [<00000000003a6534>] __elv_add_request+0xa4/0x254
[ 3081.573390]  [<00000000003a789e>] blk_insert_cloned_request+0x72/0xcc
[ 3081.573392]  [<000003c00241f466>] dm_dispatch_request+0x5a/0x94 [dm_mod]
[ 3081.573400]  [<000003c002421b0c>] dm_request_fn+0x1e4/0x208 [dm_mod]
[ 3081.573405]  [<00000000003a72c0>] blk_start_queue+0x68/0x9c
[ 3081.573407]  [<000003c00241eafe>] start_queue+0x4e/0x68 [dm_mod]
[ 3081.573411]  [<000003c002421cc2>] dm_resume+0xd2/0xfc [dm_mod]
[ 3081.573415]  [<000003c00242769e>] dev_suspend+0x1ca/0x250 [dm_mod]
[ 3081.573420]  [<000003c00242857a>] ctl_ioctl+0x1e2/0x2f4 [dm_mod]
[ 3081.573425]  [<000003c0024286b6>] dm_ctl_ioctl+0x2a/0x38 [dm_mod]
[ 3081.573429]  [<0000000000252d28>] do_vfs_ioctl+0x94/0x588
[ 3081.573432]  [<00000000002532b0>] SyS_ioctl+0x94/0xac
[ 3081.573434]  [<00000000005a789a>] sysc_noemu+0x16/0x1c
[ 3081.573438]  [<000003fffd33c7ca>] 0x3fffd33c7ca
[ 3081.573440] INFO: lockdep is turned off.
[ 3081.573441] Last Breaking-Event-Address:
[ 3081.573442]  [<00000000003a652e>] __elv_add_request+0x9e/0x254

Parts of the corresponding struct request queue:

  queue_flags = 76320,  /* == 0x12a20 --> QUEUE_FLAG_DEAD set */
  ...
  kobj = {
    name = 0x6c94f740 "queue", 
    entry = {
      next = 0x602bd0a0, 
      prev = 0x602bd0a0
    }, 
    parent = 0x0, 
    kset = 0x0, 
    ktype = 0x93fca8, 
    sd = 0x0, 
    kref = {
      refcount = {
        counter = 1
      }
    }, 
    state_initialized = 1, 
    state_in_sysfs = 0, 
    state_add_uevent_sent = 0, 
    state_remove_uevent_sent = 0, 
    uevent_suppress = 0
  }, 


In the meanwile the piece of memory got allocated and freed by the
zfcp driver (extended slub caller tracing):

Allocated:

000000000011bd3e save_stack_trace
0000000000229094 process_slab
00000000002292c4 alloc_debug_processing
000000000022a554 new_slab
000000000022b72a __kmalloc
00000000001e0b68 mempool_alloc
00000000004c2f7a zfcp_fsf_req_create
00000000004c4a52 zfcp_fsf_fcp_cmnd
00000000004c7618 zfcp_scsi_queuecommand
000000000042525a scsi_dispatch_cmd
000000000042cf58 scsi_request_fn
00000000003a733e blk_run_queue
000000000042aea6 scsi_run_queue
000000000042d3ea scsi_next_command
000000000042d608 scsi_io_completion
00000000003b0218 blk_done_softirq
000000000014c0f0 __do_softirq
000000000010e2ae do_softirq
000000000014c550 irq_exit
0000000000468998 do_IRQ
00000000005a7f3c io_return

Freed:

000000000011bd3e save_stack_trace
0000000000229094 process_slab
00000000002294f4 free_debug_processing
0000000000229888 __slab_free
0000000000229a36 kfree
00000000004c5482 zfcp_fsf_reqid_check
00000000004c63f2 zfcp_qdio_int_resp
000000000048219c qdio_kick_handler
000000000048448e __tiqdio_inbound_processing
000000000014b550 tasklet_action
000000000014c0f0 __do_softirq
000000000010e2ae do_softirq
000000000014c550 irq_exit
0000000000468998 do_IRQ
00000000005a7f3c io_return
0000000000190b3a generic_exec_single
0000000000169b1e kthread
00000000005a74d2 kernel_thread_starter
