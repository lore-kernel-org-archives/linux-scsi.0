From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 03:24:59 +0200
Message-ID: <200904140324.59657.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <200904132340.21525.bzolnier@gmail.com> <49E3BBB9.4040100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59181 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZDNBWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2009 21:22:21 -0400
Received: by bwz17 with SMTP id 17so2220026bwz.37
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2009 18:22:18 -0700 (PDT)
In-Reply-To: <49E3BBB9.4040100@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday 14 April 2009 00:24:57 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > I've started reading it and immediately noticed a thing which made by day. :-)
> > 
> > Sorry if it will sound off-topic or undiplomatic but it is the best occasion
> > to straighten up some facts:
> > 
> >  "Discussion then moved on to the current status of getting libata out of
> >   SCSI: we have had several successes, notably timer handling and pieces of
> >   error handling have moved up to block. Unfortunately, the current progress
> >   has reached the point where it's being impeded by the legacy IDE subsystem
> > 
> > Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
> > 
> > I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).

It was you!? :)

> > The thing is that during last _five_ years almost nothing was done in this
> > direction.  Despite the fact that it was #1 condition under which the whole
> > code has been merged.  Sorry to say it but it seems like the whole merge
> > strategy was to over-promise things now and worry about delivery later.
> 
> Yet, shockingly, users have been happily using libata despite all these 
> horrors.

That was not the issue raised:

If you think that you can take a "I will deliver later" credit from the
developers community and later cover it up by "this is still my goal, I
just need to find some suckers to do it for me" and think that you won by
fooling people you're sadly mistaken and will most likely have a reality
check one day (not from me, I really don't care that much to waste my
precious time on proving you wrong).

Having corporate backing will save you only to some point, I would suggest
you to look at the current situation in area quite close to our area where
we have another project manager doing heavy mumbo-jumbo on a three years
behind the schedule, untested and already technically obsolete project.

> > To make things worse all the "successes" quoted above are nothing else
> > like back-ridding on block layer and SCSI improvements which were done by
> > non-libata developers.
> 
> False.  Tejun authored many of the changesets getting timer and error 
> handling "moved up the stack."

OK, I stand corrected:

s/all/vast majority of/

> >   which is still relying on some very old fields and undocumented behavior
> >   of the block layer, since the next step is to simplify the block to low level
> > 
> > When it comes to block layer interactions the legacy IDE subsystem is just
> > another "dumb" (== very simple) block layer driver.
> 
> Hardly.  The IDE driver has all sorts of special cases that no other 
> block driver has.  One must roll dice to see which of rq->special, 
> ->buffer, ->data and ->sense is filled in, and at what times. Is 
> ->buffer, ->data, etc. pointing to a buffer... or an opaque kernel data 
> structure?  None of this is clear or documented.

I fail to see how it stops you from working on moving libata out of SCSI,
also Tejun had patches cleaning it for some time now.

> REQ_TYPE_ATA_* is still around.  Overall the consistency of request 
> handling across the IDE class drivers is low.  ide-tape sticks out like 
> a sore thumb with its use of current_nr_sectors.

ditto

What is the relation between REQ_TYPE_ATA_* or ide-tape and moving
libata out of SCSI?

> IDE's interactions with the block layer are quite complex and opaque, 
> compared to other block drivers.

They are certainly more complex than most block layer drivers but there
is very little magic left + Tejun and Borislav are taking care of it
(there were also a lot of good work done by FUJITA and Boaz in the past).

More importantly how exactly does this stop you from working on moving
libata out of SCSI?

To me it looks like some silly behind-somebody's back blame shifting...

Thanks,
Bart
