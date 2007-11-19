From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 06:54:28 +1100
Message-ID: <1195502068.6970.3.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119123240.GA12494@parisc-linux.org>
	 <1195484964.3283.4.camel@localhost.localdomain>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:59791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXKSTyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 14:54:41 -0500
In-Reply-To: <1195484964.3283.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>


On Mon, 2007-11-19 at 09:09 -0600, James Bottomley wrote:
> > What other drivers do is DMA to their own allocation and then memcpy to
> > the sense buffer.
> > 
> > There is a movement to allocate the sense data as its own sg list, but
> > I don't think that patch has even been posted yet.
> 
> I'd like to be rid of it inside the command for various reasons:  every
> command has one of these, and they're expensive in the allocation (at 96
> bytes).  There's no reason we have to allocate and free that amount of
> space with every command.  In theory, the number of these is bounded at
> the queue depth, in practice, there's usually only one, and this DMA
> alignment issue does requires most drivers to double copy.

And most drivers don't and break. Take USB storage, I -think- (code path
aren't trivial to follow) it just gets the sglist cooked up by the code
in scsi_error.c no ? That just points to the buffer in scsi_cmnd. It
then pass that for DMA to the USB stack.

Ben.


