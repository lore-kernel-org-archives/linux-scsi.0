From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 05/11] qla2xxx: Remove errant clearing of MBX_INTERRUPT flag during CT-IOCB processing.
Date: Thu, 9 Feb 2012 11:14:07 -0800
Message-ID: <1328814853-21764-6-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49171
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758175Ab2BITa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:29 -0500
Received: from mail70-ch1 (localhost [127.0.0.1])	by mail70-ch1-R.bigfish.com
 (Postfix) with ESMTP id 6BF941A058C	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:28 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

This can cause instability in mailbox command state machine handling.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e804585..349843e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2090,7 +2090,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			break;
                 case CT_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
-			clear_bit(MBX_INTERRUPT, &vha->hw->mbx_cmd_flags);
 			break;
                 case ELS_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, ELS_IOCB_TYPE);
-- 
1.6.0.2


