From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: Fix iocb_cnt calculation in qla4xxx_send_mbox_iocb()
Date: Thu, 2 May 2013 03:42:10 -0400
Message-ID: <1367480530-21626-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:23994
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250Ab3EBIVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 04:21:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Increment 'ha->iocb_cnt' before adding mbox_iocb to iocb queue.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_iocb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 14fec97..fad71ed 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -507,6 +507,7 @@ static int qla4xxx_send_mbox_iocb(struct scsi_qla_host *ha, struct mrb *mrb,
 	mrb->mbox_cmd = in_mbox[0];
 	wmb();
 
+	ha->iocb_cnt += mrb->iocb_cnt;
 	ha->isp_ops->queue_iocb(ha);
 exit_mbox_iocb:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-- 
1.8.2.GIT


