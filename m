From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain
 address.
Date: Thu, 11 Aug 2016 18:43:50 +0200
Message-ID: <20160811164350.vakulxlr4xlsyrxn@c203.arch.suse.de>
References: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
 <1470928175.2334.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470928175.2334.9.camel@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 08:09:35AM -0700, James Bottomley wrote:
> On Thu, 2016-08-11 at 09:59 +0200, Johannes Thumshirn wrote:
> > Since commit 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> > enclosures') ses_match_to_enclosure() is calling sas_get_address(),
> > which is coming from commit bcf508c13385 ('scsi_transport_sas: add
> > function to get SAS endpoint address'). sas_get_address() itself 
> > calls sas_sdev_to_rdev() which BUG_ON()s if a given scsi_device's 
> > rphy is not a SAS_END_DEVICE.
> 
> Is the BUG_ON the problem?  you're supposed to gate this call with
> is_sas_attached().
> 
> > As SAS Enclosure is a SAS expander device,
> 
> This isn't necessarily true.  There are several separated enclosure
> chips even in the SAS world (although most of the new ones are
> integrated).

Maybe change it to "As a SAS enclosure can be a SAS expander device, [..]"

> 
> >  we really shouldn't tie the lookup of a SAS address to the SAS End
> > Device but the sas_rphy, which holds the address information.
> 
> This is conceptually wrong.  A wide end device may have many rphys
> forming a port.  In that case the end device address is likely to be
> only one of the rphy addresses ... how do you know this code picks the
> right one?
> 
> > Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> > enclosures')
> > Cc: stable@vger.kernel.org # v4.5+
> 
> What's the actual bug being fixed here?

This is the callchain I have:

ses_init()
`-> scsi_register_interface()
    `-> class_interface_register()
        `-> ses_intf_add()
	    `-> ses_match_to_enclosure()
	        `-> sas_get_address()
		    `-> sas_sdev_to_rdev()
                        `-> BUG_ON(rphy->identify.device_type != SAS_END_DEVICE);
		  	    `-> KABOOM, Bug report, yelling release manager, etc..

Unfortunately I do not have a SAS enclosure here so all I could do was
read the spec and code and have the customer test the patch.

But from my git archeology:
Since 3f8d6f2a0 sas_match_to_enclosure() is calling
sas_get_address(). Which in turn is calling sas_sdev_to_rdev() and so
on...
	
The thing is, in sas_get_address() we want to get the address of a sas
device, don't we?
And looking at the UML diagram in the SAS spec, we see an enclosure as
well as an end device do have a rphy attached to it, which in turn has
a SAS address.

So where is the point in fixing the SAS address retreival to end
devices and not the rphy?

Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
