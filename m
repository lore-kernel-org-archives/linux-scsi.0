From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 18/22] qla2xxx: Defer processing of GS IOCB calls
Date: Tue, 28 Nov 2017 11:34:59 -0800
Message-ID: <20171128193503.13695-19-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0046.outbound.protection.outlook.com ([104.47.32.46]:25512
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932167AbdK1Tff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:35 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@cavium.com>

This patch defers processing of GS IOCB calls from interrupt
context to avoid hardware spinlock recursion.

Following stack trace is seen

? mod_timer+0x193/0x330
? ql_dbg+0xa7/0xf0 [qla2xxx]
_raw_spin_lock_irqsave+0x31/0x40
qla2x00_start_sp+0x3b/0x250 [qla2xxx]
qla24xx_async_gnl+0x1d3/0x240 [qla2xxx]
qla24xx_fcport_handle_login+0x285/0x290 [qla2xxx]
? vprintk_func+0x20/0x50

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7dd19785f820..57b8f43c5980 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -975,7 +975,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			ql_dbg(ql_dbg_disc, vha, 0x20bd,
 			    "%s %d %8phC post gnl\n",
 			    __func__, __LINE__, fcport->port_name);
-			qla24xx_async_gnl(vha, fcport);
+			qla24xx_post_gnl_work(vha, fcport);
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0x20bf,
 			    "%s %d %8phC post login\n",
@@ -1143,7 +1143,7 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gidpn\n",
 		    __func__, __LINE__, fcport->port_name);
 
-		qla24xx_async_gidpn(vha, fcport);
+		qla24xx_post_gidpn_work(vha, fcport);
 		return;
 	}
 
-- 
2.12.0
