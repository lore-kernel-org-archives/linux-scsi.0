From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 14/17] 53c700: Remove dead code
Date: Fri, 23 Jan 2015 13:13:58 +0100
Message-ID: <54C23B06.7070108@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:15200
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbbAWMOF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:14:05 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
Hence remove the code that tests for this value.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/53c700.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 82abfce..78f4b57 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -578,8 +578,7 @@ STATIC inline void
 NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, struct scsi_cmnd *SCp,
 	      struct NCR_700_command_slot *slot)
 {
-	if(SCp->sc_data_direction != DMA_NONE &&
-	   SCp->sc_data_direction != DMA_BIDIRECTIONAL)
+	if (SCp->sc_data_direction != DMA_NONE)
 		scsi_dma_unmap(SCp);
 }
 
@@ -1846,7 +1845,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 	default:
 		/* OK, get it from the command */
 		switch(SCp->sc_data_direction) {
-		case DMA_BIDIRECTIONAL:
 		default:
 			printk(KERN_ERR "53c700: Unknown command for data direction ");
 			scsi_print_command(SCp);
-- 
2.1.2

