From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/3] Separate zone requests from medium access requests
Date: Tue, 28 Feb 2017 19:25:32 +0900
Message-ID: <20170228102535.15966-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This series introduces blk_rq_accesses_medium(), which is equivalent to
!blk_rq_is_passthrough() minus the zone request operations REQ_OP_ZONE_REPORT
and REQ_OP_ZONE_RESET. This new helper allows avoiding problems due to the
non-standard nature of these commands (report zones does no operate on logical
block size units while reset zone operates on entire zones only).

Using blk_rq_accesses_medium(), patch 2 excludes the zone commands from
request accounting (these commands are not accessing the device medium).
Exclusion from request scheduling is also added.

Finally, patch 3 uses the blk_rq_accesses_medium() helper to fix improperly
unaligned resid values only and only for medium access commands. This
correctly excludes from the resid correction zone requests as well as
passthrough requests.

ALl 3 patches are originally from Bart.

Bart Van Assche (3):
  block: Introduce blk_rq_accesses_medium()
  block: Separate zone requests from medium access requests
  mpt3sas: Do not check resid for non medium access commands

 block/blk-core.c                     |  2 +-
 block/blk.h                          |  2 +-
 block/elevator.c                     | 12 ++++++++----
 block/mq-deadline.c                  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
 include/linux/blk_types.h            | 17 ++++++++++-------
 include/linux/blkdev.h               | 18 +++++++++++++++---
 7 files changed, 38 insertions(+), 19 deletions(-)

-- 
2.9.3
