From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03 of 16] Find bio sector offset given idx and offset
Date: Fri, 25 Apr 2008 19:12:05 -0400
Message-ID: <5d30928a273091aaa575.1209165125@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44310 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483AbYDYXR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:27 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 26 insertions(+)
fs/bio.c            |   24 ++++++++++++++++++++++++
include/linux/bio.h |    2 ++


Helper function to find the sector offset in a bio given bvec index
and page offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r b9f133a520ea -r 5d30928a2730 fs/bio.c
--- a/fs/bio.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/fs/bio.c	Fri Apr 25 17:39:29 2008 -0400
@@ -1142,6 +1142,30 @@
 	return bp;
 }
 
+sector_t bio_sector_offset(struct bio *bio, unsigned short index, unsigned int offset)
+{
+	struct bio_vec *bv;
+	unsigned int sector_sz = bio->bi_bdev->bd_disk->queue->hardsect_size;
+	sector_t sectors;
+	int i;
+
+	sectors = 0;
+
+	BUG_ON(index >= bio->bi_vcnt);
+	
+	bio_for_each_segment(bv, bio, i) {
+		if (i == index) {
+			if (offset > bv->bv_offset)
+				sectors += (offset - bv->bv_offset) / sector_sz;
+			return sectors;
+		}
+		
+		sectors += bv->bv_len / sector_sz;
+	}
+	
+	BUG();
+}
+EXPORT_SYMBOL(bio_sector_offset);
 
 /*
  * create memory pools for biovec's in a bio_set.
diff -r b9f133a520ea -r 5d30928a2730 include/linux/bio.h
--- a/include/linux/bio.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/linux/bio.h	Fri Apr 25 17:39:29 2008 -0400
@@ -315,6 +315,8 @@
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
+
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
 struct sg_iovec;


