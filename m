From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH] sd: dif sector calculation
Date: Tue, 17 Sep 2013 21:32:23 -0600
Message-ID: <1379475143-2792-1-git-send-email-keith.busch@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3IRDcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 23:32:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ric Wheeler <rwheeler@redhat.com>

The ref tag should be the device's physical LBA rather than the 512 byte
bio sector.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Ric Wheeler <rwheeler@redhat.com>
---
I CC'ed James and Ric as I think you guys expressed some interest in
seeing if this was a legit concern. :)

The patch goes out of its way to avoid division. The shifting requires
the physical sector size be a power of 2 of at least 512, which I believe
is true.

 drivers/scsi/sd_dif.c | 12 ++++++------
 fs/bio-integrity.c    | 11 ++++-------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 6174ca4..dc9f095 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -382,8 +382,8 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
 			break;
 
-		virt = bio->bi_integrity->bip_sector & 0xffffffff;
-
+		virt = (bio->bi_integrity->bip_sector >>
+					(__ffs(sector_sz) - 9)) & 0xffffffff;
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
 			sdt = kmap_atomic(iv->bv_page)
 				+ iv->bv_offset;
@@ -425,14 +425,14 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	sector_sz = scmd->device->sector_size;
 	sectors = good_bytes / sector_sz;
 
-	phys = blk_rq_pos(scmd->request) & 0xffffffff;
-	if (sector_sz == 4096)
-		phys >>= 3;
+	phys = (blk_rq_pos(scmd->request) >> (__ffs(sector_sz) - 9)) &
+								0xffffffff;
 
 	__rq_for_each_bio(bio, scmd->request) {
 		struct bio_vec *iv;
 
-		virt = bio->bi_integrity->bip_sector & 0xffffffff;
+		virt = (bio->bi_integrity->bip_sector >>
+					(__ffs(sector_sz) - 9)) & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
 			sdt = kmap_atomic(iv->bv_page)
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 6025084..6ee4f12 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -196,11 +196,7 @@ EXPORT_SYMBOL(bio_integrity_enabled);
 static inline unsigned int bio_integrity_hw_sectors(struct blk_integrity *bi,
 						    unsigned int sectors)
 {
-	/* At this point there are only 512b or 4096b DIF/EPP devices */
-	if (bi->sector_size == 4096)
-		return sectors >>= 3;
-
-	return sectors;
+	return sectors >> (__ffs(bi->sector_size) - 9);
 }
 
 /**
@@ -300,7 +296,7 @@ static void bio_integrity_generate(struct bio *bio)
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
-	sector_t sector = bio->bi_sector;
+	sector_t sector = bio->bi_sector >> (__ffs(bi->sector_size) - 9);
 	unsigned int i, sectors, total;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
@@ -442,7 +438,8 @@ static int bio_integrity_verify(struct bio *bio)
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_sector;
+	sector_t sector = bio->bi_integrity->bip_sector >>
+						(__ffs(bi->sector_size) - 9);
 	unsigned int i, sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
-- 
1.8.2.1

