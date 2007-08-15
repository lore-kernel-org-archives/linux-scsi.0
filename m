From: David Miller <davem@davemloft.net>
Subject: Re: An MCA ESP driver
Date: Wed, 15 Aug 2007 14:55:51 -0700 (PDT)
Message-ID: <20070815.145551.78731552.davem@davemloft.net>
References: <20070806232458.GC9732@parisc-linux.org>
	<20070807.002604.78735512.davem@davemloft.net>
	<20070815172600.GF16277@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54237
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbXHOVzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 17:55:53 -0400
In-Reply-To: <20070815172600.GF16277@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Wed, 15 Aug 2007 11:26:00 -0600

> On Tue, Aug 07, 2007 at 12:26:04AM -0700, David Miller wrote:
> > > -	struct sbus_dma		*dma;
> > > +	union {
> > > +		struct sbus_dma	*sbus_dma;
> > > +		unsigned int	x86_dma;
> > > +	};
> > >  };
> > 
> > Feel free to make this a "void *dma_cookie" or similar.
> > It's private to the bus front-end.
> 
> Hi Dave,
> 
> Could I just clarify; would you prefer it to be a void *?  I prefer the
> anonymous union that I have there right now, but I'm not particularly
> attached to it.  In particular, I don't really care to be casting ints
> (x86) to pointers, but that's a matter of personal taste.

Alternatively, you could remove this member entirely, and
make the front-end driver allocate a private area at the
end of "struct esp" to use for whatever purpose it likes.

I'm mostly ambivalent, but if the member stays it should be
some generic type rather than anything front-end specific
like it is now.
