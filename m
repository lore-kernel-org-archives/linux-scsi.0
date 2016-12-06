From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 19/22] qla2xxx: Reduce exess wait during chip reset
Date: Tue, 6 Dec 2016 12:30:48 -0800
Message-ID: <1481056251-2310-20-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0060.outbound.protection.outlook.com ([104.47.42.60]:65122
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751993AbcLFUqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:46:24 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Per HW recommendation, Soft reset and Risc reset should
take 100uS to complete. This change pad the timeout up to
400uS, which should be plenty.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dcb8c49..d8b18a9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2112,7 +2112,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 
 	/* Wait for soft-reset to complete. */
 	RD_REG_DWORD(&reg->ctrl_status);
-	for (cnt = 0; cnt < 6000000; cnt++) {
+	for (cnt = 0; cnt < 60; cnt++) {
 		barrier();
 		if ((RD_REG_DWORD(&reg->ctrl_status) &
 		    CSRX_ISP_SOFT_RESET) == 0)
@@ -2155,7 +2155,7 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	RD_REG_DWORD(&reg->hccr);
 
 	RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 6000000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	for (cnt = 60; RD_REG_WORD(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		barrier();
 		if (cnt)
-- 
1.8.3.1

