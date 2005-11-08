From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5]  qla2xxx: Correct ISP24xx soft-reset handling.
Date: 8 Nov 2005 14:37:48 -0800
Message-ID: <20051108223744.25189.84146.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:79 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030378AbVKHWhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:37:48 -0500
In-Reply-To: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>


A driver must wait 100us before attempting an MMIO operation
to the RISC after a soft-reset has been initiated.  A
similar delay was needed with earlier ISPs.

Note: a PCI config-space read is used to flush the MMIO
write to the ISP, since the ISP's state machines are unable
to respond to any MMIO read during the reset process.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_dbg.c  |    8 ++++----
 drivers/scsi/qla2xxx/qla_init.c |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

applies-to: 13b38f128508db7f644b25952182052c8f24d550
a51d0ae6173d81cd674335071a924385788694f8
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 89793c1..5c5d231 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -970,7 +970,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	int		rval;
 	uint32_t	cnt, timer;
 	uint32_t	risc_address;
-	uint16_t	mb[4];
+	uint16_t	mb[4], wd;
 
 	uint32_t	stat;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
@@ -1514,10 +1514,10 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 
 		WRT_REG_DWORD(&reg->ctrl_status,
 		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		RD_REG_DWORD(&reg->ctrl_status);
+		pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
+		udelay(100);
 		/* Wait for firmware to complete NVRAM accesses. */
-		udelay(5);
 		mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 		for (cnt = 10000 ; cnt && mb[0]; cnt--) {
 			udelay(5);
@@ -1525,7 +1525,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 			barrier();
 		}
 
-		udelay(20);
+		/* Wait for soft-reset to complete. */
 		for (cnt = 0; cnt < 30000; cnt++) {
 			if ((RD_REG_DWORD(&reg->ctrl_status) &
 			    CSRX_ISP_SOFT_RESET) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8fb084b..2d72012 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -567,6 +567,7 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t cnt, d2;
+	uint16_t wd;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -581,10 +582,10 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-	RD_REG_DWORD(&reg->ctrl_status);
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
+	udelay(100);
 	/* Wait for firmware to complete NVRAM accesses. */
-	udelay(5);
 	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 	for (cnt = 10000 ; cnt && d2; cnt--) {
 		udelay(5);
@@ -592,7 +593,7 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
 		barrier();
 	}
 
-	udelay(20);
+	/* Wait for soft-reset to complete. */
 	d2 = RD_REG_DWORD(&reg->ctrl_status);
 	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
 		udelay(5);
---
0.99.9.GIT

-- 
Andrew Vasquez
