Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE01DA103;
	Mon,  6 Jan 2025 08:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736152546; cv=none; b=kYYfAkdql+kA+TF4tIPueg93DBuKcBa0qn2Lz0kKkalh4iBy/gjZr6Lk5uNkC08/+S49ZLu0i75uMTZLq9wBoVeNl4sqm/An7pv/5cYQ91pjrBtH4daGYmLyH1RXqfPkeAr3Qcx2AAMCWaCPzy7FdgLJgqeFb8Stue0psN8c7D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736152546; c=relaxed/simple;
	bh=V7VA223K2lhcLy5j/K2WCv0EU7DHY4jDmAJUKwFmpDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpG5UoHBHqYL48pBNr0O58qHMT1duUu2okGSAu8WDLuUy4yC5kI/eQ/TE9Hv++eTFZGdNtluBbx6ZzdnB8hmk5WDacl/bQqEiaY0yTb8zGjF18c5Wj/8ZPM4rRqwYG7R6U5Fg14bqpgxKFuANMQzYgZlhL8ftVq7ZTaMN9dxpko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZBZKXW+F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZBZKXW+F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aJiCmeBuMbB7cHw2TQoob2VNqU2xzmL7dBAmsxp18Ew=; b=ZBZKXW+FkxQhhMvp6De3elYjDU
	DYcIj0eOvgCJbqjhHYayg1U5jNmDjrLPsTc2ywf0u2g7kJInsSGosShH+euO0mgE0xeb3PHaqcfqW
	s45GhLjRvkG8I9Fkqd41MRmiYzVLRsxgg+lnnwLF7mRC7uV6FDz/2ssmzgg6OK/bO7QKPLwT8Nl+I
	SDuzndgM/NCFbuIk0+ynPSi9j36wPiS/Vtfsof9IcQFXQ4TnYM0zeXwFi3XgFGMe7q3dPiQCHO8Gy
	1+TGkwJitXsECtgVRcWjbntxZYvOAJEnGaZ3FTNX5uSTmQf3d/W7R4O3+f5aQXxZ0cWAxFBi50/yU
	O/o1GO9Q==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUiaO-00000000XHA-0RmB;
	Mon, 06 Jan 2025 08:35:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] block: simplify tag allocation policy selection
Date: Mon,  6 Jan 2025 09:35:11 +0100
Message-ID: <20250106083531.799976-5-hch@lst.de>
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

Use a plain BLK_MQ_F_* flag to select the round robin tag selection
instead of overlaying an enum with just two possible values into the
flags space.

Doing so allows adding a BLK_MQ_F_MAX sentinel for simplified overflow
checking in the messy debugfs helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c                 | 25 ++++---------------------
 block/blk-mq-tag.c                     |  5 ++---
 block/blk-mq.c                         |  3 +--
 block/blk-mq.h                         |  2 +-
 drivers/ata/ahci.h                     |  2 +-
 drivers/ata/pata_macio.c               |  2 +-
 drivers/ata/sata_mv.c                  |  2 +-
 drivers/ata/sata_nv.c                  |  4 ++--
 drivers/ata/sata_sil24.c               |  1 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 drivers/scsi/scsi_lib.c                |  4 ++--
 include/linux/blk-mq.h                 | 22 +++++++---------------
 include/linux/libata.h                 |  4 ++--
 include/scsi/scsi_host.h               |  6 ++++--
 14 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 64b3c333aa47..adf5f0697b6b 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -172,19 +172,13 @@ static int hctx_state_show(void *data, struct seq_file *m)
 	return 0;
 }
 
-#define BLK_TAG_ALLOC_NAME(name) [BLK_TAG_ALLOC_##name] = #name
-static const char *const alloc_policy_name[] = {
-	BLK_TAG_ALLOC_NAME(FIFO),
-	BLK_TAG_ALLOC_NAME(RR),
-};
-#undef BLK_TAG_ALLOC_NAME
-
 #define HCTX_FLAG_NAME(name) [ilog2(BLK_MQ_F_##name)] = #name
 static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(TAG_QUEUE_SHARED),
 	HCTX_FLAG_NAME(STACKING),
 	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
 	HCTX_FLAG_NAME(BLOCKING),
+	HCTX_FLAG_NAME(TAG_RR),
 	HCTX_FLAG_NAME(NO_SCHED_BY_DEFAULT),
 };
 #undef HCTX_FLAG_NAME
@@ -192,22 +186,11 @@ static const char *const hctx_flag_name[] = {
 static int hctx_flags_show(void *data, struct seq_file *m)
 {
 	struct blk_mq_hw_ctx *hctx = data;
-	const int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(hctx->flags);
 
-	BUILD_BUG_ON(ARRAY_SIZE(hctx_flag_name) !=
-			BLK_MQ_F_ALLOC_POLICY_START_BIT);
-	BUILD_BUG_ON(ARRAY_SIZE(alloc_policy_name) != BLK_TAG_ALLOC_MAX);
+	BUILD_BUG_ON(ARRAY_SIZE(hctx_flag_name) != ilog2(BLK_MQ_F_MAX));
 
-	seq_puts(m, "alloc_policy=");
-	if (alloc_policy < ARRAY_SIZE(alloc_policy_name) &&
-	    alloc_policy_name[alloc_policy])
-		seq_puts(m, alloc_policy_name[alloc_policy]);
-	else
-		seq_printf(m, "%d", alloc_policy);
-	seq_puts(m, " ");
-	blk_flags_show(m,
-		       hctx->flags ^ BLK_ALLOC_POLICY_TO_MQ_FLAG(alloc_policy),
-		       hctx_flag_name, ARRAY_SIZE(hctx_flag_name));
+	blk_flags_show(m, hctx->flags, hctx_flag_name,
+			ARRAY_SIZE(hctx_flag_name));
 	seq_puts(m, "\n");
 	return 0;
 }
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index ab4a66791a20..b9f417d980b4 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -545,11 +545,10 @@ static int bt_alloc(struct sbitmap_queue *bt, unsigned int depth,
 }
 
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
-				     unsigned int reserved_tags,
-				     int node, int alloc_policy)
+		unsigned int reserved_tags, unsigned int flags, int node)
 {
 	unsigned int depth = total_tags - reserved_tags;
-	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
+	bool round_robin = flags & BLK_MQ_F_TAG_RR;
 	struct blk_mq_tags *tags;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 17f10683d640..2e6132f778fd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3476,8 +3476,7 @@ static struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
-				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
+	tags = blk_mq_init_tags(nr_tags, reserved_tags, set->flags, node);
 	if (!tags)
 		return NULL;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 3bb9ea80f9b6..c872bbbe6411 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -163,7 +163,7 @@ struct blk_mq_alloc_data {
 };
 
 struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
-		unsigned int reserved_tags, int node, int alloc_policy);
+		unsigned int reserved_tags, unsigned int flags, int node);
 void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 8f40f75ba08c..06781bdde0d2 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -396,7 +396,7 @@ extern const struct attribute_group *ahci_sdev_groups[];
 	.shost_groups		= ahci_shost_groups,			\
 	.sdev_groups		= ahci_sdev_groups,			\
 	.change_queue_depth     = ata_scsi_change_queue_depth,		\
-	.tag_alloc_policy       = BLK_TAG_ALLOC_RR,             	\
+	.tag_alloc_policy_rr	= true,					\
 	.device_configure	= ata_scsi_device_configure
 
 extern struct ata_port_operations ahci_ops;
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index f2f36e55a1f4..4b01bb6880b0 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -935,7 +935,7 @@ static const struct scsi_host_template pata_macio_sht = {
 	.device_configure	= pata_macio_device_configure,
 	.sdev_groups		= ata_common_sdev_groups,
 	.can_queue		= ATA_DEF_QUEUE,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.tag_alloc_policy_rr	= true,
 };
 
 static struct ata_port_operations pata_macio_ops = {
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index b8f363370e1a..21c72650f9cc 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -672,7 +672,7 @@ static const struct scsi_host_template mv6_sht = {
 	.dma_boundary		= MV_DMA_BOUNDARY,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.tag_alloc_policy_rr	= true,
 	.device_configure	= ata_scsi_device_configure
 };
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 36d99043ef50..823cce5ea1e9 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -385,7 +385,7 @@ static const struct scsi_host_template nv_adma_sht = {
 	.device_configure	= nv_adma_device_configure,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.tag_alloc_policy_rr	= true,
 };
 
 static const struct scsi_host_template nv_swncq_sht = {
@@ -396,7 +396,7 @@ static const struct scsi_host_template nv_swncq_sht = {
 	.device_configure	= nv_swncq_device_configure,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.tag_alloc_policy_rr	= true,
 };
 
 /*
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 72c03cbdaff4..935b13e79dec 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -378,7 +378,6 @@ static const struct scsi_host_template sil24_sht = {
 	.can_queue		= SIL24_MAX_CMDS,
 	.sg_tablesize		= SIL24_MAX_SGE,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.device_configure	= ata_scsi_device_configure
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 79129c977704..35501d0aa655 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3345,7 +3345,7 @@ static const struct scsi_host_template sht_v3_hw = {
 	.slave_alloc		= hisi_sas_slave_alloc,
 	.shost_groups		= host_v3_hw_groups,
 	.sdev_groups		= sdev_groups_v3_hw,
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
+	.tag_alloc_policy_rr	= true,
 	.host_reset             = hisi_sas_host_reset,
 	.host_tagset		= 1,
 	.mq_poll		= queue_complete_v3_hw,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5cf124e13097..51c496ca9380 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2065,8 +2065,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->queue_depth = shost->can_queue;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = dev_to_node(shost->dma_dev);
-	tag_set->flags |=
-		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+	if (shost->hostt->tag_alloc_policy_rr)
+		tag_set->flags |= BLK_MQ_F_TAG_RR;
 	if (shost->queuecommand_may_block)
 		tag_set->flags |= BLK_MQ_F_BLOCKING;
 	tag_set->driver_data = shost;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f2ff0ffa0535..a0a9007cc1e3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -296,13 +296,6 @@ enum blk_eh_timer_return {
 	BLK_EH_RESET_TIMER,
 };
 
-/* Keep alloc_policy_name[] in sync with the definitions below */
-enum {
-	BLK_TAG_ALLOC_FIFO,	/* allocate starting from 0 */
-	BLK_TAG_ALLOC_RR,	/* allocate starting from last allocated tag */
-	BLK_TAG_ALLOC_MAX
-};
-
 /**
  * struct blk_mq_hw_ctx - State for a hardware queue facing the hardware
  * block device
@@ -677,20 +670,19 @@ enum {
 	BLK_MQ_F_TAG_HCTX_SHARED = 1 << 3,
 	BLK_MQ_F_BLOCKING	= 1 << 4,
 
+	/*
+	 * Alloc tags on a round-robin base instead of the first available one.
+	 */
+	BLK_MQ_F_TAG_RR		= 1 << 5,
+
 	/*
 	 * Select 'none' during queue registration in case of a single hwq
 	 * or shared hwqs instead of 'mq-deadline'.
 	 */
 	BLK_MQ_F_NO_SCHED_BY_DEFAULT	= 1 << 6,
-	BLK_MQ_F_ALLOC_POLICY_START_BIT = 7,
-	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
+
+	BLK_MQ_F_MAX = 1 << 7,
 };
-#define BLK_MQ_FLAG_TO_ALLOC_POLICY(flags) \
-	((flags >> BLK_MQ_F_ALLOC_POLICY_START_BIT) & \
-		((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1))
-#define BLK_ALLOC_POLICY_TO_MQ_FLAG(policy) \
-	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
-		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
 
 #define BLK_MQ_MAX_DEPTH	(10240)
 #define BLK_MQ_NO_HCTX_IDX	(-1U)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c1a85d46eba6..be5183d75736 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1467,13 +1467,13 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 #define ATA_SUBBASE_SHT(drv_name)				\
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		= ATA_DEF_QUEUE,		\
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
+	.tag_alloc_policy_rr	= true,				\
 	.device_configure	= ata_scsi_device_configure
 
 #define ATA_SUBBASE_SHT_QD(drv_name, drv_qd)			\
 	__ATA_BASE_SHT(drv_name),				\
 	.can_queue		= drv_qd,			\
-	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,		\
+	.tag_alloc_policy_rr	= true,				\
 	.device_configure	= ata_scsi_device_configure
 
 #define ATA_BASE_SHT(drv_name)					\
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2b4ab0369ffb..02823d6af37d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -438,8 +438,10 @@ struct scsi_host_template {
 	 */
 	short cmd_per_lun;
 
-	/* If use block layer to manage tags, this is tag allocation policy */
-	int tag_alloc_policy;
+	/*
+	 * Allocate tags starting from last allocated tag.
+	 */
+	bool tag_alloc_policy_rr : 1;
 
 	/*
 	 * Track QUEUE_FULL events and reduce queue depth on demand.
-- 
2.45.2

