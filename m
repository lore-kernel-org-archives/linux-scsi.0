From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/18] qla2xxx: Correct locking during NVRAM manipulation.
Date: Thu, 10 Jul 2008 16:55:46 -0700
Message-ID: <1215734163-40825-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbYGJX4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:06 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Commit 2c96d8d0c17978bbf5eb82314d488f46d4a51280 pushed the
acquisition of hardware_lock to too fine a level, which in turn
will cause problems with cond_resched()s added with
40a2e34a94c336b716f631b2952d233e1ba76e3c.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 1728ab3..ebea622 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -869,11 +869,9 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	uint32_t i;
 	uint32_t *dwptr;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	unsigned long flags;
 
 	ret = QLA_SUCCESS;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	/* Enable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) | CSRX_FLASH_ENABLE);
@@ -907,7 +905,6 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return ret;
 }
-- 
1.5.6.2.292.ga9a3

