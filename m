From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 07 Nov 2003 11:11:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068228695.3417.34.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <20031107095145.A3785@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:49599 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264532AbTKGSME
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 13:12:04 -0500
In-Reply-To: <20031107095145.A3785@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Patrick M:

>

Hi!  Immediate attention!  Wow.  Thank you.

> Do you have a tar ball or such of all the code?
> Or is this still very much a work in progress?

Yes release early release often.

> I don't see all the functions in the patch, for example, gcs_in.

That patch just gives you enough to compile & link & run the verbose,
spinq.c, and to compile without linking the alternative, concise,
inq.c.  I don't mean to be coy, I'm just trying not to overwhelm the
list, I've thought about this problem in isolation for nearly a decade
without before now finding anyone else on Earth who cared.

> I was going to say put the functions in a library, but maybe you already
> are headed that way. Then create a libsgio or such, and users like
> sg_utils, scsi_id, cdrecord, scsidev, etc. could link with sgio.

Aye.  Yes I did try this already.  Most recent demo might be the
lscsi.so of the gccscsi tar ball on the web.  There I called the .so
library from gforth, which more directly offers dynamic link than static
link, again I built both Linux & Win XP/2K.

> And lose the macros I, Y, etc, just use the function name, or at least
> have more meaningful macro names.

I'm trying to distinguish two kinds of test code.

In spinq.c we see the meaningful subroutine names we like already - yes?

I'm not sure you agree we want to write any other kind of code?

In inq.c we see cryptic macro names.  Those cryptic names correspond
directly to the -a thru -z options of a "nice" tool like plscsi or
camcontrol or my now proposed sg_io.

For example, if our command line is -i x24 -y "12 00:00:00 24 00" then
our C code is { I(0x24); Y("12 00:00:00 24 00"); }.  When you learn the
one cryptic syntax, you learn the other cryptic syntax, modulo some
transliteration.

I'm thinking if we like a cryptic command line, then so too we like
cryptic C code.  We write inq.c, not just spinq.c, depending on our
audience.

I'm in two minds over the name sg_io.  I'm guessing that's the name that
the sg utils audience will want, but I'm confident that name won't mean
anything on the other operating systems and having to find how to type _
will annoy people.

I figure for those other folk we will offer a gcs command line, and let
people ignore the fact that a gcs command line and an sg_io command line
accomplish the same thing with the same syntax.

Or maybe we'd rather say gcs always.  But if the cost of getting gcs
into sg utils is to say sg_io for Linux only, then I figure we pay that
cost.

> The command line plscsi could support both long and short names (-i or
> --gcs-in).

Ouch, sorry, yes I left that part of the patch out, I find I have to
sneaker net it here, please stay tuned.

Pat LaVarre


