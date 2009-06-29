From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH]: create sysfs file, dh_state for SCSI
	devices even if they	are not in the inteernal lists
Date: Mon, 29 Jun 2009 12:30:30 -0700
Message-ID: <1246303830.15941.17.camel@chandra-ubuntu>
References: <1246069888.14164.53.camel@chandra-ubuntu>
	<4A486FF0.7040209@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A486FF0.7040209@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mario Mech <mech@meteo.uni-koeln.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


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

we do not have to worry about if attach failed or succeeded. We will
have "detached" if there is no device handler is attached to a device. 

Basically, existence of this file simply means that scsi_dh module is
active, only the contents of this file will indicate if any device
handler is attached or not.

We are just creating the file dh_state for each SCSI device that exists
and that is the only way non-in-built devices can be attached to a
handler by the end-user.

Do note that we do create this file for all the existing scsi devices
when the scsi_dh module is inserted (see scsi_dh_init()).

> 
> Not a good idea.

I do not agree, and we do need to have this fix for dh_state file to be
functionally useful.

> 
> Cheers,
> 
> Hannes
