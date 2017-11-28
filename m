From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 08/22] qla2xxx: Fix login state machine stuck at GPDB
Date: Tue, 28 Nov 2017 11:34:49 -0800
Message-ID: <20171128193503.13695-9-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0055.outbound.protection.outlook.com ([104.47.36.55]:51456
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932152AbdK1TfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:18 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch returns discovery state machine back to
Login Complete.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index be4c67b465b8..2f246996d3e2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -863,6 +863,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	int rval = ea->rc;
 	fc_port_t *fcport = ea->fcport;
 	unsigned long flags;
+	u16 opt = ea->sp->u.iocb_cmd.u.mbx.out_mb[10];
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
@@ -893,7 +894,8 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	}
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	ea->fcport->login_gen++;
+	if (opt != PDO_FORCE_ADISC)
+		ea->fcport->login_gen++;
 	ea->fcport->deleted = 0;
 	ea->fcport->logout_on_delete = 1;
 
@@ -917,6 +919,13 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 			qla24xx_post_gpsc_work(vha, fcport);
 		}
+	} else if (ea->fcport->login_succ) {
+		/*
+		 * We have an existing session. A late RSCN delivery
+		 * must have triggered the session to be re-validate.
+		 * session is still valid.
+		 */
+		fcport->disc_state = DSC_LOGIN_COMPLETE;
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 } /* gpdb event */
-- 
2.12.0
