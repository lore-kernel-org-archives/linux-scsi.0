From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 10:44:18 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311191033300.957-100000@ida.rowland.org>
References: <20031119084729.GA1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3588 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264119AbTKSPoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 10:44:18 -0500
In-Reply-To: <20031119084729.GA1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, 19 Nov 2003, Jens Axboe wrote:

> The queue already has such a restriction embedded, see bio_map_user()
> and queue_dma_alignment().

Searching through the 2.6 kernel source gave some interesting results.

queue_dma_alignment() does nothing but set the dma_alignment field of the
request queue structure.  The _only_ place this field is used is in
fs/bio.c by __bio_map_user(), called from bio_map_user().  In turn, the
_only_ place bio_map_user() is called is from drivers/block/scsi_ioctl.c,
and that's only for a certain specific type of SCSI ioctl.  It's not on
any main code path, and it wouldn't get invoked by anything using the st
or sg drivers.  In fact, it looks like scsi_ioctl.c:scsi_cmd_ioctl() is
only called from within the sd driver.

So something needs to be fixed up.  Is there some spot in the block layer 
that's supposed to be checking dma alignments but isn't doing so?

Alan Stern

