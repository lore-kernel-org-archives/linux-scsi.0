From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 09:09:24 -0600
Message-ID: <1195484964.3283.4.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119123240.GA12494@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:48603 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbXKSPJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 10:09:30 -0500
In-Reply-To: <20071119123240.GA12494@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>


On Mon, 2007-11-19 at 05:32 -0700, Matthew Wilcox wrote:
> On Mon, Nov 19, 2007 at 04:35:23PM +1100, Benjamin Herrenschmidt wrote:
> > The other one I'm hitting now is that the SCSI layer nowadays embeds the
> 
> 'nowadays'?  It has always been so.
> 
> > sense_buffer inside the scsi_cmnd structure without any kind of
> > alignment whatsoever. I've been hitting irregulary is a crash on SCSI command
> > completion that seems to be related to corruption of the "request"
> > pointer in struct scsi_cmnd and I think it might be the cause.
> > I'm now trying to setup a proper repro-case.
> 
> What other drivers do is DMA to their own allocation and then memcpy to
> the sense buffer.
> 
> There is a movement to allocate the sense data as its own sg list, but
> I don't think that patch has even been posted yet.

I'd like to be rid of it inside the command for various reasons:  every
command has one of these, and they're expensive in the allocation (at 96
bytes).  There's no reason we have to allocate and free that amount of
space with every command.  In theory, the number of these is bounded at
the queue depth, in practice, there's usually only one, and this DMA
alignment issue does requires most drivers to double copy.

James


