From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [1/22] Add new sense_buffer_mask host template field
Date: Mon, 25 Feb 2008 16:01:22 +0100
Message-ID: <20080225150122.GC16158@one.firstfloor.org>
References: <200802251235.889863872@firstfloor.org> <20080224233513.F083B1B4183@basil.firstfloor.org> <1203950908.3254.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:46731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYBYPAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 10:00:47 -0500
Content-Disposition: inline
In-Reply-To: <1203950908.3254.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Mon, Feb 25, 2008 at 06:48:28AM -0800, James Bottomley wrote:
> On Mon, 2008-02-25 at 00:35 +0100, Andi Kleen wrote:
> > sense buffers are something that still needs to be explicitely 
> > bounced in the scsi layer. Instead of using the global unchecked_isa_dma
> > flag define a special fine grained mask for this.
> > 
> > I decided to use a full dma mask because that is most useful for some future
> > infrastructure work I'm doing.
> 
> Why do we need a separate mask?  Why can't we just use the device
> dma_mask?

First a lot of drivers don't need it because they handle the sense
buffers without DMA. So if we just used a device mask we would either
do unnecessary work for those or require a special sense buffer
mask in the device (which wouldn't belong into the device layer) 

Then there isn't really a device anywhere in these drivers and I didn't
plan to rewrite them to add one. 

So just having a SCSI specific sense buffer mask seemed best. It is
only set when a ISA driver actually does sense buffer DMA, which
is only true in a handful of drivers.

-Andi
