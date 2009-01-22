From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/12] qla2xxx: Correct endianness issue during flash manipulation.
Date: Thu, 22 Jan 2009 09:45:34 -0800
Message-ID: <1232646339-32503-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369AbZAVRpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:49 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The flash data was incorrectly being converted (cpu_to_le32())
when using the bulk-flash-write mailbox command (ISP25xx and
above).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index afec7f9..ed95826 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -980,12 +980,11 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	int ret;
-	uint32_t liter, miter;
+	uint32_t liter;
 	uint32_t sec_mask, rest_addr;
 	uint32_t fdata;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
-	uint32_t *s, *d;
 	struct qla_hw_data *ha = vha->hw;
 
 	ret = QLA_SUCCESS;
@@ -1031,9 +1030,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		/* Go with burst-write. */
 		if (optrom && (liter + OPTROM_BURST_DWORDS) <= dwords) {
 			/* Copy data to DMA'ble buffer. */
-			for (miter = 0, s = optrom, d = dwptr;
-			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
-				*s = cpu_to_le32(*d);
+			memcpy(optrom, dwptr, OPTROM_BURST_SIZE);
 
 			ret = qla2x00_load_ram(vha, optrom_dma,
 			    flash_data_addr(ha, faddr),
-- 
1.6.1.48.ge9b8

