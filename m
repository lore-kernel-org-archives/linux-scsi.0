From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/5] fs/bio-integrity: remove duplicate code
Date: Thu, 20 Mar 2014 21:30:48 -0700
Message-ID: <20140321043048.8428.52698.stgit@birch.djwong.org>
References: <20140321043041.8428.79003.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20140321043041.8428.79003.stgit@birch.djwong.org>
Sender: owner-linux-aio@kvack.org
To: axboe@kernel.dk, martin.petersen@oracle.com, darrick.wong@oracle.com, JBottomley@parallels.com, bcrl@kvack.org, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-scsi@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

Fr=C3=B8m: Gu Zheng <guz.fnst@cn.fujitsu.com>

Most code of function bio_integrity_verify and bio_integrity_generate
is the same, so introduce a help function bio_integrity_generate_verify()
to remove the duplicate code.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/bio-integrity.c |   83 +++++++++++++++++++++++-----------------------=
------
 1 file changed, 37 insertions(+), 46 deletions(-)


diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 4f70f38..413312f 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -301,25 +301,26 @@ int bio_integrity_get_tag(struct bio *bio, void *ta=
g_buf, unsigned int len)
 EXPORT_SYMBOL(bio_integrity_get_tag);
=20
 /**
- * bio_integrity_generate - Generate integrity metadata for a bio
- * @bio:	bio to generate integrity metadata for
- *
- * Description: Generates integrity metadata for a bio by calling the
- * block device's generation callback function.  The bio must have a
- * bip attached with enough room to accommodate the generated
- * integrity metadata.
+ * bio_integrity_generate_verify - Generate/verify integrity metadata fo=
r a bio
+ * @bio:	bio to generate/verify integrity metadata for
+ * @operate:	operate number, 1 for generate, 0 for verify
  */
-static void bio_integrity_generate(struct bio *bio)
+static int bio_integrity_generate_verify(struct bio *bio, int operate)
 {
 	struct blk_integrity *bi =3D bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec bv;
 	struct bvec_iter iter;
-	sector_t sector =3D bio->bi_iter.bi_sector;
-	unsigned int sectors, total;
+	sector_t sector;
+	unsigned int sectors, total, ret;
 	void *prot_buf =3D bio->bi_integrity->bip_buf;
=20
-	total =3D 0;
+	if (operate)
+		sector =3D bio->bi_iter.bi_sector;
+	else
+		sector =3D bio->bi_integrity->bip_iter.bi_sector;
+
+	total =3D ret =3D 0;
 	bix.disk_name =3D bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size =3D bi->sector_size;
=20
@@ -330,7 +331,15 @@ static void bio_integrity_generate(struct bio *bio)
 		bix.prot_buf =3D prot_buf;
 		bix.sector =3D sector;
=20
-		bi->generate_fn(&bix);
+		if (operate) {
+			bi->generate_fn(&bix);
+		} else {
+			ret =3D bi->verify_fn(&bix);
+			if (ret) {
+				kunmap_atomic(kaddr);
+				return ret;
+			}
+		}
=20
 		sectors =3D bv.bv_len / bi->sector_size;
 		sector +=3D sectors;
@@ -340,6 +349,21 @@ static void bio_integrity_generate(struct bio *bio)
=20
 		kunmap_atomic(kaddr);
 	}
+	return ret;
+}
+
+/**
+ * bio_integrity_generate - Generate integrity metadata for a bio
+ * @bio:	bio to generate integrity metadata for
+ *
+ * Description: Generates integrity metadata for a bio by calling the
+ * block device's generation callback function.  The bio must have a
+ * bip attached with enough room to accommodate the generated
+ * integrity metadata.
+ */
+static void bio_integrity_generate(struct bio *bio)
+{
+	bio_integrity_generate_verify(bio, 1);
 }
=20
 static inline unsigned short blk_integrity_tuple_size(struct blk_integri=
ty *bi)
@@ -454,40 +478,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-	struct blk_integrity *bi =3D bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector =3D bio->bi_integrity->bip_iter.bi_sector;
-	unsigned int sectors, ret =3D 0;
-	void *prot_buf =3D bio->bi_integrity->bip_buf;
-	int i;
-
-	bix.disk_name =3D bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size =3D bi->sector_size;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr =3D kmap_atomic(bv->bv_page);
-
-		bix.data_buf =3D kaddr + bv->bv_offset;
-		bix.data_size =3D bv->bv_len;
-		bix.prot_buf =3D prot_buf;
-		bix.sector =3D sector;
-
-		ret =3D bi->verify_fn(&bix);
-
-		if (ret) {
-			kunmap_atomic(kaddr);
-			return ret;
-		}
-
-		sectors =3D bv->bv_len / bi->sector_size;
-		sector +=3D sectors;
-		prot_buf +=3D sectors * bi->tuple_size;
-
-		kunmap_atomic(kaddr);
-	}
-
-	return ret;
+	return bio_integrity_generate_verify(bio, 0);
 }
=20
 /**

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=3Dmailto:"aart@kvack.org">aart@kvack.org</a>
