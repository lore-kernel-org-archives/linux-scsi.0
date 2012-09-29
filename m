From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/16] lpfc 8.3.35: Fixed SCSI host create showing wrong
 link speed on SLI3 HBA ports
Date: Sat, 29 Sep 2012 11:32:09 -0400
Message-ID: <1348932729.23909.32.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35027 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab2I2Phn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:37:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed SCSI host create showing wrong link speed on SLI3 HBA ports


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:44.140154085 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:47.796154168 -0400
@@ -1892,8 +1892,10 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		max_speed = 4;
 	else if (phba->lmt & LMT_2Gb)
 		max_speed = 2;
-	else
+	else if (phba->lmt & LMT_1Gb)
 		max_speed = 1;
+	else
+		max_speed = 0;
 
 	vp = &phba->vpd;
 
@@ -2078,9 +2080,13 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 	if (descp && descp[0] == '\0') {
 		if (oneConnect)
 			snprintf(descp, 255,
-				"Emulex OneConnect %s, %s Initiator, Port %s",
+				"Emulex OneConnect %s, %s Initiator %s",
 				m.name, m.function,
 				phba->Port);
+		else if (max_speed == 0)
+			snprintf(descp, 255,
+				"Emulex %s %s %s ",
+				m.name, m.bus, m.function);
 		else
 			snprintf(descp, 255,
 				"Emulex %s %d%s %s %s",



