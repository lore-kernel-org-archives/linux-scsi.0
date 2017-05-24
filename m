From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] scsi: lpfc: Avoid NULL pointer dereference in lpfc_els_abort()
Date: Wed, 24 May 2017 18:48:51 -0300
Message-ID: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42045 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1033549AbdEXVtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 17:49:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4OLn7PQ019241
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2017 17:49:10 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2and2qwayy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2017 17:49:09 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 24 May 2017 18:49:02 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4OLmxx935717242
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2017 18:48:59 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4OLn07P008222
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2017 18:49:00 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, gpiccoli@linux.vnet.ibm.com, jsmart2021@gmail.com

We might have a NULL pring in lpfc_els_abort(), for example on
error recovery path, since queues are destroyed during error
recovery mechanism.

In this case, we should just drop the abort since the queues will
be recreated anyway. This patch just verifies for NULL pointer
and stop the abortion of the queue in case of a NULL pring.

Also, this patch converts return type of lpfc_els_abort() from int
to void, since it's not checked anywhere.

Reported-by: Harsha Thyagaraja <hathyaga@in.ibm.com>
Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
* This patch was rebased against Martin's 4.12/scsi-fixes.

 drivers/scsi/lpfc/lpfc_crtn.h      | 2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8912767e7bc8..da669dce12fe 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -127,7 +127,7 @@ int lpfc_disc_state_machine(struct lpfc_vport *, struct lpfc_nodelist *, void *,
 void lpfc_do_scr_ns_plogi(struct lpfc_hba *, struct lpfc_vport *);
 int lpfc_check_sparm(struct lpfc_vport *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t, int);
-int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
+void lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_more_plogi(struct lpfc_vport *);
 void lpfc_more_adisc(struct lpfc_vport *);
 void lpfc_end_rscn(struct lpfc_vport *);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index bff3de053df4..f74cb0142fd4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -206,7 +206,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * associated with a LPFC_NODELIST entry. This
  * routine effectively results in a "software abort".
  */
-int
+void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(abort_list);
@@ -215,6 +215,10 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 
 	pring = lpfc_phba_elsring(phba);
 
+	/* In case of error recovery path, we might have a NULL pring here */
+	if (!pring)
+		return;
+
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
 			 "2819 Abort outstanding I/O on NPort x%x "
@@ -273,7 +277,6 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
 
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
-	return 0;
 }
 
 static int
-- 
2.12.0.rc0
