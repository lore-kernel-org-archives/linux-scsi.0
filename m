From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/20] qla2xxx: Query supported RISC registers bits in determining a paused-state.
Date: Wed,  3 Jun 2009 09:55:26 -0700
Message-ID: <1244048131-56590-16-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbZFCQzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:42 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

ISP24xx and above must query the host-status register, not HCCR.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    6 ++----
 drivers/scsi/qla2xxx/qla_fw.h  |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 68671a2..4a990f4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -149,11 +149,9 @@ qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
 	int rval = QLA_SUCCESS;
 	uint32_t cnt;
 
-	if (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE)
-		return rval;
-
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	for (cnt = 30000; (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
+	for (cnt = 30000;
+	    ((RD_REG_DWORD(&reg->host_status) & HSRX_RISC_PAUSED) == 0) &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt)
 			udelay(100);
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 9e56d4a..dfde2dd 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -878,7 +878,6 @@ struct device_reg_24xx {
 					/* HCCR statuses. */
 #define HCCRX_HOST_INT		BIT_6	/* Host to RISC interrupt bit. */
 #define HCCRX_RISC_RESET	BIT_5	/* RISC Reset mode bit. */
-#define HCCRX_RISC_PAUSE	BIT_4	/* RISC Pause mode bit. */
 					/* HCCR commands. */
 					/* NOOP. */
 #define HCCRX_NOOP		0x00000000
-- 
1.6.3.1.244.gf9275

