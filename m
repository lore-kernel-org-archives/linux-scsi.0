From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/15] lpfc 8.1.7 : Issue DOWN_LINK prior to INIT_LINK to
	work around link failure issue
Date: Thu, 06 Jul 2006 15:49:49 -0400
Message-ID: <1152215389.23158.22.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20620 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750775AbWGFTte
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:34 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JnW1c006935
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Issue DOWN_LINK prior to INIT_LINK to work around link failure issue

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 14:49:10.000000000 -0400
@@ -219,9 +219,19 @@ lpfc_issue_lip(struct Scsi_Host *host)
 		return -ENOMEM;
 
 	memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
-	lpfc_init_link(phba, pmboxq, phba->cfg_topology, phba->cfg_link_speed);
+	pmboxq->mb.mbxCommand = MBX_DOWN_LINK;
+	pmboxq->mb.mbxOwner = OWN_HOST;
+
 	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
 
+	if ((mbxstatus == MBX_SUCCESS) && (pmboxq->mb.mbxStatus == 0)) {
+		memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
+		lpfc_init_link(phba, pmboxq, phba->cfg_topology,
+			       phba->cfg_link_speed);
+		mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq,
+						     phba->fc_ratov * 2);
+	}
+
 	if (mbxstatus == MBX_TIMEOUT)
 		pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	else


