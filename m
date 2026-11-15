Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754221;
	b=P958ELo8/Kn6YFEbvjGwzeYwjvej/VrLGEtwBN+kEPNv0i8OT9IlT9ikoLwQxUD6afyi
	 IuzeYuM0J3pp/1DsQfg6XIRJ4oXprSjr1VAGbc8DFwQQChqGKlNrRCbreLfwlSiFioQzh
	 yYOg2jS0DNRSI+/oWsnkb0D94Pj800NPXK148hcOFz8BcE3KWSDnzCqJUfuchMZzDOZL3
	 gU6as7wbUM651wtFJdH1ikudGIbJJIlHEGVZj6zm63/6RdLHNVbxFgHEoATkinUuDhBPz
	 C/CJhVL/U7K3CEtRmP7eo+evsX0yToSWvta0sE5LMbzx5PAsbRObL2Uu9rkH0ekTj1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754221;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	b=z3SR6YZxBbZ8XS9tezGIfUd2UxSYD7Bv39jQ/OuMS6nvHkD7m+pwlvIkLnJGBOMneIPt
	 VIKdH6wqsbH8Q04XMt9VbBrQ6IUpp+9EKBvtPvDf+/aR9/1NFyMUNiEGkRKJsxC4Xt7GB
	 Gbz+QeDRM5r4TrANEDTC2dBNx8eDzS+pu1ynu672Gon3pkjx5fPCY+Lalh1rMOcgMTHFk
	 5oD3DFxnhyDioUt8pnVOyjK/e1ALo3ZG17UaUMD45TkMB2ytpsg2DQvUslseLw3Akp5Ep
	 gqe0YKNgCjCKsszG+jh17bfLfHqeBWuaTnQn0tD7QuDGD3AIAQkf6EK3OpYo0ee+wgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5Qnor9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93190606A323;
	Sun, 15 Nov 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5Qnor9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0C81F000C6;
	Sun, 15 Nov 2026 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754220;
	bh=VJTu/hDjb/OU2PGhV/qoc3J+K4uvOXUOrkl5qJ3k9F4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=a5Qnor9mVgBs4lDkPJY7hBwkylAbYnQuyBEAcmTFaV5Beplab9R9Esbc4Igycw22t
	 M+gyutPA9upCpuW2UgMZYR1xzUfnjUzTFPvpliqYe4W+NyWTZ9hzK2yAbO8Gf/rUYM
	 ob6ae7ljzmO/0WtBvWemyzeKTS+gtirMsaZFuExR8x6CP6VpkdSmAPOqPHn6Z2uYZQ
	 3DdWQsnRSZU8u+4eRT9LYAZbJOT3OcJmauvwb87gg8gw9qnyfr271y2IP7CviuEWJ4
	 gjEwq2A2UnLKH84gPzJXXmDRYt5NypuF+Ez7C425JAksYLL9LVEGiLYy/5bsCv4qJg
	 vI3jJJqUB5EaA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 02/13] block: refactor blk_revalidate_disk_zones()
Date: Sun, 15 Nov 2026 23:50:04 +0900
Message-ID: <20261115145015.938426-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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

