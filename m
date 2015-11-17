From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-lpfc: Delete unnecessary checks before the function call
 "mempool_destroy"
Date: Tue, 17 Nov 2015 09:44:27 +0100
Message-ID: <564AE8EB.4050509@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57030 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbbKQIok (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 03:44:40 -0500
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@avagotech.com>, "James E. J. Bottomley" <JBottomley@odin.com>, James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 17 Nov 2015 09:34:27 +0100

The mempool_destroy() function tests whether its argument is NULL
and then returns immediately. Thus the test around the calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/lpfc/lpfc_mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..4fb3581 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -231,15 +231,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	if (phba->lpfc_hbq_pool)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
 	phba->lpfc_hbq_pool = NULL;
-
-	if (phba->rrq_pool)
-		mempool_destroy(phba->rrq_pool);
+	mempool_destroy(phba->rrq_pool);
 	phba->rrq_pool = NULL;
 
 	/* Free NLP memory pool */
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
-	if (phba->sli_rev == LPFC_SLI_REV4 && phba->active_rrq_pool) {
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		mempool_destroy(phba->active_rrq_pool);
 		phba->active_rrq_pool = NULL;
 	}
-- 
2.6.2

