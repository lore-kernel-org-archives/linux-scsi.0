From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 14/22] qla2xxx: Fix abort command deadlock due to spinlock
Date: Mon, 4 Dec 2017 14:45:09 -0800
Message-ID: <20171204224517.3409-15-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0079.outbound.protection.outlook.com ([104.47.41.79]:26759
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752436AbdLDWpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:47 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Original code acquires hardware_lock to add Abort IOCB
onto driver request queue for processing. However,
abort_command() will also acquire hardware lock to look up
sp pointer before issuing abort IOCB command resulting
into a deadlock. This patch safely removes the possible
deadlock scenario by removing extra spinlock.

Fixes: 6eb54715b54bb ("qla2xxx: Added interface to send explicit LOGO.")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d810a447cb4a..106f4ac4f733 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2394,7 +2394,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	unsigned long flags = 0;
 
 	ql_dbg(ql_dbg_io, vha, 0x3069,
 	    "%s Timeout, hdl=%x, portid=%02x%02x%02x\n",
@@ -2402,7 +2401,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 	    fcport->d_id.b.al_pa);
 
 	/* Abort the exchange */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (ha->isp_ops->abort_command(sp)) {
 		ql_dbg(ql_dbg_io, vha, 0x3070,
 		    "mbx abort_command failed.\n");
@@ -2410,7 +2408,6 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 		ql_dbg(ql_dbg_io, vha, 0x3071,
 		    "mbx abort_command success.\n");
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	complete(&lio->u.els_logo.comp);
 }
-- 
2.12.0
