From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/6] blk-mq: fix & improve queue quiescing
Date: Fri, 26 May 2017 11:07:33 +0800
Message-ID: <20170526030740.26959-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758864AbdEZDHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 May 2017 23:07:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi,

There are some issues in current blk_mq_quiesce_queue():
    - in case of direct issue or BLK_MQ_S_START_ON_RUN, dispatch won't
    can't be prevented after blk_mq_quiesce_queue() is returned.
    - in theory, new RCU read-side critical sections may begin while
    synchronize_rcu() was waiting, and end after returning of
    synchronize_rcu(), then dispatch still may be run after
    synchronize_rcu() returns..

It is observed that request double-free/use-after-free
can be triggered easily when canceling NVMe requests via
blk_mq_tagset_busy_iter(...nvme_cancel_request) in nvme_dev_disable().
The reason is that blk_mq_quiesce_queue() can't prevent
dispatching from being run during the period.

Actually we have to quiesce queue for canceling dispatched
requests via blk_mq_tagset_busy_iter(), otherwise use-after-free
can be made easily. This way of canceling dispatched requests
has been used in several drivers, only NVMe uses blk_mq_quiesce_queue()
to avoid the issue, and others need to be fixed too. And it
is a common case for recovering dead controller.

blk_mq_quiesce_queue() is implemented via stopping queue, which
limits its uses, and easy to casue race, any start queue is other
paths may break blk_mq_quiesce_queue(). For example, we sometimes
stops queue when hw can't handle so many ongoing requests and restart
queues after srequests are completed. Meantime when we want to cancel
requests if hardware is dead, quiescing is run first, then the restarting
in complete path can break the quiescing. This patch improves this
interface via removing stopping queue, then it can be easier to use.
 
Thanks,
Ming

Ming Lei (6):
  blk-mq: introduce blk_mq_unquiesce_queue
  blk-mq: use the introduced blk_mq_unquiesce_queue()
  blk-mq: fix blk_mq_quiesce_queue
  blk-mq: update comments on blk_mq_quiesce_queue()
  blk-mq: don't stop queue for quiescing
  blk-mq: clarify dispatching won't be blocked by stopping queue

 block/blk-mq.c           | 67 +++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/dm-rq.c       |  2 +-
 drivers/nvme/host/core.c |  2 +-
 drivers/scsi/scsi_lib.c  |  5 +++-
 include/linux/blkdev.h   |  3 +++
 5 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.9.4
