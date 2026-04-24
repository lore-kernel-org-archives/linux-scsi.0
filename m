Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBDE3E0C6B;
	Fri, 24 Apr 2026 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070573; cv=none; b=DUFC3sxXqPvYTDR1FHGxby+yYAipc3rMdjtP80eUX5HwltRadUcAWoB4InL5C2+xXhhVEIQArIOFQyBTMLI41sMQ/F/WXY5W8F+FDQg7Lf00TFYb88qpBuCMBrEV4OdIpQC4ptfk+wzGppWkNlpXc11I3Exg5dSpADENTR9crg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070573; c=relaxed/simple;
	bh=q4wNhltj9JEZjzfGIRhfeK6S8Wv2SbnEPvxNoCaI/Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDHtqRxrUzt6PiS/QEUR3HWuexQnEYKIyXtxaOAscW3K6uNtDJ0zGu0G+7BRbmRDUTOQjqciBKUFCUmdsmDH3Evwlvfte/EASxmb8BOMl1GttguJOKAMC0a/IedcQ0wFsWSgPJ5NnJJhbHsUJwQ4yhAjuZARRRU3PDbtXLhsd84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=slLDmQdP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="slLDmQdP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdr4l25z1XQmtg;
	Fri, 24 Apr 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070549; x=1779662550; bh=aO6dc
	1OpgNkWLALMkrrjmVRanHopubIi6s3XO/muCf0=; b=slLDmQdPz88B8YED4TsIi
	AqLnWzLx53TNLGqaib0XWp9BKzutEwXiOvhsc85vVuymyX5ABeRA1WqbMnQGEqRr
	bQnb/jntOqS/SPHAPFSj3znYtT2i4i2KsbuLJsUVaRlEhZj6f11jYaASPGmiagfb
	A87MckPrUd5c6TMbLjbGWDVLClh/xiWohtLGM6CbG9grKcwFsQu6dU2qFM8m1OQq
	hAz83ZdIz5Q09tbDDQVrqEOnhWUKc8ZoK05b6MoVWOghKfyE+gcC4P8PzVJgYInG
	dUWqmTkjbqJpCXzfssbabxvYuC52Wt9VYsUbK1q6Kpvrz0ht5PXtROBZsnL+bSAa
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d_Q_LHgYOCVN; Fri, 24 Apr 2026 22:42:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2SdR5X73z1XLDpT;
	Fri, 24 Apr 2026 22:42:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Vincent Fu <vincent.fu@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 04/12] block: Add an onloaded copy implementation
Date: Fri, 24 Apr 2026 15:41:53 -0700
Message-ID: <20260424224201.1949243-5-bvanassche@acm.org>
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

For the devices which do not support copy offloading, add a function that
copies data by submitting READ and WRITE operations.

Onloaded copying is implemented by reading from the source block device
into memory and by writing this data to the destination block device.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-copy.c       | 229 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   1 +
 2 files changed, 230 insertions(+)

diff --git a/block/blk-copy.c b/block/blk-copy.c
index 8ac8879442f7..459ed8581efc 100644
--- a/block/blk-copy.c
+++ b/block/blk-copy.c
@@ -7,6 +7,26 @@
 #include <linux/blk-copy.h>
 #include <linux/blk-mq.h>
=20
+/**
+ * Tracks the state of a single onloaded copy operation.
+ * @params: Data copy parameters.
+ * @read_work: For scheduling read work.
+ * @write_work: For scheduling write work.
+ * @buf: Data buffer.
+ * @buf_len: Length in bytes of @buf.
+ * @offset: Current copying offset. Range: [0, @len[.
+ * @chunk: Size in bytes of the chunk of data that is being copied.
+ */
+struct blkdev_copy_onload_ctx {
+	struct blk_copy_params *params;
+	struct work_struct read_work;
+	struct work_struct write_work;
+	void *buf;
+	ssize_t buf_len;
+	loff_t offset;
+	loff_t chunk;
+};
+
 /* End all bios in the @ctx->bios list with status @ctx->status. */
 static void blkdev_end_bios(struct bio_copy_offload_ctx *ctx)
 {
@@ -353,3 +373,212 @@ int blkdev_copy_offload(struct blk_copy_params *par=
ams)
 	return -EIOCBQUEUED;
 }
 EXPORT_SYMBOL_GPL(blkdev_copy_offload);
+
+static void *blkdev_copy_alloc_buf(size_t req_size, size_t *alloc_size)
+{
+	unsigned int min_size =3D PAGE_SIZE;
+	char *buf;
+
+	while (req_size >=3D min_size) {
+		buf =3D kmalloc(req_size, GFP_NOIO | __GFP_NOWARN);
+		if (buf) {
+			*alloc_size =3D req_size;
+			return buf;
+		}
+		req_size >>=3D 1;
+	}
+
+	return NULL;
+}
+
+static struct bio *bio_map_buf(void *buf, unsigned int len)
+{
+	struct page *page;
+	struct bio *bio;
+	static const uint16_t nr_vecs =3D 1;
+
+	bio =3D bio_kmalloc(nr_vecs, GFP_NOIO);
+	if (!bio)
+		return NULL;
+	bio_init_inline(bio, /*bdev=3D*/NULL, /*max_vecs=3D*/nr_vecs, /*opf=3D*=
/0);
+
+	page =3D virt_to_page(buf);
+	if (bio_add_page(bio, page, len, offset_in_page(buf)) < len) {
+		/* we don't support partial mappings */
+		bio_uninit(bio);
+		kfree(bio);
+		WARN_ON_ONCE(true);
+		return NULL;
+	}
+
+	return bio;
+}
+
+static void blkdev_write_done(struct bio *bio)
+{
+	struct blkdev_copy_onload_ctx *ctx =3D bio->bi_copy_ctx;
+	struct blk_copy_params *params =3D ctx->params;
+	blk_status_t sts =3D bio->bi_status;
+
+	kfree(bio);
+
+	if (sts) {
+		params->status =3D sts;
+		params->end_io(params);
+		return;
+	}
+
+	ctx->offset +=3D ctx->chunk;
+
+	schedule_work(&ctx->read_work);
+}
+
+static sector_t blkdev_offset_to_out_pos(const struct blk_copy_params *p=
arams,
+					 loff_t offset)
+{
+	for (int i =3D 0; i < params->out_nseg; i++) {
+		loff_t rem =3D params->out_segs[i].len - offset;
+
+		if (rem > 0)
+			return params->out_segs[i].pos + offset;
+		offset -=3D params->out_segs[i].len;
+	}
+	return 0;
+}
+
+static void blkdev_write_work(struct work_struct *work)
+{
+	struct blkdev_copy_onload_ctx *ctx =3D
+		container_of(work, typeof(*ctx), read_work);
+	struct blk_copy_params *params =3D ctx->params;
+	struct bio *bio;
+	loff_t out_pos;
+
+	out_pos =3D blkdev_offset_to_out_pos(params, ctx->offset);
+
+	bio =3D bio_map_buf(ctx->buf, ctx->buf_len);
+	if (!bio) {
+		params->status =3D BLK_STS_AGAIN;
+		params->end_io(params);
+		return;
+	}
+	bio->bi_opf =3D REQ_OP_WRITE;
+	bio_set_dev(bio, params->out_bdev);
+	bio->bi_iter.bi_sector =3D out_pos >> SECTOR_SHIFT;
+	bio->bi_iter.bi_size =3D ctx->chunk;
+	bio->bi_end_io =3D blkdev_write_done;
+	bio->bi_copy_ctx =3D ctx;
+	submit_bio(bio);
+}
+
+static void blkdev_read_done(struct bio *bio)
+{
+	struct blkdev_copy_onload_ctx *ctx =3D bio->bi_copy_ctx;
+	struct blk_copy_params *params =3D ctx->params;
+	blk_status_t sts =3D bio->bi_status;
+
+	kfree(bio);
+
+	if (sts) {
+		params->status =3D sts;
+		params->end_io(params);
+		return;
+	}
+
+	schedule_work(&ctx->write_work);
+}
+
+static sector_t blkdev_offset_to_in_pos(const struct blk_copy_params *pa=
rams,
+					loff_t offset, loff_t *chunk)
+{
+	for (int i =3D 0; i < params->in_nseg; i++) {
+		loff_t rem =3D params->in_segs[i].len - offset;
+
+		if (rem > 0) {
+			if (*chunk > rem)
+				*chunk =3D rem;
+			return params->in_segs[i].pos + offset;
+		}
+		offset -=3D params->in_segs[i].len;
+	}
+	*chunk =3D 0;
+	return 0;
+}
+
+static void blkdev_read_work(struct work_struct *work)
+{
+	struct blkdev_copy_onload_ctx *ctx =3D
+		container_of(work, typeof(*ctx), read_work);
+	struct blk_copy_params *params =3D ctx->params;
+	loff_t offset =3D ctx->offset;
+	sector_t in_pos;
+	struct bio *bio;
+
+	ctx->chunk =3D min(ctx->buf_len, params->len - offset);
+	if (ctx->chunk)
+		in_pos =3D blkdev_offset_to_in_pos(params, offset, &ctx->chunk);
+	if (ctx->chunk =3D=3D 0) {
+		params->end_io(params);
+		return;
+	}
+
+	bio =3D bio_map_buf(ctx->buf, ctx->buf_len);
+	if (!bio) {
+		params->status =3D BLK_STS_AGAIN;
+		params->end_io(params);
+		return;
+	}
+	bio->bi_opf =3D REQ_OP_READ;
+	bio_set_dev(bio, params->in_bdev);
+	bio->bi_iter.bi_sector =3D in_pos >> SECTOR_SHIFT;
+	bio->bi_iter.bi_size =3D ctx->chunk;
+	bio->bi_end_io =3D blkdev_read_done;
+	bio->bi_copy_ctx =3D ctx;
+	submit_bio(bio);
+}
+
+/**
+ * blkdev_copy_onload - asynchronously copy data between two block devic=
es using
+ *	read and write operations.
+ * @params: Input and output block devices, input and output ranges and
+ *	completion callback pointer.
+ * Return: 0 upon success; -EIOCBQUEUED if the completion callback funct=
ion will
+ *	be called or has already been called.
+ */
+int blkdev_copy_onload(struct blk_copy_params *params)
+{
+	loff_t max_hw_bytes =3D
+		min(queue_max_hw_sectors(params->in_bdev->bd_queue),
+		    queue_max_hw_sectors(params->out_bdev->bd_queue)) <<
+		SECTOR_SHIFT;
+	struct blkdev_copy_onload_ctx *ctx;
+	loff_t len;
+	int ret;
+
+	ret =3D blkdev_copy_check_params(params, &len);
+	if (ret)
+		return ret;
+
+	params->len =3D len;
+
+	ctx =3D kzalloc_obj(*ctx);
+	if (!ctx)
+		return -ENOMEM;
+
+	INIT_WORK(&ctx->read_work, blkdev_read_work);
+	INIT_WORK(&ctx->write_work, blkdev_write_work);
+	ctx->params =3D params;
+
+	ctx->buf =3D blkdev_copy_alloc_buf(min(max_hw_bytes, len), &ctx->buf_le=
n);
+	if (!ctx->buf)
+		goto err;
+
+	blkdev_read_work(&ctx->read_work);
+
+	return -EIOCBQUEUED;
+
+err:
+	kfree(ctx);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(blkdev_copy_onload);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fea296150cda..817eeba2f207 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1284,6 +1284,7 @@ void __blkdev_issue_discard(struct block_device *bd=
ev, sector_t sector,
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector=
,
 		sector_t nr_sects, gfp_t gfp);
 int blkdev_copy_offload(struct blk_copy_params *params);
+int blkdev_copy_onload(struct blk_copy_params *params);
=20
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes =
*/
