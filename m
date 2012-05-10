From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/20] lpfc 8.3.31: Fix error message displayed even when
 not an error
Date: Wed, 9 May 2012 21:17:37 -0400
Message-ID: <1336612667.1996.37.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27886 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756740Ab2EJBSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix error message displayed even when not an error.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:12.000000000 -0400
@@ -13278,16 +13278,14 @@ lpfc_sli4_next_xritag(struct lpfc_hba *p
 	uint16_t xri_index;
 
 	xri_index = lpfc_sli4_alloc_xri(phba);
-	if (xri_index != NO_XRI)
-		return xri_index;
-
-	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"2004 Failed to allocate XRI.last XRITAG is %d"
-			" Max XRI is %d, Used XRI is %d\n",
-			xri_index,
-			phba->sli4_hba.max_cfg_param.max_xri,
-			phba->sli4_hba.max_cfg_param.xri_used);
-	return NO_XRI;
+	if (xri_index == NO_XRI)
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2004 Failed to allocate XRI.last XRITAG is %d"
+				" Max XRI is %d, Used XRI is %d\n",
+				xri_index,
+				phba->sli4_hba.max_cfg_param.max_xri,
+				phba->sli4_hba.max_cfg_param.xri_used);
+	return xri_index;
 }
 
 /**



