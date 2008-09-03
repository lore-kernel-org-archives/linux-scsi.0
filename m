From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
	the correct SI range
Date: Wed, 03 Sep 2008 09:32:34 -0500
Message-ID: <1220452354.3254.11.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	 <1220117091.3615.3.camel@localhost.localdomain>
	 <20080830174516.GD1239@parisc-linux.org>
	 <48B9B552.8060406@simon.arlott.org.uk>
	 <48B9B588.7060709@simon.arlott.org.uk>
	 <1220147947.3615.18.camel@localhost.localdomain>
	 <20080831025412.GJ1239@parisc-linux.org>
	 <1220195310.4021.4.camel@localhost.localdomain>
	 <1220195634.4021.9.camel@localhost.localdomain>
	 <20080902203914.4ddf3735.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53750 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbYICOci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 10:32:38 -0400
In-Reply-To: <20080902203914.4ddf3735.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-09-02 at 20:39 -0700, Andrew Morton wrote:
> On Sun, 31 Aug 2008 10:13:54 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This patch adds the ability to print sizes in either units of 10^3 (SI)
> > or 2^10 (Binary) units.  It rounds up to three significant figures and
> > can be used for either memory or storage capacities.
> > 
> > Oh, and I'm fully aware that 64 bits is only 16EiB ... the Zetta and
> > Yotta units are added for future proofing against the day we have 128
> > bit computers ...
> > 
> 
> As Matthew said - a new %p thingy might be appropriate.

Yes ... I thought about that.  Two things I don't like about the
approach are:

     1. It adds to the confetti of letters vsnprintf already accepts ...
        it's becoming like ls, and we're soon going to run out of
        alphabet
     2. I'd probably have to plumb in precision and things, which make
        the code a bit nastier.

I'm not sure the advantages (use in all our prints) outweighs this.

> > 
> > ---
> >  include/linux/string_helpers.h |   10 ++++++
> >  lib/Makefile                   |    3 +-
> >  lib/string_helpers.c           |   62 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 74 insertions(+), 1 deletions(-)
> >  create mode 100644 include/linux/string_helpers.h
> >  create mode 100644 lib/string_helpers.c
> > 
> > diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
> > new file mode 100644
> > index 0000000..6b827fb
> > --- /dev/null
> > +++ b/include/linux/string_helpers.h
> > @@ -0,0 +1,10 @@
> > +#include <linux/types.h>
> > +
> > +enum string_size_units {
> > +	STRING_UNITS_10,
> > +	STRING_UNITS_2,
> > +};
> 
> Could do with some comments.

Sure, will add.

> > +int string_get_size(u64 size, enum string_size_units units,
> > +		    char *buf, int len);
> > +
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 3b1f94b..44001af 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -19,7 +19,8 @@ lib-$(CONFIG_SMP) += cpumask.o
> >  lib-y	+= kobject.o kref.o klist.o
> >  
> >  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> > -	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
> > +	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> > +	 string_helpers.o
> >  
> >  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
> >  CFLAGS_kobject.o += -DDEBUG
> > diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> > new file mode 100644
> > index 0000000..3675eaa
> > --- /dev/null
> > +++ b/lib/string_helpers.c
> > @@ -0,0 +1,62 @@
> > +/*
> > + * Helpers for formatting and printing strings
> > + *
> > + * Copyright 31 August 2008 James Bottomley
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/math64.h>
> > +#include <linux/module.h>
> > +#include <linux/string_helpers.h>
> > +
> > +/**
> > + * string_get_size - get the size in the specified units
> > + * @size:	The size to be converted
> > + * @units:	units to use (powers of 1000 or 1024)
> > + * @buf:	buffer to format to
> > + * @len:	length of buffer
> > + *
> > + * This function returns a string formatted to 3 significant figures
> > + * giving the size in the required units.  Returns 0 on success or
> > + * error on failure.  @buf is always zero terminated.
> > + *
> > + */
> > +int string_get_size(u64 size, const enum string_size_units units,
> > +		    char *buf, int len)
> > +{
> > +	const char *units_10[] = { "B", "KB", "MB", "GB", "TB", "PB",
> > +				   "EB", "ZB", "YB", NULL};
> > +	const char *units_2[] = {"B", "Kib", "MiB", "GiB", "TiB", "PiB",
> > +				 "EiB", "ZiB", "YiB", NULL };
> > +	const char **units_str[] = {
> > +		[STRING_UNITS_10] =  units_10,
> > +		[STRING_UNITS_2] = units_2,
> > +	};
> > +	const int divisor[] = {
> > +		[STRING_UNITS_10] = 1000,
> > +		[STRING_UNITS_2] = 1024,
> > +	};
> 
> Formally these should be static, but I expect the compiler will work it out.

As long as I have everything correctly const'd, the optimisations
available should be similar, yes.

> 
> > +	int i,j;
> > +	u64 remainder = 0, sf_cap;
> > +	char tmp[8];
> > +
> > +	tmp[0] = '\0';
> > +
> > +	for (i = 0; size > divisor[units] && units_str[units][i]; i++)
> > +		remainder = do_div(size, divisor[units]);
> > +
> > +	sf_cap = size;
> > +	for (j = 0; sf_cap*10 < 1000; j++)
> > +		sf_cap *= 10;
> > +
> > +	if (j) {
> > +		remainder *= 1000;
> > +		do_div(remainder, divisor[units]);
> > +		snprintf(tmp, sizeof(tmp), ".%03lld", remainder);
> > +		tmp[j+1] = '\0';
> > +	}
> > +
> > +	snprintf(buf, len, "%lld%s%s", size, tmp, units_str[units][i]);
> 
> Can't print a u64 - we don't know what type it has.  It must be cast to
> something, usually unsigned long long.

I thought there was a patch from Matthew to move u64 to unsigned long
long on all architectures, thus obviating this annoying conversion ...
is that still wandering upstream, or has it been dropped?

> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(string_get_size);

James


