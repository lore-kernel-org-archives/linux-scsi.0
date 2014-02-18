From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/35] hpsa: do ioaccel mode 2 resource allocations
Date: Tue, 18 Feb 2014 13:56:14 -0600
Message-ID: <20140218195614.15787.34932.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43525 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaBRT5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:42 -0500
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id E80D160962
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:57:41 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <michael.miller@canonical.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h |    3 +++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ba51b1e..80acb23 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5288,6 +5288,10 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 		pci_free_consistent(h->pdev,
 			    h->nr_cmds * sizeof(struct CommandList),
 			    h->cmd_pool, h->cmd_pool_dhandle);
+	if (h->ioaccel2_cmd_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
+			h->ioaccel2_cmd_pool, h->ioaccel2_cmd_pool_dhandle);
 	if (h->errinfo_pool)
 		pci_free_consistent(h->pdev,
 			    h->nr_cmds * sizeof(struct ErrorInfo),
@@ -5826,6 +5830,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->cmd_pool_bits);
 	kfree(h->blockFetchTable);
 	kfree(h->ioaccel1_blockFetchTable);
+	kfree(h->ioaccel2_blockFetchTable);
 	kfree(h->hba_inquiry_data);
 	pci_disable_device(pdev);
 	pci_release_regions(pdev);
@@ -6045,6 +6050,44 @@ clean_up:
 	return 1;
 }
 
+static int ioaccel2_alloc_cmds_and_bft(struct ctlr_info *h)
+{
+	/* Allocate ioaccel2 mode command blocks and block fetch table */
+
+	h->ioaccel_maxsg =
+		readl(&(h->cfgtable->io_accel_max_embedded_sg_count));
+	if (h->ioaccel_maxsg > IOACCEL2_MAXSGENTRIES)
+		h->ioaccel_maxsg = IOACCEL2_MAXSGENTRIES;
+
+#define IOACCEL2_COMMANDLIST_ALIGNMENT 128
+	BUILD_BUG_ON(sizeof(struct io_accel2_cmd) %
+			IOACCEL2_COMMANDLIST_ALIGNMENT);
+	h->ioaccel2_cmd_pool =
+		pci_alloc_consistent(h->pdev,
+			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
+			&(h->ioaccel2_cmd_pool_dhandle));
+
+	h->ioaccel2_blockFetchTable =
+		kmalloc(((h->ioaccel_maxsg + 1) *
+				sizeof(u32)), GFP_KERNEL);
+
+	if ((h->ioaccel2_cmd_pool == NULL) ||
+		(h->ioaccel2_blockFetchTable == NULL))
+		goto clean_up;
+
+	memset(h->ioaccel2_cmd_pool, 0,
+		h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool));
+	return 0;
+
+clean_up:
+	if (h->ioaccel2_cmd_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
+			h->ioaccel2_cmd_pool, h->ioaccel2_cmd_pool_dhandle);
+	kfree(h->ioaccel2_blockFetchTable);
+	return 1;
+}
+
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
@@ -6065,6 +6108,13 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 				CFGTBL_Trans_enable_directed_msix;
 		if (hpsa_alloc_ioaccel_cmd_and_bft(h))
 			goto clean_up;
+	} else {
+		if (trans_support & CFGTBL_Trans_io_accel2) {
+				transMethod |= CFGTBL_Trans_io_accel2 |
+				CFGTBL_Trans_enable_directed_msix;
+		if (ioaccel2_alloc_cmds_and_bft(h))
+			goto clean_up;
+		}
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 74eb22a..2a4a0cb 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -105,6 +105,8 @@ struct ctlr_info {
 	dma_addr_t		cmd_pool_dhandle;
 	struct io_accel1_cmd	*ioaccel_cmd_pool;
 	dma_addr_t		ioaccel_cmd_pool_dhandle;
+	struct io_accel2_cmd	*ioaccel2_cmd_pool;
+	dma_addr_t		ioaccel2_cmd_pool_dhandle;
 	struct ErrorInfo 	*errinfo_pool;
 	dma_addr_t		errinfo_pool_dhandle;
 	unsigned long  		*cmd_pool_bits;
@@ -139,6 +141,7 @@ struct ctlr_info {
 	dma_addr_t reply_pool_dhandle;
 	u32 *blockFetchTable;
 	u32 *ioaccel1_blockFetchTable;
+	u32 *ioaccel2_blockFetchTable;
 	unsigned char *hba_inquiry_data;
 	u32 driver_support;
 	u32 fw_support;

