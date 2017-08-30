From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 3/3] qla2xxx: Reset the logo flag, after target re-login.
Date: Wed, 30 Aug 2017 10:16:50 -0700
Message-ID: <20170830171650.32341-4-himanshu.madhani@cavium.com>
References: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:40048
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752029AbdH3RRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:17:00 -0400
In-Reply-To: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

After relogin is sucessful, "send_els_logo" flag
needs to be reinitialized. This will allow next
re-login to happen successfully.

In target mode, this flag was not reset correctly,
causing IO's failure during reset recovery and port
ON/OFF test cases from initiator.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 73a6c3abb115..b5b48ddca962 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1464,6 +1464,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 			ea->fcport->logout_on_delete = 1;
+			ea->fcport->send_els_logo = 0;
 			qla24xx_post_gpdb_work(vha, ea->fcport, 0);
 		}
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 192554b1536f..f05cfc83c9c8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -585,11 +585,13 @@ void qla2x00_async_nack_sp_done(void *s, int res)
 		sp->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
 		sp->fcport->logout_on_delete = 1;
 		sp->fcport->plogi_nack_done_deadline = jiffies + HZ;
+		sp->fcport->send_els_logo = 0;
 		break;
 
 	case SRB_NACK_PRLI:
 		sp->fcport->fw_login_state = DSC_LS_PRLI_COMP;
 		sp->fcport->deleted = 0;
+		sp->fcport->send_els_logo = 0;
 
 		if (!sp->fcport->login_succ &&
 		    !IS_SW_RESV_ADDR(sp->fcport->d_id)) {
-- 
2.12.0
