From: Syam Sidhardhan <syamsidhardh@gmail.com>
Subject: [PATCH] dc395x: Fix NULL pointer dereference
Date: Mon, 25 Feb 2013 04:40:28 +0530
Message-ID: <1361747428-29432-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48426 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab3BXXKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2013 18:10:40 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so1388221pab.33
        for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2013 15:10:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dc395x@twibble.org, linux-scsi@vger.kernel.org
Cc: syamsidhardh@gmail.com, JBottomley@parallels.com, lenehan@twibble.org, aliakc@web.de, oliver@neukum.org

When we enable dprintkdbg, then their is a NULL pointer dereference.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/scsi/dc395x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 865c64f..6c5b874 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2634,8 +2634,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 {
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
-	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
-		   srb->cmd, tag, srb);
+	dprintkdbg(DBG_0, "msgin_qtag: tag=%i\n", tag);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
-- 
1.7.9.5

