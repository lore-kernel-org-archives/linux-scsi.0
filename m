From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 10:20:55 -0800 (PST)
Message-ID: <20060303182055.14544.qmail@web31806.mail.mud.yahoo.com>
References: <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:46511 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1161012AbWCCSU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 13:20:57 -0500
In-Reply-To: <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-03-03 at 02:14 -0800, Luben Tuikov wrote: 
> > Even if you serialized it you still cannot guarantee order.  Sometimes
> > OOB depends on the _other_ device attached, and on their end, power (voltage)
> > can make a difference.  So if it happens that there is 2 expanders connected
> > to two (different) ports, OOB may "determine" which is scanned first in which case
> > you'd off by more than one device (at least one device).
> > (So you'll scan and then you'd have to come back to rescan...)
> 
> Right, but this is no different from any SCSI protocol (if the device
> isn't powered up the scan won't find it).

You're missing the point: both devices are powered (and possibly at the same time).

> > That is, to guaranee ordering you have to do it _logistically_.  For example,
> >    * by reading SES pages, or
> >    * by implementing a general facility (layer) in the kernel, which
> >      can always map "device" to "name", irrespective of _when_ the device
> >      was discovered and _where_ the device was discovered.
> 
> Yes, that's what udev does.

Yes, I know that.

> > So you cannot depend on time, as you're trying to do it above.
> 
> Actually, I can.  Assuming the cages are all powered up, which is beyond

Wow, talk about _stability_.  This is where you show the rest of the world
that Linux is in fact not enterprise.

The whole point is that the "cages" _are_ all powered up, but OOB happens
in parallel (not in serial), so you're not guaraneed to discover in the
order you would if it were a static system (your assumption).

In other words, you actually need experience with SAS.

Another point which you're missing is that BIOS had poked at all devices
already and this is why in a power-all-boot-all system you can rely on this
static behavior.  But BIOS is the exception, not the rule.  (Yes, yes, I know
the setup you have doesn't have BIOS.)

> the driver control, then serialising the scan will allow one to
> specify /dev/sda1 deterministically for root.   I agree that for flakey
> devices on multiple expanders this may not work, but the object is to
> keep expected behaviour in most cases, not solve the problem for every
> case.

Yes, and this is where you and I disagree: I always try to solve the general
case so that I don't have to worry about a spaghetti solutions later.  It is
not easy but it always pays off later when customers tell me that "it worked"
in some kind of strange configuration, which neither one of us had thought of
before.  This is the difference between enterprise and basement.

> Yes, I know ... this is one of those Open Source things: release early
> and often.  This isn't a fully formed conversion, but it is one that
> works in certain circumstances.  The extra features get added later, but
> at least people get to see the code.

Long gone are the days when "people" contributing to _a_ kernel development
were professionals whose job was _not_ to do kernel development.  But
was to work in a specific area like mathematics, or networks or storage,
and kernel contribution was just a byproduct of their professional work.

Plus, look, no one is really cares about your patch.  This is all end-customer
driven, and no one up the chain cares about technology or the right way
to do it.  It is those exact "Open Source things" (to quote you) which have
given trust to people like you to do the _right_ thing.

Again, take a look at your patch.  Do you LIKE it?  Did you contemplate it
afterwards and say "Yes, this is a good thing, I like the architecture,
I like where this is going, it is an improvement.  This is where I want
Linux SCSI to go, and I know SAS professionals would like this."

> Well ... the way you've done it (with a type union) isn't scaleable
> (every possible type must be known when the driver is complied or the
> domain device has the wrong size) However, a device generalised rphy

"struct domain_device" is supposed to live only in the SAS Stack.
What you'd want in SCSI Core is "struct scsi_domain_device".  You need
to understand the difference and how they are connected (or de-coupled),
and what makes them so.

> This is easily fixed ... I just haven't got around to it yet.

No, nothing is easy.  Everything involves thought, analysis and lots of reading.

> > > Comments?
> > 
> > Well, look at the patch, James.  Do you LIKE it?  I mean, when you finished
> > it, did you sit back, stared at it with contentment, studied it, and liked it
> > more and more?  Did you say to yourself, "This is where I want to take
> > SCSI Core to"?  Did you say to yourself, "This is the architecture I want
> > to give to Linux SCSI"?
> > 
> > Did you sit back and say to yourself "I've studied SAM and SAS and
> > I _like_ what I've done. This is good." ?
> > 
> > Here is a list of what a "step back" means:
> >   - Getting rid of struct sas_phy for the LLDD specific struct asd_sas_phy.
> > This is a step back because it gets rid of the SAS phy abstraction.  Needless
> > to say the struct sas_rphy is a complete flop.
> 
> That's a pure necessity to avoid a namespace clash.

There is no such thing as "remote phy", ala struct sas_rphy.

> Actually ... it's still there if you actually care to look.

Your patch shows that it is removed.  I remember you were very opposed
to it being in the kernel and sysfs at OLS last year.  Your opposition
was "paths would be too long".  What changed your mind?

> Just read the code, will you ... it's a set of four functions for
> control and statistics gathering ... I just haven't implemented them in
> aic94xx yet.

I saw the patch and that structure was empty.  This is what your patch showed.

> >   - Your point #2 above "doesn't do expanders" -- you mean discovery.  I think
> > this is a step back.
> 
> Not if it gets the sas transport class to the point where it does.

You're doing two things: removing perfectly working functionality and completely
missing the infrastructure.  That cannot be a good thing.

      Luben

