From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 19/42] hpsa: add ioaccel sg chaining for the ioaccel2 path
Date: Tue, 17 Mar 2015 15:04:07 -0500
Message-ID: <20150317200407.19856.39581.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54572 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbCQUFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:05:46 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Increase the request size for ioaccel2 path.

The error, if any, returned by hpsa_allocate_ioaccel2_sg_chain_blocks
to hpsa_alloc_ioaccel2_cmd_and_bft should be returned upstream rather
than assumed to be -ENOMEM.

This differs slightly from hpsa_alloc_ioaccel1_cmd_and_bft,
which does not call another hpsa_allocate function and only
has -ENOMEM to return from some kmalloc calls.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/hpsa.h |    1 
 2 files changed, 116 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9ca86be..0a3ea37 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1734,6 +1734,46 @@ static void hpsa_slave_destroy(struct scsi_device *sdev)
 	/* nothing to do. */
 }
 
+static void hpsa_free_ioaccel2_sg_chain_blocks(struct ctlr_info *h)
+{
+	int i;
+
+	if (!h->ioaccel2_cmd_sg_list)
+		return;
+	for (i = 0; i < h->nr_cmds; i++) {
+		kfree(h->ioaccel2_cmd_sg_list[i]);
+		h->ioaccel2_cmd_sg_list[i] = NULL;
+	}
+	kfree(h->ioaccel2_cmd_sg_list);
+	h->ioaccel2_cmd_sg_list = NULL;
+}
+
+static int hpsa_allocate_ioaccel2_sg_chain_blocks(struct ctlr_info *h)
+{
+	int i;
+
+	if (h->chainsize <= 0)
+		return 0;
+
+	h->ioaccel2_cmd_sg_list =
+		kzalloc(sizeof(*h->ioaccel2_cmd_sg_list) * h->nr_cmds,
+					GFP_KERNEL);
+	if (!h->ioaccel2_cmd_sg_list)
+		return -ENOMEM;
+	for (i = 0; i < h->nr_cmds; i++) {
+		h->ioaccel2_cmd_sg_list[i] =
+			kmalloc(sizeof(*h->ioaccel2_cmd_sg_list[i]) *
+					h->maxsgentries, GFP_KERNEL);
+		if (!h->ioaccel2_cmd_sg_list[i])
+			goto clean;
+	}
+	return 0;
+
+clean:
+	hpsa_free_ioaccel2_sg_chain_blocks(h);
+	return -ENOMEM;
+}
+
 static void hpsa_free_sg_chain_blocks(struct ctlr_info *h)
 {
 	int i;
@@ -1776,6 +1816,39 @@ clean:
 	return -ENOMEM;
 }
 
+static int hpsa_map_ioaccel2_sg_chain_block(struct ctlr_info *h,
+	struct io_accel2_cmd *cp, struct CommandList *c)
+{
+	struct ioaccel2_sg_element *chain_block;
+	u64 temp64;
+	u32 chain_size;
+
+	chain_block = h->ioaccel2_cmd_sg_list[c->cmdindex];
+	chain_size = le32_to_cpu(cp->data_len);
+	temp64 = pci_map_single(h->pdev, chain_block, chain_size,
+				PCI_DMA_TODEVICE);
+	if (dma_mapping_error(&h->pdev->dev, temp64)) {
+		/* prevent subsequent unmapping */
+		cp->sg->address = 0;
+		return -1;
+	}
+	cp->sg->address = cpu_to_le64(temp64);
+	return 0;
+}
+
+static void hpsa_unmap_ioaccel2_sg_chain_block(struct ctlr_info *h,
+	struct io_accel2_cmd *cp)
+{
+	struct ioaccel2_sg_element *chain_sg;
+	u64 temp64;
+	u32 chain_size;
+
+	chain_sg = cp->sg;
+	temp64 = le64_to_cpu(chain_sg->address);
+	chain_size = le32_to_cpu(cp->data_len);
+	pci_unmap_single(h->pdev, temp64, chain_size, PCI_DMA_TODEVICE);
+}
+
 static int hpsa_map_sg_chain_block(struct ctlr_info *h,
 	struct CommandList *c)
 {
@@ -1985,6 +2058,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	struct ctlr_info *h;
 	struct ErrorInfo *ei;
 	struct hpsa_scsi_dev_t *dev;
+	struct io_accel2_cmd *c2;
 
 	int sense_key;
 	int asc;      /* additional sense code */
@@ -1995,12 +2069,17 @@ static void complete_scsi_command(struct CommandList *cp)
 	cmd = cp->scsi_cmd;
 	h = cp->h;
 	dev = cmd->device->hostdata;
+	c2 = &h->ioaccel2_cmd_pool[cp->cmdindex];
 
 	scsi_dma_unmap(cmd); /* undo the DMA mappings */
 	if ((cp->cmd_type == CMD_SCSI) &&
 		(le16_to_cpu(cp->Header.SGTotal) > h->max_cmd_sg_entries))
 		hpsa_unmap_sg_chain_block(h, cp);
 
+	if ((cp->cmd_type == CMD_IOACCEL2) &&
+		(c2->sg[0].chain_indicator == IOACCEL2_CHAIN))
+		hpsa_unmap_ioaccel2_sg_chain_block(h, c2);
+
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
 
@@ -3842,10 +3921,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	u32 len;
 	u32 total_len = 0;
 
-	if (scsi_sg_count(cmd) > h->ioaccel_maxsg) {
-		atomic_dec(&phys_disk->ioaccel_cmds_out);
-		return IO_ACCEL_INELIGIBLE;
-	}
+	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
 
 	if (fixup_ioaccel_cdb(cdb, &cdb_len)) {
 		atomic_dec(&phys_disk->ioaccel_cmds_out);
@@ -3868,8 +3944,19 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	}
 
 	if (use_sg) {
-		BUG_ON(use_sg > IOACCEL2_MAXSGENTRIES);
 		curr_sg = cp->sg;
+		if (use_sg > h->ioaccel_maxsg) {
+			addr64 = le64_to_cpu(
+				h->ioaccel2_cmd_sg_list[c->cmdindex]->address);
+			curr_sg->address = cpu_to_le64(addr64);
+			curr_sg->length = 0;
+			curr_sg->reserved[0] = 0;
+			curr_sg->reserved[1] = 0;
+			curr_sg->reserved[2] = 0;
+			curr_sg->chain_indicator = 0x80;
+
+			curr_sg = h->ioaccel2_cmd_sg_list[c->cmdindex];
+		}
 		scsi_for_each_sg(cmd, sg, use_sg, i) {
 			addr64 = (u64) sg_dma_address(sg);
 			len  = sg_dma_len(sg);
@@ -3914,14 +4001,22 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	cp->Tag = cpu_to_le32(c->cmdindex << DIRECT_LOOKUP_SHIFT);
 	memcpy(cp->cdb, cdb, sizeof(cp->cdb));
 
-	/* fill in sg elements */
-	cp->sg_count = (u8) use_sg;
-
 	cp->data_len = cpu_to_le32(total_len);
 	cp->err_ptr = cpu_to_le64(c->busaddr +
 			offsetof(struct io_accel2_cmd, error_data));
 	cp->err_len = cpu_to_le32(sizeof(cp->error_data));
 
+	/* fill in sg elements */
+	if (use_sg > h->ioaccel_maxsg) {
+		cp->sg_count = 1;
+		if (hpsa_map_ioaccel2_sg_chain_block(h, cp, c)) {
+			atomic_dec(&phys_disk->ioaccel_cmds_out);
+			scsi_dma_unmap(cmd);
+			return -1;
+		}
+	} else
+		cp->sg_count = (u8) use_sg;
+
 	enqueue_cmd_and_start_io(h, c);
 	return 0;
 }
@@ -7937,6 +8032,8 @@ clean_up:
 /* Free ioaccel2 mode command blocks and block fetch table */
 static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
+	hpsa_free_ioaccel2_sg_chain_blocks(h);
+
 	if (h->ioaccel2_cmd_pool)
 		pci_free_consistent(h->pdev,
 			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
@@ -7948,6 +8045,8 @@ static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 /* Allocate ioaccel2 mode command blocks and block fetch table */
 static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
+	int rc;
+
 	/* Allocate ioaccel2 mode command blocks and block fetch table */
 
 	h->ioaccel_maxsg =
@@ -7967,7 +8066,13 @@ static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 				sizeof(u32)), GFP_KERNEL);
 
 	if ((h->ioaccel2_cmd_pool == NULL) ||
-		(h->ioaccel2_blockFetchTable == NULL))
+		(h->ioaccel2_blockFetchTable == NULL)) {
+		rc = -ENOMEM;
+		goto clean_up;
+	}
+
+	rc = hpsa_allocate_ioaccel2_sg_chain_blocks(h);
+	if (rc)
 		goto clean_up;
 
 	memset(h->ioaccel2_cmd_pool, 0,
@@ -7976,7 +8081,7 @@ static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 
 clean_up:
 	hpsa_free_ioaccel2_cmd_and_bft(h);
-	return 1;
+	return rc;
 }
 
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 87a70b5..3acacf6 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -162,6 +162,7 @@ struct ctlr_info {
 	u8 max_cmd_sg_entries;
 	int chainsize;
 	struct SGDescriptor **cmd_sg_list;
+	struct ioaccel2_sg_element **ioaccel2_cmd_sg_list;
 
 	/* pointers to command and error info pool */
 	struct CommandList 	*cmd_pool;

