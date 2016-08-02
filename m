From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [RFC PATCH] blk-mq: Prevent round-robin from scheduling dead cpus
Date: Tue,  2 Aug 2016 13:19:31 -0300
Message-ID: <1470154771-22774-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21510 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935399AbcHBQTo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2016 12:19:44 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u72GImcD133439
	for <linux-scsi@vger.kernel.org>; Tue, 2 Aug 2016 12:19:42 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24jq3rwcwe-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2016 12:19:41 -0400
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 2 Aug 2016 13:19:39 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I'm not completely sure I got the cause for this one completely right.
Still, it does looks like the correct fix and a good improvement in the
overall, so I'm making it an RFC for now to gather some feedback.

Let me hear your thoughts.

-- >8 --

When notifying blk-mq about CPU removals while running IO, we risk
racing the hctx->cpumask update with blk_mq_hctx_next_cpu, and end up
scheduling a dead cpu to execute hctx->run_{,delayed_}work.  As a
result, kblockd_schedule_delayed_work_on() may schedule another cpu
outside of hctx->cpumask, which triggers the following warning at
__blk_mq_run_hw_queue:

WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));

This patch makes the issue much more unlikely to happen, as it makes
blk_mq_hctx_next_cpu aware of dead cpus, and triggers the round-robin
code, despite of remaining batch processing time.  Thus, in case we
offline a cpu in the middle of its batch processing time, we no longer
waste time scheduling it here, and just move through to the next cpu in
the mask.

The warning may still be triggered, though, since this is not the only
case that may cause the queue to schedule on a dead cpu.  But this fixes
the common case, which is the remaining batch processing time of a
sudden dead cpu, which makes the issue much more unlikely to happen.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 block/blk-mq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c27bb37..a2cb64c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -858,7 +858,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 	if (hctx->queue->nr_hw_queues == 1)
 		return WORK_CPU_UNBOUND;
 
-	if (--hctx->next_cpu_batch <= 0) {
+	if (--hctx->next_cpu_batch <= 0 ||
+	    !cpumask_test_cpu(hctx->next_cpu, cpu_online_mask)) {
 		int cpu = hctx->next_cpu, next_cpu;
 
 		next_cpu = cpumask_next(hctx->next_cpu, hctx->cpumask);
@@ -868,7 +869,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 		hctx->next_cpu = next_cpu;
 		hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
 
-		return cpu;
+		return (cpumask_test_cpu(cpu, cpu_online_mask)) ?
+			cpu : blk_mq_hctx_next_cpu(hctx);
 	}
 
 	return hctx->next_cpu;
-- 
2.7.4

