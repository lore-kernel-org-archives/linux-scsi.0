From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2 2/9] mmc: fix max_discard_sectors
Date: Sat, 20 Apr 2013 01:40:47 +0900
Message-ID: <1366389647-19382-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39097 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968419Ab3DSQk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Apr 2013 12:40:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org, Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de, cjb@laptop.org, adrian.hunter@intel.com, James.Bottomley@HansenPartnership.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, jcmvbkbc@gmail.com, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, Vivek Trivedi <t.vivek@samsung.com>

From: Namjae Jeon <namjae.jeon@samsung.com>

https://lkml.org/lkml/2013/4/1/292
As per above discussion, there is possibility that request's __data_len
field may overflow when max_discard_sectors greater than UINT_MAX >> 9

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 drivers/mmc/card/queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 9447a0e..54726b7 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -166,7 +166,7 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 		return;
 
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-	q->limits.max_discard_sectors = max_discard;
+	blk_queue_max_discard_sectors(q, max_discard);
 	if (card->erased_byte == 0 && !mmc_can_discard(card))
 		q->limits.discard_zeroes_data = 1;
 	q->limits.discard_granularity = card->pref_erase << 9;
-- 
1.7.9.5

