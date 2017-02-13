From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix warnings reported by static checker.
Date: Mon, 13 Feb 2017 12:18:29 -0800
Message-ID: <1487017109-28811-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0061.outbound.protection.outlook.com ([104.47.36.61]:5674
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752821AbdBMUTO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 15:19:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Fix following warning reported by static checker

drivers/scsi/qla2xxx/qla_init.c:3910 qla2x00_alloc_fcport()
warn: use 'flags' here instead of GFP_XXX?

Fixes: b79414e ("qla2xxx: Add framework for async fabric discovery")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ea6ddcf..1598e84 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3878,7 +3878,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 
 	fcport->ct_desc.ct_sns = dma_alloc_coherent(&vha->hw->pdev->dev,
 		sizeof(struct ct_sns_pkt), &fcport->ct_desc.ct_sns_dma,
-			GFP_ATOMIC);
+		flags);
 	fcport->disc_state = DSC_DELETED;
 	fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
 	fcport->deleted = QLA_SESS_DELETED;
-- 
1.8.3.1
