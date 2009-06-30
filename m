From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH]: create sysfs file, dh_state for SCSI	devices
 even if they	are not in the inteernal lists
Date: Tue, 30 Jun 2009 08:39:22 +0200
Message-ID: <4A49B31A.1060304@suse.de>
References: <1246069888.14164.53.camel@chandra-ubuntu>	<4A486FF0.7040209@suse.de> <1246291743.3838.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZF3GjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 02:39:21 -0400
In-Reply-To: <1246291743.3838.13.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mario Mech <mech@meteo.uni-koeln.de>, linux-scsi <linux-scsi@vger.kernel.org>, sekharan@linux.vnet.ibm.com

James Bottomley wrote:
> On Mon, 2009-06-29 at 09:40 +0200, Hannes Reinecke wrote:
>> Chandra Seetharaman wrote:
>>> Create the sysfs file, dh_state even if the new SCSI device is not
>>> in the any of the device handler's internal lists.
>>>
>>> Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>>> ---
>>>  drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
>>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>>
>>> Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
>>> +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
>>> @@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
>>>  	sdev =3D to_scsi_device(dev);
>>> =20
>>>  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
>>> +		err =3D device_create_file(dev, &scsi_dh_state_attr);
>>> +		/* don't care about err */
>>>  		devinfo =3D device_handler_match(NULL, sdev);
>>> -		if (!devinfo)
>>> -			goto out;
>>> -
>>> -		err =3D scsi_dh_handler_attach(sdev, devinfo);
>>> -		if (!err)
>>> -			err =3D device_create_file(dev, &scsi_dh_state_attr);
>>> +		if (devinfo)
>>> +			err =3D scsi_dh_handler_attach(sdev, devinfo);
>>>  	} else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE) {
>>>  		device_remove_file(dev, &scsi_dh_state_attr);
>>>  		scsi_dh_handler_detach(sdev, NULL);
>>>  	}
>>> -out:
>>>  	return err;
>>>  }
>>> =20
>>>
>>>
>> NACK.
>>
>> This will create sysfs attributes even if the attach()
>> failed for other reason like a generic error. So we'll end
>> up with device handler attributes and no device handler attached.
>>
>> Not a good idea.
>=20
> It strikes me that what is really being reinvented here is driver
> attachment with driver attribute files ...
>=20
> Now all of this could be avoided if we had multiple attachment of
> drivers ...=20
>=20
I heard you.

If you find someone to fix the blasted iSCSI I/O stall for me ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
