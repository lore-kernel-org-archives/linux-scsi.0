From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/15] lpfc: Fix system crash when port is reset.
Date: Mon, 15 May 2017 16:31:32 -0300
Message-ID: <20170515193132.22385-1-gpiccoli@linux.vnet.ibm.com>
References: <20170510190713.30171-3-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933207AbdEOTbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 15:31:41 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4FJVCm5038004
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 15:31:40 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2afjhsr0gf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 15:31:39 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Mon, 15 May 2017 16:31:37 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4FJVZGK29753410
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 16:31:35 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4FJVaeZ017140
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 16:31:36 -0300
In-Reply-To: <20170510190713.30171-3-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, gpiccoli@linux.vnet.ibm.com

Hi James and Dick, thanks for this patch. We were investigating a pretty
similar issue, and we raised a patch that looks like yours.
Since you sent this one, we reviewed and seems it's missing a hunk to
prevent the issue we are dealing here, in PCI error recovery.

Please see the attached patch. Basically, lpfc is dereferencing a NULL
pointer on PCI error recovery path in lpfc_els_flush_cmd(). Feel free to
take this hunk on your patch, or if you prefer we can send a complete patch.

Thanks in advance,


Guilherme

---
 drivers/scsi/lpfc/lpfc_els.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 67827e397431..4e354194cb54 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7441,6 +7441,13 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	 */
 	spin_lock_irq(&phba->hbalock);
 	pring = lpfc_phba_elsring(phba);
+
+	/* Bail out if we've no ELS wq, like in PCI error recovery case. */
+	if (unlikely(!pring)) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
-- 
2.12.0.rc0
