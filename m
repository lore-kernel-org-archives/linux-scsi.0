From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8] qla2xxx: Fix issue where final flash-segment updates were falling into the slow-path write handler.
Date: Fri, 19 Oct 2007 15:59:16 -0700
Message-ID: <1192834760-573-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966637AbXJSW7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:38 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original implementation would not use the burst-write mechanisms
for requests equal to OPTROM_BURST_DWORDS transfer dwords.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b3faff0..0a35f87 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -643,7 +643,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
 		}
 
 		/* Go with burst-write. */
-		if (optrom && (liter + OPTROM_BURST_DWORDS) < dwords) {
+		if (optrom && (liter + OPTROM_BURST_DWORDS) <= dwords) {
 			/* Copy data to DMA'ble buffer. */
 			for (miter = 0, s = optrom, d = dwptr;
 			    miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
-- 
1.5.3.4.206.g58ba4

