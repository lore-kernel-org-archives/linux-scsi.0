From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/21] lpfc: Fix provide host name and OS name in RSNN-NN
 FC-GS command
Date: Thu, 5 Feb 2015 14:24:28 -0500
Message-ID: <1423164268.7917.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:20678 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbBETYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:24:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc_ct.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 61a32cd..5091184 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1070,12 +1070,29 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
 	char fwrev[FW_REV_STR_SIZE];
-	int n;
+	int n = 0;
 
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
+	/* Note :- OS name is "Linux" as per requirement BZ168199. */
+	if (size < n)
+		return n;
+	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
+
 	return n;
 }
 
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



