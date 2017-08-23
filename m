From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 14/31] qla2xxx: Prevent sp->free null/uninitialized pointer dereference.
Date: Wed, 23 Aug 2017 15:05:08 -0700
Message-ID: <20170823220525.3115-15-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0064.outbound.protection.outlook.com ([104.47.34.64]:62624
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751162AbdHWWFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:49 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.c   |  7 ++++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b380a7c97d5b..d00e0129c51b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -808,6 +808,12 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	if (!sp)
 		goto done;
 
+	sp->type = SRB_MB_IOCB;
+	sp->name = "gpdb";
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd == NULL) {
 		ql_log(ql_log_warn, vha, 0xd043,
@@ -816,12 +822,6 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	}
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
 
-	sp->type = SRB_MB_IOCB;
-	sp->name = "gpdb";
-	sp->gen1 = fcport->rscn_gen;
-	sp->gen2 = fcport->login_gen;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
 	mb = sp->u.iocb_cmd.u.mbx.out_mb;
 	mb[0] = MBC_GET_PORT_DATABASE;
 	mb[1] = fcport->loop_id;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 10b742d27e16..e23a3d4c36f3 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1819,6 +1819,10 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	if (!sp)
 		goto done;
 
+	sp->type = SRB_FXIOCB_DCMD;
+	sp->name = "fxdisc";
+	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
+
 	fdisc = &sp->u.iocb_cmd;
 	switch (fx_type) {
 	case FXDISC_GET_CONFIG_INFO:
@@ -1920,9 +1924,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			goto done_unmap_req;
 	}
 
-	sp->type = SRB_FXIOCB_DCMD;
-	sp->name = "fxdisc";
-	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
 	fdisc->timeout = qla2x00_fxdisc_iocb_timeout;
 	fdisc->u.fxiocb.req_func_type = cpu_to_le16(fx_type);
 	sp->done = qla2x00_fxdisc_sp_done;
-- 
2.12.0
