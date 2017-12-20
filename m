From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 39/43] qla2xxx: Check FCF_ASYNC_SENT flag
Date: Tue, 19 Dec 2017 22:56:40 -0800
Message-ID: <20171220065644.21511-40-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0051.outbound.protection.outlook.com ([104.47.32.51]:10368
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932458AbdLTG5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:35 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 85bdb6928ea2..49a8f2666f55 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -720,7 +720,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 *mb;
 
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		goto done;
+		return rval;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
@@ -734,8 +734,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports);
 	if (vha->gnl.sent) {
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		rval = QLA_SUCCESS;
-		goto done;
+		return QLA_SUCCESS;
 	}
 	vha->gnl.sent = 1;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-- 
2.12.0
