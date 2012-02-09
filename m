From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/11] qla2xxx: Correct out of bounds read of ISP2200 mailbox registers.
Date: Thu, 9 Feb 2012 11:14:08 -0800
Message-ID: <1328814853-21764-7-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:31185
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458Ab2BITa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:29 -0500
Received: from mail88-ch1 (localhost [127.0.0.1])	by mail88-ch1-R.bigfish.com
 (Postfix) with ESMTP id DF2F3260522	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:27 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP2200 adapters only have 24 mailbox registers so read only that many.

Reported-by: Olatunji Ruwase <oor@cs.cmu.edu>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a6a4eeb..af1003f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -44,6 +44,7 @@
  * ISP2100 HBAs.
  */
 #define MAILBOX_REGISTER_COUNT_2100	8
+#define MAILBOX_REGISTER_COUNT_2200	24
 #define MAILBOX_REGISTER_COUNT		32
 
 #define QLA2200A_RISC_ROM_VER	4
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5fd89d7..7e617a6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2054,7 +2054,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->nvram_data_off = ~0;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA2200(ha)) {
-		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->mbx_count = MAILBOX_REGISTER_COUNT_2200;
 		req_length = REQUEST_ENTRY_CNT_2200;
 		rsp_length = RESPONSE_ENTRY_CNT_2100;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
-- 
1.6.0.2


