From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 06/17] lpfc: Fix nvmet node ref count handling
Date: Thu,  1 Jun 2017 21:07:00 -0700
Message-ID: <20170602040711.21046-7-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35705 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdFBEHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:43 -0400
Received: by mail-qt0-f193.google.com with SMTP id r58so8204767qtb.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:43 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When unloading the driver, the NVMET driver would wait
the full 30 seconds for its UNMAPPED initiator node to
get removed before continuing with the unload process.
NVMEI worked correctly.

For each rport put into UNMAPPED or MAPPED state by NVMET,
the driver puts a reference on the NDLP.  The difference is
that NVMEI has a unregister call for its rports and the extra
reference is removed in the unregister process.  For NVMET,
the driver has to remove the reference explicitly when dropping
out of UNMAPPED or MAPPED because there is no unregister call.

Add a call to lpfc_nlp_put on the ndlp when NVMET and the old
state was UNMAPPED or MAPPED.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 055fedd761ea..db2d0e692ddf 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4167,14 +4167,14 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			lpfc_unregister_remote_port(ndlp);
 		}
 
-		/* Notify the NVME transport of this rport's loss on the
-		 * Initiator.  For NVME Target, should upcall transport
-		 * in the else clause when API available.
-		 */
 		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
 			vport->phba->nport_event_cnt++;
 			if (vport->phba->nvmet_support == 0)
+				/* Start devloss */
 				lpfc_nvme_unregister_port(vport, ndlp);
+			else
+				/* NVMET has no upcall. */
+				lpfc_nlp_put(ndlp);
 		}
 	}
 
-- 
2.11.0
