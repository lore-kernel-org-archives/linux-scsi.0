From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 40/48] hpsa: print CDBs instead of kernel virtual
 addresses for uncommon errors
Date: Fri, 23 Jan 2015 16:44:35 -0600
Message-ID: <20150123224435.14919.58312.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:31028 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbAWWp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:29 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Printing the address of the command pointer is of little value, change
to print the CDB.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8f2569c..18bcba9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1882,9 +1882,8 @@ static void complete_scsi_command(struct CommandList *cp)
 	case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
 		break;
 	case CMD_DATA_OVERRUN:
-		dev_warn(&h->pdev->dev, "cp %p has"
-			" completed with data overrun "
-			"reported\n", cp);
+		dev_warn(&h->pdev->dev,
+			"CDB %16phN data overrun\n", cp->Request.CDB);
 		break;
 	case CMD_INVALID: {
 		/* print_bytes(cp, sizeof(*cp), 1, 0);
@@ -1900,34 +1899,38 @@ static void complete_scsi_command(struct CommandList *cp)
 		break;
 	case CMD_PROTOCOL_ERR:
 		cmd->result = DID_ERROR << 16;
-		dev_warn(&h->pdev->dev, "cp %p has "
-			"protocol error\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN : protocol error\n",
+				cp->Request.CDB);
 		break;
 	case CMD_HARDWARE_ERR:
 		cmd->result = DID_ERROR << 16;
-		dev_warn(&h->pdev->dev, "cp %p had  hardware error\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN : hardware error\n",
+			cp->Request.CDB);
 		break;
 	case CMD_CONNECTION_LOST:
 		cmd->result = DID_ERROR << 16;
-		dev_warn(&h->pdev->dev, "cp %p had connection lost\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN : connection lost\n",
+			cp->Request.CDB);
 		break;
 	case CMD_ABORTED:
 		cmd->result = DID_ABORT << 16;
-		dev_warn(&h->pdev->dev, "cp %p was aborted with status 0x%x\n",
-				cp, ei->ScsiStatus);
+		dev_warn(&h->pdev->dev, "CDB %16phN was aborted with status 0x%x\n",
+				cp->Request.CDB, ei->ScsiStatus);
 		break;
 	case CMD_ABORT_FAILED:
 		cmd->result = DID_ERROR << 16;
-		dev_warn(&h->pdev->dev, "cp %p reports abort failed\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN : abort failed\n",
+			cp->Request.CDB);
 		break;
 	case CMD_UNSOLICITED_ABORT:
 		cmd->result = DID_SOFT_ERROR << 16; /* retry the command */
-		dev_warn(&h->pdev->dev, "cp %p aborted due to an unsolicited "
-			"abort\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN : unsolicited abort\n",
+			cp->Request.CDB);
 		break;
 	case CMD_TIMEOUT:
 		cmd->result = DID_TIME_OUT << 16;
-		dev_warn(&h->pdev->dev, "cp %p timedout\n", cp);
+		dev_warn(&h->pdev->dev, "CDB %16phN timed out\n",
+			cp->Request.CDB);
 		break;
 	case CMD_UNABORTABLE:
 		cmd->result = DID_ERROR << 16;

