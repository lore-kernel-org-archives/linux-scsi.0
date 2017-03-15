From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 02/14] qla2xxx: Fix memory leak for abts processing
Date: Wed, 15 Mar 2017 09:48:44 -0700
Message-ID: <20170315164856.17255-3-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0083.outbound.protection.outlook.com ([104.47.36.83]:12448
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753091AbdCOQtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:09 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 45f5077684f0..ecf97c5993e8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6642,6 +6642,8 @@ qlt_handle_abts_recv_work(struct work_struct *work)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_response_pkt_all_vps(vha, (response_t *)&op->atio);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	kfree(op);
 }
 
 void
-- 
2.12.0
