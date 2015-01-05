From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 5 Jan 2015 10:15:16 +0100
Message-ID: <20150105091516.GA22226@lst.de>
References: <54A43CFB.2080705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54138 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbbAEJPV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 04:15:21 -0500
Content-Disposition: inline
In-Reply-To: <54A43CFB.2080705@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: hch@lst.de, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>

On Wed, Dec 31, 2014 at 01:14:19PM -0500, Sasha Levin wrote:
> Hi Christoph,
> 
> I'm seeing an issue which was bisected down to 3c356bde1 ("scsi: stop passing
> a gfp_mask argument down the command setup path"):

->queue_rq in blk-mq context is designed to be able to sleep and be called
from process context without any spinlocks held or irqs disabled, so we
really should fix the
caller instead.

That being said your trace seems odd to me:

> [ 3395.328221] BUG: sleeping function called from invalid context at mm/mempool.c:206
> [ 3395.329540] in_atomic(): 1, irqs_disabled(): 0, pid: 6399, name: trinity-c531
> [ 3395.331104] no locks held by trinity-c531/6399.
> [ 3395.331849] Preemption disabled blk_execute_rq_nowait (block/blk-exec.c:95)

blk_execute_rq_nowait only takes a lock for the non-blk-mq case.  In my
current kernel that's in line 79, but can you verify that for you
line 95 is the spin_lock_irq in the !q->mq_ops case?

> [ 3395.348571] __might_sleep (kernel/sched/core.c:7308)
> [ 3395.351944] mempool_alloc (mm/mempool.c:206 (discriminator 1))
> [ 3395.355196] scsi_sg_alloc (drivers/scsi/scsi_lib.c:582)
> [ 3395.356893] __sg_alloc_table (lib/scatterlist.c:282)
> [ 3395.358844] ? sdev_disable_disk_events (drivers/scsi/scsi_lib.c:577)
> [ 3395.360873] scsi_alloc_sgtable (drivers/scsi/scsi_lib.c:608)
> [ 3395.362769] scsi_init_sgtable (drivers/scsi/scsi_lib.c:1087)
> [ 3395.364583] ? lockdep_init_map (kernel/locking/lockdep.c:2986)
> [ 3395.366354] scsi_init_io (drivers/scsi/scsi_lib.c:1122)
> [ 3395.368092] ? do_init_timer (kernel/time/timer.c:669)
> [ 3395.369837] scsi_setup_cmnd (drivers/scsi/scsi_lib.c:1220 drivers/scsi/scsi_lib.c:1268)
> [ 3395.371743] scsi_queue_rq (drivers/scsi/scsi_lib.c:1875 drivers/scsi/scsi_lib.c:1980)
> [ 3395.373471] __blk_mq_run_hw_queue (block/blk-mq.c:751)
> [ 3395.375481] blk_mq_run_hw_queue (block/blk-mq.c:831)
> [ 3395.377324] blk_mq_insert_request (block/blk-mq.h:92 block/blk-mq.c:974)
> [ 3395.379377] ? blk_rq_map_user (block/blk-map.c:78 block/blk-map.c:142)
> [ 3395.381307] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
> [ 3395.383485] blk_execute_rq_nowait (block/blk-exec.c:95)

But this clearly is the blk-mq case.  How does your version of
blk_execute_rq_nowait look like?

