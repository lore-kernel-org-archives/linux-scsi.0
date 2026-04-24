Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFC3FE666;
	Fri, 24 Apr 2026 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070584; cv=none; b=mMu1q2rSbKsryka8bCqj8TUeKtLZcAWS6CtEAtKGO8GRxmPYiV5Tkzncg+WyNDziUH4D648EMVKJuL8LbqGwmGjOPIVG8UjeMZ0yVr29Ox3n4seuHEK2Nf9c4oPNRIlh4bNNWjhohxBdG3ND7beiDmKVzJyLMOPEKYtLfWVEbOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070584; c=relaxed/simple;
	bh=5ovqL9xPqeVjuUQy81Uq20IpAnhVWNcmYYb40rBnUo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j82Sg6KXOv6ZODkdwM79FAKd67RdlQMmxaoPJkD41pQDPL2krshWZ+RbghKn8DcHVmo6c6LWsfvvFCJpM4OkzRC0v1sgAf3ywh/F3BzU6YsO88B8FWQtdxtcHiUeucMtvN/k+wVUXuhPa2b4wNvYIC6RjdIBrvnRu5zestaXqME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D9Jkjewt; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D9Jkjewt"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sf62qVKz1XLHYm;
	Fri, 24 Apr 2026 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070561; x=1779662562; bh=g39KJ
	h8H5bvlbH1BFc1G54n+h5+QCxvi0MIftjWuRkA=; b=D9Jkjewtjunv4m7S7Myfk
	fzRwNDP5EBTyXKOySiXsFlSyw6Yl7KkqMOCvT3E4Bu/rZYjryL2P04WKOg3KPh2v
	kncxT/Ea2KVoglrM4q/jwjg9svVVWwniWPN0XhYW7+6aYJaoJKixeROeLgPOYloY
	X4v8AH7Qgq2HMxpOQOclufhiUaQ6wJnVBP2Tp2BX2FSykVgv80C9MLK9UqeDgS7W
	Ty3+5MJjz4kUakaFwwXja2wcTdHoKTqGxdRtHVGRMvHnKKeFJq/lGb2GEoSWdKh8
	vNXepOJ1DmrRJQ+xEq6fHGYrE1qaVAjc+lWFfsEW497yDDlrzBAcPnt0uSsMg6Xj
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cC15Geao2HOZ; Fri, 24 Apr 2026 22:42:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdq0F5mz1XLHYt;
	Fri, 24 Apr 2026 22:42:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 12/12] null_blk: Add support for REQ_OP_COPY_*
Date: Fri, 24 Apr 2026 15:42:01 -0700
Message-ID: <20260424224201.1949243-13-bvanassche@acm.org>
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

Implementation is based on existing read and write infrastructure.
copy_max_bytes: A new configfs and module parameter is introduced, which
can be used to set hardware/driver supported maximum copy limit.
Only request based queue mode will support for copy offload.
Added tracefs support to copy IO tracing.

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
[ bvanassche: Split nullb_do_copy() into two functions. Added a
  cond_resched() call inside nullb_do_copy(). ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/block/null_blk.rst  |   4 ++
 drivers/block/null_blk/main.c     | 113 ++++++++++++++++++++++++++++++
 drivers/block/null_blk/null_blk.h |   1 +
 3 files changed, 118 insertions(+)

diff --git a/Documentation/block/null_blk.rst b/Documentation/block/null_=
blk.rst
index 4dd78f24d10a..ea0616dbf7f3 100644
--- a/Documentation/block/null_blk.rst
+++ b/Documentation/block/null_blk.rst
@@ -149,3 +149,7 @@ zone_size=3D[MB]: Default: 256
 zone_nr_conv=3D[nr_conv]: Default: 0
   The number of conventional zones to create when block device is zoned.=
  If
   zone_nr_conv >=3D nr_zones, it will be reduced to nr_zones - 1.
+
+max_copy_bytes=3D[size in bytes]: Default: UINT_MAX
+  A module and configfs parameter which can be used to set hardware/driv=
er
+  supported maximum copy offload limit.
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.=
c
index f8c0fd57e041..87a2f3536b50 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/blk-copy.h>
 #include "null_blk.h"
=20
 #undef pr_fmt
@@ -169,6 +170,10 @@ static int g_max_sectors;
 module_param_named(max_sectors, g_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sector=
s)");
=20
+static unsigned long g_max_copy_bytes =3D UINT_MAX;
+module_param_named(max_copy_bytes, g_max_copy_bytes, ulong, 0444);
+MODULE_PARM_DESC(max_copy_bytes, "Maximum size of a copy command (in byt=
es)");
+
 static unsigned int nr_devices =3D 1;
 module_param(nr_devices, uint, 0444);
 MODULE_PARM_DESC(nr_devices, "Number of devices to register");
@@ -450,6 +455,7 @@ NULLB_DEVICE_ATTR(home_node, uint, NULL);
 NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
 NULLB_DEVICE_ATTR(blocksize, uint, NULL);
 NULLB_DEVICE_ATTR(max_sectors, uint, NULL);
+NULLB_DEVICE_ATTR(max_copy_bytes, uint, NULL);
 NULLB_DEVICE_ATTR(irqmode, uint, NULL);
 NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
 NULLB_DEVICE_ATTR(index, uint, NULL);
@@ -601,6 +607,7 @@ static struct configfs_attribute *nullb_device_attrs[=
] =3D {
 	&nullb_device_attr_blocksize,
 	&nullb_device_attr_cache_size,
 	&nullb_device_attr_completion_nsec,
+	&nullb_device_attr_max_copy_bytes,
 	&nullb_device_attr_discard,
 	&nullb_device_attr_fua,
 	&nullb_device_attr_home_node,
@@ -805,6 +812,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->queue_mode =3D g_queue_mode;
 	dev->blocksize =3D g_bs;
 	dev->max_sectors =3D g_max_sectors;
+	dev->max_copy_bytes =3D g_max_copy_bytes;
 	dev->irqmode =3D g_irqmode;
 	dev->hw_queue_depth =3D g_hw_queue_depth;
 	dev->blocking =3D g_blocking;
@@ -1275,6 +1283,96 @@ static blk_status_t null_transfer(struct nullb *nu=
llb, struct page *page,
 	return err;
 }
=20
+static ssize_t nullb_copy_sector(struct nullb *nullb, sector_t sector_in=
,
+				 sector_t sector_out, ssize_t rem, bool is_fua)
+{
+	struct nullb_page *t_page_in, *t_page_out;
+	loff_t offset_in, offset_out;
+	void *in, *out;
+	ssize_t chunk;
+
+	chunk =3D min_t(size_t, nullb->dev->blocksize, rem);
+	offset_in =3D (sector_in & SECTOR_MASK) << SECTOR_SHIFT;
+	offset_out =3D (sector_out & SECTOR_MASK) << SECTOR_SHIFT;
+
+	guard(spinlock_irq)(&nullb->lock);
+
+	if (null_cache_active(nullb) && !is_fua)
+		null_make_cache_space(nullb, PAGE_SIZE);
+
+	t_page_in =3D null_insert_page(nullb, sector_in,
+				     !null_cache_active(nullb));
+	if (!t_page_in)
+		return -1;
+	t_page_out =3D null_insert_page(nullb, sector_out,
+				      !null_cache_active(nullb) || is_fua);
+	if (!t_page_out)
+		return -1;
+
+	in =3D kmap_local_page(t_page_in->page);
+	out =3D kmap_local_page(t_page_out->page);
+	memcpy(out + offset_out, in + offset_in, chunk);
+	kunmap_local(out);
+	kunmap_local(in);
+
+	__set_bit(sector_out & SECTOR_MASK, t_page_out->bitmap);
+
+	if (is_fua)
+		null_free_sector(nullb, sector_out, true);
+
+	return chunk;
+}
+
+static blk_status_t nullb_do_copy(struct nullb *nullb, struct request *r=
q)
+{
+	sector_t sector_in, sector_in_end, sector_out, sector_out_end;
+	struct bio_copy_offload_ctx *copy_ctx =3D rq->bio->bi_copy_ctx;
+	ssize_t chunk, rem =3D copy_ctx->len;
+	struct bio *src_bio, *dst_bio;
+
+	src_bio =3D blk_first_copy_bio(rq, REQ_OP_COPY_SRC);
+	dst_bio =3D blk_first_copy_bio(rq, REQ_OP_COPY_DST);
+
+	if (WARN_ON_ONCE(!src_bio || !dst_bio))
+		return BLK_STS_IOERR;
+
+	sector_in =3D src_bio->bi_iter.bi_sector;
+	sector_in_end =3D sector_in + (src_bio->bi_iter.bi_size >> SECTOR_SHIFT=
);
+	sector_out =3D dst_bio->bi_iter.bi_sector;
+	sector_out_end =3D sector_out + (dst_bio->bi_iter.bi_size >> SECTOR_SHI=
FT);
+
+	while (rem > 0) {
+		chunk =3D nullb_copy_sector(nullb, sector_in, sector_out, rem,
+					  rq->cmd_flags & REQ_FUA);
+		if (chunk < 0)
+			return BLK_STS_IOERR;
+		rem -=3D chunk;
+		if (!rem)
+			break;
+		sector_in +=3D chunk >> SECTOR_SHIFT;
+		if (sector_in >=3D sector_in_end) {
+			src_bio =3D blk_next_copy_bio(src_bio);
+			if (WARN_ON_ONCE(!src_bio))
+				return BLK_STS_IOERR;
+			sector_in =3D src_bio->bi_iter.bi_sector;
+			sector_in_end =3D sector_in +
+				(src_bio->bi_iter.bi_size >> SECTOR_SHIFT);
+		}
+		sector_out +=3D chunk >> SECTOR_SHIFT;
+		if (sector_out >=3D sector_out_end) {
+			dst_bio =3D blk_next_copy_bio(dst_bio);
+			if (WARN_ON_ONCE(!dst_bio))
+				return BLK_STS_IOERR;
+			sector_out =3D dst_bio->bi_iter.bi_sector;
+			sector_out_end =3D sector_out +
+				(dst_bio->bi_iter.bi_size >> SECTOR_SHIFT);
+		}
+		cond_resched();
+	}
+
+	return BLK_STS_OK;
+}
+
 /*
  * Transfer data for the given request. The transfer size is capped with=
 the
  * nr_sectors argument.
@@ -1292,6 +1390,9 @@ static blk_status_t null_handle_data_transfer(struc=
t nullb_cmd *cmd,
 	struct req_iterator iter;
 	struct bio_vec bvec;
=20
+	if (op_is_copy(req_op(rq)))
+		return nullb_do_copy(nullb, rq);
+
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
 		len =3D bvec.bv_len;
@@ -1806,6 +1907,13 @@ static void null_config_discard(struct nullb *null=
b, struct queue_limits *lim)
 	lim->max_hw_discard_sectors =3D UINT_MAX >> 9;
 }
=20
+static void null_config_copy(struct nullb *nullb, struct queue_limits *l=
im)
+{
+	lim->max_copy_hw_sectors =3D nullb->dev->max_copy_bytes >> SECTOR_SHIFT=
;
+	lim->max_copy_src_segments =3D nullb->dev->max_copy_bytes ? U16_MAX : 0=
;
+	lim->max_copy_dst_segments =3D lim->max_copy_src_segments;
+}
+
 static const struct block_device_operations null_ops =3D {
 	.owner		=3D THIS_MODULE,
 	.report_zones	=3D null_report_zones,
@@ -1922,6 +2030,9 @@ static int null_validate_conf(struct nullb_device *=
dev)
 		return -EINVAL;
 	}
=20
+	if (dev->queue_mode =3D=3D NULL_Q_BIO)
+		dev->max_copy_bytes =3D 0;
+
 	return 0;
 }
=20
@@ -1989,6 +2100,8 @@ static int null_add_dev(struct nullb_device *dev)
 	if (dev->virt_boundary)
 		lim.virt_boundary_mask =3D PAGE_SIZE - 1;
 	null_config_discard(nullb, &lim);
+	null_config_copy(nullb, &lim);
+
 	if (dev->zoned) {
 		rv =3D null_init_zoned_dev(dev, &lim);
 		if (rv)
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/n=
ull_blk.h
index 6c4c4bbe7dad..c15c319ed91b 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -93,6 +93,7 @@ struct nullb_device {
 	unsigned int queue_mode; /* block interface */
 	unsigned int blocksize; /* block size */
 	unsigned int max_sectors; /* Max sectors per command */
+	unsigned long max_copy_bytes; /* Max copy offload length in bytes */
 	unsigned int irqmode; /* IRQ completion handler */
 	unsigned int hw_queue_depth; /* queue depth */
 	unsigned int index; /* index of the disk, only valid with a disk */
