From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain
 address.
Date: Fri, 12 Aug 2016 07:34:35 -0700
Message-ID: <1471012475.2407.6.camel@linux.vnet.ibm.com>
References: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
	 <1470928175.2334.9.camel@linux.vnet.ibm.com>
	 <20160811164350.vakulxlr4xlsyrxn@c203.arch.suse.de>
	 <1470938407.2334.36.camel@linux.vnet.ibm.com>
	 <20160812100854.4cks5qxsommfwsjk@c203.arch.suse.de>
	 <20160812131125.n7p47dcf7sinwg54@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160812131125.n7p47dcf7sinwg54@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-08-12 at 15:11 +0200, Johannes Thumshirn wrote:
> On Fri, Aug 12, 2016 at 12:08:54PM +0200, Johannes Thumshirn wrote:
> > Ok, we can't use the rphy because of wide-ports. We can't fix it to 
> > an end device either, as this makes some peoples systems 
> > unbootable. Now let's find a third option satisfying the needs of 
> > SAS wide-ports and my customers (and others running 4.5+ with a SAS
> > enclosure).
> > 
> > I'm digging...
> 
> 
> To answer myself, Hannes suggested doing it like this:
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 53ef1cb6..1d82053 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct
> enclosure_device *edev,
> 
>         ses_enclosure_data_process(edev, to_scsi_device(edev
> ->edev.parent), 0);
> 
> -       if (is_sas_attached(sdev))
> +       if (scsi_is_sas_rphy(&sdev->sdev_gendev))
>                 efd.addr = sas_get_address(sdev);
> 
> 		if (efd.addr) {
> 
> 
> The reasoning behind this is, we only read the address if we have an
> actual sas_rphy.
> 
> Would this be OK for you?

Could you please debug the why? first before we start throwing patches
around.  is_sas_attached(sdev) returns true if the sdev is the child of
a SAS controller.  What is this thing you've found that has a sdev
attached to a SAS controller but isn't and end device?

if is_sas_attached() passes but scsi_is_sas_rphy() doesn't you've got a
device that is the child of a SAS host which has an rphy but which
isn't an expander or end device.  That's pretty much the end of the
list of things which can lie at the end of rphys since we lump the SATA
possibilities in with end devices.

James
