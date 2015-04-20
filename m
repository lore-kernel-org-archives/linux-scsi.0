From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/14] lpfc: Fix discovery issue when changing from Pt2Pt
 to Fabric.
Date: Mon, 20 Apr 2015 09:56:31 -0400
Message-ID: <5535058f.OpiOAP5bRRoigPLS%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbbDTN5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix discovery issue when changing from Pt2Pt to Fabric.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6ecd4ad..88af258 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4827,9 +4827,19 @@ lpfc_matchdid(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (matchdid.un.b.id == ndlpdid.un.b.id) {
 		if ((mydid.un.b.domain == matchdid.un.b.domain) &&
 		    (mydid.un.b.area == matchdid.un.b.area)) {
+			/* This code is supposed to match the ID
+			 * for a private loop device that is
+			 * connect to fl_port. But we need to
+			 * check that the port did not just go
+			 * from pt2pt to fabric or we could end
+			 * up matching ndlp->nlp_DID 000001 to
+			 * fabric DID 0x20101
+			 */
 			if ((ndlpdid.un.b.domain == 0) &&
 			    (ndlpdid.un.b.area == 0)) {
-				if (ndlpdid.un.b.id)
+				if (ndlpdid.un.b.id &&
+				    vport->phba->fc_topology ==
+				    LPFC_TOPOLOGY_LOOP)
 					return 1;
 			}
 			return 0;
-- 
1.7.11.7

