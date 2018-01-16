From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 3/8] qla2xxx: Fix warning in qla2x00_async_iocb_timeout()
Date: Mon, 15 Jan 2018 20:46:48 -0800
Message-ID: <20180116044653.20696-4-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0048.outbound.protection.outlook.com ([104.47.36.48]:45056
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751296AbeAPErD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:03 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes following Smatch warning

drivers/scsi/qla2xxx/qla_init.c:130 qla2x00_async_iocb_timeout() error: we previously assumed 'fcport' could be null (see line 107)

Fixes: 5c25d451163c ("scsi: qla2xxx: Fix NULL pointer access for fcport structure")
Reported by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9c08222e4c8b..08ad1a60cb0d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -117,6 +117,8 @@ qla2x00_async_iocb_timeout(void *data)
 
 	switch (sp->type) {
 	case SRB_LOGIN_CMD:
+		if (!fcport)
+			break;
 		/* Retry as needed. */
 		lio->u.logio.data[0] = MBS_COMMAND_ERROR;
 		lio->u.logio.data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
@@ -130,6 +132,8 @@ qla2x00_async_iocb_timeout(void *data)
 		qla24xx_handle_plogi_done_event(fcport->vha, &ea);
 		break;
 	case SRB_LOGOUT_CMD:
+		if (!fcport)
+			break;
 		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
 		break;
 	case SRB_CT_PTHRU_CMD:
-- 
2.12.0
