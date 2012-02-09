From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 27/29] qla2xxx: Fix incorrect register access in qla2x00_start_iocbs().
Date: Thu, 9 Feb 2012 11:15:59 -0800
Message-ID: <1328814961-21866-28-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:50952
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405Ab2BITcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:13 -0500
Received: from mail90-ch1 (localhost [127.0.0.1])	by mail90-ch1-R.bigfish.com
 (Postfix) with ESMTP id ACCF61E0492	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:12 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8ce8103..eac9509 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -490,7 +490,7 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 		/* Set chip new ring index. */
 		if (ha->mqenable || IS_QLA83XX(ha)) {
 			WRT_REG_DWORD(req->req_q_in, req->ring_index);
-			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+			RD_REG_DWORD_RELAXED(&ha->iobase->isp24.hccr);
 		} else if (IS_FWI2_CAPABLE(ha)) {
 			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
 			RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
-- 
1.6.0.2


