Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23981FAC34;
	Mon, 11 Aug 2025 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754942983; cv=none; b=k1e9R5cS0BlYPBj+Gk0gKN3kHMh7hG8kr5ccfqlTzXUYwkf4/NZhE9zboOErGuHdxC4ZoYAWU4Ruv78Ylh/3zRLyGVZOgleyLqena/t4olNPoYSnBW9PNIia/JvV78PwbODwnNEydBK2k7tWU1Ri48x4Yta8Tj+Llh7rghaieLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754942983; c=relaxed/simple;
	bh=z/a65iFT22iDhXRtN0Va581uLIpy4Q+V9QsNF1daOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JslSE1KOhWpmtQs38WcW1AH8L29UzS44jZD7ymRwHxj3NDL7Xe9BGjQbe+74rMTqoVecR2gvReqN9++skVxjXx5k/Lhxby1h/rnHOYDDUzrMv37h4YoJFftknRGSnp9DPpmoRa1UtBhkaimDRFW4xGimoDPVKGykukzdhn5ilbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cx/4Bg4X; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cx/4Bg4X"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15MS67F8zm0ySc;
	Mon, 11 Aug 2025 20:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754942979; x=1757534980; bh=AsK5T
	y+pixhP8ZElMyMQETn/eyff2I9jQbKKgu/0cO8=; b=cx/4Bg4XTT9Ew8dJwKhBU
	CalUuGvXk2cNelRJF+TtTL6A28+PD9uASpHq10SHlnoV43fVIdJ/MvXTwCQe2s3y
	OgKYVrj2bQ9cvJpzH+jBjG+2nNXukJD1T4BTwXzxf1IdWztO+Fhe/j97AnOziErq
	n/KVd+HIU18bvjYPN6Zx8/iNAdJv4jJB253kQjRbea4vgSwObjKeypSRTI04HdoU
	QbvbjqjmrU+CShmb8g1LgDU0wXk5/uw6QQH3yS0dJ5p06K65ztJVCrddjHHYcC9y
	4DQe50YLMtYQF9yl1fwXMg3knEmIT9eOhNE+Gj/HrLNbvHRb68cd/9n6wAkwrbUU
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9T9WkoaYaiGB; Mon, 11 Aug 2025 20:09:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15MM3Dmgzm0ytg;
	Mon, 11 Aug 2025 20:09:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 01/16] block: Support block devices that preserve the order of write requests
Date: Mon, 11 Aug 2025 13:08:36 -0700
Message-ID: <20250811200851.626402-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some storage controllers preserve the request order per hardware queue.
Some but not all device mapper drivers preserve the bio order. Introduce
the feature flag BLK_FEAT_ORDERED_HWQ to allow block drivers and stacked
drivers to indicate that the order of write commands is preserved per
hardware queue and hence that serialization of writes per zone is not
required if all pending writes are submitted to the same hardware queue.
Add a sysfs attribute for controlling write pipelining support.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/stable/sysfs-block | 15 +++++++++++++++
 block/blk-settings.c                 | 10 ++++++++++
 block/blk-sysfs.c                    |  7 +++++++
 include/linux/blkdev.h               |  9 +++++++++
 4 files changed, 41 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/sta=
ble/sysfs-block
index 803f578dc023..5a42d99cf39a 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -637,6 +637,21 @@ Description:
 		I/O size is reported this file contains 0.
=20
=20
+What:		/sys/block/<disk>/queue/pipeline_zoned_writes
+Date:		August 2025
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		[RW] If this attribute is present it means that the block driver
+		and the storage controller both support preserving the order of
+		zoned writes per hardware queue. This attribute controls whether
+		or not pipelining zoned writes is enabled. If the value of this
+		attribute is zero, the block layer restricts the queue depth for
+		sequential writes per zone to one (zone append operations are
+		not affected). If the value of this attribute is one, the block
+		layer does not restrict the queue depth of sequential writes per
+		zone to one.
+
+
 What:		/sys/block/<disk>/queue/physical_block_size
 Date:		May 2009
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 07874e9b609f..01c0edf2308a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -119,6 +119,14 @@ static int blk_validate_zoned_limits(struct queue_li=
mits *lim)
 	lim->max_zone_append_sectors =3D
 		min_not_zero(lim->max_hw_zone_append_sectors,
 			min(lim->chunk_sectors, lim->max_hw_sectors));
+
+	/*
+	 * If both the block driver and the block device preserve the write
+	 * order per hwq, enable zoned write pipelining.
+	 */
+	if (lim->features & BLK_FEAT_ORDERED_HWQ)
+		lim->features |=3D BLK_FEAT_PIPELINE_ZWR;
+
 	return 0;
 }
=20
@@ -780,6 +788,8 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,
 		t->features &=3D ~BLK_FEAT_NOWAIT;
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &=3D ~BLK_FEAT_POLL;
+	if (!(b->features & BLK_FEAT_ORDERED_HWQ))
+		t->features &=3D ~BLK_FEAT_ORDERED_HWQ;
=20
 	t->flags |=3D (b->flags & BLK_FLAG_MISALIGNED);
=20
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 78ee8d324c7f..4bf0b663f25d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -270,6 +270,7 @@ QUEUE_SYSFS_FEATURE(rotational, BLK_FEAT_ROTATIONAL)
 QUEUE_SYSFS_FEATURE(add_random, BLK_FEAT_ADD_RANDOM)
 QUEUE_SYSFS_FEATURE(iostats, BLK_FEAT_IO_STAT)
 QUEUE_SYSFS_FEATURE(stable_writes, BLK_FEAT_STABLE_WRITES);
+QUEUE_SYSFS_FEATURE(pipeline_zwr, BLK_FEAT_PIPELINE_ZWR);
=20
 #define QUEUE_SYSFS_FEATURE_SHOW(_name, _feature)			\
 static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
@@ -554,6 +555,7 @@ QUEUE_LIM_RO_ENTRY(queue_dax, "dax");
 QUEUE_RW_ENTRY(queue_io_timeout, "io_timeout");
 QUEUE_LIM_RO_ENTRY(queue_virt_boundary_mask, "virt_boundary_mask");
 QUEUE_LIM_RO_ENTRY(queue_dma_alignment, "dma_alignment");
+QUEUE_LIM_RW_ENTRY(queue_pipeline_zwr, "pipeline_zoned_writes");
=20
 /* legacy alias for logical_block_size: */
 static struct queue_sysfs_entry queue_hw_sector_size_entry =3D {
@@ -700,6 +702,7 @@ static struct attribute *queue_attrs[] =3D {
 	&queue_dax_entry.attr,
 	&queue_virt_boundary_mask_entry.attr,
 	&queue_dma_alignment_entry.attr,
+	&queue_pipeline_zwr_entry.attr,
 	&queue_ra_entry.attr,
=20
 	/*
@@ -746,6 +749,10 @@ static umode_t queue_attr_visible(struct kobject *ko=
bj, struct attribute *attr,
 	    !blk_queue_is_zoned(q))
 		return 0;
=20
+	if (attr =3D=3D &queue_pipeline_zwr_entry.attr &&
+	    !(q->limits.features & BLK_FEAT_ORDERED_HWQ))
+		return 0;
+
 	return attr->mode;
 }
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 95886b404b16..79d14b3d3309 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,6 +338,15 @@ typedef unsigned int __bitwise blk_features_t;
 /* skip this queue in blk_mq_(un)quiesce_tagset */
 #define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13)=
)
=20
+/*
+ * The request order is preserved per hardware queue by the block driver=
 and by
+ * the block device. Set by the block driver.
+ */
+#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 14))
+
+/* Whether to pipeline zoned writes. Controlled by the block layer. */
+#define BLK_FEAT_PIPELINE_ZWR		((__force blk_features_t)(1u << 15))
+
 /* undocumented magic for bcache */
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
