From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ufs-pltfrm: initialize DMA mask for device-tree
	probed device
Date: Tue, 20 Aug 2013 21:54:26 +0100
Message-ID: <20130820205426.GD17845@n2100.arm.linux.org.uk>
References: <1376920566-20325-1-git-send-email-mita@fixstars.com> <1376922720.2069.10.camel@dabdike.int.hansenpartnership.com> <52131A1D.2060907@codeaurora.org> <ed58bd5b910baee6aa4c53752a45ecbc.squirrel@webmail.fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42131 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3HTUyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 16:54:44 -0400
Content-Disposition: inline
In-Reply-To: <ed58bd5b910baee6aa4c53752a45ecbc.squirrel@webmail.fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, devicetree@vger.kernel.org

On Wed, Aug 21, 2013 at 12:03:50AM +0900, Akinobu Mita wrote:
> The discussion in that thread is useful.  Also, I found that Russell King
> proposed replacing the boilerplate by using dma_coerce_mask_and_coherent()
> in his patch set "Preview of DMA mask changes".
> https://patchwork.kernel.org/patch/2837359/

That is an attempt to pull all that stuff into one central place so we
don't have loads of drivers dealing with it in their own way.

As far as I can gather from those who deal with DT, such as Arnd, is that
they believe it to be wrong that the DT code sets up the DMA masks, and
they think that stuff will break if the DT code does set these pointers
up.

The big problem which we have is we have a whole bunch of drivers which
don't bother at all with the DMA set mask functions (because they've been
fiddling with the mask directly) and sorting that mess out is going to be
pretty damn difficult.

So, the above series is all about bringing stuff to a central place where
we can then start thinking about changing the behaviour and not have to
patch lots of drivers throughout the tree for every change that's made.

The way I envision the change happening is this:

1. Introduce the notion of mask coercion (drivers forcing the mask to a
   particular value.)

2. Add dma_set_mask() and similar functions to these drivers incrementally.

3. Move the initialization of the mask up to the device creation level
   (iow, the DT code) and out of the drivers (this can be done by
   adding it to the DT code, and removing it from the mask coercion code.)

4. Remove dma_coerce_mask_and_coherent() from the kernel once complete.

So, why bother with dma_coerce_mask_and_coherent()?  Not only does it
centralise the "hack" but it also provides a means to identify drivers
which need work and/or have been missed (you just have to grep for the
direct assignments to the DMA masks.)  Not only that but once the hack
is centralised, it removes some of the variability in the drivers, and
provides a step where we can allow things to be tested hopefully without
causing any regressions.

At least that's the theory.
