From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: 02 Feb 2004 10:51:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075737065.1897.7.camel@mulgrave>
References: <Pine.LNX.4.44L0.0401051657020.604-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22436 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265326AbUBBPvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 10:51:21 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401051657020.604-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, Kai =?ISO-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, Patrick Mansfield <patmans@us.ibm.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Mon, 2004-01-05 at 16:58, Alan Stern wrote:
> ===== st.c 1.45 vs edited =====
> --- 1.45/drivers/scsi/st.c	Fri Sep  5 12:16:40 2003
> +++ edited/drivers/scsi/st.c	Fri Nov 21 12:30:34 2003
> @@ -1267,7 +1267,8 @@
>  		i = STp->try_dio && try_rdio;
>  	else
>  		i = STp->try_dio && try_wdio;
> -	if (i) {
> +	if (i && ((unsigned int)buf & queue_dma_alignment(

This needs to be unsigned long, otherwise it will print a warning on a
64 bit compile.

> ===== scsi_lib.c 1.49 vs edited =====
> --- 1.49/drivers/scsi/scsi_lib.c	Sat Nov 22 11:20:45 2003
> +++ edited/drivers/scsi/scsi_lib.c	Mon Jan  5 16:55:32 2004
> @@ -1287,6 +1287,15 @@
>  	blk_queue_max_sectors(q, shost->max_sectors);
>  	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
>  	blk_queue_segment_boundary(q, shost->dma_boundary);
> + 
> +	/*
> +	 * Set the queue's mask to require a mere 8-byte alignment for
> +	 * DMA buffers, rather than the default 512.  This shouldn't
> +	 * inconvenience any user programs and should be okay for most
> +	 * host adapters.  A host driver can alter this mask in its
> +	 * slave_alloc() or slave_configure() callback if necessary.
> +	 */
> +	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));

sdev->request_queue is NULL here (it's filled in by the return from this
function.  The argument should be q.

I'll make the changes and apply the patch.

James


