From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/41] block/loop: queue ordered mode should be DRAIN_FLUSH
Date: Fri,  3 Sep 2010 12:29:17 +0200
Message-ID: <1283509796-1510-3-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.co
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

loop implements FLUSH using fsync but was incorrectly setting its
ordered mode to DRAIN.  Change it to DRAIN_FLUSH.  In practice, this
doesn't change anything as loop doesn't make use of the block layer
ordered implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f3c636d..c3a4a2e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -832,7 +832,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->lo_queue->unplug_fn = loop_unplug;
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN_FLUSH);
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
-- 
1.7.1

