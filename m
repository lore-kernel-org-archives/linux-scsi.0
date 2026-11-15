Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785612;
	b=TWgb7soolYUkE2arVM+ydjZawtJ1LA2kNzaLSN62OAdFJaoOHrKo+Zcj+4xdgaNUwxAQ
	 Qyft3Ej0n1eu7s1y2UPsZUHOVLFuYDvDHPWUmDpENIok/0u9XOKf5VblYj4e32iTYAJyZ
	 ZOI11PYf1WVtNfircK/17qUx1sgF2sIIhg8GW2/GghSdO4UTvtLlaCZ0+ZIQAVA7/kJ+f
	 nhh6qmp2u8R8yq+qIclBMMRvE6K9F5EvZqvaQRWIJVXljAikclDAF6AlAvCswsTcZkqSw
	 3eifsXtndoedNV7FA1q/HqeDshAvqAK8AtXwIs7EaDyqPclF1C8Ax7nLqWpz14QFE6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785612;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	b=fPi4PkHW5wBLYdCf0OBDXBiVkk7hzYsij4j1avjcW3PZnqfvxB0BuZmPLWhKY31hIe1P
	 JyWLqSYjsqbkoLHZMLtB6x9otsuPdvXfu3rMRBvSdLt1V8MeG935vBnTslKLqfPbOgpZt
	 JkrChZG3zOeJqMP/FM2tWw3zvSdUH4coESZ+G5XwO3QeEfU4Buvm/FCxCvMR6KJdB4jJl
	 rpX6bxO4PsqTmrtqWzKr1GMUZ6oRYuYRtxZSFY3xa/LMx4+2R6Ii9wLK8aLag5Z2ho5v6
	 TwxPZcbdwSI3Ycdx/td/9wMK86o+60n4FNEB8xXq6LFLD2ak//n18SM5RYMyGfoCw0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIc9pwjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB6606A31F;
	Sun, 15 Nov 2026 23:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIc9pwjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C691F000C4;
	Sun, 15 Nov 2026 23:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785612;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MIc9pwjNY9yB+I6nEjzWCUsYj0K59Oiq9jfiz/0h47Viw9kt49vNScj3JrusMPjnZ
	 Gun0CgiBJSNlj3lXdnA5STwctjM+8EmG2PgFMhI1yk/ToqUcPG35qYg8E9YBdGqX++
	 vq6Js7RjUEronHtTLu5xktdkBQvl4KLzljKUktrjSlUo/R14Gi2e9dAEwh6v8UafNs
	 fBtt38TEZqHHcBxxxNgZ70C/RiCLjsy9xLvM+kcISn0fLa5iHQgedXx7Di7qaubhWS
	 IO1EUvq7/Da8kaGNjrKHg5PBy3cvTyBiPt5HP4GVjUaMTLpBUg+huHD796/Rj2xKCf
	 pYySrH7ZvJlOw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 02/13] block: refactor blk_revalidate_disk_zones()
Date: Mon, 16 Nov 2026 08:33:16 +0900
Message-ID: <20261115233327.941586-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
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

