From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 46/48] hpsa: detect and report failures changing controller
 transport modes
Date: Wed, 14 Jan 2015 16:03:40 -0600
Message-ID: <20150114220340.21325.72187.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:35084 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbbANWE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:04:27 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Detect failues when attempting to change controller to use simple
or performant transport modes (mode change ack) rather than just
proceeding ahead after timeouts.

Return values are added to:
	hpsa_put_ctlr_into_performant_mode
	hpsa_wait_for_mode_change_ack
and all their callers check/propagate the result.

More consistency in printing errors and whether
dev_err is used.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 89744a1..c1f4a95 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -243,7 +243,7 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
 static int hpsa_wait_for_board_state(struct pci_dev *pdev, void __iomem *vaddr,
 				     int wait_for_ready);
 static inline void finish_cmd(struct CommandList *c);
-static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h);
+static int hpsa_wait_for_mode_change_ack(struct ctlr_info *h);
 #define BOARD_NOT_READY 0
 #define BOARD_READY 1
 static void hpsa_drain_accel_commands(struct ctlr_info *h);
@@ -6191,7 +6191,7 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
 }
 
-static void hpsa_wait_for_clear_event_notify_ack(struct ctlr_info *h)
+static int hpsa_wait_for_clear_event_notify_ack(struct ctlr_info *h)
 {
 	int i;
 	u32 doorbell_value;
@@ -6202,13 +6202,16 @@ static void hpsa_wait_for_clear_event_notify_ack(struct ctlr_info *h)
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
 		if (!(doorbell_value & DOORBELL_CLEAR_EVENTS))
-			break;
+			goto done;
 		/* delay and try again */
 		msleep(CLEAR_EVENT_WAIT_INTERVAL);
 	}
+	return -ENODEV;
+done:
+	return 0;
 }
 
-static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
+static int hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 {
 	int i;
 	u32 doorbell_value;
@@ -6223,12 +6226,16 @@ static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
 		if (!(doorbell_value & CFGTBL_ChangeReq))
-			break;
+			goto done;
 		/* delay and try again */
 		msleep(MODE_CHANGE_WAIT_INTERVAL);
 	}
+	return -ENODEV;
+done:
+	return 0;
 }
 
+/* return -ENODEV or other reason on error, 0 on success */
 static int hpsa_enter_simple_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
@@ -6243,7 +6250,8 @@ static int hpsa_enter_simple_mode(struct ctlr_info *h)
 	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
 	writel(0, &h->cfgtable->HostWrite.command_pool_addr_hi);
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-	hpsa_wait_for_mode_change_ack(h);
+	if (hpsa_wait_for_mode_change_ack(h))
+		goto error;
 	print_cfg_table(&h->pdev->dev, h->cfgtable);
 	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple))
 		goto error;
@@ -7144,7 +7152,8 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
+/* return -ENODEV or other reason on error, 0 on success */
+static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 {
 	int i;
 	unsigned long register_value;
@@ -7236,12 +7245,16 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 		}
 	}
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-	hpsa_wait_for_mode_change_ack(h);
+	if (hpsa_wait_for_mode_change_ack(h)) {
+		dev_err(&h->pdev->dev,
+			"performant mode problem - doorbell timeout\n");
+		return -ENODEV;
+	}
 	register_value = readl(&(h->cfgtable->TransportActive));
 	if (!(register_value & CFGTBL_Trans_Performant)) {
 		dev_err(&h->pdev->dev,
 			"performant mode problem - transport not active\n");
-		return;
+		return -ENODEV;
 	}
 	/* Change the access methods to the performant access methods */
 	h->access = access;
@@ -7249,7 +7262,7 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 
 	if (!((trans_support & CFGTBL_Trans_io_accel1) ||
 		(trans_support & CFGTBL_Trans_io_accel2)))
-		return;
+		return 0;
 
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		/* Set up I/O accelerator mode */
@@ -7313,7 +7326,12 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 			writel(bft2[i], &h->ioaccel2_bft2_regs[i]);
 	}
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-	hpsa_wait_for_mode_change_ack(h);
+	if (hpsa_wait_for_mode_change_ack(h)) {
+		dev_err(&h->pdev->dev,
+			"performant mode problem - enabling ioaccel mode\n");
+		return -ENODEV;
+	}
+	return 0;
 }
 
 static int hpsa_alloc_ioaccel_cmd_and_bft(struct ctlr_info *h)

