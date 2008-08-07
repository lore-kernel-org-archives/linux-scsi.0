From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Thu, 07 Aug 2008 10:36:47 -0700
Message-ID: <1218130607.3749.32.camel@localhost.localdomain>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <200808051415.59993.jbarnes@virtuousgeek.org>
	 <1217973297.9923.80.camel@localhost.localdomain>
	 <200808070903.23787.jbarnes@virtuousgeek.org>
	 <20080807172001.GA9773@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53553 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201AbYHGRgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2008 13:36:54 -0400
In-Reply-To: <20080807172001.GA9773@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org

On Thu, 2008-08-07 at 10:20 -0700, Greg KH wrote:
> On Thu, Aug 07, 2008 at 09:03:22AM -0700, Jesse Barnes wrote:
> > On Tuesday, August 5, 2008 2:54 pm James Bottomley wrote:
> > > > or somesuch.  That seems just as simple for driver writers as your
> > > > initial patch, and the function is named in accordance with what it
> > > > actually does, rather than what it's used for...
> > >
> > > It could, but if the bridge is the culprit (as it usually is for MSI
> > > problems), this print won't help identify it.
> > >
> > > Therefore, rather than give driver writers a recipe for "print this and
> > > this and go to the bridge and print this", I'd rather have a single PCI
> > > callback that prints all the (hopefully) relevant information that will
> > > allow either fixing or blacklisting.
> > 
> > So in addition to the IRQ type check we need to dump some device topology 
> > information... yeah that makes sense.  I wonder if the driver core should 
> > provide something like this.  Greg?
> 
> What kind of topology do you need that is not already provided?

We really need to print how the device interrupt is routed.  But,
unfortunately, we need to identify the devices in the layout (bridges
and the like by say device/vendor numbers) so we know what they are ...
this is the bit that the generic device model can't do because it's
embedded in the bus specific part.

James


