From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/15] dm stripe: support copy
Date: Tue, 15 Jul 2014 15:41:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151541020.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbaGOTlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2014 15:41:55 -0400
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

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
 

