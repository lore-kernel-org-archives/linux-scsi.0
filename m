From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: sanity check hrq is null before dereferencing it
Date: Fri, 24 Feb 2017 13:56:42 +0000
Message-ID: <20170224135642.5690-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38267 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdBXN4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2017 08:56:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The sanity check for hrq should be moved to before the deference
of hrq to ensure we don't perform a null pointer deference.

Detected by CoverityScan, CID#1411650 ("Dereference before null check")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e43e5e2..1fba5dc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15185,17 +15185,17 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		drq = drqp[idx];
 		cq  = cqp[idx];
 
-		if (hrq->entry_count != drq->entry_count) {
-			status = -EINVAL;
-			goto out;
-		}
-
 		/* sanity check on queue memory */
 		if (!hrq || !drq || !cq) {
 			status = -ENODEV;
 			goto out;
 		}
 
+		if (hrq->entry_count != drq->entry_count) {
+			status = -EINVAL;
+			goto out;
+		}
+
 		if (idx == 0) {
 			bf_set(lpfc_mbx_rq_create_num_pages,
 			       &rq_create->u.request,
-- 
2.10.2
