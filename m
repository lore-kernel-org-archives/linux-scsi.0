From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 5/7] qla4xxx: Only BIOS boot target entries should be at index 0 and 1.
Date: Mon, 8 Jul 2013 08:33:09 -0400
Message-ID: <1373286791-29659-6-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:51504
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab3GHNAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:55 -0400
Received: from mail210-co9 (localhost [127.0.0.1])	by
 mail210-co9-R.bigfish.com (Postfix) with ESMTP id 94131980478	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:54 +0000 (UTC)
Received: from CO9EHSMHS010.bigfish.com (unknown [10.236.132.247])	by
 mail210-co9.bigfish.com (Postfix) with ESMTP id AD721BC01E7	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:44 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Flash target index 0 and 1 are reserved for boot target entries created
with BIOS utility.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a6e4d51..52d01ae 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5707,7 +5707,8 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 		goto exit_ddb_add;
 	}
 
-	for (idx = 0; idx < max_ddbs; idx++) {
+	/* Index 0 and 1 are reserved for boot target entries */
+	for (idx = 2; idx < max_ddbs; idx++) {
 		if (qla4xxx_flashdb_by_index(ha, fw_ddb_entry,
 					     fw_ddb_entry_dma, idx))
 			break;
-- 
1.7.1


