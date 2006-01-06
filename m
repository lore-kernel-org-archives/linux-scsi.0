From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [CFT 1/29] Add bus_type probe, remove, shutdown methods.
Date: Fri, 6 Jan 2006 16:57:17 +0000
Message-ID: <20060106165717.GB16093@flint.arm.linux.org.uk>
References: <20060105142951.13.01@flint.arm.linux.org.uk> <20060106114822.GA11071@flint.arm.linux.org.uk> <1136565289.3528.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:38158 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S1752475AbWAFQ52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 11:57:28 -0500
Content-Disposition: inline
In-Reply-To: <1136565289.3528.26.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net, schwidefsky@de.ibm.com, Greg K-H <greg@kroah.com>

On Fri, Jan 06, 2006 at 10:34:49AM -0600, James Bottomley wrote:
> On Fri, 2006-01-06 at 11:48 +0000, Russell King wrote:
> > The scsi_driver business looks like being a pig to solve - so can
> > SCSI folk please look at what's required to unuse these fields.
> 
> Well, not necessarily pig.  Perhaps piglet.  We definitely need the
> separate probe, shutdown and remove methods for each of our ULDs.
> However, if they moved into the bus, since scsi_driver is always of type
> scsi_bus, we could add separate probe, shutdown and remove fields to
> struct scsi_driver and have the new fields in scsi_bus call those.  I
> have to ask, though; isn't that primarily what most other bus types are
> going to be doing anyway?  So doesn't it make sense to leave the fields
> in the generic driver?  Then the rule becomes that if the bus has the
> field, we call it, and the bus routine *may* call the corresponding
> generic driver field if it feels like it.  Otherwise if the bus has no
> callbacks, just use the generic driver ones?

Firstly, having both causes confusion.  As a prime example of this,
see the PCIE crap - they implement both the bus_type suspend/resume
methods _and_ the device_driver suspend/resume methods, despite these
device_driver suspend/resume methods never ever being called.

Secondly, keeping both negates the _whole_ point of this series and
the previous platform device driver series - needless bloat:

- the extra bloat in struct device_driver for all bus types,
  many of which do not have things like shutdown or suspend/resume
  callbacks.

- the extra code bloat in many drivers to convert the struct device
  to something more bus specific.

Also, don't you think it's wrong to keep these fields _just_ to
support single case that SCSI wants to remain using the Old Way,
when everything else can be (and almost has been) converted to the
New Way?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
