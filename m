From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/16]  qla2xxx: Remove RISC pause/release barriers during flash manipulation.
Date: Fri, 26 Aug 2005 19:09:10 -0700 (PDT)
Message-ID: <20050827020910.27275.53675.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:360 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751617AbVH0CJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:11 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Remove RISC pause/release barriers during flash manipulation.

Remove unnecessary RISC pause/release barriers during
ISP24xx flash manipulation.  The ISP24xx can arbitrate flash
access requests during RISC executions.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_sup.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

2fa684b695e1ff9420557a5488cc00e7ddc42499
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -468,21 +468,12 @@ qla24xx_read_flash_data(scsi_qla_host_t 
     uint32_t dwords)
 {
 	uint32_t i;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-
-	/* Pause RISC. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
 
 	/* Dword reads to flash. */
 	for (i = 0; i < dwords; i++, faddr++)
 		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
 		    flash_data_to_access_addr(faddr)));
 
-	/* Release RISC pause. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-
 	return dwptr;
 }
 
@@ -532,10 +523,6 @@ qla24xx_write_flash_data(scsi_qla_host_t
 
 	ret = QLA_SUCCESS;
 
-	/* Pause RISC. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-
 	qla24xx_get_flash_manufacturer(ha, &man_id, &flash_id);
 	DEBUG9(printk("%s(%ld): Flash man_id=%d flash_id=%d\n", __func__,
 	    ha->host_no, man_id, flash_id));
@@ -599,10 +586,6 @@ qla24xx_write_flash_data(scsi_qla_host_t
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
-	/* Release RISC pause. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-
 	return ret;
 }
 
@@ -630,11 +613,6 @@ qla24xx_read_nvram_data(scsi_qla_host_t 
 {
 	uint32_t i;
 	uint32_t *dwptr;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-
-	/* Pause RISC. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);	/* PCI Posting. */
 
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
@@ -642,10 +620,6 @@ qla24xx_read_nvram_data(scsi_qla_host_t 
 		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
 		    nvram_data_to_access_addr(naddr)));
 
-	/* Release RISC pause. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);	/* PCI Posting. */
-
 	return buf;
 }
 
@@ -690,10 +664,6 @@ qla24xx_write_nvram_data(scsi_qla_host_t
 
 	ret = QLA_SUCCESS;
 
-	/* Pause RISC. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-
 	/* Enable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
@@ -728,9 +698,5 @@ qla24xx_write_nvram_data(scsi_qla_host_t
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
-	/* Release RISC pause. */
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-
 	return ret;
 }

-- 
Andrew Vasquez
