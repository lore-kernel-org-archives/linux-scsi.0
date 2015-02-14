From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 069/104] lib/string_helpers.c:string_get_size(): remove
 redundant prefixes
Date: Fri, 13 Feb 2015 20:03:40 -0800
Message-ID: <1423886620.10229.10.camel@HansenPartnership.com>
References: <54dd30d9.8sIvA5PVH18vSWTI%akpm@linux-foundation.org>
	 <1423783508.6286.25.camel@HansenPartnership.com>
	 <20150212154019.6c27b3301962c0650ee3a516@linux-foundation.org>
	 <1423784729.6286.32.camel@HansenPartnership.com>
	 <20150212155516.937d2df60ad00737096478b2@linux-foundation.org>
	 <1423872354.10229.7.camel@HansenPartnership.com>
	 <20150213170246.9c52ad2a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbbBNEDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 23:03:43 -0500
In-Reply-To: <20150213170246.9c52ad2a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux@rasmusvillemoes.dk, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2015-02-13 at 17:02 -0800, Andrew Morton wrote:
> On Fri, 13 Feb 2015 16:05:54 -0800 James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> 
> > @@ -42,31 +44,60 @@ void string_get_size(u64 size, const enum string_size_units units,
> >  		[STRING_UNITS_2] = 1024,
> >  	};
> >  	int i, j;
> > -	u32 remainder = 0, sf_cap;
> > +	u32 remainder = 0, sf_cap, exp;
> >  	char tmp[8];
> > +	const char *unit;
> >  
> >  	tmp[0] = '\0';
> >  	i = 0;
> > +	if (!size)
> > +	  goto out;
> 
> whitespace wart.

Yes, I'll run it through checkpatch before submitting.

> > +	if (blk_size >= divisor[units]) {
> > +		while (blk_size >= divisor[units]) {
> > +			remainder = do_div(blk_size, divisor[units]);
> > +			i++;
> > +		}
> > +	}
> 
> The `if' doesn't do anything.

Right ... I just copied from the original, but it's true we can unwrap
this.

> > +	exp = divisor[units];
> > +	do_div(exp, blk_size);
> > +	if (size >= exp) {
> > +		remainder = do_div(size, divisor[units]);
> > +		remainder *= blk_size;
> > +		i++;
> > +	} else {
> > +		remainder *= size;
> > +	}
> > +	size *= blk_size;
> > +	size += (remainder/divisor[units]);
> > +	remainder %= divisor[units];
> > +
> >  	if (size >= divisor[units]) {
> >  		while (size >= divisor[units]) {
> >  			remainder = do_div(size, divisor[units]);
> >  			i++;
> >  		}
> > +	}
> 
> Here too.

Certainly,

James



