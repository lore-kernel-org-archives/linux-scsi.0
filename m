From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Tue, 6 Nov 2007 11:32:57 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711061129300.23219@localhost.localdomain>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
 <20071106153012.GG4113@parisc-linux.org> <Pine.LNX.4.64.0711061107480.21836@localhost.localdomain>
 <20071106162227.GH4113@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:51530 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXKFQeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 11:34:37 -0500
In-Reply-To: <20071106162227.GH4113@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 6 Nov 2007, Matthew Wilcox wrote:

> On Tue, Nov 06, 2007 at 11:09:51AM -0500, Robert P. J. Day wrote:
> > > >  		bits &= ~esp->scsi_id_mask;
> > > > -		if (!bits || (bits & (bits - 1)))
> > > > +		if (!is_power_of_2(bits))
> > > >  			goto do_reset;
> > >
> > > Non-equivalent transform.  Definitely a bug.
> >
> > ok, that one i'm curious about.  how is that not an equivalent
> > transform?  am i missing something painfully obvious?
>
> Apologies, I got my boolean algebra wrong.  It is equivalent:
>
> bool is_power_of_2(unsigned long n)
>         return (n != 0 && ((n & (n - 1)) == 0));
>
> substitute it in:
>
> 		if (!is_power_of_2(bits))
>
> 		if (!(bits != 0 && ((bits & (bits - 1)) == 0)))
>
> push the ! inside brackets:
>
> 		if (bits == 0 || ((bits & (bits - 1)) != 0))
>
> > > > -		if (!bits || (bits & (bits - 1)))
>
> Clearly the same thing.  Still ... I don't like it because we're not
> really looking for 'is this a power of two', we want to know 'is there
> exactly one bit set'.  Which, after a bit of thinking, is the same
> thing, but it's a bad name for this usage.  Perhaps we could add
>
> #define exactly_one_bit_set is_power_of_2
>
> to the header file.

as i recall, that was a point of early discussion and i don't see
anything terribly wrong with that.  i'll submit a patch for that
shortly and see what folks think.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
