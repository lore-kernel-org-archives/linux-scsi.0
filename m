From: Oliver Neukum <oliver@neukum.org>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: Tue, 6 Jan 2004 12:28:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401061228.08161.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0401051657020.604-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:51635 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S261965AbUAFL17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 06:27:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401051657020.604-100000@ida.rowland.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@suse.de>
Cc: Kai =?iso-8859-15?q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

 
>  static int slave_configure (struct scsi_device *sdev)
>  {
> +	/* Scatter-gather buffers (all but the last) must have a length
> +	 * divisible by the bulk maxpacket size.  Otherwise a data packet
> +	 * would end up being short, causing a premature end to the data
> +	 * transfer.  Since high-speed bulk pipes have a maxpacket size
> +	 * of 512, we'll use that as the scsi device queue's DMA alignment
> +	 * mask.  Guaranteeing proper alignment of the first buffer will
> +	 * have the desired effect because, except at the beginning and
> +	 * the end, scatter-gather buffers follow page boundaries. */
> +	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));

What about the cacheline of the last buffer? It seems to me that we have
to worry about DMA coherency.

	Regards
		Oliver

