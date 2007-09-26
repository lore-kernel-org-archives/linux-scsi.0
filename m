From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/5] add dma_max_segment_size option to scsi_host_template
Date: Wed, 26 Sep 2007 17:57:59 +0900
Message-ID: <20070925142144Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50171 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbXIZI7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:59:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

This patch moves blk_queue_max_segment_size to scsi_alloc_queue from
llds. It enables scsi_add_host to tells iommu lld's
dma_max_segment_size. If a low-level driver doesn't specify
dma_max_segment_size, scsi-ml uses 65536 (MAX_SEGMENT_SIZE). So there
are not any functional changes.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c     |    5 +++++
 drivers/scsi/scsi_lib.c  |    1 +
 include/scsi/scsi_host.h |    6 ++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 96bc312..22877d3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -365,6 +365,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
+	if (sht->dma_max_segment_size)
+		shost->dma_max_segment_size = sht->dma_max_segment_size;
+	else
+		shost->dma_max_segment_size = 65536;
+
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
 		goto fail_kfree;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a417a6f..2ec77a9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1564,6 +1564,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
+	blk_queue_max_segment_size(q, shost->dma_max_segment_size);
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b8a6a8..1eb8435 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -383,6 +383,11 @@ struct scsi_host_template {
 	unsigned long dma_boundary;
 
 	/*
+	 * dma scatter gather segment size limit.
+	 */
+	unsigned int dma_max_segment_size;
+
+	/*
 	 * This specifies "machine infinity" for host templates which don't
 	 * limit the transfer size.  Note this limit represents an absolute
 	 * maximum, and may be over the transfer limits allowed for
@@ -571,6 +576,7 @@ struct Scsi_Host {
 	short unsigned int sg_tablesize;
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
+	unsigned int dma_max_segment_size;
 	/* 
 	 * Used to assign serial numbers to the cmds.
 	 * Protected by the host lock.
-- 
1.5.2.4

