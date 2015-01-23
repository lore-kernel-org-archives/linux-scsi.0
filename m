From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/17] cciss: Remove dead code
Date: Fri, 23 Jan 2015 13:10:55 +0100
Message-ID: <54C23A4F.7050207@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:23168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196AbbAWMLE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:11:04 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Don Brace <don.brace@pmcs.com>

The code that could set sc_data_direction to DMA_BIDIRECTIONAL has
been removed eight years ago. Hence remove the code that handles
this case. See also patch "unify SCSI_IOCTL_SEND_COMMAND implementations"
(commit 21b2f0c803ad).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Don Brace <don.brace@pmcs.com>
---
 drivers/block/cciss_scsi.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index ecd845c..8f60a64 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1478,21 +1478,6 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 	  case DMA_NONE:
 		c->Request.Type.Direction = XFER_NONE;
 		break;
-	  case DMA_BIDIRECTIONAL:
-		// This can happen if a buggy application does a scsi passthru
-		// and sets both inlen and outlen to non-zero. ( see
-		// ../scsi/scsi_ioctl.c:scsi_ioctl_send_command() )
-
-		c->Request.Type.Direction = XFER_RSVD;
-		// This is technically wrong, and cciss controllers should
-		// reject it with CMD_INVALID, which is the most correct 
-		// response, but non-fibre backends appear to let it 
-		// slide by, and give the same results as if this field
-		// were set correctly.  Either way is acceptable for
-		// our purposes here.
-
-		break;
-
 	  default: 
 		dev_warn(&h->pdev->dev, "unknown data direction: %d\n",
 			cmd->sc_data_direction);
-- 
2.1.2

