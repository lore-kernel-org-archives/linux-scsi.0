From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/5] qla2xxx: Set IIDMA and fcport state before qla_nvme_register_remote()
Date: Fri, 19 Jan 2018 12:29:25 -0800
Message-ID: <20180119202928.13239-3-himanshu.madhani@cavium.com>
References: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0042.outbound.protection.outlook.com ([104.47.37.42]:24905
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756358AbeASU3n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 15:29:43 -0500
In-Reply-To: <20180119202928.13239-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, james.smart@broadcom.com, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Darren Trapp <darren.trapp@cavium.com>

Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aececf664654..e7e51ac0bb46 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5106,13 +5106,14 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->deleted = 0;
 	fcport->logout_on_delete = 1;
 
+	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
+	qla2x00_iidma_fcport(vha, fcport);
+
 	if (fcport->fc4f_nvme) {
 		qla_nvme_register_remote(vha, fcport);
 		return;
 	}
 
-	qla2x00_set_fcport_state(fcport, FCS_ONLINE);
-	qla2x00_iidma_fcport(vha, fcport);
 	qla24xx_update_fcport_fcp_prio(vha, fcport);
 
 reg_port:
-- 
2.12.0
