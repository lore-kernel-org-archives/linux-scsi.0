From: Greg KH <gregkh@suse.de>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
	controller
Date: Tue, 16 Jun 2009 10:08:12 -0700
Message-ID: <20090616170812.GA27570@suse.de>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <4A31319C.605@linux.vnet.ibm.com> <alpine.LNX.1.10.0906160546520.6270@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZFPRMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 13:12:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0906160546520.6270@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, Jun 16, 2009 at 07:10:43AM -0700, Anil Ravindranath wrote:
> 
> Please see my responses below...
> 
> On Thu, 11 Jun 2009, Brian King wrote:
> 
> > Anil Ravindranath wrote:
> > > +/*
> > > + * Supporting user-level control interface through IOCTL commands.
> > > + * pmcraid_major - major number to use
> > > + * pmcraid_minor - minor number(s) to use
> > > + */
> > > +static unsigned int pmcraid_major;
> > > +static struct class *pmcraid_class;
> > > +DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
> > 
> > New IOCTL interfaces are generally not acceptable in a new driver. Some alternative
> > interfaces include sysfs, netlink, and debugfs. Refer to the ipr driver for
> > an example of avoiding using IOCTLs. Additional comments below on how to
> > remove the dependency.
> > 
> 
> 
> 1.We want to have a single RAID management Appliction interface to support 
> multiple wide range of OS platforms.

However, Linux already has RAID management applications, so you need to
use that, and interact properly with them.  Do not create new interfaces
that duplicate existing ones, that harms all existing users of Linux and
would force them to use your "special" tool, when that should not be
necessary at all.

So please remove the custom ioctls, as they should not be needed for
proper operation with the "normal" Linux tools, right?

> IOCTL is the best approach as this interface is available in all OS
> platforms.

Just because other operating systems allow you to create new ioctls,
doesn't mean it's a good idea :)

> 2.Also we have commands which requires additional command parameters
> which need to be passed down to FW and we think IOCTL is best approach
> to send these parameters down field by field. We didn't find any other
> cleaner way to pass these additional command parameters seperately
> from the usual data buffer.

What type of commands do you need to do this for?  And what makes it
unique from other controllers of this type?

> 3. we chose IOCTL as we want our Application interface to have full
> control of filling in the fields(like FW specific headers) as passthru
> to driver.

Again, what is different here from other controllers that implement this
same type of functionality?

Creating custom ioctls for every individual controller, leads to an
explosion of different tools needed to manage the same type of devices,
which is madness as I am sure you can imagine.

So please, stick with the standard interfaces if at all possible.

thanks,

greg k-h
