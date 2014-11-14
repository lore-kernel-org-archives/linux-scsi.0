From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 14 Nov 2014 08:58:04 -0800
Message-ID: <20141114165804.GA14631@infradead.org>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161318AbaKNQ6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 11:58:06 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Paul, what's the best way to figure out these CPU stalls?

The second oops is in blk_mq_map_queue() which is a trivial
two level cpu lookup.  I wonder if there's something odd about
cpu numbers on these big old sparc systems?

Something like the debug patch below might shed some light on where the
index goes wrong, but it'll be horribly verbose.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index b5896d4..ef4b35b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1270,7 +1270,12 @@ run_queue:
  */
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
 {
-	return q->queue_hw_ctx[q->mq_map[cpu]];
+	int idx;
+
+	printk("cpu: %d\n", cpu);
+	idx = q->mq_map[cpu];
+	printk("queue: %d\n", idx);
+	return q->queue_hw_ctx[idx];
 }
 EXPORT_SYMBOL(blk_mq_map_queue);
 
