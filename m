From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] 53c700: brown paper bag fix for auto request sense
Date: Fri, 01 Dec 2006 11:25:12 -0600
Message-ID: <1164993913.22826.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:18882 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S936535AbWLARZP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 12:25:15 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id kB1HPDx00526
	for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2006 12:25:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

In the switch over, I forgot to set the command length, so it sends out
a request sense with whatever length the prior command had (and fails
badly if it wasn't 6).

James

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 562432d..9aabb64 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -622,8 +622,10 @@ #endif
 			dma_unmap_single(hostdata->dev, slot->dma_handle, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
 			/* restore the old result if the request sense was
 			 * successful */
-			if(result == 0)
+			if (result == 0)
 				result = cmnd[7];
+			/* restore the original length */
+			SCp->cmd_len = cmnd[8];
 		} else
 			NCR_700_unmap(hostdata, SCp, slot);
 
@@ -1007,6 +1009,9 @@ #endif
 				 * of the command */
 				cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
 				cmnd[7] = hostdata->status[0];
+				cmnd[8] = SCp->cmd_len;
+				SCp->cmd_len = 6; /* command length for 
+						   * REQUEST_SENSE */
 				slot->pCmd = dma_map_single(hostdata->dev, cmnd, MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
 				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | sizeof(SCp->sense_buffer));


