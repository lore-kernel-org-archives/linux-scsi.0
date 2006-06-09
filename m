From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/3] aacraid: Fix return code interpretation
Date: Fri, 9 Jun 2006 13:10:54 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F028560BD@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:2008 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1030246AbWFIRK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 13:10:56 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Yes, that is the intent. A 32 bit application is calling a 64 bit
driver. The pointers in the 32 bit application merely need the virtual
address upper word zero'd to pass themselves off as 64 bit virtual
pointers. Yes, the clear_user call could be replaced with an =0 on the
last element, but it was more generic to clear it out completely before
copying in the subset. copy_[in|out]_user works with the constructed 64
bit virtual pointer.

Sincerely -- Mark Salyzyn


> -----Original Message-----
> From: Mark Haverkamp [mailto:markh@osdl.org] 
> Sent: Friday, June 09, 2006 12:22 PM
> To: Salyzyn, Mark
> Cc: Christoph Hellwig; James Bottomley; linux-scsi
> Subject: RE: [PATCH 1/3] aacraid: Fix return code interpretation
> 
> 
> On Fri, 2006-06-09 at 08:00 -0400, Salyzyn, Mark wrote:
> > Are you sure of this? The code that follows expects the end of the
> > structure to be cleared.
> 
> Could you clarify?  It looks like copy_in_user copies one u32 
> less than
> the structure size and leaves that last word uninitialized?  The last
> element of fib_ioctl (fib) is a char pointer though.
> 
> I can't see where f.fib is initialized in next_adapter_fib even though
> copy_to_user is called.  Even if clear_user is  called, doesn't that
> mean that f.fib in next_adapter_fib will be only partially NULL, 
> 
> Mark.
> 
> 
> > 
> > Sincerely -- Mark Salyzyn
> > 
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org] 
> > > Sent: Thursday, June 08, 2006 4:11 PM
> > > To: Mark Haverkamp
> > > Cc: James Bottomley; linux-scsi; Salyzyn, Mark
> > > Subject: Re: [PATCH 1/3] aacraid: Fix return code interpretation
> > > 
> > > 
> > > > @@ -564,7 +564,7 @@
> > > >  		
> > > >  		f = compat_alloc_user_space(sizeof(*f));
> > > >  		ret = 0;
> > > > -		if (clear_user(f, sizeof(*f)) != sizeof(*f))
> > > > +		if (clear_user(f, sizeof(*f)))
> > > >  			ret = -EFAULT;
> > > >  		if (copy_in_user(f, (void __user *)arg, 
> > > sizeof(struct fib_ioctl) - sizeof(u32)))
> > > >  			ret = -EFAULT;
> > > > 
> > > 
> > > just remove the clear_user call completely, it's not needed.
> > > 
> > > 
> > 
> -- 
> Mark Haverkamp <markh@osdl.org>
> 
> 
