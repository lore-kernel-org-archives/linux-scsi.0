From: Jens Axboe <axboe@suse.de>
Subject: Re: PATCH: (as141) Unaligned scatter-gather buffers and usb-storage
Date: Mon, 5 Jan 2004 11:08:24 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20040105100824.GC3079@suse.de>
References: <20031120191859.GA3569@kai.makisara.local> <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org> <20040105004158.GA30408@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20040105004158.GA30408@one-eyed-alien.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>, Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 04 2004, Matthew Dharm wrote:
> Is there any indication that the SCSI parts of this patch will get
> accepted?

I'm fine with the patch, FWIW, just move it to scsi_alloc_queue()
instead?

> > ===== scsi_scan.c 1.52 vs edited =====
> > --- 1.52/drivers/scsi/scsi_scan.c	Fri Oct 24 14:53:37 2003
> > +++ edited/drivers/scsi/scsi_scan.c	Fri Nov 21 12:34:00 2003
> > @@ -231,6 +231,15 @@
> >  	sdev->request_queue->queuedata = sdev;
> >  	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> >  
> > +	/*
> > +	 * Set the queue's mask to require a mere 8-byte alignment for
> > +	 * DMA buffers, rather than the default 512.  This shouldn't
> > +	 * inconvenience any user programs and should be okay for most
> > +	 * host adapters.  A host driver can alter this mask in its
> > +	 * slave_alloc() or slave_configure() callback if necessary.
> > +	 */
> > +	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));
> > +
> >  	if (shost->hostt->slave_alloc) {
> >  		if (shost->hostt->slave_alloc(sdev))
> >  			goto out_free_queue;

-- 
Jens Axboe



-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
