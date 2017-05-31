From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 06/15] lpfc: Fix nvmet node ref count handling
Date: Tue, 30 May 2017 23:04:30 -0700
Message-ID: <20170531060439.2073-7-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36447 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdEaGFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:05:00 -0400
Received: by mail-qk0-f193.google.com with SMTP id y128so733098qka.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:04:59 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
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
