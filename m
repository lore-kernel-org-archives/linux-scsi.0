From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] bsg: remove unnecessary conditional expressions
Date: Sun, 15 May 2011 14:31:52 +0900
Message-ID: <1305437513-3914-2-git-send-email-namhyung@gmail.com>
References: <1305437513-3914-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:45482 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1EOFcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 May 2011 01:32:01 -0400
In-Reply-To: <1305437513-3914-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Second condition in OR always implies first condition is false
thus bytes_read in the second is not needed. The same goes to
bytes_written.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
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
1.7.5

