From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/18] lpfc 8.3.42: Fixed mailbox memory leak.
Date: Fri, 6 Sep 2013 12:19:06 -0400
Message-ID: <1378484346.14051.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22775 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQTm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:19:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed mailbox memory leak.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-09-06 10:04:06.298058357 -0400
@@ -4437,6 +4437,7 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phb
 	if (!ndlp)
 		return;
 	lpfc_issue_els_logo(vport, ndlp, 0);
+	mempool_free(pmb, phba->mbox_mem_pool);
 }
 
 /*



