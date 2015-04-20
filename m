From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/14] lpfc: The lpfc driver does not issue RFF_ID and
 RFT_ID in the correct sequence
Date: Mon, 20 Apr 2015 09:56:24 -0400
Message-ID: <55350588.xwtuh+7l3U0CWLLy%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbbDTN5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The lpfc driver does not issue RFF_ID and RFT_ID in the correct sequence

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2500f15..f2db89f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3868,11 +3868,11 @@ out:
 
 	if (vport->port_state < LPFC_VPORT_READY) {
 		/* Link up discovery requires Fabric registration. */
-		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0); /* Do this first! */
 		lpfc_ns_cmd(vport, SLI_CTNS_RNN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
 		lpfc_ns_cmd(vport, SLI_CTNS_RFT_ID, 0, 0);
+		lpfc_ns_cmd(vport, SLI_CTNS_RFF_ID, 0, 0);
 
 		/* Issue SCR just before NameServer GID_FT Query */
 		lpfc_issue_els_scr(vport, SCR_DID, 0);
-- 
1.7.11.7

