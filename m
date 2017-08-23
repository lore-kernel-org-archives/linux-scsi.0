From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 08/20] lpfc: Fix duplicate NVME rport entries and namespaces.
Date: Wed, 23 Aug 2017 16:55:37 -0700
Message-ID: <20170823235549.2883-9-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34335 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdHWX4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:17 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69so1074442wmh.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:16 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

After lip, the driver sometimes would have two rports for the same
device, allowing the namespaces to be duplicated by nvme.

In lpfc_plogi_confirm_nport() the driver was not swapping the
nrport maintained by the ndlp's undergoing address swapping. This
allowed the 2nd rport to sneak in as it was considered a separate
device.

This patch adds the fixes to Swap the nrport in each ndlp and take
care of the reference counts on the ndlps similar to FCP rports.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
v3:
  revise comment to clarify per review
---
 drivers/scsi/lpfc/lpfc_els.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 19af0e6e7667..ffbd3eddeabb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1527,6 +1527,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t rc, keepDID = 0, keep_nlp_flag = 0;
 	uint16_t keep_nlp_state;
+	struct lpfc_nvme_rport *keep_nrport = NULL;
 	int  put_node;
 	int  put_rport;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
@@ -1624,6 +1625,10 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	keep_nlp_state = new_ndlp->nlp_state;
 	lpfc_nlp_set_state(vport, new_ndlp, ndlp->nlp_state);
 
+	/* interchange the nvme remoteport structs */
+	keep_nrport = new_ndlp->nrport;
+	new_ndlp->nrport = ndlp->nrport;
+
 	/* Move this back to NPR state */
 	if (memcmp(&ndlp->nlp_portname, name, sizeof(struct lpfc_name)) == 0) {
 		/* The new_ndlp is replacing ndlp totally, so we need
@@ -1646,6 +1651,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			}
 			new_ndlp->nlp_type = ndlp->nlp_type;
 		}
+
+		/* Fix up the nvme rport */
+		if (ndlp->nrport) {
+			ndlp->nrport = NULL;
+			lpfc_nlp_put(ndlp);
+		}
+
 		/* We shall actually free the ndlp with both nlp_DID and
 		 * nlp_portname fields equals 0 to avoid any ndlp on the
 		 * nodelist never to be used.
@@ -1690,6 +1702,14 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			keep_nlp_state = NLP_STE_NPR_NODE;
 		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
 
+		/* Previous ndlp no longer active with nvme host transport.
+		 * Remove reference from earlier registration unless the
+		 * nvme host took care of it.
+		 */
+		if (ndlp->nrport)
+			lpfc_nlp_put(ndlp);
+		ndlp->nrport = keep_nrport;
+
 		/* Fix up the rport accordingly */
 		rport = ndlp->rport;
 		if (rport) {
-- 
2.13.1
