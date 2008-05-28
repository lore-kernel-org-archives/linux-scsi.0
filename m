From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: fix bsg_mutex hang with device removal
Date: Thu, 29 May 2008 07:56:55 +0900
Message-ID: <20080529075655X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:50657 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYE1XAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 19:00:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, pw@osc.edu

This is a patch to fix the bsg hang bug reported by Pete:

http://marc.info/?t=121182152200003&r=1&w=2

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] bsg: fix bsg_mutex hang with device removal

We don't need to hold bsg_mutex during bsg_complete_all_commands(). It
leads to a problem that we block bsg_unregister_queue during
bsg_complete_all_commands (untill all the outstanding commands
complete).

Thanks to Pete Wyckoff for finding the bug and testing the patch.

The detailed bug report is:

http://marc.info/?l=linux-scsi&m=121182137132145&w=2

Tested-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f0b7cd3..7cdec32 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -724,8 +724,13 @@ static int bsg_put_device(struct bsg_device *bd)
 	mutex_lock(&bsg_mutex);
 
 	do_free = atomic_dec_and_test(&bd->ref_count);
-	if (!do_free)
+	if (!do_free) {
+		mutex_unlock(&bsg_mutex);
 		goto out;
+	}
+
+	hlist_del(&bd->dev_list);
+	mutex_unlock(&bsg_mutex);
 
 	dprintk("%s: tearing down\n", bd->name);
 
@@ -741,10 +746,8 @@ static int bsg_put_device(struct bsg_device *bd)
 	 */
 	ret = bsg_complete_all_commands(bd);
 
-	hlist_del(&bd->dev_list);
 	kfree(bd);
 out:
-	mutex_unlock(&bsg_mutex);
 	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
 	if (do_free)
 		blk_put_queue(q);
-- 
1.5.3.6

