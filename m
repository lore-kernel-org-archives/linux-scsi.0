From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 15/22] qla2xxx: Replace fcport alloc with qla2x00_alloc_fcport
Date: Mon, 4 Dec 2017 14:45:10 -0800
Message-ID: <20171204224517.3409-16-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0087.outbound.protection.outlook.com ([104.47.32.87]:14063
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752414AbdLDWpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:50 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current code manually allocate an fcport structure that
is not properly initialize. Replace kzalloc with
qla2x00_alloc_fcport, so that all fields are initialized.
Also set set scan flag to port found

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e824cdc77139..2a6242d97a7e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5783,7 +5783,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 	unsigned long flags;
 	u8 newfcport = 0;
 
-	fcport = kzalloc(sizeof(*fcport), GFP_KERNEL);
+	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (!fcport) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06f,
 		    "qla_target(%d): Allocation of tmp FC port failed",
-- 
2.12.0
