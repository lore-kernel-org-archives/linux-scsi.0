From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/23] scsi: Add 'access_state' attribute
Date: Fri, 12 Feb 2016 08:16:47 +0100
Message-ID: <56BD86DF.3060606@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <1454942086-128704-21-git-send-email-hare@suse.de>
 <1455222807.22112.336.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbcBLHQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 02:16:49 -0500
In-Reply-To: <1455222807.22112.336.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/11/2016 09:33 PM, Ewan Milne wrote:
> On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
>> Add an 'access_state' attribute to struct scsi_device to
>> display the asymmetric LUN access state.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi_scan.c   |  1 +
>>  drivers/scsi/scsi_sysfs.c  | 49 +++++++++++++++++++++++++++++++++++=
+++++++++++
>>  include/scsi/scsi_device.h |  1 +
>>  include/scsi/scsi_proto.h  | 13 ++++++++++++
>>  4 files changed, 64 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 97074c9..5bf3945 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struc=
t scsi_target *starget,
>>  	sdev->lun =3D lun;
>>  	sdev->channel =3D starget->channel;
>>  	sdev->sdev_state =3D SDEV_CREATED;
>> +	sdev->access_state =3D SCSI_ACCESS_STATE_UNKNOWN;
>>  	INIT_LIST_HEAD(&sdev->siblings);
>>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>>  	INIT_LIST_HEAD(&sdev->cmd_list);
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 4f18a85..8d154ed 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -81,6 +81,34 @@ const char *scsi_host_state_name(enum scsi_host_s=
tate state)
>>  	return name;
>>  }
>> =20
>> +static const struct {
>> +	enum scsi_access_state	value;
>> +	char			*name;
>> +} sdev_access_states[] =3D {
>> +	{ SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
>> +	{ SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
>> +	{ SCSI_ACCESS_STATE_STANDBY, "standby" },
>> +	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
>> +	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
>> +	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
>> +	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
>> +	{ SCSI_ACCESS_STATE_UNKNOWN, "unknown" },
>> +};
>> +
>> +const char *scsi_access_state_name(enum scsi_access_state state)
>> +{
>> +	int i;
>> +	char *name =3D NULL;
>> +
>> +	for (i =3D 0; i < ARRAY_SIZE(sdev_access_states); i++) {
>> +		if (sdev_access_states[i].value =3D=3D state) {
>> +			name =3D sdev_access_states[i].name;
>> +			break;
>> +		}
>> +	}
>> +	return name;
>> +}
>> +
>>  static int check_set(unsigned long long *val, char *src)
>>  {
>>  	char *last;
>> @@ -973,6 +1001,26 @@ sdev_store_dh_state(struct device *dev, struct=
 device_attribute *attr,
>> =20
>>  static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
>>  		   sdev_store_dh_state);
>> +
>> +static ssize_t
>> +sdev_show_access_state(struct device *dev,
>> +		       struct device_attribute *attr,
>> +		       char *buf)
>> +{
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +	enum scsi_access_state access_state;
>> +	bool pref =3D false;
>> +
>> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
>> +		pref =3D true;
>> +
>> +	access_state =3D (sdev->access_state & SCSI_ACCESS_STATE_MASK);
>=20
> I personally think it is a mistake to stick an extra bit in the
> top of a variable declared as an enum like this.  It opens up
> the possibility of subtle bugs if someone changes the code in
> the future and does not take care to preserve your extra bit.
>=20
But I felt even more stupid adding yet another bit to the
scsi_device structure ...

>> +
>> +	return snprintf(buf, 32, "%s%s\n",
>> +			scsi_access_state_name(access_state),
>> +			pref ? " preferred" : "");
>> +}
>> +static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, N=
ULL);
>>  #endif
>> =20
>>  static ssize_t
>> @@ -1047,6 +1095,7 @@ static struct attribute *scsi_sdev_attrs[] =3D=
 {
>>  	&dev_attr_wwid.attr,
>>  #ifdef CONFIG_SCSI_DH
>>  	&dev_attr_dh_state.attr,
>> +	&dev_attr_access_state.attr,
>>  #endif
>>  	&dev_attr_queue_ramp_up_period.attr,
>>  	REF_EVT(media_change),
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 4af2b24..af16a0d 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -201,6 +201,7 @@ struct scsi_device {
>>  	struct scsi_device_handler *handler;
>>  	void			*handler_data;
>> =20
>> +	enum scsi_access_state	access_state;
>>  	enum scsi_device_state sdev_state;
>>  	unsigned long		sdev_data[0];
>>  } __attribute__((aligned(sizeof(unsigned long))));
>> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
>> index a9fbf1b..80e85e7 100644
>> --- a/include/scsi/scsi_proto.h
>> +++ b/include/scsi/scsi_proto.h
>> @@ -277,5 +277,18 @@ struct scsi_lun {
>>  	__u8 scsi_lun[8];
>>  };
>> =20
>> +/* SPC asymmetric access states */
>> +enum scsi_access_state {
>> +	SCSI_ACCESS_STATE_OPTIMAL =3D 0,
>> +	SCSI_ACCESS_STATE_ACTIVE,
>> +	SCSI_ACCESS_STATE_STANDBY,
>> +	SCSI_ACCESS_STATE_UNAVAILABLE,
>> +	SCSI_ACCESS_STATE_LBA,
>> +	SCSI_ACCESS_STATE_OFFLINE =3D 0xe,
>> +	SCSI_ACCESS_STATE_TRANSITIONING =3D 0xf,
>> +	SCSI_ACCESS_STATE_UNKNOWN =3D 0x70,
>> +};
>=20
> Given that these values are defined by the T10 spec and their values
> matter, I think it would be prudent to assign specific values to each
> enum constant, rather than just let the compiler do that.
>=20
=46air point.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
