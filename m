From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V5 14/14] block: do not set mq default scheduler
Date: Mon, 25 Sep 2017 15:14:54 +0900
Message-ID: <20170925061454.5533-15-damien.lemoal@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925061454.5533-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

For blk-mq disks with a single hardware queue, setting by default the
disk scheduler to mq-deadline early during the queue initialization
prevents properly setting zone write locking for host managed zoned
block device as the disk type is not yet known.

Fix this by simply not setting the default scheduler to mq-deadline for
single hardware queue disks. A udev rule can be used to easily do the
same later in the system initialization sequence, when the device
characteristics are known.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/elevator.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 153926a90901..8b65a757f726 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -222,19 +222,14 @@ int elevator_init(struct request_queue *q, char *name)
 
 	if (!e) {
 		/*
-		 * For blk-mq devices, we default to using mq-deadline,
-		 * if available, for single queue devices. If deadline
-		 * isn't available OR we have multiple queues, default
-		 * to "none".
+		 * For blk-mq devices, default to "none". udev can later set
+		 * an appropriate default scheduler based on the disk
+		 * characteristics which we do not yet have here.
 		 */
-		if (q->mq_ops) {
-			if (q->nr_hw_queues == 1)
-				e = elevator_get("mq-deadline", false);
-			if (!e)
-				return 0;
-		} else
-			e = elevator_get(CONFIG_DEFAULT_IOSCHED, false);
+		if (q->mq_ops)
+			return 0;
 
+		e = elevator_get(CONFIG_DEFAULT_IOSCHED, false);
 		if (!e) {
 			printk(KERN_ERR
 				"Default I/O scheduler not found. " \
-- 
2.13.5
