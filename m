From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Transport Attributes Export API
Date: 04 Jan 2004 09:44:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073231073.2069.8.camel@mulgrave>
References: <20031231190849.GE3066@localhost>
	<20040102211848.A1894@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34494 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265699AbUADPom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2004 10:44:42 -0500
In-Reply-To: <20040102211848.A1894@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Martin Hicks <mort@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-01-02 at 15:18, Christoph Hellwig wrote:
> You could get rid of most code in the drivers by placing a pointer
> to the transport attributes and the desired transport class into
> the host template and letting the common code do all setup for you.

Yes, that's what I was thinking: just make the transport class an object
that embeds the device class.  it could then contain the useful
parameters (which drivers would use directly).  We could then use a
transport specific API for updating their values (which the driver could
choose to implement, but the attribute would be exported ro if it
didn't).

> That's also consistant to how we handle all the other attributes.
> 
> > - Separate the transports out into two separate .c files
> 
> probably a good idea.
> 
> > (so they can be loaded as modules).
> 
> for the sysfs code alone that's total overkill.

But if the the error handler (and domain validation for SPI) are bound
up in here, it won't be...when someone offers to do work for you you
don't say no.

> > This also plays in to future work I'm thinking
> > about: make the error handler more transport specific.
> 
> Yupp, that's a good idea, but not really much related to this patch.
> 
> > - Then, the class register/unregister can be done in the
> > module_init/exit routines
> > - Probably move all the show/store routines in .h files so they can be
> > used equally for fc and parallel
> > - This switch on ttype (and the enum transport_type) in
> 
> > scsi_add_transport_attributes is not scaleable.  I think a better
> > solution might be to have a struct scsi_transport which has the class
> > device and a pointer to the overridden attribute.  Then, this is the
> > thing pointed to in the scsi host structure (and it can contain the
> > attributes, the class and a pointer to the default attributes, so most
> > of the trying to find the defaults code goes away).
> 
> Or no extra structure and put the two pointers directly in the host
> template as I suggested above.  Yes, that means drivers that support
> multiple transports need a template for each of them, but that's not
> a big overhead anyway.

Actually, I think we really only need one set of overrideable
attributes, which we have in the sdev class.  All the other classes we
add (for transport or anything else) should be API driven---that is,
after all, the job of a class: to embody an interface, so I think the
transport classes will only ever have a fixed set of attributes.

Of course, the mechanism will exist to allow arbitrary transport classes
to be registered for drivers that wish to create them...

James


