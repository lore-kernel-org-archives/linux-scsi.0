From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Wed, 15 Apr 2009 00:09:06 +0200
Message-ID: <200904150009.06539.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <200904141654.24067.bzolnier@gmail.com> <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64168 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZDNWJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 18:09:53 -0400
In-Reply-To: <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>


On Tuesday 14 April 2009 18:54:41 Alan Cox wrote:
> > The users were not asking for many other things, i.e. libata PATA.
> 
> Yes they were, and at the time libata PATA got done the old IDE code had
> been rotting for a long time. It was only after that you decided to

Since you seem to love going over this over and over and over again... ;)

I would like you to remind you that I wasn't saying NAK to libata PATA
despite the fact that some people spend quite a big time on trying to
blame every single IDE problem on me (while I took over only in 2.5.7x,
received next to none help and wasn't even paid for this work)...

I just wanted to have clear vision of the process instead of "lets merge
it now and worry about real users later".

I couldn't get this vision neither from you nor Jeff.

There was no technical discussion with Red Hat people at all.

Every uncomfortable technical issue raised was addressed with direct
"IDE is teh crap" shouting or indirect "you're being difficult" clues.

And don't try to tell me that I was difficult.  Sure I was. :)

Like the vase majority of other kernel people.

In the end we should handle things at the technical level.

This was clearly not the case back then.

I could have also continued to work on IDE after libata PATA.

Even if I would eventually out do it, what would it change?

Fedora will still start shipping with CONFIG_IDE=n and Red Hat will
still bless libata PATA.

SuSE and Canonical will jump on on ship just to not divert too much.

In the best case I would get a lovely "Bart was right!" comment
somewhere in libata-core.c. ;)

I was able to see that much and my motivation was completely gone,
IDE blame shifting was also really very successful in this regard.

So I took a break limiting my involvement to patch reviewing and waiting
to see how would the situation develop.

It had developed more-or-less like it was predicted.

The "lets build a great new shiny drivers" utopia ended and the real-world
"oh we have dozens of regressions and still lack hardware coverage" phase
started.

> revamp it all, duplicating work when you could have helped work on libata
> PATA. Maybe then there would have been more time to continue working on
> the split.

Well, it is not like I was working day and night on fixing old IDE,
I just dusted off old patches and then the ball started to roll.

I did it purely because it was fun to work with many great people (like
Sergei or Borislav), there were still a lot of IDE users left behind by
libata PATA and I also didn't want to let my old patches go to waste.

Have you ever wondered why people are still using IDE or sending me
IDE patches?  No, it is not because I'm such a great guy to work with. :)

Hint: the most reasons are purely technical.

There are still dozens of IDE -> libata regressions.  The fact that such
fixes are being mislabeled as an "improvements" is hardly fooling anybody.

There are also uses (embedded world) when IDE is better cause it is
smaller and _much_ simpler.

Maybe you really shouldn't have brought this topic up. ;)

However since you did lets get to some productive conclusions this time.

I'm ready to discuss anything as long as we stick to technical facts.

libata PATA is still not a replacement for IDE and cannot be removed
anytime soon.

This is the technical fact.

How we should start addressing it and who is going to do work?

>From my side I can help with setting up a another quilt tree and starting
addressing host driver regressions (there still quite a few of them left),
and maybe porting a driver or two but this is it.

I'm quite time constrained and I'm also not leaving IDE behind (we still
have some pending changes there) so I need a lot of help on cleaning up,
porting and testing of some quite peculiar host drivers.

The whole process will go slowly and will take up long time.

No problem with this as long as we make progress.

This is of course given that you want to finish the work that you started
with libata PATA and not leave it half-way done.

Comments?  Thoughts?

> > > probably forgotten, but for I occasionally mention it at kernel summits.
> > Did you you forget about Intel guys and other people working on SSDs?
> 
> It seem to be an Intel guy now 8)
> 
> > i.e. please go into libata-eh.c, try to make sense out of it and track all
> > subtle libata-SCSI-block interactions (yes, the code is clean by mingo's
> > cleanness standard -- this is not the point here)
> 
> libata-eh is pretty clear to follow and because it uses the SCSI approach
> of quiescing the queue doesn't have the creepy horrors of the old IDE
> layer which was trying to do resets and polled speed changes in IRQ
> context racing against timers and completion events.
> 
> It does that despite handling NCQ, barriers and hotplug. It does this
> despite being vastly smarter than the old IDE code in its error
> processing heuristics.

Well, old IDE is a pretty weak reference point.

> > How's about starting with working on the existing ATA/IDE subsystem?
> > 
> > You lacked _any_ hands-on experience with it.
> 
> But those helping him had extensive, painful, experience with it having
> maintained the relic for years. The decision to go with libata PATA was
> well informed and made from a deep understanding of just how big a pile of
> turd there was lurking in the old drivers, coupled with a view that it
> would be better to create the new drivers in parallel rather than
> destabilize the old code while progressing it.

Well, you are not the only person that had such bad experiences with it.

Plus I also put a significant effort into gaining insight into the
subsystem during 2001-2004 days -- this wasn't clearly visible cause
my patch game sucked big time compared to my review game (yes, it
still sucks now but it is getting bit better).  Moreover I learned
a lot do-nots from the results of 2.5.x IDE rewrite attempt.

I saw that it could have been done in a evolutionary way (which worked
miracles with SCSI subsystem) without destabilizing it too much and in
a timely manner.  Got the agreement about this with libata people and
I started the work in 2003-2004.

Lets skip the historical part here.

The rework was later finished in 2007-2008.

Despite facing heavy competition and lacking any corporate support.

With a few voluntary IDE developers and a bit of help from community.

We actually did a whole lot more changes that were originally intended.

Hey, I've never imagined that we will rewrite almost whole subsystem.

It was possible.  See?

We actually used quite a lot of libata PATA changes on the host driver front
(though because of the lack of incremental libata PATA changes and the need
to fix some IDE specific issues first this was not that easy) so maybe if we
could agree on some mid-point way back in 2005 we would be in a completely
different place today.

Lets not repeat the history again.

> > The fact that it is much harder to do nowadays than in 2004-2005 (without
> > ATAPI support, PATA support and heavy dependence on SCSI infrastructure)
> > is only _your_ fault.
> 
> Really - you could have contributed too. Anyway I wrote most of the PATA
> bits, Tejun wrote a ton of stuff including EH, and Albert Lee wrote
> chunks of it too.

I did a bit work.  Check your host drivers. :)

> So that would be Red Hat, SuSE and IBM who are to blame right, not just
> Jeff ? Sounds like a conspiracy to me ;)

There is no conspiracy there.

Just the good old game known from elsewhere.

Top layer modern day kernel hacking is based on business principles.

However, like they say "Hate the Game, Not the Player". :)

There is really nothing wrong with it as long as we don't state
otherwise to new people so they are fully aware of the situation.

> > Please save us the management fairy-tales and just show us the code.
> 
> You've misunderstood free software Bartlomiej. If you want something that

Indeed, I misunderstood it, not this point though.

Anyway, you guys know what I'm getting at.

The opportunity window that was there in 2004-2006 to push things
forward in a *really* major way and we failed to use.

As I see it now it was in large part my fault of seeing the chance
and not being able to convince people about it so I'm not pointing
finger at anybody else.

> badly *you* should us the code or work with other like minded people.

Well, it wasn't me who promised the delivery within the year and later
avoided the topic for half of the decade.

If Jeff changed his mind or simply didn't want to do this work it was as
simple as saying it, in PM or otherwise.  Seriously.

Avoiding discussion about uncomfortable topics prevents a progress.

Thanks,
Bart

"I feel so right, yet I'm so wrong"
