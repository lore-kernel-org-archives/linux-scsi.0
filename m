From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/12] qla2xxx: Correct descriptions in flash manipulation routines.
Date: Thu, 22 Jan 2009 09:45:36 -0800
Message-ID: <1232646339-32503-10-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbZAVRp5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:57 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When clearing the flash device's SR, the comment is incorrect...
clearing the SR is 2 steps:

1. the SR protect bit is 1, so the first write zero clears only
   that bit,

2. the SR protect bit is now 0, so the next write zero clears the
   remaining bits.

The sector erase debug print more correctly identifies that the erase failed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ed95826..9c3b694 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -944,9 +944,9 @@ qla24xx_unprotect_flash(struct qla_hw_data *ha)
 	if (!ha->fdt_wrt_disable)
 		return;
 
-	/* Disable flash write-protection. */
+	/* Disable flash write-protection, first clear SR protection bit */
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
-	/* Some flash parts need an additional zero-write to clear bits.*/
+	/* Then write zero again to clear remaining SR bits.*/
 	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
 }
 
@@ -1021,7 +1021,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 			    (fdata & 0xff00) |((fdata << 16) &
 			    0xff0000) | ((fdata >> 16) & 0xff));
 			if (ret != QLA_SUCCESS) {
-				DEBUG9(qla_printk("Unable to flash sector: "
+				DEBUG9(qla_printk("Unable to erase sector: "
 				    "address=%x.\n", faddr));
 				break;
 			}
-- 
1.6.1.48.ge9b8

