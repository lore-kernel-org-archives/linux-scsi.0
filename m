From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 4/8] qla2xxx: Fix warning during port_name debug print
Date: Mon, 15 Jan 2018 20:46:49 -0800
Message-ID: <20180116044653.20696-5-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0074.outbound.protection.outlook.com ([104.47.32.74]:3968
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751306AbeAPErF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:05 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes following smatch warning

drivers/scsi/qla2xxx/qla_iocb.c:2622 qla2x00_els_dcmd2_sp_done() error: '%pC' expects argument of type 'struct clk*', argument 8 has type 'uchar[]'

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 14a3f6932c9c..2c6a236dff96 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2620,7 +2620,7 @@ qla2x00_els_dcmd2_sp_done(void *ptr, int res)
 	struct scsi_qla_host *vha = sp->vha;
 
 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3072,
-	    "%s ELS hdl=%x, portid=%06x done %8pC\n",
+	    "%s ELS hdl=%x, portid=%06x done %8phC\n",
 	    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	complete(&lio->u.els_plogi.comp);
-- 
2.12.0
