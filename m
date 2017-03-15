From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 04/14] qla2xxx: Fix inadequate lock protection for ABTS.
Date: Wed, 15 Mar 2017 09:48:46 -0700
Message-ID: <20170315164856.17255-5-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0055.outbound.protection.outlook.com ([104.47.34.55]:2963
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbdCOQtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:14 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Normally, ABTS is sent to Target Core as Task MGMT command.
In the case of error, qla2xxx needs to send response, hardware_lock
is required to prevent request queue corruption.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a463bcc57902..a78c3e9bcb57 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -130,6 +130,9 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 static struct fc_port *qlt_create_sess(struct scsi_qla_host *vha,
 	fc_port_t *fcport, bool local);
 void qlt_unreg_sess(struct fc_port *sess);
+static void qlt_24xx_handle_abts(struct scsi_qla_host *,
+	struct abts_recv_from_24xx *);
+
 /*
  * Global Variables
  */
@@ -389,6 +392,8 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 			(struct abts_recv_from_24xx *)atio;
 		struct scsi_qla_host *host = qlt_find_host_by_vp_idx(vha,
 			entry->vp_index);
+		unsigned long flags;
+
 		if (unlikely(!host)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xffff,
 			    "qla_target(%d): Response pkt (ABTS_RECV_24XX) "
@@ -396,9 +401,12 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 			    vha->vp_idx, entry->vp_index);
 			break;
 		}
-		qlt_response_pkt(host, (response_t *)atio);
+		if (!ha_locked)
+			spin_lock_irqsave(&host->hw->hardware_lock, flags);
+		qlt_24xx_handle_abts(host, (struct abts_recv_from_24xx *)atio);
+		if (!ha_locked)
+			spin_unlock_irqrestore(&host->hw->hardware_lock, flags);
 		break;
-
 	}
 
 	/* case PUREX_IOCB_TYPE: ql2xmvasynctoatio */
-- 
2.12.0
