From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/3] MidLayer updates - extending transport/attributecontainer changes
Date: Sat, 5 Feb 2005 09:56:31 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C1FD1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:8665 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S273261AbVBEO4f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Feb 2005 09:56:35 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

> On Sat, 2005-01-29 at 09:03 -0500, James.Smart@Emulex.Com wrote:
> >   Updates the recent transport container patch for :
> >   - allow device driver-specific attributes to be added to 
> class objects
> >   - exposes classdev to transport via setup function
> 
> I'm not very keen on this for two reasons:
> 
> 1) The driver should be tampering with class attributes.  A class and
> its attributes are the presentation of an interface.  If the 
> driver has
> something more to add then surely that's an indication that 
> the original
> interface is missing pieces (i.e. every driver should have 
> this) or that
> the driver is trying to export a different interface (and so, 
> logically
> should use a new class.  i.e. just add a transport_class to the driver
> and everything will work nicely).

Well the only we part we disagree on is the "surely that's an indication"
statement. It may not be. What if the hardware implementation has several
device-specific steps/states that must be traversed in order to meet the
more general state of the transport. These things obviously aren't
applicable to all other adapters. If I (the driver) wanted to report these
potential interim states - how could I ?  In the case of FC and remote
ports, the difficulty is that the only place where the relevant object is
valid is in the transport. I either define an awful adapter-global attribute
that must report for all devices (or something worse), or just give up
exposing this information.

> 2) classdevs are sysfs's representation of the interface.  I'd rather
> they weren't exposed any more than necessary internally to avoid the
> urge to hack the interface.

Understood. However, the class dev is the transport's presentation point
to the system - and you're dictating how that interface can look and/or
behave. Obviously that's the intent - it's a bunch of sysfs attributes
only, and everything's either fully present or not present. That is a
pretty restrictive definition though. As the transport, given that it's
my presentation point, I'd like to be able to manipulate my presentation
if necessary.  I'm also assuming that eventually the transport is as
trusted as other parts of the midlayer, so it's allowed, under specific
constraints, to access the classdev.

-- James S
