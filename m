From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller (fwd)
Date: Sat, 05 Sep 2009 10:00:56 -0500
Message-ID: <1252162856.3882.80.camel@mulgrave.site>
References: <alpine.LNX.1.10.0909021704370.3751@rslab159.pmc-sierra.bc.ca>
	 <4A9FDBE4.2090008@linux.vnet.ibm.com>
	 <alpine.LNX.1.10.0909030959100.11364@rslab159.pmc-sierra.bc.ca>
	 <4AA03620.70904@linux.vnet.ibm.com>
	 <alpine.LNX.1.10.0909031637330.11364@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42689 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbZIEPBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 11:01:00 -0400
In-Reply-To: <alpine.LNX.1.10.0909031637330.11364@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, gregkh@suse.de

On Thu, 2009-09-03 at 16:43 -0700, Anil Ravindranath wrote:
> 
> On Thu, 3 Sep 2009, Brian King wrote:
> 
> > Anil Ravindranath wrote:
> > > Hi Brian,
> > > 
> > > 
> > > On Thu, 3 Sep 2009, Brian King wrote:
> > > 
> > >> Anil,
> > >>
> > >> Taking a quick scan through the driver, I would suggest you audit your
> > >> logging. Looks like there is a lot of dev_err, where sdev_printk might be
> > >> better,
> > > 
> > > I hope I am understanding this correct...
> > > 
> > > I don't see a difference in using dev_err Vs. sdev_printk. B'coz both call
> > > dev_printk except the prefix of KERN_ERR. But I guess even if we use
> > > sdev_printk we will use KERN_ERR anyways. Also both refer "Generic device
> > > interface".
> > > 
> > > #define dev_err(dev, format, arg...)            \   
> > >         dev_printk(KERN_ERR , dev , format , ## arg)
> > > 
> > > #define sdev_printk(prefix, sdev, fmt, a...)    \
> > >         dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
> > 
> > The difference is the dev pointer that gets passed to dev_printk. When calling
> > sdev_printk, the dev pointer for the scsi device gets passed, so the printk
> > ends up getting prefixed with the SCSI location: 0:0:0:0, for example where
> > you have SCSI Host:Bus:Target:LUN. The dev_err calls I see in the driver
> > generally pass the dev pointer of the PCI device, resulting in the PCI location
> > of the adapter being logged. Its just a matter of scoping the printk to the
> > device.
> >
> 
> Sure. We will make this change wherever its applicable like places where 
> we need scsi device location in the prints.
>  
> > > 
> > > struct scsi_device {
> > > 
> > > struct device           sdev_gendev;
> > >  
> > > }
> > > 
> > >  and pmcraid_info where sdev_info might be better, etc.
> > > Where/what is this sdev_info?
> > 
> > There isn't one... I meant to say dev_info, sdev_printk, scmd_printk, etc... 
> > 
> 
> We will change this accordingly wherever applicable. There will be places 
> where we still want to call pmcraid_info prints which we want to 
> control using debug flag parameter.

These patches are mainly cosmetic.  I'll put the current driver in as-is
on the understanding that you'll submit this lot as an update patch.

James


