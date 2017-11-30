From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 01/22] qla2xxx: Fix system crash for Notify ack timeout handling
Date: Wed, 29 Nov 2017 19:40:26 -0800
Message-ID: <20171130034047.15070-2-himanshu.madhani@cavium.com>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0060.outbound.protection.outlook.com ([104.47.34.60]:55301
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753066AbdK3Dk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 22:40:57 -0500
In-Reply-To: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Fix NULL pointer crash due to missing timeout handling callback
for Notify Ack IOCB.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 18069edd4773..1259ec85ec0a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -665,7 +665,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
 
 	sp->u.iocb_cmd.u.nack.ntfy = ntfy;
-
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_nack_sp_done;
 
 	rval = qla2x00_start_sp(sp);
-- 
2.12.0
