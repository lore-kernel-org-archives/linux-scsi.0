From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct
 Scsi_Host
Date: Mon, 11 Apr 2016 19:22:30 -0400 (EDT)
Message-ID: <1375441901.28363505.1460416950062.JavaMail.zimbra@redhat.com>
References: <1460414846-29540-1-git-send-email-hch@lst.de> <1460414846-29540-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55734 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbcDKXWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 19:22:32 -0400
In-Reply-To: <1460414846-29540-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

This looks fine to me.
I am pulling this in to my SRP initiator and target testing ongoing at the moment so will be testing.
Up to now this has likely not affected me but I am pulling in all RDMA patches to test.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Christoph Hellwig" <hch@lst.de>
To: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org
Sent: Monday, April 11, 2016 6:47:25 PM
Subject: [PATCH 1/2] scsi: add a max_segment_size limitation to struct Scsi_Host

RDMA drivers need segments that aren't larger than a single HCA page
for memory registrations to work properly, so wire up this limitation
in the host.

While we could just call blk_queue_max_segment_size from ->slave_configure,
that would override the global limit based on the DMA device, so let's do
it the traditional way by adding a field to the Scsi_Host structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_host.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..04c660d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2120,7 +2120,8 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
-	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
+	blk_queue_max_segment_size(q,
+		min(shost->max_segment_size, dma_get_max_seg_size(dev)));
 
 	if (!shost->use_clustering)
 		q->limits.cluster = 0;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..f11d3fe 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -621,6 +621,7 @@ struct Scsi_Host {
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
 	unsigned int max_sectors;
+	unsigned int max_segment_size;
 	unsigned long dma_boundary;
 	/*
 	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
