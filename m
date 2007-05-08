From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Tue, 08 May 2007 10:11:00 -0500
Message-ID: <1178637060.3737.15.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	 <1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	 <20070507140656.3debfb55.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52896 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933977AbXEHPLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 11:11:06 -0400
In-Reply-To: <20070507140656.3debfb55.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Mon, 2007-05-07 at 14:06 -0700, Andrew Morton wrote:
> On Mon, 07 May 2007 14:50:19 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> > > From: Richard Knutsson <ricknu-0@student.ltu.se>
> > > 
> > > Convert:
> > > FALSE -> false
> > > TRUE  -> true
> > 
> > NAK'd by maintainer.
> > 
> 
> I went back and reviewed the previous discussion.  Maintaner's reasons for
> NAKing were, and remain wholly specious.

Well, I agree with them.  There are three primary reasons for this

     1. In C logical values are arithmetic types by design.  Trying to
        backfill C++ ideas of separation of logical and arithmetic types
        is asking for bugs.
     2. If people have to use boolean values (which I don't like; I
        prefer simple assignment and checking), I prefer the upper case
        values because, effectively, they're simple arithmetical
        constants.
     3. it's going to generate a huge amount of churn in all the
        subsystems and drivers for no appreciable benefit.  Unless
        someone can actually articulate one?  (Other than "because it's
        there").

The patch in question basically just downcased the TRUE/FALSE in the
driver, which makes it less readable (mainly because I really don't like
the way it uses truth values, but that's a maintainer's prerogative, and
I recognise the upper case values as warning me to be careful).

> That being said, the patch is moderately wrong (or at least incomplete)
> because it does things like:
> 
> -            unsigned char done = FALSE;
> +            unsigned char done = false;
> 
> whereas it should have done
> 
> -            unsigned char done = FALSE;
> +            bool done = false;

And the value to the driver of this transformation?

James


