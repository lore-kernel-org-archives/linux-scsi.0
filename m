From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 03/21] lpfc: Fix loop mode target discovery
Date: Wed,  2 Aug 2017 16:36:30 -0700
Message-ID: <20170802233648.4573-4-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36509 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdHBXhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:37:54 -0400
Received: by mail-qt0-f193.google.com with SMTP id c15so6152366qta.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:37:54 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

The driver does not discover targets when in loop mode.

The NLP type is correctly getting set when a fabric connection is
detected but, not for loop. The unknown NLP type means that the
driver does not issue a PRLI when in loop topology. Thus target
discovery fails.

Fix by checking the topology during discovery.  If it is loop,
set the NLP FC4 type to FCP.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f74cb0142fd4..95b2b43ac37d 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1724,6 +1724,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 				lpfc_nvme_update_localport(vport);
 			}
 
+		} else if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+			ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+
 		} else if (ndlp->nlp_fc4_type == 0) {
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_GFT_ID,
 					 0, ndlp->nlp_DID);
-- 
2.13.1
