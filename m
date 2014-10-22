From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 14/18] dm stripe: support copy
Date: Wed, 22 Oct 2014 09:32:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220931460.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Support the copy operation for the stripe target.

In stripe_merge, we verify that the underlying device supports copy. If it
doesn't, we can fail fast without any bio being contructed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-3.16-rc4/drivers/md/dm-stripe.c
===================================================================
--- linux-3.16-rc4.orig/drivers/md/dm-stripe.c	2014-07-11 22:20:25.000000000 +0200
+++ linux-3.16-rc4/drivers/md/dm-stripe.c	2014-07-11 22:23:54.000000000 +0200
@@ -165,6 +165,7 @@ static int stripe_ctr(struct dm_target *
 	ti->num_flush_bios = stripes;
 	ti->num_discard_bios = stripes;
 	ti->num_write_same_bios = stripes;
+	ti->copy_supported = 1;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
@@ -416,11 +417,19 @@ static int stripe_merge(struct dm_target
 	struct stripe_c *sc = ti->private;
 	sector_t bvm_sector = bvm->bi_sector;
 	uint32_t stripe;
+	struct block_device *bdev;
 	struct request_queue *q;
 
 	stripe_map_sector(sc, bvm_sector, &stripe, &bvm_sector);
 
-	q = bdev_get_queue(sc->stripe[stripe].dev->bdev);
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	if (unlikely((bvm->bi_rw & REQ_COPY) != 0)) {
+		if (!bdev_copy_offload(bdev))
+			return 0;
+	}
+
+	q = bdev_get_queue(bdev);
 	if (!q->merge_bvec_fn)
 		return max_size;
 
