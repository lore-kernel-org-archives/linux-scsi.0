From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 11/15] qla2xxx: Fix inadequate lock protection for ABTS.
Date: Thu, 2 Feb 2017 11:42:34 -0800
Message-ID: <1486064558-365-12-git-send-email-himanshu.madhani@cavium.com>
References: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0056.outbound.protection.outlook.com ([104.47.36.56]:17424
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751209AbdBBTot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 14:44:49 -0500
In-Reply-To: <1486064558-365-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Normally, ABTS is sent to Target Core as Task MGMT command.
In the case of error, qla2xxx needs to send response, hardware_lock
is required to prevent request queue corruption.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1bd4eff..6351132 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -128,6 +128,9 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 static struct fc_port *qlt_create_sess(struct scsi_qla_host *vha,
 	fc_port_t *fcport, bool local);
 void qlt_unreg_sess(struct fc_port *sess);
+static void qlt_24xx_handle_abts(struct scsi_qla_host *,
+	struct abts_recv_from_24xx *);
+
 /*
  * Global Variables
  */
@@ -403,6 +406,8 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 			(struct abts_recv_from_24xx *)atio;
 		struct scsi_qla_host *host = qlt_find_host_by_vp_idx(vha,
 			entry->vp_index);
+		unsigned long flags;
+
 		if (unlikely(!host)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xffff,
 			    "qla_target(%d): Response pkt (ABTS_RECV_24XX) "
@@ -410,9 +415,12 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
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
1.8.3.1
