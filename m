From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] cciss: use memdup_user
Date: Sat, 29 Apr 2017 09:45:11 +0800
Message-ID: <4db2a0ba17dc68d7bcfbd7d47b0eb22ad9a220c2.1493381463.git.geliangtang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34414 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164635AbdD2BqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 21:46:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Geliang Tang <geliangtang@gmail.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use memdup_user() helper instead of open-coding to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/block/cciss.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd37550..40ee715 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1596,15 +1596,9 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc) {
-		status = -ENOMEM;
-		goto cleanup1;
-	}
-	if (copy_from_user(ioc, argp, sizeof(*ioc))) {
-		status = -EFAULT;
-		goto cleanup1;
-	}
+	ioc = memdup_user(argp, sizeof(*ioc));
+	if (IS_ERR(ioc))
+		return PTR_ERR(ioc);
 	if ((ioc->buf_size < 1) &&
 	    (ioc->Request.Type.Direction != XFER_NONE)) {
 		status = -EINVAL;
-- 
2.9.3
