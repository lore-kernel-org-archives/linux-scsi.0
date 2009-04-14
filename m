From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 17:54:41 +0100
Message-ID: <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
References: <49E335BA.3020103@panasas.com>
	<200904140324.59657.bzolnier@gmail.com>
	<49E461E8.10106@garzik.org>
	<200904141654.24067.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200904141654.24067.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> The users were not asking for many other things, i.e. libata PATA.

Yes they were, and at the time libata PATA got done the old IDE code had
been rotting for a long time. It was only after that you decided to
revamp it all, duplicating work when you could have helped work on libata
PATA. Maybe then there would have been more time to continue working on
the split.

> > probably forgotten, but for I occasionally mention it at kernel summits.
> Did you you forget about Intel guys and other people working on SSDs?

I seem to be an Intel guy now 8)

> i.e. please go into libata-eh.c, try to make sense out of it and track all
> subtle libata-SCSI-block interactions (yes, the code is clean by mingo's
> cleanness standard -- this is not the point here)

libata-eh is pretty clear to follow and because it uses the SCSI approach
of quiescing the queue doesn't have the creepy horrors of the old IDE
layer which was trying to do resets and polled speed changes in IRQ
context racing against timers and completion events.

It does that despite handling NCQ, barriers and hotplug. It does this
despite being vastly smarter than the old IDE code in its error
processing heuristics.

> How's about starting with working on the existing ATA/IDE subsystem?
> 
> You lacked _any_ hands-on experience with it.

But those helping him had extensive, painful, experience with it having
maintained the relic for years. The decision to go with libata PATA was
well informed and made from a deep understanding of just how big a pile of
turd there was lurking in the old drivers, coupled with a view that it
would be better to create the new drivers in parallel rather than
destabilize the old code while progressing it.

> The fact that it is much harder to do nowadays than in 2004-2005 (without
> ATAPI support, PATA support and heavy dependence on SCSI infrastructure)
> is only _your_ fault.

Really - you could have contributed too. Anyway I wrote most of the PATA
bits, Tejun wrote a ton of stuff including EH, and Albert Lee wrote
chunks of it too.

So that would be Red Hat, SuSE and IBM who are to blame right, not just
Jeff ? Sounds like a conspiracy to me ;)

> Please save us the management fairy-tales and just show us the code.

You've misunderstood free software Bartlomiej. If you want something that
badly *you* should us the code or work with other like minded people.

Alan
