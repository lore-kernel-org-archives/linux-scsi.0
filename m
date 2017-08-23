From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 02/20] lpfc: Fix loop mode target discovery
Date: Wed, 23 Aug 2017 16:55:31 -0700
Message-ID: <20170823235549.2883-3-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35920 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdHWX4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id f127so1061045wmf.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:04 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
