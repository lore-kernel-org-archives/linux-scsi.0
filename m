From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] block/SCSI MQ: two RESTART related patches
Date: Tue, 17 Oct 2017 13:04:16 +0800
Message-ID: <20171017050418.22555-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

The 1st patch runs idle hctx after dealy in scsi_mq_get_budget(),
so that we can keep same behaviour with before, and it can be
thought as a fix.

The 2nd patch cleans up RESTART, and removes handling for TAG_SHARED
from current blk-mq's RESTART mechanism because SCSI_MQ can covers its
restart by itself, so that no need to handle TAG_SHARED in blk-mq
RESTART. And >20% IOPS boost is observed in my rand read test over
scsi_debug.

John, please test this two patches and see if it may improve your SAS
IO performance, and you can find the two patches in the following branch:

	https://github.com/ming1/linux/commits/blk_mq_improve_restart_V1


Ming Lei (2):
  SCSI: run idle hctx after delay in scsi_mq_get_budget()
  blk-mq: don't handle TAG_SHARED in restart

 block/blk-mq-sched.c    | 78 +++----------------------------------------------
 drivers/scsi/scsi_lib.c | 13 +++++++--
 2 files changed, 14 insertions(+), 77 deletions(-)

-- 
2.9.5
