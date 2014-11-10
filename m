From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/11] scsi: remove ordered_tag host template field
Date: Mon, 10 Nov 2014 16:56:23 +0100
Message-ID: <1415634990-3023-5-git-send-email-hch@lst.de>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKJP4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 10:56:34 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      |  1 -
 drivers/usb/storage/uas.c |  1 -
 include/scsi/scsi_host.h  | 10 ----------
 3 files changed, 12 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 06030e1..8bb173e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -418,7 +418,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
-	shost->ordered_tag = sht->ordered_tag;
 	shost->no_write_same = sht->no_write_same;
 
 	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b38bc13..1bc5df4 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -817,7 +817,6 @@ static struct scsi_host_template uas_host_template = {
 	.sg_tablesize = SG_NONE,
 	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
-	.ordered_tag = 1,
 
 	/*
 	 * The uas drivers expects tags not to be bigger than the maximum
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index bb9e278..5b03ba9 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -451,11 +451,6 @@ struct scsi_host_template {
 	 */
 	unsigned skip_settle_delay:1;
 
-	/*
-	 * True if we are using ordered write support.
-	 */
-	unsigned ordered_tag:1;
-
 	/* True if the controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
@@ -670,11 +665,6 @@ struct Scsi_Host {
 	 */
 	unsigned reverse_ordering:1;
 
-	/*
-	 * Ordered write support
-	 */
-	unsigned ordered_tag:1;
-
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-- 
1.9.1

