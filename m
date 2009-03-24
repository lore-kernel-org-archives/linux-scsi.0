From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/26] qla2xxx: Use byte-address while reading FC boot code versions from flash.
Date: Tue, 24 Mar 2009 09:07:59 -0700
Message-ID: <1237910900-30817-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762311AbZCXQI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:26 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

The pcihdr variable is used to find valid boot code image to get
FC boot code versions from flash. The pcihdr variable should be
byte aligned.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 2848279..5b24af8 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2518,7 +2518,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	dcode = mbuf;
 
 	/* Begin with first PCI expansion ROM header. */
-	pcihdr = ha->flt_region_boot;
+	pcihdr = ha->flt_region_boot << 2;
 	last_image = 1;
 	do {
 		/* Verify PCI expansion ROM header. */
-- 
1.6.2.rc0.55.g30aa4f

