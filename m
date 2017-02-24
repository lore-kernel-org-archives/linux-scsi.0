From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 09/14] qla2xxx: Fix memory leak for abts processing
Date: Fri, 24 Feb 2017 13:37:38 -0800
Message-ID: <1487972263-3795-10-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0050.outbound.protection.outlook.com ([104.47.42.50]:2048
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751314AbdBXViR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:38:17 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
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
index 2720b8f6..a09e4a5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6766,6 +6766,8 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_response_pkt_all_vps(vha, (response_t *)&op->atio);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	kfree(op);
 }
 
 void
-- 
1.8.3.1
