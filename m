From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/6] scsi_debug: fix resp_xdwriteread() return value when running out of memory
Date: Mon,  6 Jan 2014 08:33:10 +0900
Message-ID: <1388964792-3546-5-git-send-email-akinobu.mita@gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:43601 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaAEXdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 18:33:33 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so17864174pbb.0
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jan 2014 15:33:32 -0800 (PST)
In-Reply-To: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

When resp_xdwriteread() can't allocate temporary buffer, it returns -1.
But the return value is used as scsi status code and -1 is not
interpreted as correct code.

target_core_mod has similar xdwriteread emulation code. So this mimics
what target_core_mod does for xdwriteread when running out of memory.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1a42880..a102519 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -64,6 +64,7 @@ static const char * scsi_debug_version_date = "20100324";
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
 #define LOGICAL_UNIT_NOT_READY 0x4
+#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
 #define UNRECOVERED_READ_ERR 0x11
 #define PARAMETER_LIST_LENGTH_ERR 0x1a
 #define INVALID_OPCODE 0x20
@@ -2318,8 +2319,11 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 
 	/* better not to use temporary buffer. */
 	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
-	if (!buf)
-		return ret;
+	if (!buf) {
+		mk_sense_buffer(devip, NOT_READY,
+				LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		return check_condition_result;
+	}
 
 	scsi_sg_copy_to_buffer(scp, buf, scsi_bufflen(scp));
 
-- 
1.8.3.2

