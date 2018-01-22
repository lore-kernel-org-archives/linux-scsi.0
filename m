From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/2] qla2xxx: Fix warning reported for req_que_no in qla24xx_async_cmd()
Date: Mon, 22 Jan 2018 12:04:19 -0800
Message-ID: <20180122200420.19516-2-himanshu.madhani@cavium.com>
References: <20180122200420.19516-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0063.outbound.protection.outlook.com ([104.47.32.63]:41325
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750891AbeAVUGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jan 2018 15:06:31 -0500
In-Reply-To: <20180122200420.19516-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes following sparse warning

drivers/scsi/qla2xxx/qla_init.c:1570:44: sparse: incorrect type in assignment
(different base types)

Fixes: 07a21872cf2b ("scsi: qla2xxx: Fix queue ID for async abort with Multiqueue")
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 27e67f7ae18a..5b6f3c53fdcf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1567,9 +1567,10 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp)
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 
 	if (vha->flags.qpairs_available && cmd_sp->qpair)
-		abt_iocb->u.abt.req_que_no = cmd_sp->qpair->req->id;
+		abt_iocb->u.abt.req_que_no =
+		    cpu_to_le16(cmd_sp->qpair->req->id);
 	else
-		abt_iocb->u.abt.req_que_no = vha->req->id;
+		abt_iocb->u.abt.req_que_no = cpu_to_le16(vha->req->id);
 
 	sp->done = qla24xx_abort_sp_done;
 	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
-- 
2.12.0
