From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/19] qla2xxx: Correct staging of RISC while attempting to pause.
Date: Thu, 20 Sep 2007 14:07:38 -0700
Message-ID: <1190322470-15543-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXITVHu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:50 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's no need to reset the RISC prior to pausing.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b52fa89..2defe0c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -172,19 +172,16 @@ qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
 	int rval = QLA_SUCCESS;
 	uint32_t cnt;
 
-	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET |
-		    HCCRX_CLR_HOST_INT);
-		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-		for (cnt = 30000;
-		    (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
-		    rval == QLA_SUCCESS; cnt--) {
-			if (cnt)
-				udelay(100);
-			else
-				rval = QLA_FUNCTION_TIMEOUT;
-		}
+	if (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE)
+		return rval;
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+	for (cnt = 30000; (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(100);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
 	}
 
 	return rval;
-- 
1.5.3.2.80.g077d6f

