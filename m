From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/8] scsi-mq: Add support for multiple hardware queues
Date: Fri, 19 Sep 2014 14:57:02 +0200
Message-ID: <541C281E.9090206@acm.org>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:46467 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaISM5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 08:57:03 -0400
In-Reply-To: <541C27BF.6070609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

Allow a SCSI LLD to declare how many hardware queues it supports
by setting Scsi_Host.nr_hw_queues before calling scsi_add_host().

Note: it is assumed that each hardware queue has a queue depth of
shost->can_queue. In other words, the total queue depth per host
is (number of hardware queues) * (shost->can_queue).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c  | 2 +-
 include/scsi/scsi_host.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d837dc1..b0b6117 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2071,7 +2071,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 
 	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
 	shost->tag_set.ops = &scsi_mq_ops;
-	shost->tag_set.nr_hw_queues = 1;
+	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth = shost->can_queue;
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba20347..0a867d9 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -638,6 +638,10 @@ struct Scsi_Host {
 	short unsigned int sg_prot_tablesize;
 	unsigned int max_sectors;
 	unsigned long dma_boundary;
+	/*
+	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
+	 */
+	unsigned nr_hw_queues;
 	/* 
 	 * Used to assign serial numbers to the cmds.
 	 * Protected by the host lock.
-- 
1.8.4.5

