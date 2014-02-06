From: Shlomo Pongratz <shlomop@mellanox.com>
Subject: [PATCH] block/null_blk: Fix completion processing from LIFO to FIFO
Date: Thu,  6 Feb 2014 18:33:17 +0200
Message-ID: <1391704397-26816-1-git-send-email-shlomop@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:45001 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751370AbaBFQdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 11:33:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, Shlomo Pongratz <shlomop@mellanox.com>

The completion queue is implemented using lockless list.

The llist_add is adds the events to the list head which is a push operation.
The processing of the completion elements is done by disconnecting all the
pushed elements and iterating over the disconnected list. The problem is
that the processing is done in reverse order w.r.t order of the insertion
i.e. LIFO processing. By reversing the disconnected list which is done in
linear time the desired FIFO processing is achieved.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
---
 drivers/block/null_blk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 3107282..cc801cd 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -195,6 +195,7 @@ static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
 	cq = &per_cpu(completion_queues, smp_processor_id());
 
 	while ((entry = llist_del_all(&cq->list)) != NULL) {
+		entry = llist_reverse_order(entry);
 		do {
 			cmd = container_of(entry, struct nullb_cmd, ll_list);
 			end_cmd(cmd);
@@ -235,6 +236,7 @@ static void null_ipi_cmd_end_io(void *data)
 	cq = &per_cpu(completion_queues, smp_processor_id());
 
 	entry = llist_del_all(&cq->list);
+	entry = llist_reverse_order(entry);
 
 	while (entry) {
 		next = entry->next;
-- 
1.7.1

