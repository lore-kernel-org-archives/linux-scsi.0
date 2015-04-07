From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in
 RSNN-NN FC-GS command
Date: Tue, 7 Apr 2015 15:07:18 -0400
Message-ID: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27592 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbDGTIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix provide host name and OS name in RSNN-NN FC-GS command

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 61a32cd..5fb431a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1074,8 +1074,25 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 
 	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
 
-	n = snprintf(symbol, size, "Emulex %s FV%s DV%s",
-		vport->phba->ModelName, fwrev, lpfc_release_version);
+	n = snprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
+
+	if (size < n)
+		return n;
+	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
+
+	if (size < n)
+		return n;
+	n += snprintf(symbol + n, size - n, " DV%s", lpfc_release_version);
+
+	if (size < n)
+		return n;
+	n += snprintf(symbol + n, size - n, " HN:%s", init_utsname()->nodename);
+
+	/* Note :- OS name is "Linux" */
+	if (size < n)
+		return n;
+	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
+
 	return n;
 }
 
-- 
1.7.11.7

