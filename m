From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: Tue, 6 Jan 2004 11:10:43 -0500 (EST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0401061100130.770-100000@ida.rowland.org>
References: <200401061228.08161.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <200401061228.08161.oliver@neukum.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jens Axboe <axboe@suse.de>, Kai =?iso-8859-15?q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 6 Jan 2004, Oliver Neukum wrote:

> > +	/* Scatter-gather buffers (all but the last) must have a length
> > +	 * divisible by the bulk maxpacket size.  Otherwise a data packet
> > +	 * would end up being short, causing a premature end to the data
> > +	 * transfer.  Since high-speed bulk pipes have a maxpacket size
> > +	 * of 512, we'll use that as the scsi device queue's DMA alignment
> > +	 * mask.  Guaranteeing proper alignment of the first buffer will
> > +	 * have the desired effect because, except at the beginning and
> > +	 * the end, scatter-gather buffers follow page boundaries. */
> > +	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
> 
> What about the cacheline of the last buffer? It seems to me that we have
> to worry about DMA coherency.

We don't have to worry about that, at least not here in the low-level
driver.  These buffers are passed from user processes.  Suppose a process
wants to write an amount that's smaller than a cacheline.  But that small
amount might be stored in part of a buffer that does end on a cacheline
boundary -- there's no way for the driver to know.  Ultimately the user
process must be responsible for insuring that DMA coherency is maintained.

Alan Stern



-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
