From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as141) Unaligned scatter-gather buffers and usb-storage
Date: Fri, 21 Nov 2003 13:03:05 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
References: <20031120191859.GA3569@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264394AbTKUSDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 13:03:06 -0500
In-Reply-To: <20031120191859.GA3569@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Jens Axboe <axboe@suse.de>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

I'm not sure whether Jens is objecting to adding the extra member to the
host template or to making the default alignment something other than 512.  
Here's my attempt at a compromise patch, which boils the area of
disagreement between Kai and Jens down to a single line of code (plus a
comment).  It doesn't change the host template and it shouldn't slow down
any tape I/O programs when using a non-USB device.

If there aren't any more objections to this, I urge James to apply the
SCSI parts to a post-2.6.0-final tree, and likewise for Matt and the USB 
part.

Alan Stern


===== scsiglue.c 1.60 vs edited =====
--- 1.60/drivers/usb/storage/scsiglue.c	Fri Oct 24 14:53:38 2003
+++ edited/drivers/usb/storage/scsiglue.c	Fri Nov 21 12:45:21 2003
@@ -65,6 +65,16 @@
 
 static int slave_configure (struct scsi_device *sdev)
 {
+	/* Scatter-gather buffers (all but the last) must have a length
+	 * divisible by the bulk maxpacket size.  Otherwise a data packet
+	 * would end up being short, causing a premature end to the data
+	 * transfer.  Since high-speed bulk pipes have a maxpacket size
+	 * of 512, we'll use that as the scsi device queue's DMA alignment
+	 * mask.  Guaranteeing proper alignment of the first buffer will
+	 * have the desired effect because, except at the beginning and
+	 * the end, scatter-gather buffers follow page boundaries. */
+	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
+
 	/* this is to satisify the compiler, tho I don't think the 
 	 * return code is ever checked anywhere. */
 	return 0;
===== sg.c 1.48 vs edited =====
--- 1.48/drivers/scsi/sg.c	Fri Oct 24 14:53:37 2003
+++ edited/drivers/scsi/sg.c	Fri Nov 21 12:28:52 2003
@@ -1741,7 +1741,11 @@
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	struct scatterlist *sgl;
 	int mx_sc_elems, res;
+	struct scsi_device *sdev = sfp->parentdp->device;
 
+	if (((unsigned long)hp->dxferp &
+			queue_dma_alignment(sdev->request_queue)) != 0)
+		return 1;
 	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
         if (mx_sc_elems <= 0) {
                 return 1;
===== st.c 1.45 vs edited =====
--- 1.45/drivers/scsi/st.c	Fri Sep  5 12:16:40 2003
+++ edited/drivers/scsi/st.c	Fri Nov 21 12:30:34 2003
@@ -1267,7 +1267,8 @@
 		i = STp->try_dio && try_rdio;
 	else
 		i = STp->try_dio && try_wdio;
-	if (i) {
+	if (i && ((unsigned int)buf & queue_dma_alignment(
+					STp->device->request_queue)) == 0) {
 		i = st_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
 				      (unsigned long)buf, count, (is_read ? READ : WRITE),
 				      STp->max_pfn);
===== scsi_scan.c 1.52 vs edited =====
--- 1.52/drivers/scsi/scsi_scan.c	Fri Oct 24 14:53:37 2003
+++ edited/drivers/scsi/scsi_scan.c	Fri Nov 21 12:34:00 2003
@@ -231,6 +231,15 @@
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
+	/*
+	 * Set the queue's mask to require a mere 8-byte alignment for
+	 * DMA buffers, rather than the default 512.  This shouldn't
+	 * inconvenience any user programs and should be okay for most
+	 * host adapters.  A host driver can alter this mask in its
+	 * slave_alloc() or slave_configure() callback if necessary.
+	 */
+	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));
+
 	if (shost->hostt->slave_alloc) {
 		if (shost->hostt->slave_alloc(sdev))
 			goto out_free_queue;

