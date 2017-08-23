From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 17/31] qla2xxx: Add timeout ability to wait_for_sess_deletion().
Date: Wed, 23 Aug 2017 15:05:11 -0700
Message-ID: <20170823220525.3115-18-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0053.outbound.protection.outlook.com ([104.47.34.53]:35136
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751187AbdHWWF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:58 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c     | 2 +-
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 10c3ee53ec3a..c217cec4dd49 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1141,7 +1141,7 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 {
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	wait_event(vha->fcport_waitQ, test_fcport_count(vha));
+	wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha), 10*HZ);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 3bcfbee2ae26..6a6d9db6479f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1479,7 +1479,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
 	    "Waiting for tgt %p: sess_count=%d\n", tgt, tgt->sess_count);
 
-	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
+	wait_event_timeout(tgt->waitQ, test_tgt_sess_count(tgt), 10*HZ);
 
 	/* Big hammer */
 	if (!ha->flags.host_shutting_down &&
@@ -1487,7 +1487,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 		qlt_disable_vha(vha);
 
 	/* Wait for sessions to clear out (just in case) */
-	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
+	wait_event_timeout(tgt->waitQ, test_tgt_sess_count(tgt), 10*HZ);
 	return 0;
 }
 EXPORT_SYMBOL(qlt_stop_phase1);
-- 
2.12.0
