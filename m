From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 09:23:24 -0600
Message-ID: <1141399404.3928.5.camel@mulgrave.il.steeleye.com>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56017 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932097AbWCCPX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 10:23:29 -0500
In-Reply-To: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-03-03 at 02:14 -0800, Luben Tuikov wrote: 
> Even if you serialized it you still cannot guarantee order.  Sometimes
> OOB depends on the _other_ device attached, and on their end, power (voltage)
> can make a difference.  So if it happens that there is 2 expanders connected
> to two (different) ports, OOB may "determine" which is scanned first in which case
> you'd off by more than one device (at least one device).
> (So you'll scan and then you'd have to come back to rescan...)

Right, but this is no different from any SCSI protocol (if the device
isn't powered up the scan won't find it).

> That is, to guaranee ordering you have to do it _logistically_.  For example,
>    * by reading SES pages, or
>    * by implementing a general facility (layer) in the kernel, which
>      can always map "device" to "name", irrespective of _when_ the device
>      was discovered and _where_ the device was discovered.

Yes, that's what udev does.

> So you cannot depend on time, as you're trying to do it above.

Actually, I can.  Assuming the cages are all powered up, which is beyond
the driver control, then serialising the scan will allow one to
specify /dev/sda1 deterministically for root.   I agree that for flakey
devices on multiple expanders this may not work, but the object is to
keep expected behaviour in most cases, not solve the problem for every
case.

> And there is a very good reason why ports are discovered in parallel.

Which is?

> > 2. The minimal attachment to the sas transport class doesn't do
> > expanders.  This needs to be fixed up by patching better expander
> 
> Yes.  And my code does all that.  I'm not sure what you mean by
> "better".

Yes, I know ... this is one of those Open Source things: release early
and often.  This isn't a fully formed conversion, but it is one that
works in certain circumstances.  The extra features get added later, but
at least people get to see the code.

> > support into the class.  The way to do this is probably to pull the
> > domain_device into the sas transport class.
> 
> 2006?  I asked for a similar construct to be added in 2001, and also
> last year I suggested that struct domain_device be added to SCSI Core to
> represent domain devices de facto.

Well ... the way you've done it (with a type union) isn't scaleable
(every possible type must be known when the driver is complied or the
domain device has the wrong size) However, a device generalised rphy
might be.  I think I also said on more than one occasion that I'm not
averse to the concept, but we can't redo all the drivers to conform.

> > 3. The object lifetimes are all basically infinite (this will probably
> > fixed by 2)
> 
> Yes, you see and this is a problem.  In the new world of layered SCSI,
> where interconnects/transport protocols/command sets/device types have been
> decoupled, you need to know that devices can come and go as easily as anything
> else (or eaiser).

This is easily fixed ... I just haven't got around to it yet.

> 
> Your patch does _not_ improve things.  It is taking a step back. (way back)
> 
> > There's a host of minor details, and I think the ultimate goal needs to
> > be to turn Luben's sas_class into an adjunct to the transport class that
> > handles drivers with domain devices.
> 
> Not really.  This was explained before on this list: no "adjunct" stuff.  No appendages.
> Read SAM, read some SCSI literature.  Things are layered now.
> 
> > However, my basic though is that once we can get the critical issues
> > sorted out, this driver can go in.
> > 
> > Comments?
> 
> Well, look at the patch, James.  Do you LIKE it?  I mean, when you finished
> it, did you sit back, stared at it with contentment, studied it, and liked it
> more and more?  Did you say to yourself, "This is where I want to take
> SCSI Core to"?  Did you say to yourself, "This is the architecture I want
> to give to Linux SCSI"?
> 
> Did you sit back and say to yourself "I've studied SAM and SAS and
> I _like_ what I've done. This is good." ?
> 
> Here is a list of what a "step back" means:
>   - Getting rid of struct sas_phy for the LLDD specific struct asd_sas_phy.
> This is a step back because it gets rid of the SAS phy abstraction.  Needless
> to say the struct sas_rphy is a complete flop.

That's a pure necessity to avoid a namespace clash.

>   - Getting rid of the SAS Stack showing the domain(s) it discovered,
> in sysfs.  This is useful, for many things: domain visualization, device
> control, etc, etc.  Why would you want to have to recreate it every time?
> The discover process already does represent internally the physical world
> (the domain), in order to better control it and expedite things, and it is
> just a perk to show its current state in sysfs.  Plus you get nice krefs
> to objects which might be used elsewhere.  It is a consolidation, which
> you're ripping out.

Actually ... it's still there if you actually care to look.

>   - You are introducing "sas_transport_functions".  Now what can that be?
> (I can see it is currently empty.)  Would it be used externally?  Or internally?
> Will the SAS stack represent itself to itself?

Just read the code, will you ... it's a set of four functions for
control and statistics gathering ... I just haven't implemented them in
aic94xx yet.

>   - Your point #2 above "doesn't do expanders" -- you mean discovery.  I think
> this is a step back.

Not if it gets the sas transport class to the point where it does.

James

