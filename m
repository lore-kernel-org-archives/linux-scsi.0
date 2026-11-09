Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217909;
	b=O9PB5nzsyjoW2FIPSP4ajArKB5Cd6T42ormh0kxNBRpSLNHOcEiowBA1mXiNQlX6kLKs
	 WLlHUKQ6UQhZKURcUhz6agTrDlKNpVcH0SwCkLZ7iGzJ1825g2SiDT1L0V+bGhf44S6LK
	 b3BoyYWqRtCX18eGA/XXP0yIXEDiGAPp7u2MNRDvb88uVDGxcF+hRzJ/br1tue9h59+A8
	 8HHKGf+GmhIRO+5V1PWzmXG/GqdpkKNgmH0pC9VsXWWw/FMIiTcqqhAfOJmZhuWIycdjA
	 YMy3RQjQnRsbzpoBs94RLbPrjAhUkewRbhJQFqVxSK7VPrzEd5r7ugNGEL9Qt1/yaUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217909;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	b=oDGdMA5nZHrQS0cSEPgtell2nVSZVyrR7ZdmuUuCvuPxnbwMJqOUB5L8OaC4EMy7TrBr
	 Q7ALpYjV91472E8jhtZWDnyKfAYGCoaivOpDx++C2EJtttDfMmtm9boADU+4RUpDaJxYY
	 4wDZq/2O13QR/1cRUuIrt94w5JBpGj/S0KKaKgt/nvWKsQuWPd+gD9JbrrmNB3PWvK8at
	 7qwR9iIB7/YA4tI+7lVEdrOCM+1WPGiCByE3cmEonjVftfjE87McJp3oqi6JPM/HybvWC
	 yk/Iumjmu/nAtmspEu+tTb5Z5uC4T/rQRuqi6KYbtKOZGZZIY3b0QL6Xsy4rbIN0cXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6K5SPuY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B81606D804;
	Mon,  9 Nov 2026 09:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6K5SPuY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697BC1F008A4;
	Mon,  9 Nov 2026 09:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217909;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=j6K5SPuYnpLEGCBkck2IIahtJgSySbUh+0+k6WGllzs4+nw2RlRHJaoms+B5DmvnZ
	 +ga4dhjxUKWYP/0ibSmqyqgkzyy8CsxbQh4eeU7lbE9pYyxp2y4oxqcUJfExLFlIgs
	 FuE1FAyoP+FgmrneGg6Ys2xUKK1oz2v2efBXst/rTaYbHM4wUKuE0OQXGQriEN6yh3
	 hY3/XXmKSf9fDBkbLKY4X2n5k9wDcvEN9iLW7pYXZKviTGP4YhChrW8wJyatx+O5nW
	 97uAD+zJrGD5eynGGXLZZ0zn1lVcoBsD83+Um++ZxFp34MZW18RQRYbkAsYotj9dH6
	 MhGOeeY8IxFUw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 02/12] block: refactor blk_revalidate_disk_zones()
Date: Mon,  9 Nov 2026 18:51:34 +0900
Message-ID: <20261109095144.819709-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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
2.56.0

