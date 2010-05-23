From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 14/27] drivers/scsi: Use memdup_user
Date: Sun, 23 May 2010 11:22:32 -0500
Message-ID: <1274631752.5894.24.camel@mulgrave.site>
References: <Pine.LNX.4.64.1005221022180.13021@ask.diku.dk>
	 <1274538263.4410.38.camel@mulgrave.site>  <4BF94B89.2050101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49450 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0EWQWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2010 12:22:39 -0400
In-Reply-To: <4BF94B89.2050101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Julia Lawall <julia@diku.dk>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sun, 2010-05-23 at 18:36 +0300, Boaz Harrosh wrote:
> > This type of transformation has really no value at all.  The code you're
> > proposing to replace is already correct.  I'm fairly ambivalent on
> > patterned APIs anyway but I accept they're useful way to prevent new
> > code getting it wrong. However, it's completely bogus to force
> > replacement of correctly functioning code throughout the kernel (unless
> > you're going to argue that everyone who tries to copy from user into a
> > kmalloc space does a cut and paste from sg?)
> > 
> > Of infinitely greater service would be finding any places where the
> > pattern is being incorrectly used.
> > 
> 
> It looks like it is not done 100% kosher and calling memdup_user should
> be better.
> 
> - For 1 memdup_user does a GFP_KERNEL with a comment on how copy_from_user
>   would eventually sleep, so what's the point of GFP_ATOMIC?

Well, since you've written a storage driver, I really hope that question
is rhetorical ...

The reason for using GFP_ATOMIC from user context in storage drivers is
to avoid writeout deadlock:  you don't want to trigger a swap write
while you potentially occupy the writeout path.  In all older drivers
this had to be GFP_ATOMIC because GFP_NOIO wasn't around.

This also illustrates the problem with design patterns:  The idea that
if you have user context, you must be able to kmalloc GFP_KERNEL seems
logical to the people who wrote the pattern, but actually it's
potentially incorrect for storage.

Now in the particular case of sg, I don't believe we'll ever want to
swap over sg (famous last words, of course), so in this instance we
probably could get away with using GFP_KERNEL ... but since it's
following the storage pattern, GFP_ATOMIC (or GFP_NOIO) is correct.

Does osd need auditing for this problem (or would no-one ever do swap
over osd)?

> If this is by design then it surly calls for a comment that explains.
> (I would like to know)

This pattern occurs many times in storage ... documenting it at every
callsite would be a huge waste.

James


