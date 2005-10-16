From: Andrew Morton <akpm@osdl.org>
Subject: Re: ips.c warnings
Date: Sun, 16 Oct 2005 16:24:20 -0700
Message-ID: <20051016162420.16ac1851.akpm@osdl.org>
References: <20051016140817.4de1cc19.akpm@osdl.org>
	<1129502688.9388.1.camel@mulgrave>
	<20051016155715.3edda40d.akpm@osdl.org>
	<1129504267.9388.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:45225 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750961AbVJPXY4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 19:24:56 -0400
In-Reply-To: <1129504267.9388.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, ipslinux@adaptec.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Sun, 2005-10-16 at 15:57 -0700, Andrew Morton wrote:
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > >  That's weird ... the compiler can't possibly be in a position to make
> > >  that judgement call.  We have lots of places where we return null if
> > >  something goes wrong and the kernel oopses.  The compiler certainly
> > >  isn't warning about all of them.
> > 
> > Well I guess the difference is that the compiler can _see_ that
> > IPS_SG_ADDRESS() might return NULL:
> > 
> > #define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
> >                                   page_address((sg)->page)+(sg)->offset : NULL)
> > 
> > What's the point in this expression anyway?  Why not just assume that
> > page_address() returns non-NULL?
> 
> Actually, what it should be doing is a kmap/kunmap on page instead of
> assuming the page has an address ...  hopefully the IPS people can fix
> it.
> 

(cc's the IPS people)
