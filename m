From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 0/10] block/scsi: safe SCSI quiescing
Date: Tue, 19 Sep 2017 11:49:15 +0800
Message-ID: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
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

This patch introduces preempt freeze, and solves the issue
by preempt freezing block queue during SCSI quiesce, and allows
to allocate request of RQF_PREEMPT when queue is in this state.

Oleksandr verified that V4 does fix the hang during suspend/resume,
and Cathy verified that V4 fixes hang in sending SCSI domain validation
wrt. transport_spi.

Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
them all by introducing/unifying blk_freeze_queue_preempt() and
blk_unfreeze_queue_preempt(), and cleanup is done together.

The patchset can be found in the following gitweb:

	https://github.com/ming1/linux/tree/blk_safe_scsi_quiesce_V5

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

Ming Lei (10):
  blk-mq: only run hw queues for blk-mq
  block: tracking request allocation with q_usage_counter
  blk-mq: rename blk_mq_[freeze|unfreeze]_queue
  blk-mq: rename blk_mq_freeze_queue_wait as blk_freeze_queue_wait
  block: rename .mq_freeze_wq and .mq_freeze_depth
  block: pass flags to blk_queue_enter()
  block: introduce preempt version of blk_[freeze|unfreeze]_queue
  block: allow to allocate req with RQF_PREEMPT when queue is preempt
    frozen
  SCSI: transport_spi: resume a quiesced device
  SCSI: preempt freeze block queue when SCSI device is put into quiesce

 block/bfq-iosched.c               |   2 +-
 block/blk-cgroup.c                |   8 +-
 block/blk-core.c                  |  80 +++++++++++++----
 block/blk-mq.c                    | 180 ++++++++++++++++++++++++++++----------
 block/blk-mq.h                    |   1 -
 block/blk-timeout.c               |   2 +-
 block/blk.h                       |  25 ++++++
 block/elevator.c                  |   4 +-
 drivers/block/loop.c              |  24 ++---
 drivers/block/rbd.c               |   2 +-
 drivers/nvme/host/core.c          |   8 +-
 drivers/scsi/scsi_lib.c           |  25 +++++-
 drivers/scsi/scsi_transport_spi.c |   3 +
 fs/block_dev.c                    |   4 +-
 include/linux/blk-mq.h            |  15 ++--
 include/linux/blkdev.h            |  32 +++++--
 16 files changed, 311 insertions(+), 104 deletions(-)

-- 
2.9.5
