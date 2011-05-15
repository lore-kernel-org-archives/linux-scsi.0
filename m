From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] bsg: fix bsg_poll() to return POLLOUT properly
Date: Sun, 15 May 2011 14:31:51 +0900
Message-ID: <1305437513-3914-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1EOFb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 May 2011 01:31:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

POLLOUT should be returned only if bd->queued_cmds < bd->max_queue
so that bsg_alloc_command() can proceed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 0c8b64a16484..c4f49e255751 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -878,7 +878,7 @@ static unsigned int bsg_poll(struct file *file, poll_table *wait)
 	spin_lock_irq(&bd->lock);
 	if (!list_empty(&bd->done_list))
 		mask |= POLLIN | POLLRDNORM;
-	if (bd->queued_cmds >= bd->max_queue)
+	if (bd->queued_cmds < bd->max_queue)
 		mask |= POLLOUT;
 	spin_unlock_irq(&bd->lock);
 
-- 
1.7.5

