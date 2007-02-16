From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Fri, 16 Feb 2007 12:23:34 -0600
Message-ID: <1171650214.3443.41.camel@mulgrave.il.steeleye.com>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
	 <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
	 <20070212122738.b5e9a8af.akpm@linux-foundation.org>
	 <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
	 <45D5F21B.2010804@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39672 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946188AbXBPSXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 13:23:43 -0500
In-Reply-To: <45D5F21B.2010804@student.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2007-02-16 at 19:04 +0100, Richard Knutsson wrote:
> James Bottomley wrote:
> > On Mon, 2007-02-12 at 12:27 -0800, Andrew Morton wrote:
> >   
> >> Given that we now have a standard kernel-wide, c99-friendly way of
> >> expressing true and false, I'd suggest that this decision can be revisited.
> >>
> >> Because a "true" is significantly more meaningful (and hence readable)
> >> thing than a bare "1".
> >>     
> >
> > OK, I'm really not happy with doing this for three reasons:
> >
> > 1. It's inviting huge amounts of driver churn changing bitfields to
> > booleans
> >   
> Have been some work done already. Has there been any problems?

There's always an issue when two people work on the same driver ... it
causes patch conflicts, which is why we try to avoid it where we can.

> > 2. I do find it to be a readability issue.  Like most driver writers,
> > I'm used to register layouts, and those are simple bitfields, so I don't
> > tend to think true and false, I think 1 and 0.
> >   
> It is a fundamental difference between an integer and a boolean. Have 
> you seen anyone trying to do "bool var = true + true;"? ;)

I don't quite see how this is relevant to the readability issue?

> > 3. Having a different, special, type for single bit bitfields (while
> > still using u<n> for multi bit bitfields) is asking for confusion, and
> > hence trouble at the driver level.
> >   
> I don't think a boolean should be view as a single bit bitfield. Ex:
> u8 a:1;
> ...
> int b = 4 + a;
> is obviously not a boolean, while:
> u8 a:1;
> ...
> if (a)
> is, and a should be "bool a:1;" (imho)

This again, doesn't really address the argument.  I'm saying I'd rather
not have confusion over what types to use in the driver.  You're saying
that if you only check the value for truth or falsehood it should be a
boolean.  That's actually worse than I was anticipating because you're
now saying that single bit bitfields may or may not be booleans
depending on use.  This looks like worse potential for confusion than
before.

James


