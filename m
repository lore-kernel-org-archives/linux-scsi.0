From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Sat, 20 Feb 2016 09:03:01 +0100
Message-ID: <56C81DB5.7070102@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424530AbcBTIDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Feb 2016 03:03:05 -0500
In-Reply-To: <56C7688A.2050608@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/19/2016 08:10 PM, Bart Van Assche wrote:
> On 02/19/2016 12:17 AM, Hannes Reinecke wrote:
>> +static ssize_t
>> +sdev_show_access_state(struct device *dev,
>> +		       struct device_attribute *attr,
>> +		       char *buf)
>> +{
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);
>> +	unsigned char access_state;
>> +	const char *access_state_name;
>> +	bool pref =3D false;
>> +
>> +	if (!sdev->handler)
>> +		return -EINVAL;
>> +
>> +	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
>> +		pref =3D true;
>> +
>> +	access_state =3D (sdev->access_state & SCSI_ACCESS_STATE_MASK);
>> +	access_state_name =3D scsi_access_state_name(access_state);
>> +
>> +	return snprintf(buf, 32, "%s%s\n",
>> +			access_state_name ? access_state_name : "unknown",
>> +			pref ? " preferred" : "");
>> +}
>
> Hello Hannes,
>
> What is inelegant about the above approach is that the access_state a=
ttribute
> is added to all SCSI devices, whether or not a device handler has bee=
n attached,
> and that reading that attribute doesn't fail for devices to which ano=
ther handler
> than the ALUA handler has been attached. How about the patch below, w=
hich moves
> the access_state show handler to the scsi_dh_alua.c source file, wher=
e it belongs?
>
Actually, this was my first approach, but hch suggested moving it to
the generic code :-(

Also when using your suggestion the 'access_state' attribute will only=20
be created _after_ the 'ADD' uevent, making it impossible to use it fro=
m=20
udev events.

However, I'm currently working on using the 'is_visible' callback for=20
SCSI sysfs attributes for this; in theory it should be possible to
use 'sysfs_update_groups()' during scsi_add_lun() to blank out the
unsupported attributes.

Which I think might be the best approach here.

But probably not for this patch series; I'd rather have the alua update=
=20
in first as it took long enough.

If you're absolutely against it we can drop the 'access_state' patches
(ie patch 20-22) and have them folded into a separate patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
