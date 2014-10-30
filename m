From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 02/11] scsi-mq: Add support for multiple hardware queues
Date: Thu, 30 Oct 2014 14:45:36 +0100
Message-ID: <54524100.7060704@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52385 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759786AbaJ3Nph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:45:37 -0400
In-Reply-To: <545240AE.6060009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Allow a SCSI LLD to declare how many hardware queues it supports
by setting Scsi_Host.nr_hw_queues before calling scsi_add_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_lib.c  | 2 +-
 include/scsi/scsi_host.h | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9eff8a3..38711c2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2086,7 +2086,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 
 	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
 	shost->tag_set.ops = &scsi_mq_ops;
-	shost->tag_set.nr_hw_queues = 1;
+	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth = shost->can_queue;
 	shost->tag_set.cmd_size = cmd_size;
 	shost->tag_set.numa_node = NUMA_NO_NODE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5e36248..bb9e278 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -638,6 +638,14 @@ struct Scsi_Host {
 	short unsigned int sg_prot_tablesize;
 	unsigned int max_sectors;
 	unsigned long dma_boundary;
+	/*
+	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
+	 *
+	 * Note: it is assumed that each hardware queue has a queue depth of
+	 * can_queue. In other words, the total queue depth per host
+	 * is nr_hw_queues * can_queue.
+	 */
+	unsigned nr_hw_queues;
 	/* 
 	 * Used to assign serial numbers to the cmds.
 	 * Protected by the host lock.
-- 
1.8.4.5

