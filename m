From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] scsi: lpfc: Fix crash on PCI hotplug remove path
Date: Sun, 28 May 2017 18:45:54 -0300
Message-ID: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37577 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750879AbdE1VqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 May 2017 17:46:04 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4SLhjFl147195
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2017 17:46:03 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2aqg1nhug4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2017 17:46:03 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Sun, 28 May 2017 18:46:00 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4SLjvin61669472
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2017 18:45:57 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4SLjwCM031202
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2017 18:45:58 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, gpiccoli@linux.vnet.ibm.com, jsmart2021@gmail.com, porcusbr@gmail.com

During a PCI hotplug remove event we could have a NULL pointer
dereference on lpfc_sli_abort_iocb(), if pring is NULL. This
patch adds a check for this case and is able to circumvent the
failure and continue the hotplug remove process with success.

This issue was introduced after the driver refactor made on
commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications").

Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
This patch was rebased against Martin's 4.12/scsi-fixes.

 drivers/scsi/lpfc/lpfc_sli.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d6b184839bc2..134c60a66fb8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11003,9 +11003,13 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		/* Setup callback routine and issue the command. */
 		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
-		ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
-					      abtsiocb, 0);
-		if (ret_val == IOCB_ERROR) {
+
+		/* In PCI hotplug remove path, pring might be NULL */
+		if (pring)
+			ret_val = lpfc_sli_issue_iocb(phba, pring->ringno,
+						      abtsiocb, 0);
+
+		if (!pring || ret_val == IOCB_ERROR) {
 			lpfc_sli_release_iocbq(phba, abtsiocb);
 			errcnt++;
 			continue;
-- 
2.12.0.rc0
