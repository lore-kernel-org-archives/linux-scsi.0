From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/15] block copy: use a timer to fix a theoretical deadlock
Date: Thu, 10 Dec 2015 12:30:20 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101209070.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The block layer creates two bios for each copy operation. The bios travel
independently through the storage stack and they are paired at the block
device.

There is a theoretical problem with this - the block device stack only
guarantees forward progress for a single bio. When two bios are sent, it
is possible (though very unlikely) that the first bio exhausts some
mempool and the second bio waits until there is free space in the mempool
(and thus it waits until the first bio finishes).

To avoid this deadlock, we introduce a timer. If the two bios are not
paired at the physical block device within 10 seconds, the copy operation
is aborted and the bio that waits to be paired is released with an error.

Note that there is no guarantee that any XCOPY operation succeed, so
aborting an operation with an error shouldn't cause any problems - the
caller is supposed to perform the copy manually if XCOPY fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c           |   31 +++++++++++++++++++++++++++++++
 include/linux/blk_types.h |    2 ++
 2 files changed, 33 insertions(+)

Index: linux-4.3/block/blk-lib.c
===================================================================
--- linux-4.3.orig/block/blk-lib.c	2015-11-02 18:43:06.000000000 +0100
+++ linux-4.3/block/blk-lib.c	2015-11-02 18:43:10.000000000 +0100
@@ -300,6 +300,34 @@ int blkdev_issue_zeroout(struct block_de
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
 
+#define BLK_COPY_TIMEOUT	(10 * HZ)
+
+static void blk_copy_timeout(unsigned long bc_)
+{
+	struct bio_copy *bc = (struct bio_copy *)bc_;
+	struct bio *bio0 = NULL, *bio1 = NULL;
+
+	WARN_ON(!irqs_disabled());
+
+	spin_lock(&bc->spinlock);	/* the timer is IRQSAFE */
+	if (bc->error == 1) {
+		bc->error = -ETIMEDOUT;
+		bio0 = bc->pair[0];
+		bio1 = bc->pair[1];
+		bc->pair[0] = bc->pair[1] = NULL;
+	}
+	spin_unlock(&bc->spinlock);
+
+	if (bio0) {
+		bio0->bi_error = -ETIMEDOUT;
+		bio_endio(bio0);
+	}
+	if (bio1) {
+		bio1->bi_error = -ETIMEDOUT;
+		bio_endio(bio1);
+	}
+}
+
 static void bio_copy_end_io(struct bio *bio)
 {
 	struct bio_copy *bc = bio->bi_copy;
@@ -335,6 +363,7 @@ static void bio_copy_end_io(struct bio *
 			} while (unlikely(atomic64_cmpxchg(bc->first_error,
 				first_error, bc->offset) != first_error));
 		}
+		del_timer_sync(&bc->timer);
 		kfree(bc);
 		if (atomic_dec_and_test(&bb->done))
 			complete(bb->wait);
@@ -425,6 +454,8 @@ int blkdev_issue_copy(struct block_devic
 		bc->first_error = &first_error;
 		bc->offset = offset;
 		spin_lock_init(&bc->spinlock);
+		__setup_timer(&bc->timer, blk_copy_timeout, (unsigned long)bc, TIMER_IRQSAFE);
+		mod_timer(&bc->timer, jiffies + BLK_COPY_TIMEOUT);
 
 		read_bio->bi_iter.bi_sector = src_sector;
 		read_bio->bi_iter.bi_size = chunk << 9;
Index: linux-4.3/include/linux/blk_types.h
===================================================================
--- linux-4.3.orig/include/linux/blk_types.h	2015-11-02 18:43:06.000000000 +0100
+++ linux-4.3/include/linux/blk_types.h	2015-11-02 18:43:10.000000000 +0100
@@ -6,6 +6,7 @@
 #define __LINUX_BLK_TYPES_H
 
 #include <linux/types.h>
+#include <linux/timer.h>
 
 struct bio_set;
 struct bio;
@@ -52,6 +53,7 @@ struct bio_copy {
 	atomic64_t *first_error;
 	sector_t offset;
 	spinlock_t spinlock;
+	struct timer_list timer;
 };
 
 /*
