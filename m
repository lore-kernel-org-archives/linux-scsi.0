From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10810] New: Performance regression on DAC960
	and kernel 2.6.24+
Date: Wed, 28 May 2008 14:56:51 -0500
Message-ID: <1212004611.3445.70.camel@localhost.localdomain>
References: <bug-10810-10286@http.bugzilla.kernel.org/>
	 <20080528105810.3912c2a1.akpm@linux-foundation.org>
	 <1211999681.3445.67.camel@localhost.localdomain>
	 <20080528183725.GD25504@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41661 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbYE1T4z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 15:56:55 -0400
In-Reply-To: <20080528183725.GD25504@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, alex@nibbles.it, bugme-daemon@bugzilla.kernel.org, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-scsi@vger.kernel.org

On Wed, 2008-05-28 at 20:37 +0200, Jens Axboe wrote:
> On Wed, May 28 2008, James Bottomley wrote:
> > Well, the DAC960 is very old.  It has a trick we escaped from in SCSI
> > where if it gets an error in the request it resubmits it a sector at a
> > time.  It sounds very much like it's doing that for every request if the
> > I/O speed is down to a few k/s.
> > 
> > So, could you try this patch?  It won't fix anything, but if the message
> > spews all over the console, we know the 1 sector at a time retry is
> > causing the problems.  If not we'll try to think of something else ...
> 
> A bit unlikely, me thinks...

I can't really see any other way of getting such a massive slowdown ...
but give us your straws, we can grasp at them too ...

> Anyway, a blktrace dump of some IO would show what is going on. I'm
> assuming the problem is persistent across IO schedulers?

Yes, that might help.  If it's not the one sector chunk problem it would
have to be either some strange wait issue or massive retries.

James


