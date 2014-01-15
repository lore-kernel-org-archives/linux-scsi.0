From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 23/41] hpsa: initialize controller to perform io accelerator
	mode 2
Date: Wed, 15 Jan 2014 16:38:16 -0600
Message-ID: <20140115223816.5061.41864.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40956 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaAOViR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:38:17 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c     |  111 ++++++++++++++++++++++++++++++++---------------
 drivers/scsi/hpsa.h     |    1 
 drivers/scsi/hpsa_cmd.h |    2 -
 3 files changed, 78 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e471782..6c59b74 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5141,6 +5141,7 @@ static int hpsa_enter_simple_mode(struct ctlr_info *h)
 
 	/* Update the field, and then ring the doorbell */
 	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
+	writel(0, &h->cfgtable->HostWrite.command_pool_addr_hi);
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 	hpsa_wait_for_mode_change_ack(h);
 	print_cfg_table(&h->pdev->dev, h->cfgtable);
@@ -5907,9 +5908,9 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	unsigned long register_value;
 	unsigned long transMethod = CFGTBL_Trans_Performant |
 			(trans_support & CFGTBL_Trans_use_short_tags) |
-			CFGTBL_Trans_enable_directed_msix |
-			(trans_support & CFGTBL_Trans_io_accel1);
-
+				CFGTBL_Trans_enable_directed_msix |
+			(trans_support & (CFGTBL_Trans_io_accel1 |
+				CFGTBL_Trans_io_accel2));
 	struct access_method access = SA5_performant_access;
 
 	/* This is a bit complicated.  There are 8 registers on
@@ -5930,6 +5931,16 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	 * sizes for small commands, and fewer sizes for larger commands.
 	 */
 	int bft[8] = {5, 6, 8, 10, 12, 20, 28, SG_ENTRIES_IN_CMD + 4};
+#define MIN_IOACCEL2_BFT_ENTRY 5
+#define HPSA_IOACCEL2_HEADER_SZ 4
+	int bft2[16] = {MIN_IOACCEL2_BFT_ENTRY, 6, 7, 8, 9, 10, 11, 12,
+			13, 14, 15, 16, 17, 18, 19,
+			HPSA_IOACCEL2_HEADER_SZ + IOACCEL2_MAXSGENTRIES};
+	BUILD_BUG_ON(ARRAY_SIZE(bft2) != 16);
+	BUILD_BUG_ON(ARRAY_SIZE(bft) != 8);
+	BUILD_BUG_ON(offsetof(struct io_accel2_cmd, sg) >
+				 16 * MIN_IOACCEL2_BFT_ENTRY);
+	BUILD_BUG_ON(sizeof(struct ioaccel2_sg_element) != 16);
 	BUILD_BUG_ON(28 > SG_ENTRIES_IN_CMD + 4);
 	/*  5 = 1 s/g entry or 4k
 	 *  6 = 2 s/g entry or 8k
@@ -5959,6 +5970,7 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 			&h->transtable->RepQAddr[i].lower);
 	}
 
+	writel(0, &h->cfgtable->HostWrite.command_pool_addr_hi);
 	writel(transMethod, &(h->cfgtable->HostWrite.TransportRequest));
 	/*
 	 * enable outbound interrupt coalescing in accelerator mode;
@@ -5980,43 +5992,72 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	h->access = access;
 	h->transMethod = transMethod;
 
-	if (!(trans_support & CFGTBL_Trans_io_accel1))
+	if (!((trans_support & CFGTBL_Trans_io_accel1) ||
+		(trans_support & CFGTBL_Trans_io_accel2)))
 		return;
 
-	/* Set up I/O accelerator mode */
-	for (i = 0; i < h->nreply_queues; i++) {
-		writel(i, h->vaddr + IOACCEL_MODE1_REPLY_QUEUE_INDEX);
-		h->reply_queue[i].current_entry =
-			readl(h->vaddr + IOACCEL_MODE1_PRODUCER_INDEX);
-	}
-	bft[7] = h->ioaccel_maxsg + 8;
-	calc_bucket_map(bft, ARRAY_SIZE(bft), h->ioaccel_maxsg, 8,
-			h->ioaccel1_blockFetchTable);
+	if (trans_support & CFGTBL_Trans_io_accel1) {
+		/* Set up I/O accelerator mode */
+		for (i = 0; i < h->nreply_queues; i++) {
+			writel(i, h->vaddr + IOACCEL_MODE1_REPLY_QUEUE_INDEX);
+			h->reply_queue[i].current_entry =
+				readl(h->vaddr + IOACCEL_MODE1_PRODUCER_INDEX);
+		}
+		bft[7] = h->ioaccel_maxsg + 8;
+		calc_bucket_map(bft, ARRAY_SIZE(bft), h->ioaccel_maxsg, 8,
+				h->ioaccel1_blockFetchTable);
 
-	/* initialize all reply queue entries to unused */
-	memset(h->reply_pool, (u8) IOACCEL_MODE1_REPLY_UNUSED,
-			h->reply_pool_size);
+		/* initialize all reply queue entries to unused */
+		memset(h->reply_pool, (u8) IOACCEL_MODE1_REPLY_UNUSED,
+				h->reply_pool_size);
 
-	/* set all the constant fields in the accelerator command
-	 * frames once at init time to save CPU cycles later.
-	 */
-	for (i = 0; i < h->nr_cmds; i++) {
-		struct io_accel1_cmd *cp = &h->ioaccel_cmd_pool[i];
-
-		cp->function = IOACCEL1_FUNCTION_SCSIIO;
-		cp->err_info = (u32) (h->errinfo_pool_dhandle +
-				(i * sizeof(struct ErrorInfo)));
-		cp->err_info_len = sizeof(struct ErrorInfo);
-		cp->sgl_offset = IOACCEL1_SGLOFFSET;
-		cp->host_context_flags = IOACCEL1_HCFLAGS_CISS_FORMAT;
-		cp->timeout_sec = 0;
-		cp->ReplyQueue = 0;
-		cp->Tag.lower = (i << DIRECT_LOOKUP_SHIFT) | DIRECT_LOOKUP_BIT;
-		cp->Tag.upper = 0;
-		cp->host_addr.lower = (u32) (h->ioaccel_cmd_pool_dhandle +
-				(i * sizeof(struct io_accel1_cmd)));
-		cp->host_addr.upper = 0;
+		/* set all the constant fields in the accelerator command
+		 * frames once at init time to save CPU cycles later.
+		 */
+		for (i = 0; i < h->nr_cmds; i++) {
+			struct io_accel1_cmd *cp = &h->ioaccel_cmd_pool[i];
+
+			cp->function = IOACCEL1_FUNCTION_SCSIIO;
+			cp->err_info = (u32) (h->errinfo_pool_dhandle +
+					(i * sizeof(struct ErrorInfo)));
+			cp->err_info_len = sizeof(struct ErrorInfo);
+			cp->sgl_offset = IOACCEL1_SGLOFFSET;
+			cp->host_context_flags = IOACCEL1_HCFLAGS_CISS_FORMAT;
+			cp->timeout_sec = 0;
+			cp->ReplyQueue = 0;
+			cp->Tag.lower = (i << DIRECT_LOOKUP_SHIFT) |
+						DIRECT_LOOKUP_BIT;
+			cp->Tag.upper = 0;
+			cp->host_addr.lower =
+				(u32) (h->ioaccel_cmd_pool_dhandle +
+					(i * sizeof(struct io_accel1_cmd)));
+			cp->host_addr.upper = 0;
+		}
+	} else if (trans_support & CFGTBL_Trans_io_accel2) {
+		u64 cfg_offset, cfg_base_addr_index;
+		u32 bft2_offset, cfg_base_addr;
+		int rc;
+
+		rc = hpsa_find_cfg_addrs(h->pdev, h->vaddr, &cfg_base_addr,
+			&cfg_base_addr_index, &cfg_offset);
+		BUILD_BUG_ON(offsetof(struct io_accel2_cmd, sg) != 64);
+		bft2[15] = h->ioaccel_maxsg + HPSA_IOACCEL2_HEADER_SZ;
+		calc_bucket_map(bft2, ARRAY_SIZE(bft2), h->ioaccel_maxsg,
+				4, h->ioaccel2_blockFetchTable);
+		bft2_offset = readl(&h->cfgtable->io_accel_request_size_offset);
+		BUILD_BUG_ON(offsetof(struct CfgTable,
+				io_accel_request_size_offset) != 0xb8);
+		h->ioaccel2_bft2_regs =
+			remap_pci_mem(pci_resource_start(h->pdev,
+					cfg_base_addr_index) +
+					cfg_offset + bft2_offset,
+					ARRAY_SIZE(bft2) *
+					sizeof(*h->ioaccel2_bft2_regs));
+		for (i = 0; i < ARRAY_SIZE(bft2); i++)
+			writel(bft2[i], &h->ioaccel2_bft2_regs[i]);
 	}
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+	hpsa_wait_for_mode_change_ack(h);
 }
 
 static int hpsa_alloc_ioaccel_cmd_and_bft(struct ctlr_info *h)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 2a4a0cb..0e14e9b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -142,6 +142,7 @@ struct ctlr_info {
 	u32 *blockFetchTable;
 	u32 *ioaccel1_blockFetchTable;
 	u32 *ioaccel2_blockFetchTable;
+	u32 *ioaccel2_bft2_regs;
 	unsigned char *hba_inquiry_data;
 	u32 driver_support;
 	u32 fw_support;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 6b336e8..dfdb4a5 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -547,7 +547,7 @@ struct hpsa_tmf_struct {
 /* Configuration Table Structure */
 struct HostWrite {
 	u32 TransportRequest;
-	u32 Reserved;
+	u32 command_pool_addr_hi;
 	u32 CoalIntDelay;
 	u32 CoalIntCount;
 };

