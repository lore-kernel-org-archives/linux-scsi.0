From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] sg: fix integer overflow
Date: Fri, 24 Jan 2014 12:04:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401241158060.16419@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401241131380.12824@file01.intranet.prod.int.rdu2.redhat.com> <1390582587.2275.22.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaAXREi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 12:04:38 -0500
In-Reply-To: <1390582587.2275.22.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org



On Fri, 24 Jan 2014, James Bottomley wrote:

> On Fri, 2014-01-24 at 11:34 -0500, Mikulas Patocka wrote:
> > On alpha, USER_HZ may be higher than HZ. This results in integer overflow
> > in MULDIV.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >  drivers/scsi/sg.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-3.13/drivers/scsi/sg.c
> > ===================================================================
> > --- linux-3.13.orig/drivers/scsi/sg.c	2014-01-20 21:44:02.000000000 +0100
> > +++ linux-3.13/drivers/scsi/sg.c	2014-01-24 17:28:02.000000000 +0100
> > @@ -856,8 +856,10 @@ sg_ioctl(struct file *filp, unsigned int
> >  			return result;
> >  		if (val < 0)
> >  			return -EIO;
> > +#if USER_HZ < HZ
> >  		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
> >  		    val = MULDIV (INT_MAX, USER_HZ, HZ);
> > +#endif
> 
> Is this really a problem worth fixing?  Is USER_HZ ever greater than HZ?

Yes. The integer overflow results in unpredictable value and the timeout 
is limited to that value.

> >  		sfp->timeout_user = val;
> 
> If it can happen, this needs fixing as well:
> 
> >  		sfp->timeout = MULDIV (val, HZ, USER_HZ);

This line is correct. Note, that here the arguments HZ and USER_HZ are 
swapped. Here, you divide val by USER_HZ and multiply it by HZ, so there 
is no oveflow if USER_HZ > HZ. There could be overflow if USER_HZ < HZ, 
but the above "if" condition avoids that.

> any val that would divide to less than 1 will now set the timeout to
> zero, which will cause the queue default timeout to be applied instead.
> 
> I'd fix it in the macro rather than having code peppered with #ifs

You can't easily fix it in the macro: "MULDIV (INT_MAX, USER_HZ, HZ)" is 
undefined value if USER_HZ > HZ, it is not specified what the macro should 
return in this case.

> James

Mikulas
