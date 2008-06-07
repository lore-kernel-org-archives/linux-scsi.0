From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 7] block: Find bio sector offset given idx and offset
Date: Sat, 07 Jun 2008 00:55:36 -0400
Message-ID: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756323AbYFGE55@vger.kernel.org>
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2 files changed, 26 insertions(+)
fs/bio.c            |   24 ++++++++++++++++++++++++
include/linux/bio.h |    2 ++


Helper function to find the sector offset in a bio given bvec index
and page offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 550d61001baa -r 318fa71e735d fs/bio.c
--- a/fs/bio.c	Sat Jun 07 00:45:14 2008 -0400
+++ b/fs/bio.c	Sat Jun 07 00:45:14 2008 -0400
@@ -1232,6 +1232,30 @@
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
diff -r 550d61001baa -r 318fa71e735d include/linux/bio.h
--- a/include/linux/bio.h	Sat Jun 07 00:45:14 2008 -0400
+++ b/include/linux/bio.h	Sat Jun 07 00:45:14 2008 -0400
@@ -315,6 +315,8 @@
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
+
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
 struct sg_iovec;
