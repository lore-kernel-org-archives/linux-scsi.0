From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 33/41] hpsa: retry certain ioaccel error cases on the RAID path
Date: Wed, 15 Jan 2014 16:39:12 -0600
Message-ID: <20140115223912.5061.71010.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:7801 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAOVj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:39:27 -0500
Received: from g5t0007.atlanta.hp.com (g5t0007.atlanta.hp.com [15.192.0.44])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id F01F6892
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 21:39:21 +0000 (UTC)
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Change the handling of HP SSD Smart Path errors with status:
  0x02 CHECK CONDITION
  0x08 BUSY
  0x18 RESERVATION CONFLICT
  0x40 TASK ABORTED
So that they get retried on the RAID Path.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f78d08b..6ff47ba 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1351,12 +1351,18 @@ static void hpsa_unmap_sg_chain_block(struct ctlr_info *h,
 	pci_unmap_single(h->pdev, temp64.val, chain_sg->Len, PCI_DMA_TODEVICE);
 }
 
-static void handle_ioaccel_mode2_error(struct ctlr_info *h,
+
+/* Decode the various types of errors on ioaccel2 path.
+ * Return 1 for any error that should generate a RAID path retry.
+ * Return 0 for errors that don't require a RAID path retry.
+ */
+static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 					struct CommandList *c,
 					struct scsi_cmnd *cmd,
 					struct io_accel2_cmd *c2)
 {
 	int data_len;
+	int retry = 0;
 
 	switch (c2->error_data.serv_response) {
 	case IOACCEL2_SERV_RESPONSE_COMPLETE:
@@ -1380,16 +1386,19 @@ static void handle_ioaccel_mode2_error(struct ctlr_info *h,
 			memcpy(cmd->sense_buffer,
 				c2->error_data.sense_data_buff, data_len);
 			cmd->result |= SAM_STAT_CHECK_CONDITION;
+			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_BUSY:
 			dev_warn(&h->pdev->dev,
 				"%s: task complete with BUSY status.\n",
 				"HP SSD Smart Path");
+			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_RES_CON:
 			dev_warn(&h->pdev->dev,
 				"%s: task complete with reservation conflict.\n",
 				"HP SSD Smart Path");
+			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL:
 			/* Make scsi midlayer do unlimited retries */
@@ -1399,11 +1408,13 @@ static void handle_ioaccel_mode2_error(struct ctlr_info *h,
 			dev_warn(&h->pdev->dev,
 				"%s: task complete with aborted status.\n",
 				"HP SSD Smart Path");
+			retry = 1;
 			break;
 		default:
 			dev_warn(&h->pdev->dev,
 				"%s: task complete with unrecognized status: 0x%02x\n",
 				"HP SSD Smart Path", c2->error_data.status);
+			retry = 1;
 			break;
 		}
 		break;
@@ -1412,6 +1423,7 @@ static void handle_ioaccel_mode2_error(struct ctlr_info *h,
 		dev_warn(&h->pdev->dev,
 			"unexpected delivery or target failure, "
 			"status = 0x%02x\n", c2->error_data.status);
+		retry = 1;
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
 		break;
@@ -1419,6 +1431,7 @@ static void handle_ioaccel_mode2_error(struct ctlr_info *h,
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_REJECTED:
 		dev_warn(&h->pdev->dev, "task management function rejected.\n");
+		retry = 1;
 		break;
 	case IOACCEL2_SERV_RESPONSE_TMF_WRONG_LUN:
 		dev_warn(&h->pdev->dev, "task management function invalid LUN\n");
@@ -1426,9 +1439,13 @@ static void handle_ioaccel_mode2_error(struct ctlr_info *h,
 	default:
 		dev_warn(&h->pdev->dev,
 			"%s: Unrecognized server response: 0x%02x\n",
-			"HP SSD Smart Path", c2->error_data.serv_response);
+			"HP SSD Smart Path",
+			c2->error_data.serv_response);
+		retry = 1;
 		break;
 	}
+
+	return retry;	/* retry on raid path? */
 }
 
 static void process_ioaccel2_completion(struct ctlr_info *h,
@@ -1436,6 +1453,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		struct hpsa_scsi_dev_t *dev)
 {
 	struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
+	int raid_retry = 0;
 
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
@@ -1452,11 +1470,16 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
-		if (c2->error_data.status !=
-				IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
+		if (c2->error_data.status ==
+			IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
+			dev_warn(&h->pdev->dev,
+				"%s: Path is unavailable, retrying on standard path.\n",
+				"HP SSD Smart Path");
+		else
 			dev_warn(&h->pdev->dev,
-				"%s: Error 0x%02x, Retrying on standard path.\n",
+				"%s: Error 0x%02x, retrying on standard path.\n",
 				"HP SSD Smart Path", c2->error_data.status);
+
 		dev->offload_enabled = 0;
 		h->drv_req_rescan = 1;	/* schedule controller for a rescan */
 		cmd->result = DID_SOFT_ERROR << 16;
@@ -1464,7 +1487,17 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		cmd->scsi_done(cmd);
 		return;
 	}
-	handle_ioaccel_mode2_error(h, c, cmd, c2);
+	raid_retry = handle_ioaccel_mode2_error(h, c, cmd, c2);
+	/* If error found, disable Smart Path, schedule a rescan,
+	 * and force a retry on the standard path.
+	 */
+	if (raid_retry) {
+		dev_warn(&h->pdev->dev, "%s: Retrying on standard path.\n",
+			"HP SSD Smart Path");
+		dev->offload_enabled = 0; /* Disable Smart Path */
+		h->drv_req_rescan = 1;	  /* schedule controller rescan */
+		cmd->result = DID_SOFT_ERROR << 16;
+	}
 	cmd_free(h, c);
 	cmd->scsi_done(cmd);
 }

