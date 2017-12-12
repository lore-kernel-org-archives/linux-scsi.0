From: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
Subject: [PATCH] scsi: aacraid: fix io drop during the reset
Date: Tue, 12 Dec 2017 11:40:10 -0800
Message-ID: <1513107610-24451-1-git-send-email-prasad.munirathnam@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0079.outbound.protection.outlook.com ([104.47.32.79]:5408
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751643AbdLLTle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 14:41:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: prasad.munirathnam@microsemi.com, david.carroll@microsemi.com, raghavaaditya.renukunta@microsemi.com, martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

"FIB_CONTEXT_FLAG_TIMEDOUT" flag is set in aac_eh_abort to
indicate command timeout, using the same flag in reset handler
causes the command to timeout and the IO's were droped.

defined a new flag "FIB_CONTEXT_FLAG_EH_RESET" to make sure IO
is properly handled in eh_reset handler.

Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h | 1 +
 drivers/scsi/aacraid/linit.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 403a639..b0b290f 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1724,6 +1724,7 @@ struct aac_dev
 #define FIB_CONTEXT_FLAG_NATIVE_HBA		(0x00000010)
 #define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF	(0x00000020)
 #define FIB_CONTEXT_FLAG_SCSI_CMD	(0x00000040)
+#define FIB_CONTEXT_FLAG_EH_RESET	(0x00000080)
 
 /*
  *	Define the command values
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3677bef..03af5bd 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1034,7 +1034,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 			info = &aac->hba_map[bus][cid];
 			if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
 			    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
-				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				fib->flags |= FIB_CONTEXT_FLAG_EH_RESET;
 				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 			}
 		}
-- 
2.7.4
