From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 02/43] qla2xxx: Fix NULL pointer access for fcport structure
Date: Tue, 19 Dec 2017 22:56:03 -0800
Message-ID: <20171220065644.21511-3-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0050.outbound.protection.outlook.com ([104.47.40.50]:2481
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932336AbdLTG4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:56:55 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

when preocessing iocb in a timeout case, driver was trying to log messages
without verifying if the fcport structure could have valid data. This
results in a NULL pointer access.

Fixes: 726b85487067("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7fa71170d6ff..9d65fbe85e30 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -102,11 +102,16 @@ qla2x00_async_iocb_timeout(void *data)
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct event_arg ea;
 
-	ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
-	    "Async-%s timeout - hdl=%x portid=%06x %8phC.\n",
-	    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
+	if (fcport) {
+		ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
+		    "Async-%s timeout - hdl=%x portid=%06x %8phC.\n",
+		    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
 
-	fcport->flags &= ~FCF_ASYNC_SENT;
+		fcport->flags &= ~FCF_ASYNC_SENT;
+	} else {
+		pr_info("Async-%s timeout - hdl=%x.\n",
+		    sp->name, sp->handle);
+	}
 
 	switch (sp->type) {
 	case SRB_LOGIN_CMD:
-- 
2.12.0
