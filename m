From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH]: create sysfs file, dh_state for SCSI	devices
	even if they	are not in the inteernal lists
Date: Tue, 11 Aug 2009 10:54:12 +0200
Message-ID: <4A8131B4.6000605@suse.de>
References: <1246069888.14164.53.camel@chandra-ubuntu>	
	<4A486FF0.7040209@suse.de>
	<1246303830.15941.17.camel@chandra-ubuntu>
	<1249329099.31433.23.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1249329099.31433.23.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: Mario Mech <mech@meteo.uni-koeln.de>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> Hi Hannes,
>=20
> Can you comment on this please.
>=20
> If you are convinced with my justification, please send an ACK.
>=20
> Thanks & Regards,
>=20
> chandra
> On Mon, 2009-06-29 at 12:30 -0700, Chandra Seetharaman wrote:
>> On Mon, 2009-06-29 at 09:40 +0200, Hannes Reinecke wrote:
>>> Chandra Seetharaman wrote:
>>>> Create the sysfs file, dh_state even if the new SCSI device is not
>>>> in the any of the device handler's internal lists.
>>>>
>>>> Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>>>> ---
>>>>  drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
>>>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>>>
>>>> Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
>>>> +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
>>>> @@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
>>>>  	sdev =3D to_scsi_device(dev);
>>>> =20
>>>>  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
>>>> +		err =3D device_create_file(dev, &scsi_dh_state_attr);
>>>> +		/* don't care about err */
>>>>  		devinfo =3D device_handler_match(NULL, sdev);
>>>> -		if (!devinfo)
>>>> -			goto out;
>>>> -
>>>> -		err =3D scsi_dh_handler_attach(sdev, devinfo);
>>>> -		if (!err)
>>>> -			err =3D device_create_file(dev, &scsi_dh_state_attr);
>>>> +		if (devinfo)
>>>> +			err =3D scsi_dh_handler_attach(sdev, devinfo);
>>>>  	} else if (action =3D=3D BUS_NOTIFY_DEL_DEVICE) {
>>>>  		device_remove_file(dev, &scsi_dh_state_attr);
>>>>  		scsi_dh_handler_detach(sdev, NULL);
>>>>  	}
>>>> -out:
>>>>  	return err;
>>>>  }
>>>> =20
>>>>
>>>>
>>>> --
>>>> dm-devel mailing list
>>>> dm-devel@redhat.com
>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>> NACK.
>>>
>>> This will create sysfs attributes even if the attach()
>>> failed for other reason like a generic error. So we'll end
>>> up with device handler attributes and no device handler attached.
>> we do not have to worry about if attach failed or succeeded. We will
>> have "detached" if there is no device handler is attached to a device.=
=20
>>
>> Basically, existence of this file simply means that scsi_dh module is
>> active, only the contents of this file will indicate if any device
>> handler is attached or not.
>>
>> We are just creating the file dh_state for each SCSI device that exist=
s
>> and that is the only way non-in-built devices can be attached to a
>> handler by the end-user.
>>
>> Do note that we do create this file for all the existing scsi devices
>> when the scsi_dh module is inserted (see scsi_dh_init()).
>>
Right. So you're changing the semantics from the 'dh_state' attribute
to mean 'scsi_dh' is active, not 'a scsi_dh module has been attached'.

Ok, that seems reasonable.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
