From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/30] block/loop: queue ordered mode should be
	DRAIN_FLUSH
Date: Wed, 25 Aug 2010 17:47:19 +0200
Message-ID: <1282751267-3530-3-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
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
