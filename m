From: Colin King <colin.king@canonical.com>
Subject: [PATCH] qla2xxx: remove redundant check on sess being non-null
Date: Thu, 23 Mar 2017 11:49:56 +0000
Message-ID: <20170323114956.18245-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

All error paths to label out_term2 result in sess being null, so the
check for sess being non-null and the call to put_sess is dead code
and can therefore be removed.

Detected with CoverityScan, CID#1420664 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0e03ca2ab3e5..32e07f21ddb2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5853,8 +5853,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	return;
 
 out_term2:
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
 out_term:
-- 
2.11.0
