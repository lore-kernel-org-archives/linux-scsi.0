From: James.Smart@Emulex.Com
Subject: [PATCH 9 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:33 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F414E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46270 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261256AbVFYOef convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:35 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYY9P008205
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:34 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix ADISC completion incorrectly putting initiators on mapped list

Symptom - An unmapped node (initiator) that goes away in a situation
such as cable pull, comes back as a mapped node.  Fix - On ADISC
completion, put a list on the mapped list only if it is a FCP_TARGET.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_nportdisc.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_nportdisc.c~adisc drivers/scsi/lpfc/lpfc_nportdisc.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_nportdisc.c~adisc	2005-06-25 09:42:42.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_nportdisc.c	2005-06-25 09:42:42.000000000 -0400
@@ -950,8 +950,13 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_
 		lpfc_unreg_rpi(phba, ndlp);
 		return (ndlp->nlp_state);
 	}
-	ndlp->nlp_state = NLP_STE_MAPPED_NODE;
-	lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+	if (ndlp->nlp_type & NLP_FCP_TARGET) {
+		ndlp->nlp_state = NLP_STE_MAPPED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_MAPPED_LIST);
+	} else {
+		ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
+		lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
+	}
 	return (ndlp->nlp_state);
 }
 
_
