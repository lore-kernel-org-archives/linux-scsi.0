From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/11] scsi: remove ordered_tag host template field
Date: Tue,  4 Nov 2014 08:54:09 +0100
Message-ID: <1415087656-9491-5-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKDHyM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:12 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 5e36248..f62143a 100644
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
 
@@ -662,11 +657,6 @@ struct Scsi_Host {
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

