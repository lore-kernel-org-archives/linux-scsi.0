From: Greg KH <greg@kroah.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Wed, 2 Apr 2008 07:53:55 -0700
Message-ID: <20080402145355.GB29318@kroah.com>
References: <1206203957.4393.16.camel@localhost.localdomain> <20080402063232.GD8158@kroah.com> <1207145753.3082.7.camel@localhost.localdomain> <20080402143040.GU16451@parisc-linux.org> <1207146776.3082.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYDBOys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 10:54:48 -0400
Content-Disposition: inline
In-Reply-To: <1207146776.3082.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Apr 02, 2008 at 09:32:55AM -0500, James Bottomley wrote:
> On Wed, 2008-04-02 at 08:30 -0600, Matthew Wilcox wrote:
> > On Wed, Apr 02, 2008 at 09:15:53AM -0500, James Bottomley wrote:
> > > On Tue, 2008-04-01 at 23:32 -0700, Greg KH wrote:
> > > > BUG_ON() should not do anything in the macro except test for a value, no
> > > > function calling.  I think checkpatch.pl checks for this...
> > > 
> > > Well, we can agree to differ on this.  The camp that wants no side
> > > effects for BUG_ON() does so in case they want to define it to be a nop.
> > 
> > That's one argument, but to me, the most important thing is that reading
> > the content of BUG_ON is unnecessary for understanding the function.
> > 
> > > OK ... your subsystem tree your call, I suppose.  How about the
> > > attached.
> > 
> > > -static inline int transport_container_unregister(struct transport_container *tc)
> > > +static inline void transport_container_unregister(struct transport_container *tc)
> > >  {
> > > -	return attribute_container_unregister(&tc->ac);
> > > +	int err = attribute_container_unregister(&tc->ac);
> > > +	BUG_ON(err);
> > >  }
> > 
> > What's wrong with:
> > 
> > 	if (attribute_container_unregister(&tc->ac))
> > 		BUG();
> 
> You've lost the unlikely designation which is one of the main reasons
> for using BUG_ON().  Most people who write in this form also forget it
> leading to a heap of suboptimal jump prediction code in the kernel and
> another reason not to encourage it.

Most people who think that they need "unlikely" are also usually wrong
:)

This is on a register/unregister path, nothing "fast" about it at all,
so please don't be worrying about "unlikely" for stuff like this.

I prefer the form mentioned by Matthew above please.

thanks,

greg k-h
