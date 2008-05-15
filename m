From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] scsi_dh: Add 'dh_state' sysfs attribute
Date: Thu, 15 May 2008 09:23:39 +0200
Message-ID: <482BE4FB.4080800@suse.de>
References: <20080514144315.968DE10B5DF@craiglockhart-ipmi.suse.de> <1210819555.21974.253.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:47530 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYEOHXl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 03:23:41 -0400
In-Reply-To: <1210819555.21974.253.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>

Chandra Seetharaman wrote:
> On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
>> Implement a 'dh_state' sdev attribute for dynamic device handler
>> manipulation. A read on the attribute will return the name of
>> the currently attached device handler or 'detached' if no handler
>> is attached.
>> The attribute allows the following strings to be written:
>> - The name of the device handler to be attached if the state is
>>   'detached'.
>> - 'activate' to trigger path activation if a device handler
>>   is attached.
>> - 'detach' to detach the currently attached device handler.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>=20
> All the sysfs functions can be grouped together. Helps in readability=
=2E
>=20
?? But I did ... Or thought so, anyway. Checking.

>>  drivers/scsi/device_handler/scsi_dh.c |   88 ++++++++++++++++++++++=
+++++++++++
>>  1 files changed, 88 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/de=
vice_handler/scsi_dh.c
>> index 55e5fd2..2dbf84b 100644
>> --- a/drivers/scsi/device_handler/scsi_dh.c
>> +++ b/drivers/scsi/device_handler/scsi_dh.c
>> @@ -54,6 +54,55 @@ static struct scsi_device_handler *get_device_han=
dler(const char *name)
>>  	return found;
>>  }
>>
>> +static ssize_t
>> +store_dh_state(struct device *dev, struct device_attribute *attr,
>> +	       const char *buf, size_t count)
>> +{
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +	struct scsi_device_handler *scsi_dh;
>> +	int err =3D -EINVAL;
>> +
>> +	if (!sdev->scsi_dh_data) {
>> +		/*
>> +		 * Attach to a device handler
>> +		 */=20
>> +		if (!(scsi_dh =3D get_device_handler(buf)))
>> +			return err;
>> +		err =3D scsi_dh_handler_attach(sdev, scsi_dh);
>> +	} else {
>> +		/*
>> +		 * Detach from a device handler
>> +		 */
>> +		if (!strncmp(buf, "detach", 6)) {
>> +			err =3D scsi_dh_handler_detach(sdev);
>> +		} else if (!strncmp(buf, "activate", 8)) {
>> +			scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
>> +
>> +			err =3D scsi_dh->activate(sdev);
>> +		}
>> +	}
>> +
>> +	return err<0?err:count;
>> +}
>> +
>> +static ssize_t
>> +show_dh_state(struct device *dev, struct device_attribute *attr, ch=
ar *buf)
>> +{
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +	struct scsi_device_handler *scsi_dh;
>> +
>> +	if (!sdev->scsi_dh_data)
>> +		return snprintf(buf, 20, "detached\n");
>> +
>> +	scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
>=20
> we can use it directly instead of this variable ?
>=20
Yes.

>> +
>> +	return snprintf(buf, 20, "%s\n", scsi_dh->name);
>> +}
>> +
>> +static struct device_attribute scsi_dh_state_attr =3D
>> +	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
>> +	       store_dh_state);
>> +
>>  /*
>>   * scsi_dh_handler_attach - Attach a device handler to a device
>>   * @sdev - SCSI device the device handler should attach to
>> @@ -115,9 +164,11 @@ static int scsi_dh_notifier(struct notifier_blo=
ck *nb,
>>
>>  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
>>  		scsi_dh_handler_attach(sdev, devinfo->handler);
>> +		device_create_file(dev, &scsi_dh_state_attr);
>=20
> A later patch checks for the return status of scsi_dh_handler_attach(=
),
> should be moved here.
>=20
Ok.

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
