From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 06:53:04 +1100
Message-ID: <1195501984.6970.1.camel@pasglop>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119123240.GA12494@parisc-linux.org>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:59778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXKSTxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 14:53:18 -0500
In-Reply-To: <20071119123240.GA12494@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>


On Mon, 2007-11-19 at 05:32 -0700, Matthew Wilcox wrote:
> On Mon, Nov 19, 2007 at 04:35:23PM +1100, Benjamin Herrenschmidt wrote:
> > The other one I'm hitting now is that the SCSI layer nowadays embeds the
> 
> 'nowadays'?  It has always been so.

Wasn't it kmalloc'ed at one point ?

> > sense_buffer inside the scsi_cmnd structure without any kind of
> > alignment whatsoever. I've been hitting irregulary is a crash on SCSI command
> > completion that seems to be related to corruption of the "request"
> > pointer in struct scsi_cmnd and I think it might be the cause.
> > I'm now trying to setup a proper repro-case.
> 
> What other drivers do is DMA to their own allocation and then memcpy to
> the sense buffer.

What "other drivers" ? Those architectures use the same drivers as
everything else.

> There is a movement to allocate the sense data as its own sg list, but
> I don't think that patch has even been posted yet.

I've seen code creating an sglist from the scsi_cmnd->sense_buffer and
passing that to drivers. That breaks.

Ben.

