From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: Tue, 3 Feb 2004 10:47:38 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402031044390.1161-100000@ida.rowland.org>
References: <1075737065.1897.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16132 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266014AbUBCPrj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2004 10:47:39 -0500
In-Reply-To: <1075737065.1897.7.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 2 Feb 2004, James Bottomley wrote:

> On Mon, 2004-01-05 at 16:58, Alan Stern wrote:
> > ===== st.c 1.45 vs edited =====
> > --- 1.45/drivers/scsi/st.c	Fri Sep  5 12:16:40 2003
> > +++ edited/drivers/scsi/st.c	Fri Nov 21 12:30:34 2003
> > @@ -1267,7 +1267,8 @@
> >  		i = STp->try_dio && try_rdio;
> >  	else
> >  		i = STp->try_dio && try_wdio;
> > -	if (i) {
> > +	if (i && ((unsigned int)buf & queue_dma_alignment(
> 
> This needs to be unsigned long, otherwise it will print a warning on a
> 64 bit compile.

Really?  I'm surprised.  Although I know nothing about the details of 
using gcc on a 64-bit platform, it seems odd that an explicit cast would 
generate a warning.  Was that done deliberately, to try and catch 
inadvertent bugs in address arithmetic?

> > ===== scsi_lib.c 1.49 vs edited =====
> > --- 1.49/drivers/scsi/scsi_lib.c	Sat Nov 22 11:20:45 2003
> > +++ edited/drivers/scsi/scsi_lib.c	Mon Jan  5 16:55:32 2004
> > @@ -1287,6 +1287,15 @@
> >  	blk_queue_max_sectors(q, shost->max_sectors);
> >  	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
> >  	blk_queue_segment_boundary(q, shost->dma_boundary);
> > + 
> > +	/*
> > +	 * Set the queue's mask to require a mere 8-byte alignment for
> > +	 * DMA buffers, rather than the default 512.  This shouldn't
> > +	 * inconvenience any user programs and should be okay for most
> > +	 * host adapters.  A host driver can alter this mask in its
> > +	 * slave_alloc() or slave_configure() callback if necessary.
> > +	 */
> > +	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));
> 
> sdev->request_queue is NULL here (it's filled in by the return from this
> function.  The argument should be q.

Whoops.  I cut and pasted the code from somewhere else and didn't notice 
that the variable needed to be changed.

> I'll make the changes and apply the patch.

Thank you.

Alan Stern

