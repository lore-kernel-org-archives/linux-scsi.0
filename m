From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/5] bsg: use better helper list functions
Date: Mon, 31 Mar 2008 10:03:40 +0900
Message-ID: <1206925422-4722-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 20080331092020R.fujita.tomonori@lab.ntt.co.jp
 <1206925422-4722-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206925422-4722-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58048 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYCaBFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 21:05:09 -0400
In-Reply-To: <1206925422-4722-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, pw@osc.edu, tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This replace hlist_for_each and list_entry with hlist_for_each_entry
and list_first_entry respectively.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/bsg.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index e2c65a1..b413318 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -368,7 +368,7 @@ static struct bsg_command *bsg_next_done_cmd(struct bsg_device *bd)
 
 	spin_lock_irq(&bd->lock);
 	if (bd->done_cmds) {
-		bc = list_entry(bd->done_list.next, struct bsg_command, list);
+		bc = list_first_entry(&bd->done_list, struct bsg_command, list);
 		list_del(&bc->list);
 		bd->done_cmds--;
 	}
@@ -772,21 +772,19 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 
 static struct bsg_device *__bsg_get_device(int minor)
 {
-	struct bsg_device *bd = NULL;
+	struct bsg_device *bd;
 	struct hlist_node *entry;
 
 	mutex_lock(&bsg_mutex);
 
-	hlist_for_each(entry, bsg_dev_idx_hash(minor)) {
-		bd = hlist_entry(entry, struct bsg_device, dev_list);
+	hlist_for_each_entry(bd, entry, bsg_dev_idx_hash(minor), dev_list) {
 		if (bd->minor == minor) {
 			atomic_inc(&bd->ref_count);
-			break;
+			goto found;
 		}
-
-		bd = NULL;
 	}
-
+	bd = NULL;
+found:
 	mutex_unlock(&bsg_mutex);
 	return bd;
 }
-- 
1.5.3.7

