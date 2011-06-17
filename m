From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH RESEND 1/3] bsg: fix bsg_poll() to return POLLOUT properly
Date: Fri, 17 Jun 2011 11:17:07 +0900
Message-ID: <1308277029-2193-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37339 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1FQCRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 22:17:15 -0400
Received: by pvg12 with SMTP id 12so1463913pvg.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 19:17:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

POLLOUT should be returned only if bd->queued_cmds < bd->max_queue
so that bsg_alloc_command() can proceed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jens Axboe <jaxboe@fusionio.com>
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
1.7.5.2

