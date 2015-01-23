From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/17] aachba: Fix bidi command test
Date: Fri, 23 Jan 2015 13:08:17 +0100
Message-ID: <54C239B1.1010102@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0076.outbound.protection.outlook.com ([157.56.110.76]:15008
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754203AbbAWMIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:08:24 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/aacraid/aachba.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index b32e77d..5ade84a 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1228,21 +1228,14 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	u32 timeout;
 
 	aac_fib_init(fib);
-	switch(cmd->sc_data_direction){
-	case DMA_TO_DEVICE:
-		flag = SRB_DataOut;
-		break;
-	case DMA_BIDIRECTIONAL:
+	if (scsi_bidi_cmnd(cmd))
 		flag = SRB_DataIn | SRB_DataOut;
-		break;
-	case DMA_FROM_DEVICE:
+	else if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		flag = SRB_DataOut;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		flag = SRB_DataIn;
-		break;
-	case DMA_NONE:
-	default:	/* shuts up some versions of gcc */
+	else
 		flag = SRB_NoDataXfer;
-		break;
-	}
 
 	srbcmd = (struct aac_srb*) fib_data(fib);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-- 
2.1.2

