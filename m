From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: Mon, 5 Jan 2004 16:58:01 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401051657020.604-100000@ida.rowland.org>
References: <20040105100824.GC3079@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:772 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265894AbUAEV6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 16:58:02 -0500
In-Reply-To: <20040105100824.GC3079@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Mon, 5 Jan 2004, Jens Axboe wrote:

> On Sun, Jan 04 2004, Matthew Dharm wrote:
> > Is there any indication that the SCSI parts of this patch will get
> > accepted?
> 
> I'm fine with the patch, FWIW, just move it to scsi_alloc_queue()
> instead?

Here's the revised patch.

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
===== scsi_lib.c 1.49 vs edited =====
--- 1.49/drivers/scsi/scsi_lib.c	Sat Nov 22 11:20:45 2003
+++ edited/drivers/scsi/scsi_lib.c	Mon Jan  5 16:55:32 2004
@@ -1287,6 +1287,15 @@
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
+ 
+	/*
+	 * Set the queue's mask to require a mere 8-byte alignment for
+	 * DMA buffers, rather than the default 512.  This shouldn't
+	 * inconvenience any user programs and should be okay for most
+	 * host adapters.  A host driver can alter this mask in its
+	 * slave_alloc() or slave_configure() callback if necessary.
+	 */
+	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);

