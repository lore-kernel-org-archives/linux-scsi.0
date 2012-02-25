From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 7/7] qla_target: Drop qla_tgt_mgmt_cmd->se_tmr_req usage
Date: Sat, 25 Feb 2012 21:05:59 +0000
Message-ID: <1330203959-6170-8-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45557 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2BYVOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:21 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Convert qla_target.c callback qla_tgt_xmit_tm_rsp() to use
qla_tgt_mgmt_cmd->se_cmd->se_tmr_req instead of local qla_target.h
pointer.

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 drivers/scsi/qla2xxx/qla_target.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5d88e69..a2dabb4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1437,7 +1437,7 @@ void qla_tgt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		qla_tgt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
 			0, 0, 0, 0, 0, 0);
 	else {
-		if (mcmd->se_tmr_req->function == TMR_ABORT_TASK)
+		if (mcmd->se_cmd.se_tmr_req->function == TMR_ABORT_TASK)
 			qla_tgt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
 				mcmd->fc_tm_rsp, false);
 		else
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 935ea32..1e03d47 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -869,7 +869,6 @@ struct qla_tgt_mgmt_cmd {
 	uint8_t fc_tm_rsp;
 	struct qla_tgt_sess *sess;
 	struct se_cmd se_cmd;
-	struct se_tmr_req *se_tmr_req;
 	unsigned int flags;
 #define QLA24XX_MGMT_SEND_NACK	1
 	union {
-- 
1.7.2.5

