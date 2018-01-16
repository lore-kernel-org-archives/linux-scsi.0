From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/8] qla2xxx: Fix recursion while sending terminate exchange
Date: Mon, 15 Jan 2018 20:46:47 -0800
Message-ID: <20180116044653.20696-3-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0075.outbound.protection.outlook.com ([104.47.37.75]:7968
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751098AbeAPErB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:01 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

During error test case where switch port status is toggled
from enable to disable, following stack trace is seen which
indicates recursion trying to send terminate exchange.
This regression was introduced by commit 82de802ad46e
("scsi: qla2xxx: Preparation for Target MQ.")

BUG: stack guard page was hit at ffffb96488383ff8 (stack is ffffb96488384000..ffffb96488387fff)
BUG: stack guard page was hit at ffffb964886c3ff8 (stack is ffffb964886c4000..ffffb964886c7fff)
kernel stack overflow (double-fault): 0000 [#1] SMP
qlt_term_ctio_exchange+0x9c/0xb0 [qla2xxx]
qlt_term_ctio_exchange+0x9c/0xb0 [qla2xxx]
qlt_term_ctio_exchange+0x9c/0xb0 [qla2xxx]
qlt_term_ctio_exchange+0x9c/0xb0 [qla2xxx]
qlt_term_ctio_exchange+0x9c/0xb0 [qla2xxx]

Fixes: 82de802ad46e ("scsi: qla2xxx: Preparation for Target MQ.")
Cc: <stable@vger.kernel.org> #4.10
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0d3c3f647f91..cc80e57675e4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3756,7 +3756,7 @@ static int qlt_term_ctio_exchange(struct qla_qpair *qpair, void *ctio,
 		term = 1;
 
 	if (term)
-		qlt_term_ctio_exchange(qpair, ctio, cmd, status);
+		qlt_send_term_exchange(qpair, cmd, &cmd->atio, 1, 0);
 
 	return term;
 }
-- 
2.12.0
