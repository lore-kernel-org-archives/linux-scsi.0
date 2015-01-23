From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/17] hpsa: Remove dead code
Date: Fri, 23 Jan 2015 13:11:23 +0100
Message-ID: <54C23A6B.7000905@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0057.outbound.protection.outlook.com ([157.56.110.57]:15488
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751014AbbAWMLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:11:30 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
Hence remove the code that tests for this value.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6bb4611..9d16a06 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3969,24 +3969,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		c->Request.type_attr_dir =
 			TYPE_ATTR_DIR(TYPE_CMD, ATTR_SIMPLE, XFER_NONE);
 		break;
-	case DMA_BIDIRECTIONAL:
-		/* This can happen if a buggy application does a scsi passthru
-		 * and sets both inlen and outlen to non-zero. ( see
-		 * ../scsi/scsi_ioctl.c:scsi_ioctl_send_command() )
-		 */
-
-		c->Request.type_attr_dir =
-			TYPE_ATTR_DIR(TYPE_CMD, ATTR_SIMPLE, XFER_RSVD);
-		/* This is technically wrong, and hpsa controllers should
-		 * reject it with CMD_INVALID, which is the most correct
-		 * response, but non-fibre backends appear to let it
-		 * slide by, and give the same results as if this field
-		 * were set correctly.  Either way is acceptable for
-		 * our purposes here.
-		 */
-
-		break;
-
 	default:
 		dev_err(&h->pdev->dev, "unknown data direction: %d\n",
 			cmd->sc_data_direction);
-- 
2.1.2

