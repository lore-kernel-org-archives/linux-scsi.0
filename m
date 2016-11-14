From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 2/2] blk-mq: Avoid memory reclaim when remapping queues
Date: Mon, 14 Nov 2016 17:24:38 -0200
Message-ID: <1479151478-19725-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1479151478-19725-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36999 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932343AbcKNTY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 14:24:56 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAEJOKRt072785
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 14:24:55 -0500
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26qjus1qn9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2016 14:24:55 -0500
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Mon, 14 Nov 2016 17:24:53 -0200
In-Reply-To: <1479151478-19725-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-block@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

While stressing memory and IO at the same time we changed SMT settings,
we were able to consistently trigger deadlocks in the mm system, which
froze the entire machine.

I think that under memory stress conditions, the large allocations
performed by blk_mq_init_rq_map may trigger a reclaim, which stalls
waiting on the block layer remmaping completion, thus deadlocking the
system.  The trace below was collected after the machine stalled,
waiting for the hotplug event completion.

The simplest fix for this is to make allocations in this path
non-reclaimable, with GFP_NOWAIT.  With this patch, We couldn't hit the
issue anymore.

This should apply on top of Jen's for-next branch cleanly.

 Call Trace:
[c000000f0160aaf0] [c000000f0160ab50] 0xc000000f0160ab50 (unreliable)
[c000000f0160acc0] [c000000000016624] __switch_to+0x2e4/0x430
[c000000f0160ad20] [c000000000b1a880] __schedule+0x310/0x9b0
[c000000f0160ae00] [c000000000b1af68] schedule+0x48/0xc0
[c000000f0160ae30] [c000000000b1b4b0] schedule_preempt_disabled+0x20/0x30
[c000000f0160ae50] [c000000000b1d4fc] __mutex_lock_slowpath+0xec/0x1f0
[c000000f0160aed0] [c000000000b1d678] mutex_lock+0x78/0xa0
[c000000f0160af00] [d000000019413cac] xfs_reclaim_inodes_ag+0x33c/0x380 [xfs]
[c000000f0160b0b0] [d000000019415164] xfs_reclaim_inodes_nr+0x54/0x70 [xfs]
[c000000f0160b0f0] [d0000000194297f8] xfs_fs_free_cached_objects+0x38/0x60 [xfs]
[c000000f0160b120] [c0000000003172c8] super_cache_scan+0x1f8/0x210
[c000000f0160b190] [c00000000026301c] shrink_slab.part.13+0x21c/0x4c0
[c000000f0160b2d0] [c000000000268088] shrink_zone+0x2d8/0x3c0
[c000000f0160b380] [c00000000026834c] do_try_to_free_pages+0x1dc/0x520
[c000000f0160b450] [c00000000026876c] try_to_free_pages+0xdc/0x250
[c000000f0160b4e0] [c000000000251978] __alloc_pages_nodemask+0x868/0x10d0
[c000000f0160b6f0] [c000000000567030] blk_mq_init_rq_map+0x160/0x380
[c000000f0160b7a0] [c00000000056758c] blk_mq_map_swqueue+0x33c/0x360
[c000000f0160b820] [c000000000567904] blk_mq_queue_reinit+0x64/0xb0
[c000000f0160b850] [c00000000056a16c] blk_mq_queue_reinit_notify+0x19c/0x250
[c000000f0160b8a0] [c0000000000f5d38] notifier_call_chain+0x98/0x100
[c000000f0160b8f0] [c0000000000c5fb0] __cpu_notify+0x70/0xe0
[c000000f0160b930] [c0000000000c63c4] notify_prepare+0x44/0xb0
[c000000f0160b9b0] [c0000000000c52f4] cpuhp_invoke_callback+0x84/0x250
[c000000f0160ba10] [c0000000000c570c] cpuhp_up_callbacks+0x5c/0x120
[c000000f0160ba60] [c0000000000c7cb8] _cpu_up+0xf8/0x1d0
[c000000f0160bac0] [c0000000000c7eb0] do_cpu_up+0x120/0x150
[c000000f0160bb40] [c0000000006fe024] cpu_subsys_online+0x64/0xe0
[c000000f0160bb90] [c0000000006f5124] device_online+0xb4/0x120
[c000000f0160bbd0] [c0000000006f5244] online_store+0xb4/0xc0
[c000000f0160bc20] [c0000000006f0a68] dev_attr_store+0x68/0xa0
[c000000f0160bc60] [c0000000003ccc30] sysfs_kf_write+0x80/0xb0
[c000000f0160bca0] [c0000000003cbabc] kernfs_fop_write+0x17c/0x250
[c000000f0160bcf0] [c00000000030fe6c] __vfs_write+0x6c/0x1e0
[c000000f0160bd90] [c000000000311490] vfs_write+0xd0/0x270
[c000000f0160bde0] [c0000000003131fc] SyS_write+0x6c/0x110
[c000000f0160be30] [c000000000009204] system_call+0x38/0xec

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7f7c4ba91adf..3e44303646cb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1597,7 +1597,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 	INIT_LIST_HEAD(&tags->page_list);
 
 	tags->rqs = kzalloc_node(set->queue_depth * sizeof(struct request *),
-				 GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
+				 GFP_NOWAIT | __GFP_NOWARN | __GFP_NORETRY,
 				 set->numa_node);
 	if (!tags->rqs) {
 		blk_mq_free_tags(tags);
@@ -1623,7 +1623,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 
 		do {
 			page = alloc_pages_node(set->numa_node,
-				GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY | __GFP_ZERO,
+				GFP_NOWAIT | __GFP_NOWARN | __GFP_NORETRY | __GFP_ZERO,
 				this_order);
 			if (page)
 				break;
@@ -1644,7 +1644,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		 * Allow kmemleak to scan these pages as they contain pointers
 		 * to additional allocations like via ops->init_request().
 		 */
-		kmemleak_alloc(p, order_to_size(this_order), 1, GFP_KERNEL);
+		kmemleak_alloc(p, order_to_size(this_order), 1, GFP_NOWAIT);
 		entries_per_page = order_to_size(this_order) / rq_size;
 		to_do = min(entries_per_page, set->queue_depth - i);
 		left -= to_do * rq_size;
-- 
2.7.4

