Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931064;
	b=E4PsDaDeua9a95AkKht6B/rw+TRBNTbrLVUmg1RLxpLXZMaOCo9Ou5ENT9fgpY1H1FlN
	 LioIIffmGtWfugpX76Cctt0Brt71/4urWsE5BT9FT/QvDkhYl1cJIFECEBWhK43/tSI/r
	 tRxu1Ydcvw0MRWwJ9A28RsJGCNh7ikg6m/rzv2Evx+F0MzLcXupOu53N9PjXdOKQ2usVd
	 es66s+yBYPhTExGC9lanryZYlqf8VVDFMtccLybQbB49JNVNhhP/b0+3SCEADNkGcjmZU
	 V55/nUtNS2YNZkDqvxfuyxUBG9XdNk43vOHVE18zAhvk2lIoI27OWsu/KgMe7tDQwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931064;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LAFzGRj5h02qybvze9qAIfbGkTR2VUVUCRu5nTmxe8M=;
	b=Uu6Pv/gfKC0oS09wA36SL1RwK9bDpZFH06bsvl41Ho2JjT4sq8LazlCV2oCHfqTGSFAr
	 aLCZ/pJNy2fICrYWHzXyzzIOdH8ywpl0ea5eao1L6hYS97UBev1GV51O4WzrNha8LsReo
	 SrK0BLv9hhE07wWTcAAh5lQTucqQzRSuwq/adLSApcTIvC8MBHkBkPo42e+GeBGLWVm/U
	 ylK8MgCh2yKcxkwhvDwhfmfNT5alh+J7H05Bx5xkPfFUExW9EhlUlsKkeH+iLBI31DBAF
	 QOKFucVAlKePcjesuhHayHTm8nRNenVXYC1nD/QwzeZikjM0hnvjIFxvb14iSgHexvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hG7zGBVl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9BE606A336;
	Tue, 17 Nov 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hG7zGBVl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B171F00926;
	Tue, 17 Nov 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931064;
	bh=LAFzGRj5h02qybvze9qAIfbGkTR2VUVUCRu5nTmxe8M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hG7zGBVl/TxjAT4UHZ1zsTTvYInylWxN2Q7SOqczUpFlfej93u/uKP2BqYHmHGCKJ
	 zTNas0fkZ+VayOe0BuCCYARgJX81T1B5ij0jaKp3yefCf7Z9FpmzQ/tHcT4A1Je7DP
	 BWoqn0GY6RR+A+IH8pxO++5SHi6zL3K2dki5ljrmnGY0x1b9IDit0cLW92ARG2dtbV
	 4yy7BWyEWbQSXOeh8ht2hYQt+RxkxPWgG9bmiWD0ZyTd6ZWef8GvO5rrQK4r4lN2qk
	 mOaIuYnvoZk/tXVsBMG2pUWI7j596XC+8Vfg3vUmCwa2mOQIxnnwgr6VFojN+1k0+a
	 FaMNk/knK8NdA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 02/13] block: refactor blk_revalidate_disk_zones()
Date: Wed, 18 Nov 2026 00:57:28 +0900
Message-ID: <20261117155739.304506-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split out most of the code of blk_revalidate_disk_zones() into the
internal function disk_revalidate_zones(). This will allow calling this
new helper together with other code under the zone revalidation mutex.
No functional change.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 block/blk-zoned.c | 63 +++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 07d504287024..600d6bd008ae 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2552,20 +2552,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	return ret;
 }
 
-/**
- * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
- * @disk:	Target disk
- *
- * Helper function for low-level device drivers to check, (re) allocate and
- * initialize resources used for managing zoned disks. This function should
- * normally be called by blk-mq based drivers when a zoned gendisk is probed
- * and when the zone configuration of the gendisk changes (e.g. after a format).
- * Before calling this function, the device driver must already have set the
- * device zone size (chunk_sector limit) and the max zone append limit.
- * BIO based drivers can also use this function as long as the device queue
- * can be safely frozen.
- */
-int blk_revalidate_disk_zones(struct gendisk *disk)
+static int disk_revalidate_zones(struct gendisk *disk)
 {
 	struct blk_revalidate_zone_args args = { };
 	struct blk_report_zones_args rep_args = {
@@ -2576,19 +2563,10 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	int retries = 2;
 	int ret;
 
-	if (WARN_ON_ONCE(!blk_queue_is_zoned(disk->queue)))
-		return -EIO;
-
-	/*
-	 * Serialize calls to this function so that we can safely look at and
-	 * eventually change the disk zone information.
-	 */
-	mutex_lock(&disk->zone_revalidate_mutex);
-
 again:
 	ret = disk_revalidate_capacity(disk, &args);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	/*
 	 * Allocate zone resources if they are needed and we have not done
@@ -2601,14 +2579,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 		ret = disk_alloc_zone_resources(disk, args.capacity);
 		if (ret) {
 			memalloc_noio_restore(noio_flag);
-			goto unlock;
+			return ret;
 		}
 	}
 
 	ret = disk_init_revalidate_args(disk, &args);
 	if (ret) {
 		memalloc_noio_restore(noio_flag);
-		goto unlock;
+		return ret;
 	}
 
 	ret = disk->fops->report_zones(disk, 0, UINT_MAX, &rep_args);
@@ -2625,8 +2603,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	if (ret)
 		goto free_args;
 
-	mutex_unlock(&disk->zone_revalidate_mutex);
-
 	return 0;
 
 free_args:
@@ -2642,7 +2618,36 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 
 	pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-unlock:
+
+	return ret;
+}
+
+/**
+ * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
+ * @disk:	Target disk
+ *
+ * Helper function for low-level device drivers to check, (re) allocate and
+ * initialize resources used for managing zoned disks. This function should
+ * normally be called by blk-mq based drivers when a zoned gendisk is probed
+ * and when the zone configuration of the gendisk changes (e.g. after a format).
+ * Before calling this function, the device driver must already have set the
+ * device zone size (chunk_sector limit) and the max zone append limit.
+ * BIO based drivers can also use this function as long as the device queue
+ * can be safely frozen.
+ */
+int blk_revalidate_disk_zones(struct gendisk *disk)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!blk_queue_is_zoned(disk->queue)))
+		return -EIO;
+
+	/*
+	 * Serialize calls to this function so that we can safely look at and
+	 * eventually change the disk zone information.
+	 */
+	mutex_lock(&disk->zone_revalidate_mutex);
+	ret = disk_revalidate_zones(disk);
 	mutex_unlock(&disk->zone_revalidate_mutex);
 
 	return ret;
-- 
2.56.1

