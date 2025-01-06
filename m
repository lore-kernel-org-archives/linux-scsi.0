Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585E41D618E;
	Mon,  6 Jan 2025 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736152544; cv=none; b=mq0/4pyK5vj6WE0t9C/N/t5k+/TZHo+UkD7XxFvz3fCBmq9hCf0tPlWwtsxcpnP93nFzwMmbfcb1eqI47o2DLD+heJMKrspSQfz9r4OBzZepJD9oMTLFpxiRq+IkyqM7bqQB8YJgZK6wGo8LLxKaMyUdEibkhqYWJgjkmd37GZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736152544; c=relaxed/simple;
	bh=gg7D7SSxNOxz95SEyDgDxOAqDYGHOYO2Ts3Mu8zMzRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhCL0RK4+F3lzrE7rSAJTVwNhw4PLV6fkn09BIhELCRjHeDsUfSg0sn6QbjQPa5pwoLLRQF805sGFOyAuM85i6yF0O4fKSUHfJ26jKH3Y0YAduoaTajZemJQN8YylgEZDgXzZUco7UsJpheW00T7geOOD+lchydJ34cEgDhi6jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j2Ap7DhA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j2Ap7DhA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LM5IMKhTYo0FleSZhUI1BRrSHoN4f8wpWkes3cOuDFA=; b=j2Ap7DhAK+flUf5Q+LTRmH/ira
	UigLnTQ0gMrcY0rSz2TDeXHIzGipTzEwqLtJG1xx5uD3XphmnrFDc9+RqHS4gZm/cwRhSgUPKaEUk
	ibW67vgLQNsRexJpmZViW6O3iplExrWuFZ6pYlum6sdDSgPQ2xsrf+xZ1HVD85iBJ1IKgQ9ufAgE9
	qoSLIJ1aeX5XXZnEOnGboQ80xJvVEoZYqSzf31OCbmdGQmSrd6TTTerkItyAGShHKHMx3+9OGcAuw
	UbkO7y2clROPRxKENg1ArDp0XX9Hf52hyKfsSL5LT/X3IYBEe+bIC94zj1N/xA6kSBcbYQsb7WXuO
	psZtKpJQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUiaL-00000000XGY-2Ihs;
	Mon, 06 Jan 2025 08:35:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] block: remove BLK_MQ_F_NO_SCHED
Date: Mon,  6 Jan 2025 09:35:10 +0100
Message-ID: <20250106083531.799976-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106083531.799976-1-hch@lst.de>
References: <20250106083531.799976-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only queues that really can't support a scheduler are those that
do not have a gendisk associated with them, and thus can't be used for
non-passthrough commands.  In addition to those null_blk can optionally
set the flag, which is a bad odd.  Replace the null_blk usage with
BLK_MQ_F_NO_SCHED_BY_DEFAULT to keep the expected semantics and then
remove BLK_MQ_F_NO_SCHED as the non-disk queues never call into
elevator_init_mq or blk_register_queue which adds the sysfs attributes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c        |  1 -
 block/bsg-lib.c               |  2 +-
 block/elevator.c              | 20 --------------------
 drivers/block/null_blk/main.c |  4 ++--
 drivers/nvme/host/apple.c     |  1 -
 drivers/nvme/host/core.c      |  1 -
 drivers/ufs/core/ufshcd.c     |  1 -
 include/linux/blk-mq.h        |  2 --
 8 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4b6b20ccdb53..64b3c333aa47 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -185,7 +185,6 @@ static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(STACKING),
 	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
 	HCTX_FLAG_NAME(BLOCKING),
-	HCTX_FLAG_NAME(NO_SCHED),
 	HCTX_FLAG_NAME(NO_SCHED_BY_DEFAULT),
 };
 #undef HCTX_FLAG_NAME
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 32da4a4429ce..93523d8f8195 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -381,7 +381,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	set->queue_depth = 128;
 	set->numa_node = NUMA_NO_NODE;
 	set->cmd_size = sizeof(struct bsg_job) + dd_job_size;
-	set->flags = BLK_MQ_F_NO_SCHED | BLK_MQ_F_BLOCKING;
+	set->flags = BLK_MQ_F_BLOCKING;
 	if (blk_mq_alloc_tag_set(set))
 		goto out_tag_set;
 
diff --git a/block/elevator.c b/block/elevator.c
index be6e994256ac..b81216c48b6b 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -547,14 +547,6 @@ void elv_unregister(struct elevator_type *e)
 }
 EXPORT_SYMBOL_GPL(elv_unregister);
 
-static inline bool elv_support_iosched(struct request_queue *q)
-{
-	if (!queue_is_mq(q) ||
-	    (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
-		return false;
-	return true;
-}
-
 /*
  * For single queue devices, default to using mq-deadline. If we have multiple
  * queues or mq-deadline is not available, default to "none".
@@ -580,9 +572,6 @@ void elevator_init_mq(struct request_queue *q)
 	struct elevator_type *e;
 	int err;
 
-	if (!elv_support_iosched(q))
-		return;
-
 	WARN_ON_ONCE(blk_queue_registered(q));
 
 	if (unlikely(q->elevator))
@@ -714,9 +703,6 @@ void elv_iosched_load_module(struct gendisk *disk, const char *buf,
 	struct elevator_type *found;
 	const char *name;
 
-	if (!elv_support_iosched(disk->queue))
-		return;
-
 	strscpy(elevator_name, buf, sizeof(elevator_name));
 	name = strstrip(elevator_name);
 
@@ -734,9 +720,6 @@ ssize_t elv_iosched_store(struct gendisk *disk, const char *buf,
 	char elevator_name[ELV_NAME_MAX];
 	int ret;
 
-	if (!elv_support_iosched(disk->queue))
-		return count;
-
 	strscpy(elevator_name, buf, sizeof(elevator_name));
 	ret = elevator_change(disk->queue, strstrip(elevator_name));
 	if (!ret)
@@ -751,9 +734,6 @@ ssize_t elv_iosched_show(struct gendisk *disk, char *name)
 	struct elevator_type *cur = NULL, *e;
 	int len = 0;
 
-	if (!elv_support_iosched(q))
-		return sprintf(name, "none\n");
-
 	if (!q->elevator) {
 		len += sprintf(name+len, "[none] ");
 	} else {
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 178e62cd9a9f..d94ef37480bd 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1792,7 +1792,7 @@ static int null_init_global_tag_set(void)
 	tag_set.queue_depth = g_hw_queue_depth;
 	tag_set.numa_node = g_home_node;
 	if (g_no_sched)
-		tag_set.flags |= BLK_MQ_F_NO_SCHED;
+		tag_set.flags |= BLK_MQ_F_NO_SCHED_BY_DEFAULT;
 	if (g_shared_tag_bitmap)
 		tag_set.flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 	if (g_blocking)
@@ -1817,7 +1817,7 @@ static int null_setup_tagset(struct nullb *nullb)
 	nullb->tag_set->queue_depth = nullb->dev->hw_queue_depth;
 	nullb->tag_set->numa_node = nullb->dev->home_node;
 	if (nullb->dev->no_sched)
-		nullb->tag_set->flags |= BLK_MQ_F_NO_SCHED;
+		nullb->tag_set->flags |= BLK_MQ_F_NO_SCHED_BY_DEFAULT;
 	if (nullb->dev->shared_tag_bitmap)
 		nullb->tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 	if (nullb->dev->blocking)
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 83c60468542c..1de11b722f04 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1251,7 +1251,6 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
 	anv->admin_tagset.timeout = NVME_ADMIN_TIMEOUT;
 	anv->admin_tagset.numa_node = NUMA_NO_NODE;
 	anv->admin_tagset.cmd_size = sizeof(struct apple_nvme_iod);
-	anv->admin_tagset.flags = BLK_MQ_F_NO_SCHED;
 	anv->admin_tagset.driver_data = &anv->adminq;
 
 	ret = blk_mq_alloc_tag_set(&anv->admin_tagset);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 42283d268500..c2250ddef5a2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4564,7 +4564,6 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		/* Reserved for fabric connect and keep alive */
 		set->reserved_tags = 2;
 	set->numa_node = ctrl->numa_node;
-	set->flags = BLK_MQ_F_NO_SCHED;
 	if (ctrl->ops->flags & NVME_F_BLOCKING)
 		set->flags |= BLK_MQ_F_BLOCKING;
 	set->cmd_size = cmd_size;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8a01e4393159..fd53c9f402c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10412,7 +10412,6 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba)
 		.nr_hw_queues	= 1,
 		.queue_depth	= hba->nutmrs,
 		.ops		= &ufshcd_tmf_ops,
-		.flags		= BLK_MQ_F_NO_SCHED,
 	};
 	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
 	if (err < 0)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 6340293511c9..f2ff0ffa0535 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -676,8 +676,6 @@ enum {
 	BLK_MQ_F_STACKING	= 1 << 2,
 	BLK_MQ_F_TAG_HCTX_SHARED = 1 << 3,
 	BLK_MQ_F_BLOCKING	= 1 << 4,
-	/* Do not allow an I/O scheduler to be configured. */
-	BLK_MQ_F_NO_SCHED	= 1 << 5,
 
 	/*
 	 * Select 'none' during queue registration in case of a single hwq
-- 
2.45.2

