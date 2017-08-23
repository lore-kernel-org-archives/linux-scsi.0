From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 12/31] qla2xxx: Use fabric name for Get Port Speed command
Date: Wed, 23 Aug 2017 15:05:06 -0700
Message-ID: <20170823220525.3115-13-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0071.outbound.protection.outlook.com ([104.47.40.71]:52496
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdHWWFr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:47 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

The Get Port Speed switch command needs the fabric
port name of the remote device.  Current code uses
the registered WWPN.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b323a7c71eda..0ec250993e93 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3080,7 +3080,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 		GPSC_RSP_SIZE);
 
 	/* GPSC req */
-	memcpy(ct_req->req.gpsc.port_name, fcport->port_name,
+	memcpy(ct_req->req.gpsc.port_name, fcport->fabric_port_name,
 		WWN_SIZE);
 
 	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
-- 
2.12.0
