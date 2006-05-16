From: Luben Tuikov <ltuikov@yahoo.com>
Subject: SAS wide port support [Was [storage-summit-2006] Attendees List]
Date: Tue, 16 May 2006 10:20:41 -0700 (PDT)
Message-ID: <20060516172041.72990.qmail@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:35495 "HELO
	web31812.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932162AbWEPRUm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 13:20:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: storage-summit-2006@lists.osdl.org, Eric Moore <eric.moore@lsil.com>, James Bottomley <james.bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

[Last night I subscribed to the storage summit list and could log in, but this morning
I cannot log in. I'm posting my message, anyway.  I doubt it will reach the storage
summit list, now that my subscription has mysteriously broken.]

On Monday, 15 Mayn 2006, Eric Moore wrote:
> On Monday, May 15, 2006 3:45 PM, James Bottomley wrote:
> > 
> > The problem (as I see it from the way aic94xx functions) 
> > isn't specific
> > to wide ports, it's a simple lack of port support.  We only 
> > have phys to
> > hang things under.  I think the way Christoph envisaged is that you
> > choose a master phy to be the port in wide ports, but all 
> > this would be
> > obviated if we had an actual port object under the phy.
> 
> I don't think having master phy will work.   Any phy can come
> and go at any time in a wide port.  Data is going over all
> the phys at any time.

Yes, Eric, you are absolutely correct.

It is very unfortunate that someone "envisages" how technology
should work, when 1) there is a spec telling them how it works,
and 2) there is code which adheres to the spec, showing them
how it works.

> What I would like to see is the 
> transport layer contain port objects, that contains phys objects 
> under it.

Correct. This is exactly how I designed the SAS stack and it is
exactly how it works.  The source is GPL and had been available since 09/09/2005.

>  My driver tells you I have a wide port, and 
> you (as the transport) manage the phys.

I think you meant "manage the ports" ... when you get phy events/port events
on a phy, you report the event on the phy, and then the transport layer
handles changes which need to be done to the port.

Phy management is done by the HW and by the FW, e.g. OOB, link resets, etc.
Port management is done by the SAS Stack, on behalf of phys reporting
events. (see next paragraph)

> I can tell you  
> when link changes within the wide port.

Exactly right!  Those things are called "port events".  All port
events arrive on a "phy", it is exactly this callback function:

void notify_port_event(struct sas_phy *phy, enum port_event event)

from sas_events.c SAS Stack (my version, not Bottomleys & Hellwigs).

A SAS phy event is not necessarily a port event, but a SAS port event
is a phy event (since it arrived on a phy).  E.g. BROADCAST, HARD RESET,
LINK RESET ERR are all port events, but arrive on a phy, and things like
OOB error are phy events which also arrive on a phy.

> You tear down the port when all the phys go away.  Also brigning
> up the port should handle only calling scsi_scan_target once for
> the port, instead of once for every phy as it does today.

Agreed, although, here you are using a more liberal definition of
"port".

A SAS port is not an FC port, and neither one of those is a SAM port.

If your Protocol stack is in the FW, you don't want to bother
SCSI Core with SAS ports.  SAM ports are ok.  I.e. you don't want
SCSI Core to know about a port between expander #9 and device Z.
This is purely managed by the expander, the device and the discover
process in the Protocol stack.

But remember -- SCSI Core has no concept, neither representation,
nor infrastructure for SAM ports support.  All you can do right now
is register devices with SCSI Core.

A good architectural design is very important.  You don't want to
"go down the rabbit's whole" where you find out more and more problems
due to design mistakes.

> Today
> with engenio box, the same target is reported four times ( as 
> I have 4 phys in my wide port). 

LOL!

> > 
> > > * passthru support, e.g. smp and stp
> > 
> > I have some ideas on this, but I want Jens to talk about bsg 
> > (his SG_IO
> > replacement) before I put them forward.
> > 
> > > * discovery - what is going to be implemented to support 
> > non-firmware
> > > assist solutions?
> > 
> > Pretty much what we have today for the aic94xx ... I think its fairly
> > feature complete; what more needs adding?
> 
> THere is no discovery support in the sas transport layer.  It maybe over
> in the scsi/sas folder, but I've not looked into that yet, and the
> mptsas driver
> is not using that.   So my doubt was whether this was being moved over
> to scsi_transport_sas,
> and what it impacts on fusion would be.

The Discover Process has gotten vastly complicated, maintaining wide ports
deep in the domain, self-configuring expanders, zoning, etc.  There is a lot
of tricky situations, gotcha-s, some due to the spec, others due to a tricky
domain configuration.

The Discover as it existed back when I submitted my code September 09, 2005,
has seen updates, augmentations, etc.  I cannot imagine someone (those who pay
the bill) to want to include it in the kernel as it existed back then.  It needs
support and it needs support by professionals working in this area.

> > > * SAS Generation II - 6 gib support
> > 
> > Placeholders for this are in the SAS class
> > 
> 
> What I what to discuss is the changes that are occuring in the fusion
> firmware to support sas gen II.  I suggest we go for new driver, and I
> would
> like to discuss that with you, as well as how ioctls will be supported
> if
> we go for new design.

"New driver"?

> One of the changes is we are getting rid of H:C:T:L mapping.  We are
> going
> for handles.   So I ask, when will we start removing H:C:T:L mapping in
> mid layer for
> everything but SPI?

Ideally, since you implement the Protocol Stack in FW, you would simply
register the devices you've discovered in the domain, as SCSI devices
with SCSI Core.  Then SCSI Core would do LU discovery, and do SCSI maintenance.

The whole point is that the protocol is hidden in the FW.  Pure SCSI abstraction
is exported to SCSI Core.

With the proper tools you can implement Protocol maintenance with a user
space tool, which would be closed source.  This user space tool would give
you zone management, protocol management, hw management, etc.

This would remove unnecessary crud from the kernel.

With host-based solutions, then you'd have something as the SAS Stack,
whereby settings can be altered from userspace, using something like
sysfs, where the whole domain is laid out as it exists in the physical
world, as the SAS stack (mine) currently does.

Addressing a device in the domain (expander or end device) from user space,
is a simple "cd /sysfs/.../..." to the proper directory.  Then you can use
expander_conf.c to tweak it, or directly writing single value data to the
properties (exported as files).

Either way, certain things should stay hidden.  Imagine user space
changing the TLR bit, all the while the FW thinks that it is the old value.
I can use the sg utils to do this.  And then your customer files
a bug report with you that this SAS tape drive doesn't work with your
host adapter...

All in all, a good architectural design is very important.  Normally
people who come up with those things are people with experience, experience
in the field, in the area, working with the technology and developing
the technology.

Bad design leads to more bad design, trying to accommodate unrepresented,
missing features or new features.  It is like falling into the rabbit's
hole.

    Luben
P.S. BTW, why a separate mailing list?  Wouldn't lsml suffice?

