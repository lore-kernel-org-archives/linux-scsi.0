From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 16/22] qla2xxx: Fix scan state field for fcport
Date: Tue, 28 Nov 2017 11:34:57 -0800
Message-ID: <20171128193503.13695-17-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:64085
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932146AbdK1Tf2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:28 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add correct value of scan_state field indicating state
of the FC port

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2a6242d97a7e..1c219998ab60 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5812,6 +5812,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		tfcp->port_type = fcport->port_type;
 		tfcp->supported_classes = fcport->supported_classes;
 		tfcp->flags |= fcport->flags;
+		tfcp->scan_state = QLA_FCPORT_FOUND;
 
 		del = fcport;
 		fcport = tfcp;
-- 
2.12.0
