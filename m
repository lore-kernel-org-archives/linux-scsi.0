From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Should isci create its own device class?
Date: Wed, 02 Mar 2011 07:49:06 -0500
Message-ID: <1299070146.604.3.camel@mulgrave.site>
References: <4D6DB7FF.4090506@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab1CBMtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2011 07:49:18 -0500
In-Reply-To: <4D6DB7FF.4090506@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>

On Tue, 2011-03-01 at 19:22 -0800, Dan Williams wrote:
> For compatibility with other software raid environments an isci [1] 
> device may contain up to two controller instances per pci device.

So every other SCSI card I've seen that's done this, the multiple
controllers have been different PCI functions, and thus distinguishable
at the PCI level ... why is isci different?

> Currently the sysfs path for its scsi_host objects is:
> > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host10/scsi_host/host10
> > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/host11/scsi_host/host11
> 
> But to reflect reality the pci device is actually the parent of two 
> independent controller instances.  With a mockup like:
> > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller0/host10/scsi_host/host10
> > ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0/0000:03:00.0/controller1/host11/scsi_host/host11
> 
> I can see this being beneficial in a few ways:
> 
> 1/ fix dev_printk() messages which right now give an ambiguous "isci 
> 0000:03:00.0" prefix
> 2/ controller boundaries are visible via the sysfs path without need to 
> to look at sas_addresses to determine the controller.
> 2/ if we ever wanted to support some per controller attributes between 
> the global pci attributes and the scsi_host attributes.

So what's wrong with just using the hostX for this instead of inventing
a new dummy level in the tree?

> ...but would this confuse /dev/disk/by-path/ or any other unintended 
> side effects?

Yes and no ... yes as in this extra piece now has to be in the tree so
any tool that actually parses by path could get confused, but no because
all the usual links will update correctly.

James


