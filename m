From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from
 fc_queuecommand
Date: Wed, 15 Sep 2010 10:31:17 -0700
Message-ID: <1284571877.30345.24.camel@vi2.jf.intel.com>
References: <20100903222715.6237.75737.stgit@localhost.localdomain>
	 <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0IORbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 13:31:19 -0400
In-Reply-To: <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

On Sun, 2010-09-12 at 18:37 +0200, Bart Van Assche wrote:
> On Sat, Sep 4, 2010 at 12:27 AM, Vasu Dev <vasu.dev@intel.com> wrote:
> >
> > Currently fc_queuecommand drops this lock very early on and then re-acquires
> > this lock just before return, this re-acquired lock gets dropped immediately
> > by its fast path caller scsi_dispatch_cmd, this re-acquire and then immediate
> > drop on each IO hits performance especially with small size IOs on multi-core
> > systems, this hit is significant about 25% with 512 bytes size IOs.
> >
> > This lock is not needed in fc_queuecommand and calling fc_queuecommand
> > without this lock held removes above described performance hit.
> >
> > So this patch adds unlocked_qcmds flag to drop host_lock before
> > calling only fc_queuecommand and removes re-acquire &  then drop
> > for  each IO. Added flag, drops this lock only if LLD wants such
> > as fcoe.ko does here for fc_queuecommand. This change won't affect
> > any existing LLD since added unlocked_qcmds flag will be zero
> > in those cases and their host lock uses would effectively remain
> > same after this patch.
> [ ... ]
> 
> Hello Vasu,
> 
> While I don't doubt that your patch improves performance, there might
> be more bottlenecks in the Linux storage stack than the SCSI host
> lock. 

Yes there are, upper blocks(scsi/block layer) of fcoe stack were still
highest hit in my perf profiling even after the unlocked_qcmds, as I
mentioned this unlocked_qcmds change helped with small IOs most and that
too at 10G host link and same was verified by our validation but
improving on more upper blocks of fcoe stack bottleneck should give
better perf for all IO sizes at various link speeds for various
transports.
 
> After having converted the SRP initiator (ib_srp) to use per-LUN
> locking instead of per-host locking and after having enabled

Per-lun locking looks good idea and should mitigate host lock
bottlenecks while lun is not simultaneously used by all host cores, may
be some use case would prevent that by limiting lun to VM on specific
core. Is this change already upstream or queued for upstream ? Is that
change going to eliminate host lock on fast path completely ?

> unlocked_qcmds, I noticed that the largest source of contention was in
> the block layer. There was ten times more contention on
> request_queue.queue_lock than on any other spinlock. As you can see
> below, the four most contended locks in the test I ran were:
> * request_queue.queue_lock, needed by __make_request() in blk-core.c.
> * srp_target_port.lock, the per-LUN lock in ib_srp.c.
> * The SCSI host lock.
> * An AIO lock.
> 
> The test I ran used libaio and the NOOP scheduler. Block merging was
> disabled via sysfs.
> 
> >From /proc/lock_stat:
> 
> lock_stat version 0.3
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    con-bounces    contentions
>   waittime-min   waittime-max waittime-total    acq-bounces
> acquisitions   holdtime-min   holdtime-max holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>               &(&q->__queue_lock)->rlock:      11093047       11093901
>           0.22           9.37    10163231.15       41697489
> 74851829           0.00          21.14    60656375.82
>               --------------------------
>               &(&q->__queue_lock)->rlock        2093562
> [<ffffffff811af406>] __make_request+0x56/0x500
>               &(&q->__queue_lock)->rlock              2
> [<ffffffff811bcd70>] cfq_get_queue+0xf0/0x2a0
>               &(&q->__queue_lock)->rlock              1
> [<ffffffff811bd3e4>] cfq_set_request+0x414/0x500
>               &(&q->__queue_lock)->rlock             36
> [<ffffffff811bd049>] cfq_set_request+0x79/0x500
>               --------------------------
>               &(&q->__queue_lock)->rlock             17
> [<ffffffff811bd049>] cfq_set_request+0x79/0x500
>               &(&q->__queue_lock)->rlock        1007349
> [<ffffffff811af406>] __make_request+0x56/0x500
>               &(&q->__queue_lock)->rlock        3036167
> [<ffffffff811af45f>] __make_request+0xaf/0x500
>               &(&q->__queue_lock)->rlock              1
> [<ffffffff811bcd70>] cfq_get_queue+0xf0/0x2a0
> 
> ...............................................................................................................................................................................................
> 
>                  &(&target->lock)->rlock:       1098815        1098945
>           0.21           3.67      317746.64       16107020
> 48401787           0.00          14.65    11997072.82
>                  -----------------------
>                  &(&target->lock)->rlock         220238
> [<ffffffffa04e1307>] __srp_get_tx_iu+0x47/0xd0 [ib_srp]
>                  &(&target->lock)->rlock         366255
> [<ffffffffa04e2ee0>] srp_queuecommand+0xb0/0xad0 [ib_srp]
>                  &(&target->lock)->rlock         297993
> [<ffffffffa04e25b6>] srp_remove_req+0x46/0x80 [ib_srp]
>                  &(&target->lock)->rlock         114850
> [<ffffffffa04e2ae2>] srp_handle_recv+0x182/0x420 [ib_srp]
>                  -----------------------
>                  &(&target->lock)->rlock         277148
> [<ffffffffa04e2ee0>] srp_queuecommand+0xb0/0xad0 [ib_srp]
>                  &(&target->lock)->rlock         142360
> [<ffffffffa04e2ae2>] srp_handle_recv+0x182/0x420 [ib_srp]
>                  &(&target->lock)->rlock         245220
> [<ffffffffa04e1307>] __srp_get_tx_iu+0x47/0xd0 [ib_srp]
>                  &(&target->lock)->rlock         266847
> [<ffffffffa04e25b6>] srp_remove_req+0x46/0x80 [ib_srp]
> 
> ...............................................................................................................................................................................................
> 
>               &(shost->host_lock)->rlock:        989776         989903
>           0.21           5.78      271707.74       20089204
> 38990409           0.00           7.07     9908160.13
>               --------------------------
>               &(shost->host_lock)->rlock         123198
> [<ffffffffa0037583>] scsi_request_fn+0x163/0x4d0 [scsi_mod]
>               &(shost->host_lock)->rlock         235047
> [<ffffffffa003036c>] scsi_dispatch_cmd+0x11c/0x3e0 [scsi_mod]
>               &(shost->host_lock)->rlock         389901
> [<ffffffffa00383cd>] scsi_device_unbusy+0x3d/0xd0 [scsi_mod]
>               &(shost->host_lock)->rlock         241762
> [<ffffffffa0036824>] scsi_run_queue+0x54/0x3d0 [scsi_mod]
>               --------------------------
>               &(shost->host_lock)->rlock         107827
> [<ffffffffa0037583>] scsi_request_fn+0x163/0x4d0 [scsi_mod]
>               &(shost->host_lock)->rlock          95756
> [<ffffffffa003036c>] scsi_dispatch_cmd+0x11c/0x3e0 [scsi_mod]
>               &(shost->host_lock)->rlock         316122
> [<ffffffffa0036824>] scsi_run_queue+0x54/0x3d0 [scsi_mod]
>               &(shost->host_lock)->rlock         470203
> [<ffffffffa00383cd>] scsi_device_unbusy+0x3d/0xd0 [scsi_mod]
> 
> ...............................................................................................................................................................................................
> 
>                 &(&ctx->ctx_lock)->rlock:        399855         399868
>           0.22           4.22      143530.86        7351017
> 50104676           0.00           8.92    14706301.05
>                 ------------------------
>                 &(&ctx->ctx_lock)->rlock         194753
> [<ffffffff81158805>] aio_complete+0x45/0x260
>                 &(&ctx->ctx_lock)->rlock          67287
> [<ffffffff81159434>] do_io_submit+0x214/0x7b0
>                 &(&ctx->ctx_lock)->rlock          56529
> [<ffffffff81157da5>] __aio_get_req+0x95/0x1a0
>                 &(&ctx->ctx_lock)->rlock          54461
> [<ffffffff8115785d>] aio_put_req+0x2d/0x60
>                 ------------------------
>                 &(&ctx->ctx_lock)->rlock         205740
> [<ffffffff81158805>] aio_complete+0x45/0x260
>                 &(&ctx->ctx_lock)->rlock         125933
> [<ffffffff8115785d>] aio_put_req+0x2d/0x60
>                 &(&ctx->ctx_lock)->rlock          37042
> [<ffffffff81157da5>] __aio_get_req+0x95/0x1a0
>                 &(&ctx->ctx_lock)->rlock          29197
> [<ffffffff81159434>] do_io_submit+0x214/0x7b0
> 
> ...............................................................................................................................................................................................

May be block layer experts working on improving these code paths and I
don't know much about that part and any case this all goes beyond what I
was trying to accomplish with simple unlocked_qcmds change.

	Thanks
	Vasu

