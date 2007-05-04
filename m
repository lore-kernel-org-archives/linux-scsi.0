From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] SCSI: Remove redundant GFP_KERNEL type flag in kmalloc().
Date: Fri, 4 May 2007 18:38:37 +0530
Message-ID: <a781481a0705040608l45aeb106nc75365689dc51ec9@mail.gmail.com>
References: <Pine.LNX.4.64.0704300434460.3703@localhost.localdomain>
	 <20070504011535.ff7181fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:37494 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbXEDNIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2007 09:08:40 -0400
Received: by ug-out-1314.google.com with SMTP id 44so643972uga
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2007 06:08:38 -0700 (PDT)
In-Reply-To: <20070504011535.ff7181fb.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 5/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> [...]
> >
> > -  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > +  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC);
>
> No, this converts the allocation from a robust one which can sleep into a
> flakey one which cannot.
>
> If we want to just clean this code up, we should switch to
>
>         GFP_KERNEL|__GFP_HIGH
>
> and add a comment explaining why we're turning on __GFP_HIGH (pointlessly,
> I suspect).
>
> However I suspect what the code really meant to do was to use just
> GFP_KERNEL.

Yes.

A recap from http://lkml.org/lkml/2007/4/28/160 ...

> > So combining GFP_ATOMIC with GFP_KERNEL gives you
> > "allow io, allow fs, allow waiting, and use emergency pools when it's
> > getting tight" which to me looks like a valid, but probably unwanted
> > combination.

and:

> As a matter of style, the author there could've written (GFP_KERNEL |
> __GFP_HIGH) instead, but I'm not sure how much sense that makes
> because once we specify GFP_KERNEL, we essentially bring out the heavy
> weaponry to *make* some free space for ourselves if it isn't there
> already (and we're prepared to sleep when all that happens) -- so
> where's the need left to scavenge into emergency pools anymore?
> __GFP_HIGH only makes sense for poor atomic contexts for whom sleeping
> (when we try_to_free other pages to satisfy our allocation request) is
> not an option, which is precisely how things are presently.
>
> [...]
> 1. If you're in_atomic() context, that GFP_KERNEL is a BUG and *must*
> be removed.
>
> 2. If not, that GFP_ATOMIC is redundant / nonsensical and *can* be removed.

It _was_ established towards the end of that thread that neither of the two
cases are atomic contexts. And it would still make sense to remove the redundant
__GFP_HIGH, as we don't want to unnecessarily deplete the emergency
reserve pool for normal GFP_KERNEL cases thus making ENOMEM on some future
kmalloc(GFP_ATOMIC) more likely. I'll send out the patches.
