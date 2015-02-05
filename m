From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/21] lpfc: Fix internal loopback failure
Date: Thu, 5 Feb 2015 14:25:25 -0500
Message-ID: <1423164325.7917.40.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:47587 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbBETZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:25:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---
 drivers/scsi/lpfc/lpfc_els.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ba5da26..1003b5b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3337,7 +3337,11 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* FLOGI retry policy */
 		retry = 1;
 		/* retry FLOGI forever */
-		maxretry = 0;
+		if (phba->link_flag != LS_LOOPBACK_MODE)
+			maxretry = 0;
+		else
+			maxretry = 2;
+
 		if (cmdiocb->retry >= 100)
 			delay = 5000;
 		else if (cmdiocb->retry >= 32)
-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



