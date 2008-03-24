From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] stex: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 01:54:54 +0900
Message-ID: <1206377695-26084-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206377695-26084-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41632 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbYCXQ4j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 12:56:39 -0400
In-Reply-To: <1206377695-26084-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/stex.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8c7b183..9ef47fe 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
 #define ST_DRIVER_VERSION "3.6.0000.1"
@@ -366,11 +367,7 @@ static void stex_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
-	cmd->sense_buffer[0] = 0x70;    /* fixed format, current */
-	cmd->sense_buffer[2] = sk;
-	cmd->sense_buffer[7] = 18 - 8;  /* additional sense length */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
+	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq, 10);
 }
 
 static void stex_invalid_field(struct scsi_cmnd *cmd,
-- 
1.5.3.7

