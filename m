From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] scsi: ufs & ums-* & esp_scsi: fix module reference
 counting
Date: Tue, 5 May 2015 10:25:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1505051002320.1639-100000@iolanthe.rowland.org>
References: <1430775664.2177.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2993173AbbEEOZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 10:25:30 -0400
In-Reply-To: <1430775664.2177.36.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 4 May 2015, James Bottomley wrote:

> On Mon, 2015-05-04 at 16:09 -0400, Alan Stern wrote:
> > On Mon, 4 May 2015, James Bottomley wrote:
> > 
> > > However, it does also strike me that these three drivers have problems
> > > because they're using the wrong initialisation pattern: the template is
> > > supposed to be in the bus connector for compound drivers not in the
> > > core.
> > 
> > Why is it supposed to be done that way?  Isn't that less efficient?  It 
> > means you have to have a separate copy of the template for each bus 
> > connector driver, instead of letting them all share a common template 
> > in the core.
> 
> Well, no it doesn't.  The way 53c700 implements it is that there is a
> common template in the core.  The drivers just initialise their variant
> fields (for 53c700 it's name, proc_name and this_id) and the core fills
> in the rest.  Admittedly wd33c93 doesn't quite get this right, that's
> why I cited 53c700.

You seem to be agreeing with me, even though you think you are 
disagreeing.

	"... there is a common template in the core." -- that's one
	scsi_host_template structure.

	"The drivers just initialize their variant fields ... and the
	core fills in the rest." -- that's an additional
	scsi_host_template structure for each driver.

The total comes to N+1 scsi_host_templates, where N is the number of 
drivers.

Now consider the way usb-storage does things.

	There is a common template in the core.  That's one
	scsi_host_template structure.

	The drivers use the core's template.  They have _no_ variant
	fields other than .owner.  That's why I thought Akinobu's idea
	of putting the owner field in the Scsi_Host structure was a
	good idea.

The total comes to 1 scsi_host_template.  Is that not better than N+1?

Consider the patch Akinobu just posted.  In addition to a whole bunch 
of new code, it adds this:

> --- a/drivers/usb/storage/alauda.c
> +++ b/drivers/usb/storage/alauda.c
...
> @@ -1232,6 +1233,8 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
>  	return USB_STOR_TRANSPORT_FAILED;
>  }
>  
> +static struct scsi_host_template alauda_host_template;

alauda.c was the only driver modified in that patch, and it gained an 
new scsi_host_template.

For the case where the variants are identical in all respects other 
than .owner, doesn't it make sense to allow them to share a single 
scsi_host_template?

The original design of the SCSI stack envisioned multiple drivers, each 
in control of multiple SCSI hosts.  The idea was that 
scsi_host_template would be associated with the driver and Scsi_Host 
with the individual host.

Now the kernel has evolved, and we have multiple drivers, some of which
contain multiple subdrivers, each in control of multiple SCSI hosts.  
In this situation we should be flexible enough to allow the
scsi_host_template to be associated with either the driver or the
subdriver (decision to be made by the driver).  When the only variant
field is .owner, it makes sense to associate the scsi_host_template
with the driver, not force it to be associated with the subdriver.

The cost is duplication of the .owner field in every Scsi_Host.  The 
savings is a reduction in the number of scsi_host_templates.

Alan Stern

