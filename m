From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 6/6] SCSI: esas2r: coccinelle - Replace memcpy with struct assignment
Date: Thu, 29 Aug 2013 15:55:44 -0400
Message-ID: <1377806144-4902-7-git-send-email-bgrove@attotech.com>
References: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:45379 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756888Ab3H2Unz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 16:43:55 -0400
In-Reply-To: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_flash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 45e353f..2ec3c23 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -1360,7 +1360,7 @@ void esas2r_nvram_set_defaults(struct esas2r_adapter *a)
 	u32 time = jiffies_to_msecs(jiffies);
 
 	esas2r_lock_clear_flags(&a->flags, AF_NVR_VALID);
-	memcpy(n, &default_sas_nvram, sizeof(struct esas2r_sas_nvram));
+	*n = default_sas_nvram;
 	n->sas_addr[3] |= 0x0F;
 	n->sas_addr[4] = HIBYTE(LOWORD(time));
 	n->sas_addr[5] = LOBYTE(LOWORD(time));
@@ -1378,7 +1378,7 @@ void esas2r_nvram_get_defaults(struct esas2r_adapter *a,
 	 * address out first.
 	 */
 	memcpy(&sas_addr[0], a->nvram->sas_addr, 8);
-	memcpy(nvram, &default_sas_nvram, sizeof(struct esas2r_sas_nvram));
+	*nvram = default_sas_nvram;
 	memcpy(&nvram->sas_addr[0], &sas_addr[0], 8);
 }
 
-- 
1.8.1.4

