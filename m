Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D634C808;
	Fri, 24 Apr 2026 22:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070554; cv=none; b=bgr8baWjtN5VRtyxx4AtKviam8AurM1JYL34RaR0L6YJ4ao7n5NaecdpHGc5ZJ4f9Iy2ydWGQdpdxrtNz3wlaWNUpm0lN/EYiahtWuiLssIb4pOtZWLp26RIQ6V7ghw7iCSVGc/nS3KWN9+QQrC7izpZGR6D4ujq7DHlb+bZF0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070554; c=relaxed/simple;
	bh=lma9j9dud9xs22KRa24OP3AZQ85ENU8kI5+xy4V4G2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCV9+kOUaGS8MQTj4ITQk2ZRs19wmq16oZoOcSovwlyL7c4+5/PxTCEEiO7YttxqE82O5XncjS5M7JchpSi2xRTJUpzpmk4lUC4gmhpQ/NM2vQA4qnALp/wCXS/XuJ+3u058LltX8nQT6d2cU35JbdSt7Rp/Z5N5lNOp1to3dXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eHH8iKjI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eHH8iKjI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdc2NVfz1XQmth;
	Fri, 24 Apr 2026 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070534; x=1779662535; bh=KlHJN
	fWd/yVI30FVs1la77MHEmoiC3Q3HLV11nDAA5E=; b=eHH8iKjI0c5SAX2VNMjp4
	+rgZxkO9d90V5XF1NA0yBohCXuI2e89y/gPiL7wKRRNhfAK98Yc2QiXNqgkcEwvf
	bWxrfqWz+inxyJLLUK+DfsjsyqrlxdMVJGainhHT84fsdRE3MJTIKlM8a6MMbPmn
	wiC/VWhHHJib7qZUaKi8GtFp3wNimaUhTotYs66XV4t5+2XGbaCP48eFhuWw6Xxw
	JAn/H0vIjzX33u8aNZBAhSTu2qpu4Q3KKT0qi2w2vxGYU6buj4MYYuzCrb6+iVJE
	Fk1FROM/P1GZj2yyYlvGEmDKYrGbpiWHR2lSaBrGnwExcEwNPoFD/hFoo6TXy4VV
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hYzSRjkU9k1y; Fri, 24 Apr 2026 22:42:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2SdJ523Rz1XQmtk;
	Fri, 24 Apr 2026 22:42:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 01/12] block: Introduce queue limits for copy offloading
Date: Fri, 24 Apr 2026 15:41:50 -0700
Message-ID: <20260424224201.1949243-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Nitesh Shetty <nj.shetty@samsung.com>

Add the following request queue limits:
 - max_copy_hw_sectors: the maximum number of sectors supported by the
   block driver for a single offloaded copy operation.
 - max_copy_src_segments: the maximum number of source segments
   supported by the block driver for a single offloaded copy operation.
 - max_copy_dst_segments: the maximum number of destination segments
   supported by the block driver for a single offloaded copy operation.
 - max_user_copy_sectors: the maximum number of sectors configured by the
   user for a single offloaded copy operation.
 - max_copy_sectors: the maximum number of sectors for a single
   offloaded copy operation. This is the minimum of the above two
   parameters.

The default value for all these new limits is zero which means that copy
offloading is not supported unless if these limits are set by the block
driver.

ake the following two limits available in sysfs:
 - copy_max_bytes (RW)
 - copy_max_hw_bytes (RO)

These limits will be used by the function that implements copy
offloading to decide the bio size.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[ bvanassche: Added max_copy_{src,dst}_segments limits. Introduced
  blk_validate_copy_limits(). Introduced BLK_FEAT_STACKING_COPY_OFFL.
  Modified patch description. ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/stable/sysfs-block | 24 +++++++++++++++++++
 block/blk-settings.c                 | 36 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                    | 35 +++++++++++++++++++++++++++
 include/linux/blkdev.h               | 18 +++++++++++++-
 4 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index 900b3fc4c72d..bec5e04085da 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -239,6 +239,30 @@ Description:
 		last zone of the device which may be smaller.
=20
=20
+What:		/sys/block/<disk>/queue/copy_max_bytes
+Date:		May 2026
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RW] This is the maximum number of bytes that the block layer
+		will allow for a copy request. This is always smaller or
+		equal to the maximum size allowed by the block driver.
+		Any value higher than 'copy_max_hw_bytes' will be reduced to
+		'copy_max_hw_bytes'. Writing '0' to this attribute will disable
+		copy offloading for this block device. If copy offloading is
+		disabled, copy requests will be translated into read and write
+		requests.
+
+
+What:		/sys/block/<disk>/queue/copy_max_hw_bytes
+Date:		May 2026
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] This is the maximum number of bytes that is allowed for
+		a single data copy request. Set by the block driver. The value
+		zero indicates that the block device does not support copy
+		offloading.
+
+
 What:		/sys/block/<disk>/queue/crypto/
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 78c83817b9d3..cb846ff2926e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -57,6 +57,11 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_hw_zone_append_sectors =3D UINT_MAX;
 	lim->max_user_discard_sectors =3D UINT_MAX;
 	lim->atomic_write_hw_max =3D UINT_MAX;
+
+	lim->max_user_copy_sectors =3D UINT_MAX;
+	lim->max_copy_hw_sectors =3D UINT_MAX;
+	lim->max_copy_src_segments =3D U16_MAX;
+	lim->max_copy_dst_segments =3D U16_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
=20
@@ -333,6 +338,21 @@ static void blk_validate_atomic_write_limits(struct =
queue_limits *lim)
 	lim->atomic_write_unit_max =3D 0;
 }
=20
+/*
+ * Check whether max_copy_hw_sectors and max_copy_{src,dst}_segments are
+ * either all nonzero or all zero.
+ */
+static int blk_validate_copy_limits(const struct queue_limits *lim)
+{
+	if (lim->max_copy_hw_sectors && lim->max_copy_src_segments &&
+	    lim->max_copy_dst_segments)
+		return 0;
+	if (!lim->max_copy_hw_sectors && !lim->max_copy_src_segments &&
+	    !lim->max_copy_dst_segments)
+		return 0;
+	return -EINVAL;
+}
+
 /*
  * Check that the limits in lim are valid, initialize defaults for unset
  * values, and cap values based on others where needed.
@@ -510,6 +530,13 @@ int blk_validate_limits(struct queue_limits *lim)
 	err =3D blk_validate_integrity_limits(lim);
 	if (err)
 		return err;
+
+	err =3D blk_validate_copy_limits(lim);
+	if (err)
+		return err;
+	lim->max_copy_sectors =3D
+		min(lim->max_copy_hw_sectors, lim->max_user_copy_sectors);
+
 	return blk_validate_zoned_limits(lim);
 }
 EXPORT_SYMBOL_GPL(blk_validate_limits);
@@ -528,6 +555,7 @@ int blk_set_default_limits(struct queue_limits *lim)
 	 */
 	lim->max_user_discard_sectors =3D UINT_MAX;
 	lim->max_user_wzeroes_unmap_sectors =3D UINT_MAX;
+	lim->max_user_copy_sectors =3D UINT_MAX;
 	return blk_validate_limits(lim);
 }
=20
@@ -829,6 +857,14 @@ int blk_stack_limits(struct queue_limits *t, struct =
queue_limits *b,
 	t->max_segment_size =3D min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
=20
+	t->max_copy_hw_sectors =3D
+		min(t->max_copy_hw_sectors, b->max_copy_hw_sectors);
+	t->max_copy_src_segments =3D
+		min(t->max_copy_src_segments, b->max_copy_src_segments);
+	t->max_copy_dst_segments =3D
+		min(t->max_copy_dst_segments, b->max_copy_dst_segments);
+	t->max_copy_sectors =3D min(t->max_copy_sectors, b->max_copy_sectors);
+
 	alignment =3D queue_limit_alignment_offset(b, start);
=20
 	/* Bottom device has different alignment.  Check that it is
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f22c1f253eb3..8e1e14d1682d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -325,6 +325,36 @@ queue_max_sectors_store(struct gendisk *disk, const =
char *page, size_t count,
 	return 0;
 }
=20
+static ssize_t queue_copy_hw_max_show(struct gendisk *disk, char *page)
+{
+	return queue_var_show(
+		disk->queue->limits.max_copy_hw_sectors << SECTOR_SHIFT, page);
+}
+
+static ssize_t queue_copy_max_show(struct gendisk *disk, char *page)
+{
+	return queue_var_show(
+		disk->queue->limits.max_copy_sectors << SECTOR_SHIFT, page);
+}
+
+static int queue_copy_max_store(struct gendisk *disk, const char *page,
+				size_t count, struct queue_limits *lim)
+{
+	unsigned long max_copy_bytes;
+	ssize_t ret;
+
+	ret =3D queue_var_store(&max_copy_bytes, page, count);
+	if (ret < 0)
+		return ret;
+
+	if ((max_copy_bytes >> SECTOR_SHIFT) > UINT_MAX)
+		return -EINVAL;
+
+	lim->max_user_copy_sectors =3D max_copy_bytes >> SECTOR_SHIFT;
+
+	return 0;
+}
+
 static ssize_t queue_feature_store(struct gendisk *disk, const char *pag=
e,
 		size_t count, struct queue_limits *lim, blk_features_t feature)
 {
@@ -652,6 +682,9 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
 QUEUE_LIM_RO_ENTRY(queue_max_open_zones, "max_open_zones");
 QUEUE_LIM_RO_ENTRY(queue_max_active_zones, "max_active_zones");
=20
+QUEUE_LIM_RO_ENTRY(queue_copy_hw_max, "copy_max_hw_bytes");
+QUEUE_LIM_RW_ENTRY(queue_copy_max, "copy_max_bytes");
+
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_LIM_RW_ENTRY(queue_iostats_passthrough, "iostats_passthrough");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
@@ -760,6 +793,8 @@ static const struct attribute *const queue_attrs[] =3D=
 {
 	&queue_max_hw_wzeroes_unmap_sectors_entry.attr,
 	&queue_max_wzeroes_unmap_sectors_entry.attr,
 	&queue_max_zone_append_sectors_entry.attr,
+	&queue_copy_hw_max_entry.attr,
+	&queue_copy_max_entry.attr,
 	&queue_zone_write_granularity_entry.attr,
 	&queue_rotational_entry.attr,
 	&queue_zoned_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 890128cdea1c..8ae64cc0546f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -353,13 +353,17 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
=20
+/* block driver is a stacking block driver that supports copy offloading=
 */
+#define BLK_FEAT_STACKING_COPY_OFFL	((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
 #define BLK_FEAT_INHERIT_MASK \
 	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA | BLK_FEAT_ROTATIONAL | \
 	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | \
-	 BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE)
+	 BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE | \
+	 BLK_FEAT_STACKING_COPY_OFFL)
=20
 /* internal flags in queue_limits.flags */
 typedef unsigned int __bitwise blk_flags_t;
@@ -415,6 +419,13 @@ struct queue_limits {
 	unsigned int		atomic_write_hw_unit_max;
 	unsigned int		atomic_write_unit_max;
=20
+	/* copy offloading limits */
+	unsigned int		max_copy_hw_sectors;	/* set by block driver*/
+	uint16_t		max_copy_src_segments;	/* set by block driver*/
+	uint16_t		max_copy_dst_segments;	/* set by block driver*/
+	unsigned int		max_user_copy_sectors;	/* set via sysfs */
+	unsigned int		max_copy_sectors;	/* min() of the above */
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -1454,6 +1465,11 @@ static inline unsigned int bdev_discard_granularit=
y(struct block_device *bdev)
 	return bdev_limits(bdev)->discard_granularity;
 }
=20
+static inline unsigned int bdev_max_copy_sectors(struct block_device *bd=
ev)
+{
+	return bdev_get_queue(bdev)->limits.max_copy_sectors;
+}
+
 static inline unsigned int
 bdev_max_secure_erase_sectors(struct block_device *bdev)
 {
