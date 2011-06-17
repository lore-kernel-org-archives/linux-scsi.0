From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH RESEND 2/3] bsg: remove unnecessary conditional expressions
Date: Fri, 17 Jun 2011 11:17:08 +0900
Message-ID: <1308277029-2193-2-git-send-email-namhyung@gmail.com>
References: <1308277029-2193-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37339 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1FQCRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 22:17:17 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so1463913pvg.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 19:17:17 -0700 (PDT)
In-Reply-To: <1308277029-2193-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Second condition in OR always implies first condition is false
thus bytes_read in the second is not needed. The same goes to
bytes_written.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c4f49e255751..b7e42ad55361 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -606,7 +606,7 @@ bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
 	*ppos = bytes_read;
 
-	if (!bytes_read || (bytes_read && err_block_err(ret)))
+	if (!bytes_read || err_block_err(ret))
 		bytes_read = ret;
 
 	return bytes_read;
@@ -686,7 +686,7 @@ bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	/*
 	 * return bytes written on non-fatal errors
 	 */
-	if (!bytes_written || (bytes_written && err_block_err(ret)))
+	if (!bytes_written || err_block_err(ret))
 		bytes_written = ret;
 
 	dprintk("%s: returning %Zd\n", bd->name, bytes_written);
-- 
1.7.5.2

