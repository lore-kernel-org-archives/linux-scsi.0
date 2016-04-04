From: Ming Lin <mlin@kernel.org>
Subject: [PATCH v3 4/5] scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
Date: Mon, 04 Apr 2016 14:48:10 -0700
Message-ID: <1459806491-16428-5-git-send-email-mlin@kernel.org>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1459806491-16428-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

Rename SCSI_MAX_SG_SEGMENTS to SG_CHUNK_SIZE, which means the amount
we fit into a single scatterlist chunk.

Rename SCSI_MAX_SG_CHAIN_SEGMENTS to SG_MAX_SEGMENTS.

Will move these 2 generic definitions to scatterlist.h later.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Bart Van Assche <bart.vanassche@sandisk.com> (for ib_srp changes)
Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
---
 drivers/ata/pata_icside.c           |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c |  4 ++--
 drivers/scsi/arm/cumana_2.c         |  2 +-
 drivers/scsi/arm/eesox.c            |  2 +-
 drivers/scsi/arm/powertec.c         |  2 +-
 drivers/scsi/esas2r/esas2r_main.c   |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas.h    |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 +-
 drivers/scsi/scsi_debug.c           |  2 +-
 drivers/scsi/scsi_lib.c             | 34 +++++++++++++++++-----------------
 drivers/usb/storage/scsiglue.c      |  2 +-
 include/scsi/scsi.h                 |  8 ++++----
 include/scsi/scsi_host.h            |  2 +-
 14 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index d7c7320..188f2f2 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -294,7 +294,7 @@ static int icside_dma_init(struct pata_icside_info *info)
 
 static struct scsi_host_template pata_icside_sht = {
 	ATA_BASE_SHT(DRV_NAME),
-	.sg_tablesize		= SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize		= SG_MAX_SEGMENTS,
 	.dma_boundary		= IOMD_DMA_BOUNDARY,
 };
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ff21597..369a75e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -81,7 +81,7 @@ MODULE_PARM_DESC(cmd_sg_entries,
 
 module_param(indirect_sg_entries, uint, 0444);
 MODULE_PARM_DESC(indirect_sg_entries,
-		 "Default max number of gather/scatter entries (default is 12, max is " __stringify(SCSI_MAX_SG_CHAIN_SEGMENTS) ")");
+		 "Default max number of gather/scatter entries (default is 12, max is " __stringify(SG_MAX_SEGMENTS) ")");
 
 module_param(allow_ext_sg, bool, 0444);
 MODULE_PARM_DESC(allow_ext_sg,
@@ -3097,7 +3097,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 
 		case SRP_OPT_SG_TABLESIZE:
 			if (match_int(args, &token) || token < 1 ||
-					token > SCSI_MAX_SG_CHAIN_SEGMENTS) {
+					token > SG_MAX_SEGMENTS) {
 				pr_warn("bad max sg_tablesize parameter '%s'\n",
 					p);
 				goto out;
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index faa1bee..edce5f3 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -365,7 +365,7 @@ static struct scsi_host_template cumanascsi2_template = {
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
-	.sg_tablesize			= SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize			= SG_MAX_SEGMENTS,
 	.dma_boundary			= IOMD_DMA_BOUNDARY,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "cumanascsi2",
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index a8ad688..e93e047 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -484,7 +484,7 @@ static struct scsi_host_template eesox_template = {
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
-	.sg_tablesize			= SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize			= SG_MAX_SEGMENTS,
 	.dma_boundary			= IOMD_DMA_BOUNDARY,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.proc_name			= "eesox",
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 5e1b73e..79aa889 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -291,7 +291,7 @@ static struct scsi_host_template powertecscsi_template = {
 
 	.can_queue			= 8,
 	.this_id			= 7,
-	.sg_tablesize			= SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize			= SG_MAX_SEGMENTS,
 	.dma_boundary			= IOMD_DMA_BOUNDARY,
 	.cmd_per_lun			= 2,
 	.use_clustering			= ENABLE_CLUSTERING,
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 33581ba..2aca4d1 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -246,7 +246,7 @@ static struct scsi_host_template driver_template = {
 	.eh_target_reset_handler	= esas2r_target_reset,
 	.can_queue			= 128,
 	.this_id			= -1,
-	.sg_tablesize			= SCSI_MAX_SG_SEGMENTS,
+	.sg_tablesize			= SG_CHUNK_SIZE,
 	.cmd_per_lun			=
 		ESAS2R_DEFAULT_CMD_PER_LUN,
 	.present			= 0,
@@ -271,7 +271,7 @@ module_param(num_sg_lists, int, 0);
 MODULE_PARM_DESC(num_sg_lists,
 		 "Number of scatter/gather lists.  Default 1024.");
 
-int sg_tablesize = SCSI_MAX_SG_SEGMENTS;
+int sg_tablesize = SG_CHUNK_SIZE;
 module_param(sg_tablesize, int, 0);
 MODULE_PARM_DESC(sg_tablesize,
 		 "Maximum number of entries in a scatter/gather table.");
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 29e89f3..fa12eea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -298,7 +298,7 @@ struct hisi_sas_command_table_stp {
 	u8	atapi_cdb[ATAPI_CDB_LEN];
 };
 
-#define HISI_SAS_SGE_PAGE_CNT SCSI_MAX_SG_SEGMENTS
+#define HISI_SAS_SGE_PAGE_CNT SG_CHUNK_SIZE
 struct hisi_sas_sge_page {
 	struct hisi_sas_sge sge[HISI_SAS_SGE_PAGE_CNT];
 };
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c44b9c..28d8531 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3207,10 +3207,10 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 		sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
 	else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
 		sg_tablesize = min_t(unsigned short, sg_tablesize,
-				      SCSI_MAX_SG_CHAIN_SEGMENTS);
+				      SG_MAX_SEGMENTS);
 		pr_warn(MPT3SAS_FMT
 		 "sg_tablesize(%u) is bigger than kernel"
-		 " defined SCSI_MAX_SG_SEGMENTS(%u)\n", ioc->name,
+		 " defined SG_CHUNK_SIZE(%u)\n", ioc->name,
 		 sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
 	}
 	ioc->shost->sg_tablesize = sg_tablesize;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 32580b5..6940c57 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -90,7 +90,7 @@
 /*
  * Set MPT3SAS_SG_DEPTH value based on user input.
  */
-#define MPT_MAX_PHYS_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#define MPT_MAX_PHYS_SEGMENTS	SG_CHUNK_SIZE
 #define MPT_MIN_PHYS_SEGMENTS	16
 
 #ifdef CONFIG_SCSI_MPT3SAS_MAX_SGE
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f3d69a98..06b1517 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5305,7 +5305,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.eh_host_reset_handler = scsi_debug_host_reset,
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
-	.sg_tablesize =		SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize =		SG_MAX_SEGMENTS,
 	.cmd_per_lun =		DEF_CMD_PER_LUN,
 	.max_sectors =		-1U,
 	.use_clustering = 	DISABLE_CLUSTERING,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 08134f6..8f776f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -51,25 +51,25 @@ struct sg_pool {
 };
 
 #define SP(x) { .size = x, "sgpool-" __stringify(x) }
-#if (SCSI_MAX_SG_SEGMENTS < 32)
-#error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
+#if (SG_CHUNK_SIZE < 32)
+#error SG_CHUNK_SIZE is too small (must be 32 or greater)
 #endif
 static struct sg_pool sg_pools[] = {
 	SP(8),
 	SP(16),
-#if (SCSI_MAX_SG_SEGMENTS > 32)
+#if (SG_CHUNK_SIZE > 32)
 	SP(32),
-#if (SCSI_MAX_SG_SEGMENTS > 64)
+#if (SG_CHUNK_SIZE > 64)
 	SP(64),
-#if (SCSI_MAX_SG_SEGMENTS > 128)
+#if (SG_CHUNK_SIZE > 128)
 	SP(128),
-#if (SCSI_MAX_SG_SEGMENTS > 256)
-#error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
+#if (SG_CHUNK_SIZE > 256)
+#error SG_CHUNK_SIZE is too large (256 MAX)
 #endif
 #endif
 #endif
 #endif
-	SP(SCSI_MAX_SG_SEGMENTS)
+	SP(SG_CHUNK_SIZE)
 };
 #undef SP
 
@@ -557,7 +557,7 @@ static inline unsigned int sg_pool_index(unsigned short nents)
 {
 	unsigned int index;
 
-	BUG_ON(nents > SCSI_MAX_SG_SEGMENTS);
+	BUG_ON(nents > SG_CHUNK_SIZE);
 
 	if (nents <= 8)
 		index = 0;
@@ -585,9 +585,9 @@ static struct scatterlist *sg_pool_alloc(unsigned int nents, gfp_t gfp_mask)
 
 static void sg_free_table_chained(struct sg_table *table, bool first_chunk)
 {
-	if (first_chunk && table->orig_nents <= SCSI_MAX_SG_SEGMENTS)
+	if (first_chunk && table->orig_nents <= SG_CHUNK_SIZE)
 		return;
-	__sg_free_table(table, SCSI_MAX_SG_SEGMENTS, first_chunk, sg_pool_free);
+	__sg_free_table(table, SG_CHUNK_SIZE, first_chunk, sg_pool_free);
 }
 
 static int sg_alloc_table_chained(struct sg_table *table, int nents,
@@ -598,14 +598,14 @@ static int sg_alloc_table_chained(struct sg_table *table, int nents,
 	BUG_ON(!nents);
 
 	if (first_chunk) {
-		if (nents <= SCSI_MAX_SG_SEGMENTS) {
+		if (nents <= SG_CHUNK_SIZE) {
 			table->nents = table->orig_nents = nents;
 			sg_init_table(table->sgl, nents);
 			return 0;
 		}
 	}
 
-	ret = __sg_alloc_table(table, nents, SCSI_MAX_SG_SEGMENTS,
+	ret = __sg_alloc_table(table, nents, SG_CHUNK_SIZE,
 			       first_chunk, GFP_ATOMIC, sg_pool_alloc);
 	if (unlikely(ret))
 		sg_free_table_chained(table, (bool)first_chunk);
@@ -1937,7 +1937,7 @@ static int scsi_mq_prep_fn(struct request *req)
 	if (scsi_host_get_prot(shost)) {
 		cmd->prot_sdb = (void *)sg +
 			min_t(unsigned int,
-			      shost->sg_tablesize, SCSI_MAX_SG_SEGMENTS) *
+			      shost->sg_tablesize, SG_CHUNK_SIZE) *
 			sizeof(struct scatterlist);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
@@ -2110,7 +2110,7 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	 * this limit is imposed by hardware restrictions
 	 */
 	blk_queue_max_segments(q, min_t(unsigned short, shost->sg_tablesize,
-					SCSI_MAX_SG_CHAIN_SEGMENTS));
+					SG_MAX_SEGMENTS));
 
 	if (scsi_host_prot_dma(shost)) {
 		shost->sg_prot_tablesize =
@@ -2192,8 +2192,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	unsigned int cmd_size, sgl_size, tbl_size;
 
 	tbl_size = shost->sg_tablesize;
-	if (tbl_size > SCSI_MAX_SG_SEGMENTS)
-		tbl_size = SCSI_MAX_SG_SEGMENTS;
+	if (tbl_size > SG_CHUNK_SIZE)
+		tbl_size = SG_CHUNK_SIZE;
 	sgl_size = tbl_size * sizeof(struct scatterlist);
 	cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size + sgl_size;
 	if (scsi_host_get_prot(shost))
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index dba5136..82e5eddc 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -563,7 +563,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.target_alloc =			target_alloc,
 
 	/* lots of sg segments can be handled */
-	.sg_tablesize =			SCSI_MAX_SG_CHAIN_SEGMENTS,
+	.sg_tablesize =			SG_MAX_SEGMENTS,
 
 	/* limit the total size of a transfer to 120 KB */
 	.max_sectors =                  240,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e0a3398..74dafa7 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -24,16 +24,16 @@ enum scsi_timeouts {
  * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
  * minimum value is 32
  */
-#define SCSI_MAX_SG_SEGMENTS	128
+#define SG_CHUNK_SIZE	128
 
 /*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
+ * Like SG_CHUNK_SIZE, but for archs that have sg chaining. This limit
  * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
  */
 #ifdef CONFIG_ARCH_HAS_SG_CHAIN
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
+#define SG_MAX_SEGMENTS	2048
 #else
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#define SG_MAX_SEGMENTS	SG_CHUNK_SIZE
 #endif
 
 /*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..76e9d27 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -37,7 +37,7 @@ struct blk_queue_tags;
  *	 used in one scatter-gather request.
  */
 #define SG_NONE 0
-#define SG_ALL	SCSI_MAX_SG_SEGMENTS
+#define SG_ALL	SG_CHUNK_SIZE
 
 #define MODE_UNKNOWN 0x00
 #define MODE_INITIATOR 0x01
-- 
1.9.1
