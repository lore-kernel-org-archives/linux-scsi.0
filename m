From: Jeff Garzik <jeff@garzik.org>
Subject: Re: LSF Papers online?
Date: Mon, 13 Apr 2009 18:24:57 -0400
Message-ID: <49E3BBB9.4040100@garzik.org>
References: <49E335BA.3020103@panasas.com> <49E34F41.6050903@panasas.com> <20090413121137.5c5d259c@bike.lwn.net> <200904132340.21525.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34129 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZDMWZK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2009 18:25:10 -0400
In-Reply-To: <200904132340.21525.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Bartlomiej Zolnierkiewicz wrote:
> I've started reading it and immediately noticed a thing which made by day. :-)
> 
> Sorry if it will sound off-topic or undiplomatic but it is the best occasion
> to straighten up some facts:
> 
>  "Discussion then moved on to the current status of getting libata out of
>   SCSI: we have had several successes, notably timer handling and pieces of
>   error handling have moved up to block. Unfortunately, the current progress
>   has reached the point where it's being impeded by the legacy IDE subsystem
> 
> Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
> 
> I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).
> 
> The thing is that during last _five_ years almost nothing was done in this
> direction.  Despite the fact that it was #1 condition under which the whole
> code has been merged.  Sorry to say it but it seems like the whole merge
> strategy was to over-promise things now and worry about delivery later.

Yet, shockingly, users have been happily using libata despite all these 
horrors.


> To make things worse all the "successes" quoted above are nothing else
> like back-ridding on block layer and SCSI improvements which were done by
> non-libata developers.

False.  Tejun authored many of the changesets getting timer and error 
handling "moved up the stack."


>   which is still relying on some very old fields and undocumented behavior
>   of the block layer, since the next step is to simplify the block to low level
> 
> When it comes to block layer interactions the legacy IDE subsystem is just
> another "dumb" (== very simple) block layer driver.

Hardly.  The IDE driver has all sorts of special cases that no other 
block driver has.  One must roll dice to see which of rq->special, 
->buffer, ->data and ->sense is filled in, and at what times. Is 
->buffer, ->data, etc. pointing to a buffer... or an opaque kernel data 
structure?  None of this is clear or documented.

REQ_TYPE_ATA_* is still around.  Overall the consistency of request 
handling across the IDE class drivers is low.  ide-tape sticks out like 
a sore thumb with its use of current_nr_sectors.

IDE's interactions with the block layer are quite complex and opaque, 
compared to other block drivers.

	Jeff



