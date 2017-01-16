From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 01/12] qla2xxx: Remove direct access of scsi_status field in se_cmd
Date: Mon, 16 Jan 2017 12:35:13 -0800
Message-ID: <1484598924-29066-2-git-send-email-himanshu.madhani@cavium.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0069.outbound.protection.outlook.com ([104.47.34.69]:3347
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751177AbdAPUgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Jan 2017 15:36:03 -0500
In-Reply-To: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1f7c6d2..1196150 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1794,6 +1794,7 @@ struct crc_context {
 #define SS_RESIDUAL_OVER		BIT_10
 #define SS_SENSE_LEN_VALID		BIT_9
 #define SS_RESPONSE_INFO_LEN_VALID	BIT_8
+#define SS_SCSI_STATUS_BYTE	0xff
 
 #define SS_RESERVE_CONFLICT		(BIT_4 | BIT_3)
 #define SS_BUSY_CONDITION		BIT_3
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9c6cb75..47acc26 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2288,7 +2288,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		int i;
 
 		if (qlt_need_explicit_conf(prm->tgt->ha, prm->cmd, 1)) {
-			if (prm->cmd->se_cmd.scsi_status != 0) {
+			if ((prm->rq_result & SS_SCSI_STATUS_BYTE) != 0) {
 				ql_dbg(ql_dbg_tgt, prm->cmd->vha, 0xe017,
 				    "Skipping EXPLICIT_CONFORM and "
 				    "CTIO7_FLAGS_CONFORM_REQ for FCP READ w/ "
-- 
1.8.3.1

