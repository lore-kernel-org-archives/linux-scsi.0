From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 17/22] qla2xxx: Clear loop id after delete
Date: Wed, 29 Nov 2017 19:40:42 -0800
Message-ID: <20171130034047.15070-18-himanshu.madhani@cavium.com>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0069.outbound.protection.outlook.com ([104.47.32.69]:10912
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753446AbdK3DlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 22:41:17 -0500
In-Reply-To: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

clear loop id after delete to prevent session invalidation
of stale session.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1c219998ab60..0c0453f2ca9e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -986,7 +986,7 @@ static void qlt_free_session_done(struct work_struct *work)
 			sess->send_els_logo = 0;
 		}
 
-		if (sess->logout_on_delete) {
+		if (sess->logout_on_delete && sess->loop_id != FC_NO_LOOP_ID) {
 			int rc;
 
 			rc = qla2x00_post_async_logout_work(vha, sess, NULL);
@@ -1045,8 +1045,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		sess->login_succ = 0;
 	}
 
-	if (sess->chip_reset != ha->base_qpair->chip_reset)
-		qla2x00_clear_loop_id(sess);
+	qla2x00_clear_loop_id(sess);
 
 	if (sess->conflict) {
 		sess->conflict->login_pause = 0;
@@ -4600,9 +4599,9 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
-
 				other_sess->keep_nport_handle = 1;
-				*conflict_sess = other_sess;
+				if (other_sess->disc_state != DSC_DELETED)
+					*conflict_sess = other_sess;
 				qlt_schedule_sess_for_deletion(other_sess,
 				    true);
 			}
-- 
2.12.0
