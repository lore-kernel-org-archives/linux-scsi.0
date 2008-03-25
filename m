From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 4/5] stex: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 09:26:52 +0900
Message-ID: <1206404816-21710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 1206378609.3494.50.camel@localhost.localdomain
 <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206404816-21710-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37433 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbYCYAsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 20:48:46 -0400
In-Reply-To: <1206404816-21710-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/stex.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8c7b183..f308a03 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
 #define ST_DRIVER_VERSION "3.6.0000.1"
@@ -362,22 +363,14 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 	return status;
 }
 
-static void stex_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
-{
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	cmd->sense_buffer[0] = 0x70;    /* fixed format, current */
-	cmd->sense_buffer[2] = sk;
-	cmd->sense_buffer[7] = 18 - 8;  /* additional sense length */
-	cmd->sense_buffer[12] = asc;
-	cmd->sense_buffer[13] = ascq;
-}
-
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
 	/* "Invalid field in cbd" */
-	stex_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	scsi_build_sense_buffer(0, cmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
+				0x0);
 	done(cmd);
 }
 
-- 
1.5.3.7

