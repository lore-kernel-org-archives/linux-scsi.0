From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] lpfc: Fix NULL pointer dereference during PCI error recovery
Date: Wed, 17 May 2017 19:02:17 -0300
Message-ID: <20170517220217.28337-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43059 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753658AbdEQWCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 May 2017 18:02:55 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4HLwrLI112773
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 18:02:55 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2agn5vn53b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 18:02:54 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 17 May 2017 19:02:52 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4HM2jL030474248
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 19:02:50 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4HM2TQ0010780
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 19:02:30 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com, gpiccoli@linux.vnet.ibm.com

Recent commit on patchset "lpfc updates for 11.2.0.14" fixed an issue
about dereferencing a NULL pointer on port reset. The specific commit,
named "lpfc: Fix system crash when port is reset.", is missing a check
against NULL pointer on lpfc_els_flush_cmd() though.

Since we destroy the queues on adapter resets, like in PCI error
recovery path, we need the validation present on this patch in order
to avoid a NULL pointer dereference when trying to flush commands of
ELS wq, after it has been destroyed (which would lead to a kernel oops).

Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---

This patch was rebased against 4.12/scsi-fixes on mkp tree.
I couldn't figure a better way to refer to commits in this
message because they weren't merged on linus tree yet, so
the sha hashes wouldn't make sense. If you have some idea,
please let me know and I can send v2 if desired.

 drivers/scsi/lpfc/lpfc_els.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1d36f82fa369..8e532b39ae93 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7451,6 +7451,13 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
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
