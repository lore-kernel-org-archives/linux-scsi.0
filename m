From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 11/10] fix leak in scsi_req_map_sg
Date: Tue, 08 Nov 2005 16:52:26 -0600
Message-ID: <1131490346.3787.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30883 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965265AbVKHWwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:52:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

I guess this would be 11/10. I found a bug in testing.

I should not have been testing against bi_max_vecs. For odd
IO sizes it would cause us to leak bios. We should test against
the number of vecs we requested and were planning on adding.

All my patches are here
http://www.cs.wisc.edu/~michaelc/block/use-sg/v9/
this includes fixups Jens requested (hopefully they
are correct now). And they were made against scsi-misc.


--- scsi-misc-2.6/drivers/scsi/scsi_lib.c.orig	2005-11-08 16:45:28.000000000 -0600
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c	2005-11-08 16:45:55.000000000 -0600
@@ -369,7 +369,7 @@ static int scsi_req_map_sg(struct reques
 	unsigned int data_len = 0, len, bytes, off;
 	struct page *page;
 	struct bio *bio = NULL;
-	int i, err;
+	int i, err, nr_vecs = 0;
 
 	for (i = 0; i < nsegs; i++) {
 		page = sgl[i].page;
@@ -381,8 +381,6 @@ static int scsi_req_map_sg(struct reques
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
 
 			if (!bio) {
-				int nr_vecs;
-
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 
@@ -401,7 +399,7 @@ static int scsi_req_map_sg(struct reques
 				goto free_bios;
 			}
 
-			if (bio->bi_vcnt >= bio->bi_max_vecs) {
+			if (bio->bi_vcnt >= nr_vecs) {
 				err = scsi_merge_bio(rq, bio);
 				if (err) {
 					bio_endio(bio, bio->bi_size, 0);


