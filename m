From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/12] qla2xxx: Simplify sector-mask calculation in preparation for larger flash parts.
Date: Thu, 22 Jan 2009 09:45:29 -0800
Message-ID: <1232646339-32503-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbZAVRpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:43 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Also removes unneeded 'findex' local variable within routine.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 303f8ee..afec7f9 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -982,7 +982,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	int ret;
 	uint32_t liter, miter;
 	uint32_t sec_mask, rest_addr;
-	uint32_t fdata, findex;
+	uint32_t fdata;
 	dma_addr_t optrom_dma;
 	void *optrom = NULL;
 	uint32_t *s, *d;
@@ -1003,17 +1003,15 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	}
 
 	rest_addr = (ha->fdt_block_size >> 2) - 1;
-	sec_mask = (ha->optrom_size >> 2) - (ha->fdt_block_size >> 2);
+	sec_mask = ~rest_addr;
 
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-
-		findex = faddr;
-		fdata = (findex & sec_mask) << 2;
+		fdata = (faddr & sec_mask) << 2;
 
 		/* Are we at the beginning of a sector? */
-		if ((findex & rest_addr) == 0) {
+		if ((faddr & rest_addr) == 0) {
 			/* Do sector unprotect. */
 			if (ha->fdt_unprotect_sec_cmd)
 				qla24xx_write_flash_dword(ha,
-- 
1.6.1.48.ge9b8

