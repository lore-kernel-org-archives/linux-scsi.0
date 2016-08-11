From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain
 address.
Date: Thu, 11 Aug 2016 11:00:07 -0700
Message-ID: <1470938407.2334.36.camel@linux.vnet.ibm.com>
References: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
	 <1470928175.2334.9.camel@linux.vnet.ibm.com>
	 <20160811164350.vakulxlr4xlsyrxn@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160811164350.vakulxlr4xlsyrxn@c203.arch.suse.de>
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-08-11 at 18:43 +0200, Johannes Thumshirn wrote:
> On Thu, Aug 11, 2016 at 08:09:35AM -0700, James Bottomley wrote:
> > On Thu, 2016-08-11 at 09:59 +0200, Johannes Thumshirn wrote:
> > > Since commit 3f8d6f2a0 ('ses: fix discovery of SATA devices in
> > > SAS
> > > enclosures') ses_match_to_enclosure() is calling
> > > sas_get_address(),
> > > which is coming from commit bcf508c13385 ('scsi_transport_sas:
> > > add
> > > function to get SAS endpoint address'). sas_get_address() itself 
> > > calls sas_sdev_to_rdev() which BUG_ON()s if a given scsi_device's
> > > rphy is not a SAS_END_DEVICE.
> > 
> > Is the BUG_ON the problem?  you're supposed to gate this call with
> > is_sas_attached().
> > 
> > > As SAS Enclosure is a SAS expander device,
> > 
> > This isn't necessarily true.  There are several separated enclosure
> > chips even in the SAS world (although most of the new ones are
> > integrated).
> 
> Maybe change it to "As a SAS enclosure can be a SAS expander device,
> [..]"
> 
> > 
> > >  we really shouldn't tie the lookup of a SAS address to the SAS
> > > End
> > > Device but the sas_rphy, which holds the address information.
> > 
> > This is conceptually wrong.  A wide end device may have many rphys
> > forming a port.  In that case the end device address is likely to
> > be
> > only one of the rphy addresses ... how do you know this code picks
> > the
> > right one?
> > 
> > > Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> > > enclosures')
> > > Cc: stable@vger.kernel.org # v4.5+
> > 
> > What's the actual bug being fixed here?
> 
> This is the callchain I have:
> 
> ses_init()
> `-> scsi_register_interface()
>     `-> class_interface_register()
>         `-> ses_intf_add()
> 	    `-> ses_match_to_enclosure()
> 	        `-> sas_get_address()
> 		    `-> sas_sdev_to_rdev()
>                         `-> BUG_ON(rphy->identify.device_type !=
> SAS_END_DEVICE);
> 		  	    `-> KABOOM, Bug report, yelling release
> manager, etc..

So what is at the end?  is_sas_attached() indicates the transport class
attached to something and that something generated an sdev ... that can
only happen I think if that something is an end device.

> Unfortunately I do not have a SAS enclosure here so all I could do 
> was read the spec and code and have the customer test the patch.
> 
> But from my git archeology:
> Since 3f8d6f2a0 sas_match_to_enclosure() is calling
> sas_get_address(). Which in turn is calling sas_sdev_to_rdev() and so
> on...
> 	
> The thing is, in sas_get_address() we want to get the address of a 
> sas device, don't we? And looking at the UML diagram in the SAS spec, 
> we see an enclosure as well as an end device do have a rphy attached 
> to it, which in turn has a SAS address.

Because, as I said in the previous reply, the rphy is only the sas
address for non-wide ports.  They phy layer is just above the physical
layer.  The end device sits at the application layer, which is four
layers above that. Whatever diagram you're looking at is probably
showing port layer connections.  The way the transport class works is
that each rphy, even when part of a formed wide port, is individually
addressable, so we can send SMP phy controls to it, but the device is
separately addressable by its own SAS address.

James


> So where is the point in fixing the SAS address retreival to end
> devices and not the rphy?
> 
> Johannes
