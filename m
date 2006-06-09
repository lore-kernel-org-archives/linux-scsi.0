From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 1/3] aacraid: Fix return code interpretation
Date: Fri, 09 Jun 2006 09:22:09 -0700
Message-ID: <1149870129.8498.12.camel@markh3.pdx.osdl.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02855F6F@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22229 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030273AbWFIQWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 12:22:15 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F02855F6F@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-06-09 at 08:00 -0400, Salyzyn, Mark wrote:
> Are you sure of this? The code that follows expects the end of the
> structure to be cleared.

Could you clarify?  It looks like copy_in_user copies one u32 less than
the structure size and leaves that last word uninitialized?  The last
element of fib_ioctl (fib) is a char pointer though.

I can't see where f.fib is initialized in next_adapter_fib even though
copy_to_user is called.  Even if clear_user is  called, doesn't that
mean that f.fib in next_adapter_fib will be only partially NULL, 

Mark.


> 
> Sincerely -- Mark Salyzyn
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org] 
> > Sent: Thursday, June 08, 2006 4:11 PM
> > To: Mark Haverkamp
> > Cc: James Bottomley; linux-scsi; Salyzyn, Mark
> > Subject: Re: [PATCH 1/3] aacraid: Fix return code interpretation
> > 
> > 
> > > @@ -564,7 +564,7 @@
> > >  		
> > >  		f = compat_alloc_user_space(sizeof(*f));
> > >  		ret = 0;
> > > -		if (clear_user(f, sizeof(*f)) != sizeof(*f))
> > > +		if (clear_user(f, sizeof(*f)))
> > >  			ret = -EFAULT;
> > >  		if (copy_in_user(f, (void __user *)arg, 
> > sizeof(struct fib_ioctl) - sizeof(u32)))
> > >  			ret = -EFAULT;
> > > 
> > 
> > just remove the clear_user call completely, it's not needed.
> > 
> > 
> 
-- 
Mark Haverkamp <markh@osdl.org>

