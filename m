From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 16/17] sym_glue: Fix bidi command test
Date: Fri, 23 Jan 2015 13:15:02 +0100
Message-ID: <54C23B46.1070209@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0095.outbound.protection.outlook.com ([157.56.110.95]:37664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbbAWMPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:15:12 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 5d00e51..c33c697 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -374,14 +374,16 @@ int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *cmd, struct s
 		cp->segments = 0;
 	}
 
+	if (scsi_bidi_cmnd(cmd)) {
+		scmd_printk(KERN_INFO, cmd, "got bidi command");
+		sym_set_cam_status(cmd, DID_ERROR);
+		goto out_abort;
+	}
+
 	/*
 	 *  Set the data pointer.
 	 */
 	switch (dir) {
-	case DMA_BIDIRECTIONAL:
-		scmd_printk(KERN_INFO, cmd, "got DMA_BIDIRECTIONAL command");
-		sym_set_cam_status(cmd, DID_ERROR);
-		goto out_abort;
 	case DMA_TO_DEVICE:
 		goalp = SCRIPTA_BA(np, data_out2) + 8;
 		lastp = goalp - 8 - (cp->segments * (2*4));
-- 
2.1.2

