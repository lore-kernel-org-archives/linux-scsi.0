From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] scsi: Fix bad use of udelay in atp870u.c
Date: Fri, 17 Oct 2008 07:48:42 +0200
Message-ID: <20081017054842.GG25834@deprecation.cyrius.com>
References: <20081016082146.GA18535@deprecation.cyrius.com> <20081016155135.8fc411ae.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:1648 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYJQFs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 01:48:56 -0400
Content-Disposition: inline
In-Reply-To: <20081016155135.8fc411ae.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@HansenPartnership.com, linux-arm-kernel@lists.arm.linux.org.uk

* Andrew Morton <akpm@linux-foundation.org> [2008-10-16 15:51]:
> > +	mdelay(2);
> > +	udelay(48);
> >  	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
> >  		outw(0, tmport--);
> >  		outb(0, tmport);
> > 
> 
> hum.  The code has been like that for many years - why was the
> error only discovered now.  Is that check in arm new?

I don't think so.  I cannot remember for sure, but I probably ran into
it when we started moving the Debian ARM kernels from a config file
that only selected a limited number of modules to a more generic
config file that enables as much as possible.  I don't think anyone
cares about this one driver in particular, but it's hard to know which
modules users need, so we enable everything we can.

Anyway, we've carried a patch around since December 2007 that disables
this module on ARM because of this compilation error, but I'd like to
get this resolved in the mainline kernel.

> If so, was it present in 2.6.27?
>   If so, does anyone actually use this driver on arm?
>     If so, we'll need this patch in 2.6.27.x as well.

Nah, fixing it for 2.6.28 would be fine.
-- 
Martin Michlmayr
http://www.cyrius.com/
