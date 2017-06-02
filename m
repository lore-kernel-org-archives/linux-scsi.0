From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 05/17] lpfc: Fix Lun Priority level shown as NA
Date: Thu,  1 Jun 2017 21:06:59 -0700
Message-ID: <20170602040711.21046-6-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35697 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdFBEHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:41 -0400
Received: by mail-qt0-f195.google.com with SMTP id r58so8204724qtb.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:41 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Lun Priority level shown as NA

Remote port is not getting registered for nameserver and fdmi.
Due to which dfc SendCTPassThru cmd is failing.

Made changes to register the remote port for both.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3ffcd9215ca8..055fedd761ea 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4182,8 +4182,10 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	if (new_state ==  NLP_STE_MAPPED_NODE ||
 	    new_state == NLP_STE_UNMAPPED_NODE) {
-		if ((ndlp->nlp_fc4_type & NLP_FC4_FCP) ||
-		    (ndlp->nlp_DID == Fabric_DID)) {
+		if (ndlp->nlp_fc4_type & NLP_FC4_FCP ||
+		    ndlp->nlp_DID == Fabric_DID ||
+		    ndlp->nlp_DID == NameServer_DID ||
+		    ndlp->nlp_DID == FDMI_DID) {
 			vport->phba->nport_event_cnt++;
 			/*
 			 * Tell the fc transport about the port, if we haven't
-- 
2.11.0
