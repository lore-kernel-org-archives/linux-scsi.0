From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/15] block copy: use merge_bvec_fn for copies
Date: Tue, 15 Jul 2014 15:37:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151536470.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We use merge_bvec_fn to make sure that copies do not split internal
boundaries of device mapper devices.

There is no possibility to split a copy bio (splitting would complicate
the design significantly), so we must use merge_bvec_fn to make sure that
the bios have appropriate size for the device mapper stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

Index: linux-3.16-rc5/block/blk-lib.c
===================================================================
--- linux-3.16-rc5.orig/block/blk-lib.c	2014-07-15 15:27:51.000000000 +0200
+++ linux-3.16-rc5/block/blk-lib.c	2014-07-15 15:27:59.000000000 +0200
@@ -369,6 +369,31 @@ static void bio_copy_end_io(struct bio *
 	}
 }
 
+static unsigned blkdev_copy_merge(struct block_device *bdev,
+				  struct request_queue *q, unsigned long bi_rw,
+				  sector_t sector, unsigned n)
+{
+	if (!q->merge_bvec_fn) {
+		return n;
+	} else {
+		unsigned m;
+		struct bvec_merge_data bvm = {
+			.bi_bdev = bdev,
+			.bi_sector = sector,
+			.bi_size = 0,
+			.bi_rw = bi_rw,
+		};
+		struct bio_vec vec = {
+			.bv_page = NULL,
+			.bv_len = likely(n <= UINT_MAX >> 9) ? n << 9 : UINT_MAX & ~511U,
+			.bv_offset = 0,
+		};
+		m = q->merge_bvec_fn(q, &bvm, &vec);
+		m >>= 9;
+		return min(m, n);
+	}
+}
+
 /**
  * blkdev_issue_copy - queue a copy same operation
  * @src_bdev:	source blockdev
@@ -424,6 +449,18 @@ int blkdev_issue_copy(struct block_devic
 		struct bio_copy *bc;
 		unsigned chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
 
+		chunk = blkdev_copy_merge(src_bdev, sq, READ | REQ_COPY, src_sector, chunk);
+		if (!chunk) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		chunk = blkdev_copy_merge(dst_bdev, dq, WRITE | REQ_COPY, dst_sector, chunk);
+		if (!chunk) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
 			ret = -ENOMEM;
