From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: qla2xxx: remove redundant null check on tgt
Date: Mon,  5 Jun 2017 18:29:58 +0100
Message-ID: <20170605172958.12844-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54448 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdFERaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 13:30:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An earlier commit ed7fb808477b846bb2 ("scsi: qla2xxx: Remove
redundant wait when target is stopped.") removed a null check
on ha->tgt.tgt_ops and replaced it with a new check that null
checked tgt, thus making the subsequent null check on tgt
totally redundant. Remove it.

Detected by CoverityScan, CID#1440452 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb33ca87ca37..3594a76f6155 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5519,12 +5519,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	if (!tgt || tgt->tgt_stop || tgt->tgt_stopped)
 		return;
 
-	if (unlikely(tgt == NULL)) {
-		ql_dbg(ql_dbg_tgt, vha, 0xe03a,
-		    "ASYNC EVENT %#x, but no tgt (ha %p)\n", code, ha);
-		return;
-	}
-
 	if (((code == MBA_POINT_TO_POINT) || (code == MBA_CHG_IN_CONNECTION)) &&
 	    IS_QLA2100(ha))
 		return;
-- 
2.11.0
