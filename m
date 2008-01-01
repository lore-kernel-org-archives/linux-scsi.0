From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] relax scsi dma alignment
Date: Tue, 01 Jan 2008 10:00:10 -0600
Message-ID: <1199203210.3252.2.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0712311754240.11410-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50521 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbYAAQAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jan 2008 11:00:17 -0500
In-Reply-To: <Pine.LNX.4.44L0.0712311754240.11410-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kristian Hoegsberg <krh@bitplanet.net>

On Mon, 2007-12-31 at 17:57 -0500, Alan Stern wrote:
> On Mon, 31 Dec 2007, James Bottomley wrote:
> > --- a/drivers/usb/storage/scsiglue.c
> > +++ b/drivers/usb/storage/scsiglue.c
> > @@ -82,6 +82,12 @@ static int slave_alloc (struct scsi_device *sdev)
> >  	sdev->inquiry_len = 36;
> >  
> >  	/*
> > +	 * Update the dma alignment (minimum alignment requirements for
> > +	 * start and end of DMA transfers) to be a sector
> > +	 */
> > +	blk_queue_update_dma_alignment(sdev->request_queue, 511);
> > +
> > +	/*
> >  	 * The UFI spec treates the Peripheral Qualifier bits in an
> >  	 * INQUIRY result as reserved and requires devices to set them
> >  	 * to 0.  However the SCSI spec requires these bits to be set
> 
> It would be better to move the existing code from the start of
> slave_configure() up into slave_alloc().  Otherwise it's fine.

Um, yes, you're right, I didn't notice there was an existing one ... I
just assumed you were relying on the SCSI default.

Here's an updated patch.

James

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fed5308..25c9470 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -824,6 +824,9 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	 * requests.
 	 */
 	sdev->max_device_blocked = 1;
+
+	/* set the min alignment */
+	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_MASK);
 }
 
 static void ata_scsi_dev_config(struct scsi_device *sdev,
@@ -868,7 +871,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
-	return 0;	/* scsi layer doesn't check return value, sigh */
+	return 0;
 }
 
 /**
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 624ff3e..c2169d2 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1238,6 +1238,12 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 
 	sdev->allow_restart = 1;
 
+	/*
+	 * Update the dma alignment (minimum alignment requirements for
+	 * start and end of DMA transfers) to be a sector
+	 */
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index b83d254..1eda11a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1963,6 +1963,12 @@ static int sbp2scsi_slave_alloc(struct scsi_device *sdev)
 	lu->sdev = sdev;
 	sdev->allow_restart = 1;
 
+	/*
+	 * Update the dma alignment (minimum alignment requirements for
+	 * start and end of DMA transfers) to be a sector
+	 */
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+
 	if (lu->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1a4671..0aa5296 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1667,6 +1667,14 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	/*
+	 * set a reasonable default alignment on word boundaries: the
+	 * host and device may alter it using
+	 * blk_queue_update_dma_alignment() later.
+	 */
+	blk_queue_dma_alignment(q, 0x03);
+
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 7c9593b..dd8b13e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -81,6 +81,16 @@ static int slave_alloc (struct scsi_device *sdev)
 	 */
 	sdev->inquiry_len = 36;
 
+	/* Scatter-gather buffers (all but the last) must have a length
+	 * divisible by the bulk maxpacket size.  Otherwise a data packet
+	 * would end up being short, causing a premature end to the data
+	 * transfer.  Since high-speed bulk pipes have a maxpacket size
+	 * of 512, we'll use that as the scsi device queue's DMA alignment
+	 * mask.  Guaranteeing proper alignment of the first buffer will
+	 * have the desired effect because, except at the beginning and
+	 * the end, scatter-gather buffers follow page boundaries. */
+	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
+
 	/*
 	 * The UFI spec treates the Peripheral Qualifier bits in an
 	 * INQUIRY result as reserved and requires devices to set them
@@ -100,16 +110,6 @@ static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
-	/* Scatter-gather buffers (all but the last) must have a length
-	 * divisible by the bulk maxpacket size.  Otherwise a data packet
-	 * would end up being short, causing a premature end to the data
-	 * transfer.  Since high-speed bulk pipes have a maxpacket size
-	 * of 512, we'll use that as the scsi device queue's DMA alignment
-	 * mask.  Guaranteeing proper alignment of the first buffer will
-	 * have the desired effect because, except at the beginning and
-	 * the end, scatter-gather buffers follow page boundaries. */
-	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
-
 	/* Many devices have trouble transfering more than 32KB at a time,
 	 * while others have trouble with more than 64K. At this time we
 	 * are limiting both to 32K (64 sectores).


