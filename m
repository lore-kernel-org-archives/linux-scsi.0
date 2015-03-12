From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/7] dm: add full blk-mq support to request-based DM
Date: Wed, 11 Mar 2015 23:56:35 -0400
Message-ID: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patchset updates request-based DM (used exclussively by DM
multipath) to support blk-mq I/O path or the old ->request_fn I/O
path -- the default is still the old ->request_fn I/O path.

Like was done for SCSI, I've exposed a dm-mod.ko 'use_blk_mq' module
parameter and a CONFIG_DM_MQ_DEFAULT.  I've queued these patches in
linux-next via linux-dm.git's 'for-next' branch -- my goal is for
these changes to land upstream in 4.1.

I've tested all 4 supported permutations of rq-based queue stacking:
1) blk-mq mpath stacked on blk-mq device(s)
2) blk-mq mpath stacked on ->request_fn device(s)
3) old ->request_fn mpath stacked on blk-mq device(s)
4) old ->request_fn mpath stacked on old ->request_fn device(s)

There is definitely much more room for optimizing the blk-mq mpath
queue (via dm_mq_ops setup) to have more awareness about the
characteristics of the underlying blk-mq device(s) -- Jens offered
some suggestions that are worth pursuing.  Goal being to leverage the
ability to have multiple software submission queues that map to the
underlying paths' HW queue.  I expect Keith to be the most likely
person to pursue these follow-on optimizations given his immediate
access to NVMe devices, etc.

blk-mq allows for the removal of 2 of the 3 mempools and associated
allocations that were traditionally performed using old ->request_fn
I/O path.  The md->bs bioset still remains for cloning a request's
bios.

I'll be pursuing the possibility of removing the bio cloning that
happens when cloning a request (it was put in place for partial
completion of a request's bios but the prospect of avoiding those bio
clones warrants further review of how useful those partial completions
are, see: http://www.redhat.com/archives/dm-devel/2014-June/msg00030.html)

Jens and Keith, special thanks for your help answering more blk-mq
questions than I'd have hoped would be needed while at LSF/MM.

Keith Busch (1):
  blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set

Mike Snitzer (6):
  blk-mq: fix use of incorrect goto label in blk_mq_init_queue error path
  blk-mq: add blk_mq_init_allocated_queue and export blk_mq_register_disk
  blk-mq: export blk_mq_run_hw_queues
  dm: add full blk-mq support to request-based DM
  dm: optimize dm_mq_queue_rq to _not_ use kthread if using pure blk-mq
  dm: add 'use_blk_mq' module param and expose in per-device ro sysfs attr

 block/blk-mq-sysfs.c   |   1 +
 block/blk-mq.c         |  47 ++++--
 drivers/md/Kconfig     |  11 ++
 drivers/md/dm-mpath.c  |   4 +-
 drivers/md/dm-sysfs.c  |   9 ++
 drivers/md/dm-table.c  |  17 +-
 drivers/md/dm.c        | 414 +++++++++++++++++++++++++++++++++++++++----------
 drivers/md/dm.h        |   5 +-
 include/linux/blk-mq.h |   3 +
 9 files changed, 401 insertions(+), 110 deletions(-)

-- 
1.9.5 (Apple Git-50.3)
