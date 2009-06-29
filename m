From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [PATCH]: create sysfs file, dh_state for SCSI
 devices even if they	are not in the inteernal lists
Date: Mon, 29 Jun 2009 11:09:03 -0500
Message-ID: <1246291743.3838.13.camel@mulgrave.site>
References: <1246069888.14164.53.camel@chandra-ubuntu>
	 <4A486FF0.7040209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50691 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbZF2QJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2009 12:09:05 -0400
In-Reply-To: <4A486FF0.7040209@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: sekharan@linux.vnet.ibm.com, Mario Mech <mech@meteo.uni-koeln.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-06-29 at 09:40 +0200, Hannes Reinecke wrote:
> Chandra Seetharaman wrote:
> > Create the sysfs file, dh_state even if the new SCSI device is not
> > in the any of the device handler's internal lists.
> > 
> > Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> > 
> > Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
> > ===================================================================
> > --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
> > +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
> > @@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
> >  	sdev = to_scsi_device(dev);
> >  
> >  	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > +		err = device_create_file(dev, &scsi_dh_state_attr);
> > +		/* don't care about err */
> >  		devinfo = device_handler_match(NULL, sdev);
> > -		if (!devinfo)
> > -			goto out;
> > -
> > -		err = scsi_dh_handler_attach(sdev, devinfo);
> > -		if (!err)
> > -			err = device_create_file(dev, &scsi_dh_state_attr);
> > +		if (devinfo)
> > +			err = scsi_dh_handler_attach(sdev, devinfo);
> >  	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> >  		device_remove_file(dev, &scsi_dh_state_attr);
> >  		scsi_dh_handler_detach(sdev, NULL);
> >  	}
> > -out:
> >  	return err;
> >  }
> >  
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> NACK.
> 
> This will create sysfs attributes even if the attach()
> failed for other reason like a generic error. So we'll end
> up with device handler attributes and no device handler attached.
> 
> Not a good idea.

It strikes me that what is really being reinvented here is driver
attachment with driver attribute files ...

Now all of this could be avoided if we had multiple attachment of
drivers ... 

James


