Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865027;
	b=eR1fDnBDBUECQY+hraPdwZV0HFA+gWuSJ9BuHaN/lYRhZ0odOao37H0N5l92922ecBAD
	 Y5LT5wxPbkwfDO0DwsadyV26q6pq7T9FFakC6yjiKPXBtEET165r6mrfOEUjxsybgeBG1
	 bNJgg3VdBr8sCau008IthvOfCD1dVTy3D1gv1qQUyNKvq0IxtU6DckE84lhh505CJ0SDi
	 EwNDg0dUmdD0AaUQjiMRj+wjup6SGgzIVyR254x6MP9RLy7ra5IPa8gULyYsR+8WHDK92
	 i9gHFfjxx4nWOJEsa3Me9+PHgE0Yzx8iEcHlXMUAVxrvK1GsnFGIfrMZ8iGK6gSjX4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865027;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LAFzGRj5h02qybvze9qAIfbGkTR2VUVUCRu5nTmxe8M=;
	b=rMyBt+Hpb6A2mD78XOb9daMg4RYqnqsglKVfVIm775eBr+zflG3x/VgJJCu6spWUckW/
	 l3t1YvlGqm2+LbTvDOxv9idBxCVl7hVAx7/1xf9a/lW1zQ09Mso1nR2VOrxZwXhXJMpiS
	 3/NcRmxW6OciSFuXhAknOnO86ZNfQ/u1QWi/eWijVA9s7tlpZgEPkg+OC5PY/N7HdfrYf
	 JmyWoUIJbJqPehnblszzyNxMp++ccLfMd5PKTUajFBAAJai+nYpVeGa247jUGfgviVnkC
	 T5YxNc3HVIRsTYymChBSg57pxqHJRssLRpc1m8QS2kR2+ugddVNtDGlTZKRBQqBSxSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7rSwmzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F99606A33D;
	Mon, 16 Nov 2026 21:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7rSwmzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FEE1F000C7;
	Mon, 16 Nov 2026 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865026;
	bh=LAFzGRj5h02qybvze9qAIfbGkTR2VUVUCRu5nTmxe8M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=O7rSwmzMxkMDkT4mG5kdf0xzQMkfk5+BpkHfmyod5MrR9ds1jnJ1XF2YF3nARewM4
	 zBXkeDZYhFLlhEnwJK5MGQOj5Ew+su5KOtpLGkYz4xLI77L7srstSLGKPgr8DrKObN
	 N8Ccg139u+i8I86uOf+al0J98sI+VBSEC/EZVtWYvvSPdRZAGE4ypE9kt9NdqYbxym
	 I9h1PJQKasXHyx2BoRxU2FaaCq5uI6adZIvfk2rBbBjrVbgL8Fd1dUDmBR+oozknqT
	 ZNe2tynKk3OOftjProewqAij2O4Qi/RLWBclDXbHbZwn1pNZcaHxsBYKjkxWSXjEQO
	 OswTMbyQ8C6Vw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 02/13] block: refactor blk_revalidate_disk_zones()
Date: Tue, 17 Nov 2026 06:36:51 +0900
Message-ID: <20261116213702.225970-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116213702.225970-1-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
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

