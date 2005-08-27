From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/16]  qla2xxx: Correct ISP24xx soft-reset handling.
Date: Fri, 26 Aug 2005 19:08:20 -0700 (PDT)
Message-ID: <20050827020820.27275.23899.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:42855 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751611AbVH0CIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:21 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Correct ISP24xx soft-reset handling.

A driver must wait 100us before attempting an MMIO operation
to the RISC after a soft-reset has been initiated.  A
similar delay was needed with earlier ISPs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.c  |   10 +++++++---
 drivers/scsi/qla2xxx/qla_init.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

de11680e687bc8e8a0d34e42b872a60dd9ab7db2
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1526,10 +1526,14 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 
 		WRT_REG_DWORD(&reg->ctrl_status,
 		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		RD_REG_DWORD(&reg->ctrl_status);
+		/*
+		 * It is necessary to delay here since the card doesn't respond
+		 * to PCI reads during a reset. On some architectures this will
+		 * result in an MCA.
+		*/
+		udelay(100);
 
 		/* Wait for firmware to complete NVRAM accesses. */
-		udelay(5);
 		mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 		for (cnt = 10000 ; cnt && mb[0]; cnt--) {
 			udelay(5);
@@ -1537,7 +1541,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 			barrier();
 		}
 
-		udelay(20);
+		/* Wait for soft-reset to complete. */
 		for (cnt = 0; cnt < 30000; cnt++) {
 			if ((RD_REG_DWORD(&reg->ctrl_status) &
 			    CSRX_ISP_SOFT_RESET) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -589,10 +589,14 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-	RD_REG_DWORD(&reg->ctrl_status);
+	/*
+	 * It is necessary to delay here since the card doesn't respond to PCI
+	 * reads during a reset. On some architectures this will result in an
+	 * MCA.
+	 */
+	udelay(100);
 
 	/* Wait for firmware to complete NVRAM accesses. */
-	udelay(5);
 	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 	for (cnt = 10000 ; cnt && d2; cnt--) {
 		udelay(5);
@@ -600,7 +604,7 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 		barrier();
 	}
 
-	udelay(20);
+	/* Wait for soft-reset to complete. */
 	d2 = RD_REG_DWORD(&reg->ctrl_status);
 	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
 		udelay(5);

-- 
Andrew Vasquez
