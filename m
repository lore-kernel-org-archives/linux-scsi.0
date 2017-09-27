From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 0/6] block/scsi: safe SCSI quiescing
Date: Wed, 27 Sep 2017 13:48:47 +0800
Message-ID: <20170927054853.6647-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.

Once SCSI device is put into QUIESCE, no new request except for
RQF_PREEMPT can be dispatched to SCSI successfully, and
scsi_device_quiesce() just simply waits for completion of I/Os
dispatched to SCSI stack. It isn't enough at all.

Because new request still can be comming, but all the allocated
requests can't be dispatched successfully, so request pool can be
consumed up easily.

Then request with RQF_PREEMPT can't be allocated and wait forever,
meantime scsi_device_resume() waits for completion of RQF_PREEMPT,
then system hangs forever, such as during system suspend or
sending SCSI domain alidation.

Both IO hang inside system suspend[1] or SCSI domain validation
were reported before.

This patch introduces preempt only mode, and solves the issue
by allowing RQF_PREEMP only during SCSI quiesce.

Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
them all.

V6:
	- borrow Bart's idea of preempt only, with clean
	  implementation(patch 5/patch 6)
	- needn't any external driver's dependency, such as MD's
	change

V5:
	- fix one tiny race by introducing blk_queue_enter_preempt_freeze()
	given this change is small enough compared with V4, I added
	tested-by directly

V4:
	- reorganize patch order to make it more reasonable
	- support nested preempt freeze, as required by SCSI transport spi
	- check preempt freezing in slow path of of blk_queue_enter()
	- add "SCSI: transport_spi: resume a quiesced device"
	- wake up freeze queue in setting dying for both blk-mq and legacy
	- rename blk_mq_[freeze|unfreeze]_queue() in one patch
	- rename .mq_freeze_wq and .mq_freeze_depth
	- improve comment

V3:
	- introduce q->preempt_unfreezing to fix one bug of preempt freeze
	- call blk_queue_enter_live() only when queue is preempt frozen
	- cleanup a bit on the implementation of preempt freeze
	- only patch 6 and 7 are changed

V2:
	- drop the 1st patch in V1 because percpu_ref_is_dying() is
	enough as pointed by Tejun
	- introduce preempt version of blk_[freeze|unfreeze]_queue
	- sync between preempt freeze and normal freeze
	- fix warning from percpu-refcount as reported by Oleksandr


[1] https://marc.info/?t=150340250100013&r=3&w=2


Thanks,
Ming

Ming Lei (6):
  blk-mq: only run hw queues for blk-mq
  block: tracking request allocation with q_usage_counter
  block: pass flags to blk_queue_enter()
  block: prepare for passing RQF_PREEMPT to request allocation
  block: support PREEMPT_ONLY
  SCSI: set block queue at preempt only when SCSI device is put into
    quiesce

 block/blk-core.c        | 62 ++++++++++++++++++++++++++++++++++++++-----------
 block/blk-mq.c          | 14 ++++-------
 block/blk-timeout.c     |  2 +-
 drivers/scsi/scsi_lib.c | 25 +++++++++++++++++---
 fs/block_dev.c          |  4 ++--
 include/linux/blk-mq.h  |  7 +++---
 include/linux/blkdev.h  | 27 ++++++++++++++++++---
 7 files changed, 106 insertions(+), 35 deletions(-)

-- 
2.9.5
