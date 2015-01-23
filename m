From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/17] dpt_i2o: Fix bidi command test
Date: Fri, 23 Jan 2015 13:07:53 +0100
Message-ID: <54C23999.50803@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:1459
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751014AbbAWMH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:07:59 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
---
 drivers/scsi/dpt_i2o.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 0bf9769..9bab86c 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2240,26 +2240,17 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 		 * Note:  Do not have to verify index is less than 0 since
 		 * cmd->cmnd[0] is an unsigned char
 		 */
-		switch(cmd->sc_data_direction){
-		case DMA_FROM_DEVICE:
-			scsidir  =0x40000000;	// DATA IN  (iop<--dev)
-			break;
-		case DMA_TO_DEVICE:
-			direction=0x04000000;	// SGL OUT
-			scsidir  =0x80000000;	// DATA OUT (iop-->dev)
-			break;
-		case DMA_NONE:
-			break;
-		case DMA_BIDIRECTIONAL:
-			scsidir  =0x40000000;	// DATA IN  (iop<--dev)
-			// Assume In - and continue;
-			break;
-		default:
+		if (scsi_bidi_cmnd(cmd)) {
 			printk(KERN_WARNING"%s: scsi opcode 0x%x not supported.\n",
 			     pHba->name, cmd->cmnd[0]);
 			cmd->result = (DID_OK <<16) | (INITIATOR_ERROR << 8);
 			cmd->scsi_done(cmd);
 			return 	0;
+		} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+			scsidir  =0x40000000;	// DATA IN  (iop<--dev)
+		} else if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+			direction=0x04000000;	// SGL OUT
+			scsidir  =0x80000000;	// DATA OUT (iop-->dev)
 		}
 	}
 	// msg[0] is set later
-- 
2.1.2

