From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 1/9] lpfc: Correct LOGO handling during login
Date: Thu, 31 Mar 2016 14:12:27 -0700
Message-ID: <56fd92bb.f1iGbo3Q4TLsfnF0%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34737 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbcCaVMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:31 -0400
Received: by mail-pf0-f169.google.com with SMTP id x3so77741235pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:31 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id l14sm15508672pfi.23.2016.03.31.14.12.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct LOGO handling during login

After a link bounce, when a remote port issues a LOGO while a REGLOGIN is
pending on that port, the driver does not clean up the ndlp structure. May
result in stack traces in the console log.

Fix: Clear the NLP_REG_LOGIN_SEND flag on the ndlp in the routine

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 ++
 drivers/scsi/lpfc/lpfc_sli.c       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 193733e..9b539e2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1512,6 +1512,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 	if ((mb = phba->sli.mbox_active)) {
 		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) &&
 		   (ndlp == (struct lpfc_nodelist *) mb->context2)) {
+			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 			lpfc_nlp_put(ndlp);
 			mb->context2 = NULL;
 			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -1527,6 +1528,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc_vport *vport,
 				__lpfc_mbuf_free(phba, mp->virt, mp->phys);
 				kfree(mp);
 			}
+			ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 			lpfc_nlp_put(ndlp);
 			list_del(&mb->list);
 			phba->sli.mboxq_cnt--;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2207726..035105a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2211,6 +2211,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		rpi = pmb->u.mb.un.varWords[0];
 		vpi = pmb->u.mb.un.varRegLogin.vpi;
 		lpfc_unreg_login(phba, vpi, rpi, pmb);
+		pmb->vport = vport;
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 		if (rc != MBX_NOT_FINISHED)
-- 
2.5.0

