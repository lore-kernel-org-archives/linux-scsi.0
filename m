From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Wed, 20 Jun 2018 21:22:39 +0800
Message-ID: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear all

scsi timeout and error handler are based on an assumption that normal
completion mustn't do anything on an timeout request. After 12f5b931
(blk-mq: Remove generation seqeunce), we lost this. __blk_mq_complete
request could ensure a request won't be completed twice, but it can
still complete a timeout request.
scsi (even other drivers) have been working on this assumption for many
years, it is dangerous to discard it suddenly. This patch set is to regain this.

1st patch
 - introduce blk_mq_mark_rq_complete in blk_mq_check_expired and blk_mq_complete_request
   to avoid the race between them.
 - blk_mq_complete_request cannot complete a timeout request anymore, so have to export
   __blk_mq_complete_request for LLDD timeout path
2nd ~ 5th patches
  replace the blk_mq_complete_request to __blk_mq_complete_request.

Jianchao Wang(5)
blk-mq: prevent normal completion from entering a timeout request
nbd: use __blk_mq_complete_request in timeout path
null_blk: use __blk_mq_complete_request in timeout path
mmc: use __blk_mq_complete_request in timeout path
nvme: use __blk_mq_complete_request in timeout path

 block/blk-mq.c             | 22 +++++++++++++++-------
 drivers/block/nbd.c        |  2 +-
 drivers/block/null_blk.c   |  2 +-
 drivers/mmc/core/queue.c   |  2 +-
 drivers/nvme/host/pci.c    |  8 ++++++++
 drivers/nvme/host/rdma.c   |  1 +
 drivers/nvme/target/loop.c |  1 +
 include/linux/blk-mq.h     |  1 +
 include/linux/blkdev.h     |  6 ++++++

Thanks
Jianchao
