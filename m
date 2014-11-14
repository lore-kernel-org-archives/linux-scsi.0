From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 10/13] hpsa: do not be so noisy about check conditions
Date: Fri, 14 Nov 2014 17:27:14 -0600
Message-ID: <20141114232714.20808.59968.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58620 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:39 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <stephenmcameron@gmail.com>

We were printing a lot of useless information before ultimately
just passing things up to the SCSI mid layer.  Just let the
midlayer handle it without LLD chatter.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Signed-off-by: Stephen M. Cameron <stephenmcameron@gmail.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c |   59 ---------------------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c9554e6..58f6847 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1760,72 +1760,13 @@ static void complete_scsi_command(struct CommandList *cp)
 			/* Get addition sense code qualifier */
 			ascq = ei->SenseInfo[13];
 		}
-
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
-			if (check_for_unit_attention(h, cp))
-				break;
-			if (sense_key == ILLEGAL_REQUEST) {
-				/*
-				 * SCSI REPORT_LUNS is commonly unsupported on
-				 * Smart Array.  Suppress noisy complaint.
-				 */
-				if (cp->Request.CDB[0] == REPORT_LUNS)
-					break;
-
-				/* If ASC/ASCQ indicate Logical Unit
-				 * Not Supported condition,
-				 */
-				if ((asc == 0x25) && (ascq == 0x0)) {
-					dev_warn(&h->pdev->dev, "cp %p "
-						"has check condition\n", cp);
-					break;
-				}
-			}
-
-			if (sense_key == NOT_READY) {
-				/* If Sense is Not Ready, Logical Unit
-				 * Not ready, Manual Intervention
-				 * required
-				 */
-				if ((asc == 0x04) && (ascq == 0x03)) {
-					dev_warn(&h->pdev->dev, "cp %p "
-						"has check condition: unit "
-						"not ready, manual "
-						"intervention required\n", cp);
-					break;
-				}
-			}
 			if (sense_key == ABORTED_COMMAND) {
-				/* Aborted command is retryable */
-				dev_warn(&h->pdev->dev, "cp %p "
-					"has check condition: aborted command: "
-					"ASC: 0x%x, ASCQ: 0x%x\n",
-					cp, asc, ascq);
 				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
-			/* Must be some other type of check condition */
-			dev_dbg(&h->pdev->dev, "cp %p has check condition: "
-					"unknown type: "
-					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
-					"Returning result: 0x%x, "
-					"cmd=[%02x %02x %02x %02x %02x "
-					"%02x %02x %02x %02x %02x %02x "
-					"%02x %02x %02x %02x %02x]\n",
-					cp, sense_key, asc, ascq,
-					cmd->result,
-					cmd->cmnd[0], cmd->cmnd[1],
-					cmd->cmnd[2], cmd->cmnd[3],
-					cmd->cmnd[4], cmd->cmnd[5],
-					cmd->cmnd[6], cmd->cmnd[7],
-					cmd->cmnd[8], cmd->cmnd[9],
-					cmd->cmnd[10], cmd->cmnd[11],
-					cmd->cmnd[12], cmd->cmnd[13],
-					cmd->cmnd[14], cmd->cmnd[15]);
 			break;
 		}
-
-
 		/* Problem was not a check condition
 		 * Pass it up to the upper layers...
 		 */

