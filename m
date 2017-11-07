From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH V8 0/8] block/scsi: safe SCSI quiescing
Date: Tue, 07 Nov 2017 13:32:44 +0100
Message-ID: <96969c080934c2d12f8ef787da89cd1c@natalenko.name>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming, Jens.

What is the fate of this patchset please?

03.10.2017 16:03, Ming Lei wrote:
> Hi Jens,
> 
> Please consider this patchset for V4.15, and it fixes one
> kind of long-term I/O hang issue in either block legacy path
> or blk-mq.
> 
> The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.
> 
> Once SCSI device is put into QUIESCE, no new request except for
> RQF_PREEMPT can be dispatched to SCSI successfully, and
> scsi_device_quiesce() just simply waits for completion of I/Os
> dispatched to SCSI stack. It isn't enough at all.
> 
> Because new request still can be comming, but all the allocated
> requests can't be dispatched successfully, so request pool can be
> consumed up easily.
> 
> Then request with RQF_PREEMPT can't be allocated and wait forever,
> then system hangs forever, such as during system suspend or
> sending SCSI domain alidation in case of transport_spi.
> 
> Both IO hang inside system suspend[1] or SCSI domain validation
> were reported before.
> 
> This patch introduces preempt only mode, and solves the issue
> by allowing RQF_PREEMP only during SCSI quiesce.
> 
> Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> them all.
> 
> V8:
> 	- fix one race as pointed out by Bart
> 	- pass 'op' to blk_queue_enter() as suggested by Christoph
> 
> V7:
> 	- add Reviewed-by & Tested-by
> 	- one line change in patch 5 for checking preempt request
> 
> V6:
> 	- borrow Bart's idea of preempt only, with clean
> 	  implementation(patch 5/patch 6)
> 	- needn't any external driver's dependency, such as MD's
> 	change
> 
> V5:
> 	- fix one tiny race by introducing blk_queue_enter_preempt_freeze()
> 	given this change is small enough compared with V4, I added
> 	tested-by directly
> 
> V4:
> 	- reorganize patch order to make it more reasonable
> 	- support nested preempt freeze, as required by SCSI transport spi
> 	- check preempt freezing in slow path of of blk_queue_enter()
> 	- add "SCSI: transport_spi: resume a quiesced device"
> 	- wake up freeze queue in setting dying for both blk-mq and legacy
> 	- rename blk_mq_[freeze|unfreeze]_queue() in one patch
> 	- rename .mq_freeze_wq and .mq_freeze_depth
> 	- improve comment
> 
> V3:
> 	- introduce q->preempt_unfreezing to fix one bug of preempt freeze
> 	- call blk_queue_enter_live() only when queue is preempt frozen
> 	- cleanup a bit on the implementation of preempt freeze
> 	- only patch 6 and 7 are changed
> 
> V2:
> 	- drop the 1st patch in V1 because percpu_ref_is_dying() is
> 	enough as pointed by Tejun
> 	- introduce preempt version of blk_[freeze|unfreeze]_queue
> 	- sync between preempt freeze and normal freeze
> 	- fix warning from percpu-refcount as reported by Oleksandr
> 
> 
> [1] https://marc.info/?t=150340250100013&r=3&w=2
> 
> 
> Thanks,
> Ming
> 
> Bart Van Assche (1):
>   block: Convert RQF_PREEMPT into REQ_PREEMPT
> 
> Ming Lei (7):
>   blk-mq: only run hw queues for blk-mq
>   block: tracking request allocation with q_usage_counter
>   block: pass 'op' to blk_queue_enter()
>   percpu-refcount: introduce __percpu_ref_tryget_live
>   blk-mq: return if queue is frozen via current blk_freeze_queue_start
>   block: support PREEMPT_ONLY
>   SCSI: set block queue at preempt only when SCSI device is put into
>     quiesce
> 
>  block/blk-core.c                | 66 
> +++++++++++++++++++++++++++++++++++++----
>  block/blk-mq-debugfs.c          |  2 +-
>  block/blk-mq.c                  | 26 ++++++++--------
>  block/blk-mq.h                  |  1 -
>  block/blk-timeout.c             |  2 +-
>  block/blk.h                     |  2 +-
>  drivers/ide/ide-atapi.c         |  3 +-
>  drivers/ide/ide-io.c            |  2 +-
>  drivers/ide/ide-pm.c            |  4 +--
>  drivers/scsi/scsi_lib.c         | 31 +++++++++++++++----
>  fs/block_dev.c                  |  4 +--
>  include/linux/blk-mq.h          |  4 +--
>  include/linux/blk_types.h       |  6 ++++
>  include/linux/blkdev.h          | 10 ++++---
>  include/linux/percpu-refcount.h | 27 ++++++++++-------
>  15 files changed, 137 insertions(+), 53 deletions(-)
