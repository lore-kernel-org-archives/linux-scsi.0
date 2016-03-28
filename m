From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/3] block: Limit work processed in softirq context
Date: Mon, 28 Mar 2016 14:49:46 -0700
Message-ID: <56F9A6FA.9040503@sandisk.com>
References: <56F9A692.2090704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:15850
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252AbcC1Vtv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:49:51 -0400
In-Reply-To: <56F9A692.2090704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that complaints like the one below are reported against a
debug kernel:

NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [disk11_0:2708]
irq event stamp: 17120809
hardirqs last  enabled at (17120808): [<ffffffff81599191>] _raw_spin_unlock_irqrestore+0x31/0x50
hardirqs last disabled at (17120809): [<ffff88046f223bd0>] 0xffff88046f223bd0
softirqs last  enabled at (17120794): [<ffffffffa060aa67>] scst_check_blocked_dev+0x77/0x1c0 [scst]
softirqs last disabled at (17120795): [<ffffffff8159acbc>] do_softirq_own_stack+0x1c/0x30
RIP: 0010:[<ffffffff81599193>]  [<ffffffff81599193>] _raw_spin_unlock_irqrestore+0x33/0x50
Call Trace:
 <IRQ>
 [<ffffffff81171450>] free_debug_processing+0x270/0x3a0
 [<ffffffff8117277a>] __slab_free+0x17a/0x2c0
 [<ffffffff81172a74>] kmem_cache_free+0x1b4/0x1d0
 [<ffffffff8111a6c2>] mempool_free_slab+0x12/0x20
 [<ffffffff8111a846>] mempool_free+0x26/0x80
 [<ffffffff81294cb9>] bio_free+0x49/0x60
 [<ffffffff81294cee>] bio_put+0x1e/0x30
 [<ffffffffa0199d31>] end_clone_bio+0x21/0x70 [dm_mod]
 [<ffffffff81294d52>] bio_endio+0x52/0x60
 [<ffffffff8129aaec>] blk_update_request+0x7c/0x2a0
 [<ffffffff813f4a8e>] scsi_end_request+0x2e/0x1d0
 [<ffffffff813f7674>] scsi_io_completion+0xb4/0x610
 [<ffffffff813ee79a>] scsi_finish_command+0xca/0x120
 [<ffffffff813f6ef0>] scsi_softirq_done+0x120/0x140
 [<ffffffff812a26e6>] blk_done_softirq+0x76/0x90
 [<ffffffff8105bc1f>] __do_softirq+0x10f/0x230
 [<ffffffff8159acbc>] do_softirq_own_stack+0x1c/0x30
 <EOI>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-softirq.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 53b1737..d4d2fe4 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -21,10 +21,22 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
 static void blk_done_softirq(struct softirq_action *h)
 {
 	struct list_head *cpu_list, local_list;
+	struct request *e;
+	bool reraise = false;
+	int i = 0;
 
 	local_irq_disable();
 	cpu_list = this_cpu_ptr(&blk_cpu_done);
+	list_for_each_entry(e, cpu_list, ipi_list) {
+		if (++i < 256)
+			continue;
+		list_cut_position(&local_list, cpu_list, &e->ipi_list);
+		reraise = true;
+		goto enable_irq;
+	}
 	list_replace_init(cpu_list, &local_list);
+
+enable_irq:
 	local_irq_enable();
 
 	while (!list_empty(&local_list)) {
@@ -34,6 +46,14 @@ static void blk_done_softirq(struct softirq_action *h)
 		list_del_init(&rq->ipi_list);
 		rq->q->softirq_done_fn(rq);
 	}
+
+	if (!reraise)
+		return;
+
+	local_irq_disable();
+	if (!list_empty(cpu_list))
+		raise_softirq_irqoff(BLOCK_SOFTIRQ);
+	local_irq_enable();
 }
 
 #ifdef CONFIG_SMP
-- 
2.7.3

