From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 15/20] lpfc: Fix internal loopback failure.
Date: Tue, 7 Apr 2015 15:07:23 -0400
Message-ID: <55242aeb.qQxscBPgZlKQn6E+%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:33630 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbDGTIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix internal loopback failure.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
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

