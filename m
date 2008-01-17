From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Wait for FLASH write-protection to complete after a write.
Date: Thu, 17 Jan 2008 09:02:10 -0800
Message-ID: <1200589340-19499-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYAQRCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:32 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Some flash parts have a slow enable write-protection (WP)
operation whereby subsequent FLASH accesses would fail if the WP
operation had not completed.  Software now polls the SPI's
status-register for WP completion.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ad2fa01..af16c55 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -550,7 +550,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 	int ret;
 	uint32_t liter, miter;
 	uint32_t sec_mask, rest_addr, conf_addr;
-	uint32_t fdata, findex ;
+	uint32_t fdata, findex, cnt;
 	uint8_t	man_id, flash_id;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	dma_addr_t optrom_dma;
@@ -690,8 +690,14 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 			    0xff0000) | ((fdata >> 16) & 0xff));
 	}
 
-	/* Enable flash write-protection. */
+	/* Enable flash write-protection and wait for completion. */
 	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
+	for (cnt = 300; cnt &&
+	    qla24xx_read_flash_dword(ha,
+		    flash_conf_to_access_addr(0x005)) & BIT_0;
+	    cnt--) {
+		udelay(10);
+	}
 
 	/* Disable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
-- 
1.5.4.rc3.14.g44397

