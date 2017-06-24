From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] scsi: qedi: Remove comparison of u16 idx with zero.
Date: Sat, 24 Jun 2017 17:24:45 +0100
Message-ID: <1498321485-21677-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Variable idx is defined as u16 thus statement (idx < 0) is
always false and should be removed.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/qedi/qedi_fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index e937490..19254bd 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -333,7 +333,7 @@ static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
 
 	/* Obtain buffer address from rqe_opaque */
 	idx = cqe->rqe_opaque.lo;
-	if ((idx < 0) || (idx > (QEDI_BDQ_NUM - 1))) {
+	if (idx > (QEDI_BDQ_NUM - 1)) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
 			  "wrong idx %d returned by FW, dropping the unsolicited pkt\n",
 			  idx);
@@ -370,7 +370,7 @@ static void qedi_put_rq_bdq_buf(struct qedi_ctx *qedi,
 
 	/* Obtain buffer address from rqe_opaque */
 	idx = cqe->rqe_opaque.lo;
-	if ((idx < 0) || (idx > (QEDI_BDQ_NUM - 1))) {
+	if (idx > (QEDI_BDQ_NUM - 1)) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
 			  "wrong idx %d returned by FW, dropping the unsolicited pkt\n",
 			  idx);
-- 
2.7.4
