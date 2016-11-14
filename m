From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 1/2] blk-mq: Fix failed allocation path when mapping queues
Date: Mon, 14 Nov 2016 17:24:37 -0200
Message-ID: <1479151478-19725-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936591AbcKNTY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 14:24:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAEJOKrt023520
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 14:24:55 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26qfdadr6e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 14:24:55 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Mon, 14 Nov 2016 17:24:52 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-block@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

In blk_mq_map_swqueue, there is a memory optimization that frees the
tags of a queue that has gone unmapped.  Later, if that hctx is remapped
after another topology change, the tags need to be reallocated.

If this allocation fails, a simple WARN_ON triggers, but the block layer
ends up with an active hctx without any corresponding set of tags.
Then, any income IO to that hctx can trigger an Oops.

I can reproduce it consistently by running IO, flipping CPUs on and off
and eventually injecting a memory allocation failure in that path.

In the fix below, if the system experiences a failed allocation of any
hctx's tags, we remap all the ctxs of that queue to the hctx_0, which
should always keep it's tags.  There is a minor performance hit, since
our mapping just got worse after the error path, but this is
the simplest solution to handle this error path.  The performance hit
will disappear after another successful remap.

I considered dropping the memory optimization all together, but it
seemed a bad trade-off to handle this very specific error case.

My one concern about this patch is if remapping an arbitrary queue to
hctx_0 could result in outstanding requests getting submitted to the
wrong hctx.  I couldn't observe this happening during tests, but I'm not
entirely sure it'll never happen.  I believe the queue will be empty if
we are trying to allocate tags for it, unless it was using another alive
hctx queue and for some reason got reassigned to this new hctx.  is this
possible at all?

This should apply cleanly on top of Jen's for-next branch.

The Oops is the one below:

SP (3fff935ce4d0) is in userspace
1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c000000fe99eb110]
    pc: c0000000005e868c: __sbitmap_queue_get+0x2c/0x180
    lr: c000000000575328: __bt_get+0x48/0xd0
    sp: c000000fe99eb390
   msr: 900000010280b033
   dar: 28
 dsisr: 40000000
  current = 0xc000000fe9966800
  paca    = 0xc000000007e80300   softe: 0        irq_happened: 0x01
    pid   = 11035, comm = aio-stress
Linux version 4.8.0-rc6+ (root@bean) (gcc version 5.4.0 20160609
(Ubuntu/IBM 5.4.0-6ubuntu1~16.04.2) ) #3 SMP Mon Oct 10 20:16:53 CDT 2016
1:mon> s
[c000000fe99eb3d0] c000000000575328 __bt_get+0x48/0xd0
[c000000fe99eb400] c000000000575838 bt_get.isra.1+0x78/0x2d0
[c000000fe99eb480] c000000000575cb4 blk_mq_get_tag+0x44/0x100
[c000000fe99eb4b0] c00000000056f6f4 __blk_mq_alloc_request+0x44/0x220
[c000000fe99eb500] c000000000570050 blk_mq_map_request+0x100/0x1f0
[c000000fe99eb580] c000000000574650 blk_mq_make_request+0xf0/0x540
[c000000fe99eb640] c000000000561c44 generic_make_request+0x144/0x230
[c000000fe99eb690] c000000000561e00 submit_bio+0xd0/0x200
[c000000fe99eb740] c0000000003ef740 ext4_io_submit+0x90/0xb0
[c000000fe99eb770] c0000000003e95d8 ext4_writepages+0x588/0xdd0
[c000000fe99eb910] c00000000025a9f0 do_writepages+0x60/0xc0
[c000000fe99eb940] c000000000246c88 __filemap_fdatawrite_range+0xf8/0x180
[c000000fe99eb9e0] c000000000246f90 filemap_write_and_wait_range+0x70/0xf0
[c000000fe99eba20] c0000000003dd844 ext4_sync_file+0x214/0x540
[c000000fe99eba80] c000000000364718 vfs_fsync_range+0x78/0x130
[c000000fe99ebad0] c0000000003dd46c ext4_file_write_iter+0x35c/0x430
[c000000fe99ebb90] c00000000038c280 aio_run_iocb+0x3b0/0x450
[c000000fe99ebce0] c00000000038dc28 do_io_submit+0x368/0x730
[c000000fe99ebe30] c000000000009404 system_call+0x38/0xec

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 block/blk-mq.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3c5aaead71bb..7f7c4ba91adf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1862,7 +1862,7 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 static void blk_mq_map_swqueue(struct request_queue *q,
 			       const struct cpumask *online_mask)
 {
-	unsigned int i;
+	unsigned int i, hctx_idx;
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_tag_set *set = q->tag_set;
@@ -1885,6 +1885,15 @@ static void blk_mq_map_swqueue(struct request_queue *q,
 		if (!cpumask_test_cpu(i, online_mask))
 			continue;
 
+		hctx_idx = q->mq_map[i];
+		/* unmapped hw queue can be remapped after CPU topo changed */
+		if (!set->tags[hctx_idx]) {
+			set->tags[hctx_idx] = blk_mq_init_rq_map(set, hctx_idx);
+
+			if (!set->tags[hctx_idx])
+				q->mq_map[i] = 0;
+		}
+
 		ctx = per_cpu_ptr(q->queue_ctx, i);
 		hctx = blk_mq_map_queue(q, i);
 
@@ -1901,7 +1910,10 @@ static void blk_mq_map_swqueue(struct request_queue *q,
 		 * disable it and free the request entries.
 		 */
 		if (!hctx->nr_ctx) {
-			if (set->tags[i]) {
+			/* Never unmap queue 0.  We need it as a
+			 * fallback in case of a new remap fails
+			 * allocation. */
+			if (i && set->tags[i]) {
 				blk_mq_free_rq_map(set, set->tags[i], i);
 				set->tags[i] = NULL;
 			}
@@ -1909,11 +1921,8 @@ static void blk_mq_map_swqueue(struct request_queue *q,
 			continue;
 		}
 
-		/* unmapped hw queue can be remapped after CPU topo changed */
-		if (!set->tags[i])
-			set->tags[i] = blk_mq_init_rq_map(set, i);
 		hctx->tags = set->tags[i];
-		WARN_ON(!hctx->tags);
+		BUG_ON(!hctx->tags);
 
 		/*
 		 * Set the map size to the number of mapped software queues.
-- 
2.7.4

