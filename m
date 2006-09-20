From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: AIC94XX discovery timeout problem details...
Date: Wed, 20 Sep 2006 07:55:59 -0700 (PDT)
Message-ID: <20060920145559.15218.qmail@web31807.mail.mud.yahoo.com>
References: <20060919205902.GA4326@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:17753 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751579AbWITOz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 10:55:59 -0400
In-Reply-To: <20060919205902.GA4326@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

--- malahal@us.ibm.com wrote:
> I am planning to process port/phy events in two phases. Phase-I sets up
> asd_sas_port, asd_sas_phy lists and calls the LLDD with a correct
> phy_mask. Phase-II is done in the thread context by queuing to the scsi
> work queue that involves setting up sysfs objects.  Still there would be
> just one thread setting up/tearing down sysfs objects that should avoid
> any races.
> 
> Would appreciate any suggestions or issues with this approach.

Malahal,

Your persev erance is commen dable.  Unfortunately this approach is too
simplistic and naive, no offence intended.  That is, such an approach
seems to be the first thing that "pops" into someone's head on how
to do it and a more elaborate analysis of the protocol is warranted
when coding such concepts.  That is, you want to handle the absolute
general case of _more than one type of event_. (This is not intuitive.)

You should take a look at the "patches" submitted by Bottomley and Hellwig
in the areas of event infra, event processing, and discovery, since
I posted the SAS Stack:
  - The Priority Queue Without Duplication Implementation (sas_event.c)
for queueing infinitely many events in finite storage, sorted by arrival
time, where insertion is O(1) and ordered removal is O(1) has
been completely removed.  For some reason they called it "long queue"
in the subject line of their message or in the body, cannot remember.
  - Threaded event processing has been completely removed.
  - Threaded discovery has been removed for the more naive and simplistic,
do-it-all-now-at-once way.

Add to this the fact that some things shouldn't be done "right now",
even though they happened "right now", but should be done "way later"
because you want other things which depend on those things to ...
This isn't intuitive, but is the result of careful analysis of the protocol.

That is, since my original posting of the SAS Stack, Bottomley's refusal
to accept it into the kernel has resulted in what you have right now.

But look on the bright side: just take a look at the mailing list at how
many people are now employed by this?  Five, six people?  So from another
angle, Bottomley's refusal to accept what is the beginning of an enterprise
level SAS Stack written by one person, and his subsequent "patches" has
now created jobs for at least 5 people, and keeps another 1 or 2 busy with
something to do.

Good luck! (Because you're going to need it.)
   Luben
P.S. I even wrote a proposal for a presentation at OLS this year ('06) to
describe the design and architectural decisions of the SAS Stack and SAS LLDD,
as well as talk about SATL and future SCSI directions and while this proposal
was initialy approved, then later it was silently dropped.  The details are in
the archives of linux-scsi.  Good luck!

> Thanks, Malahal.
> 
> Luben Tuikov [ltuikov@yahoo.com] wrote:
> > --- malahal@us.ibm.com wrote:
> > > I chased the time out problem and found that the PORTE_BYTES_DMAED port
> > > event must be responded with a call to lldd_port_formed() which will
> > > update PHY_IS_UP and port-links fields in DDB 0. As there is a single
> > > thread handling PHY/port events as well as discovery, we really can't
> > > handle PORTE_BYTES_DMAED event until the discovery is complete. This
> > > results in SCSI commands timing out in the discovery thread no matter
> > > what I do!  This problem may be unique to Vitesse expander, read the PS
> > > section for details.
> > > 
> > > Tried using two threads, one for events and the other for discovery.
> > 
> > Malahal,
> > 
> > If you go back in the archives, and take a look at the SAS Stack
> > as I submitted it last year, you'll notice that this is exactly how
> > the code is: there is a separate event thread and a separate
> > discovery thread.
> > 
> > That is, from inception, my code has always had two separate threads,
> > one for events and one for discovery.
> > 
> > I wasn't aware that the code had been changed such that a single
> > thread handles events and discovery.  This is a very naive approach,
> > and a regression over the original code.
> > 
> > > That avoided the timeout problems, but the discovery thread would die
> > > after few iterations due to the event thread and the discovery thread
> > > racing each other for setting up and tearing down of sysfs objects.
> > 
> > Indeed, the situation presented in such circumstances is tricky.
> > These "races" have been dealt with in my (original) code.  Currently,
> > I don't experience any problems with my SAS Stack, as I maintain it.
> > 
> > If any of my original comments are still left in the code or the README
> > files, that would give you a hint of how such "races" are handled.
> > 
> > > I tried calling lldd_port_formed() with appropriate phy_mask from the
> > > notify_port_event() itself. That worked fine. It is just a hack for now!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

