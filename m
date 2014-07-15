From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 8/15] dm: introduce dm_ask_for_duplicate_bios
Date: Tue, 15 Jul 2014 15:39:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151539230.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbaGOTkW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2014 15:40:22 -0400
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

[ this isn't connected to XCOPY, but it is requires for the following
device mapper patches to apply cleanly ]

This function can be used if the target needs to receive another duplicate
of the current bio.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |   24 +++++++++++++++++++-----
 include/linux/device-mapper.h |    2 ++
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-3.16-rc5/drivers/md/dm.c
===================================================================
--- linux-3.16-rc5.orig/drivers/md/dm.c	2014-07-14 16:25:29.000000000 +0200
+++ linux-3.16-rc5/drivers/md/dm.c	2014-07-14 16:25:31.000000000 +0200
@@ -1161,9 +1161,9 @@ EXPORT_SYMBOL_GPL(dm_set_target_max_io_l
  *	 to make it empty)
  * The target requires that region 3 is to be sent in the next bio.
  *
- * If the target wants to receive multiple copies of the bio (via num_*bios, etc),
- * the partially processed part (the sum of regions 1+2) must be the same for all
- * copies of the bio.
+ * If the target wants to receive multiple copies of the bio with num_*_bios or
+ * dm_ask_for_duplicate_bio, the partially processed part (the sum of regions
+ * 1+2) must be the same for all copies of the bio.
  */
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
@@ -1177,6 +1177,17 @@ void dm_accept_partial_bio(struct bio *b
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+/*
+ * The target driver can call this function only from the map routine. The
+ * target driver requests that the dm sends more duplicates of the current bio.
+ */
+void dm_ask_for_duplicate_bios(struct bio *bio, unsigned n_duplicates)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	(*tio->num_bios) += n_duplicates;
+}
+EXPORT_SYMBOL_GPL(dm_ask_for_duplicate_bios);
+
 static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
@@ -1267,12 +1278,14 @@ static struct dm_target_io *alloc_tio(st
 
 static void __clone_and_map_simple_bio(struct clone_info *ci,
 				       struct dm_target *ti,
-				       unsigned target_bio_nr, unsigned *len)
+				       unsigned target_bio_nr, unsigned *len,
+				       unsigned *num_bios)
 {
 	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs, target_bio_nr);
 	struct bio *clone = &tio->clone;
 
 	tio->len_ptr = len;
+	tio->num_bios = num_bios;
 
 	/*
 	 * Discard requests require the bio's inline iovecs be initialized.
@@ -1292,7 +1305,7 @@ static void __send_duplicate_bios(struct
 	unsigned target_bio_nr;
 
 	for (target_bio_nr = 0; target_bio_nr < num_bios; target_bio_nr++)
-		__clone_and_map_simple_bio(ci, ti, target_bio_nr, len);
+		__clone_and_map_simple_bio(ci, ti, target_bio_nr, len, &num_bios);
 }
 
 static int __send_empty_flush(struct clone_info *ci)
@@ -1318,6 +1331,7 @@ static void __clone_and_map_data_bio(str
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
 		tio = alloc_tio(ci, ti, 0, target_bio_nr);
 		tio->len_ptr = len;
+		tio->num_bios = &num_target_bios;
 		clone_bio(tio, bio, sector, *len);
 		__map_bio(tio);
 	}
Index: linux-3.16-rc5/include/linux/device-mapper.h
===================================================================
--- linux-3.16-rc5.orig/include/linux/device-mapper.h	2014-07-14 16:25:29.000000000 +0200
+++ linux-3.16-rc5/include/linux/device-mapper.h	2014-07-14 16:25:31.000000000 +0200
@@ -271,6 +271,7 @@ struct dm_target_io {
 	struct dm_target *ti;
 	unsigned target_bio_nr;
 	unsigned *len_ptr;
+	unsigned *num_bios;
 	struct bio clone;
 };
 
@@ -382,6 +383,7 @@ struct gendisk *dm_disk(struct mapped_de
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
+void dm_ask_for_duplicate_bios(struct bio *bio, unsigned n_duplicates);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);

