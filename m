From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/15] lpfc 8.1.7 : Fix txcmplq related panics on heavy IO
	while downloading firmware
Date: Thu, 06 Jul 2006 15:49:56 -0400
Message-ID: <1152215396.23158.23.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21388 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750776AbWGFTtl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:41 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66Jnd3s006939
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix txcmplq related panics on heavy IO while downloading firmware

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 14:50:59.000000000 -0400
@@ -1339,7 +1339,8 @@ lpfc_offline(struct lpfc_hba * phba)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	unsigned long iflag;
-	int i = 0;
+	int i;
+	int cnt = 0;
 
 	if (!phba)
 		return 0;
@@ -1348,17 +1349,26 @@ lpfc_offline(struct lpfc_hba * phba)
 		return 0;
 
 	psli = &phba->sli;
-	pring = &psli->ring[psli->fcp_ring];
 
 	lpfc_linkdown(phba);
 
-	/* The linkdown event takes 30 seconds to timeout. */
-	while (pring->txcmplq_cnt) {
-		mdelay(10);
-		if (i++ > 3000)
-			break;
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->ring[i];
+		/* The linkdown event takes 30 seconds to timeout. */
+		while (pring->txcmplq_cnt) {
+			mdelay(10);
+			if (cnt++ > 3000) {
+				lpfc_printf_log(phba,
+					KERN_WARNING, LOG_INIT,
+					"%d:0466 Outstanding IO when "
+					"bringing Adapter offline\n",
+					phba->brd_no);
+				break;
+			}
+		}
 	}
 
+
 	/* stop all timers associated with this hba */
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;


