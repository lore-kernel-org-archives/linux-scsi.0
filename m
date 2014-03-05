From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Wed, 05 Mar 2014 08:38:01 +0100
Message-ID: <5316D459.6070107@suse.de>
References: <1392286032-85036-1-git-send-email-hare@suse.de> <1392286032-85036-3-git-send-email-hare@suse.de> <20140228170131.GA31510@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaCEHiE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 02:38:04 -0500
In-Reply-To: <20140228170131.GA31510@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/28/2014 06:01 PM, Christoph Hellwig wrote:
> On Thu, Feb 13, 2014 at 11:07:11AM +0100, Hannes Reinecke wrote:
>> EVPD page 0x83 is used to uniquely identify the device.
>> So instead of having each and every program issue a separate
>> SG_IO call to retrieve this information it does make far more
>> sense to display it in sysfs.
>=20
> This just shows binary data from the protocol, so shouldn't it be a
> binary sysfs attribute?
>=20
> In general I have to I prefer the actual text attributes, but this is
> still better than having to do all the SG_IO inquirys.
>=20
Binary sysfs attributes have a rather special handling, and IIRC
they should be used for direct hardware interaction only.
Also the hexdump is easier to parse for the unsuspecting user.

>> - * Returns 0 on success or a negative error number.
>> + * Returns size of the vpg page on success or a negative error numb=
er.
>>   */
>>  static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char=
 *buffer,
>>  							u8 page, unsigned len)
>> @@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *=
sdev, unsigned char *buffer,
>>  	int result;
>>  	unsigned char cmd[16];
>> =20
>> +	if (len < 4)
>> +		return -EINVAL;
>=20
> Seems the change in calling conventions for these existing functions
> should be split into a separate patch?
>=20
Ok.

>>  /**
>> + * scsi_attach_vpd - Attach Vital Product Data to a SCSI device str=
ucture
>> + * @sdev: The device to ask
>> + *
>> + * Attach the 'Device Identification' VPD page (0x83) to a SCSI dev=
ice
>> + * structure. This information can be used to identify the device
>> + * uniquely.
>> + */
>> +void scsi_attach_vpd(struct scsi_device *sdev)
>> +{
>> +	int result, i;
>> +	int vpd_len =3D 255;
>> +	int pg83_supported =3D 0;
>> +	unsigned char *vpd_buf;
>> +
>> +	if (sdev->skip_vpd_pages)
>> +		return;
>> +retry_pg0:
>> +	vpd_buf =3D kmalloc(vpd_len, GFP_KERNEL);
>> +	if (!vpd_buf)
>> +		return;
>> +
>> +	/* Ask for all the pages supported by this device */
>> +	result =3D scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
>> +	if (result < 0) {
>> +		kfree(vpd_buf);
>> +		return;
>> +	}
>> +	if (result > vpd_len) {
>> +		vpd_len =3D result;
>> +		kfree(vpd_buf);
>> +		goto retry_pg0;
>> +	}
>> +
>> +	for (i =3D 4; i < result; i++) {
>> +		if (vpd_buf[i] =3D=3D 0x83) {
>> +			pg83_supported =3D 1;
>> +		}
>> +	}
>> +	kfree(vpd_buf);
>=20
> Given how many checks all over the place we have which EVPD pages are
> suppored shouldn't we have query for evpd 0, and then set flags in th=
e
> scsi device which are present?
>=20
> Either way I think the call to query evpd 0 should be a separate
> function, so even if we don't store the information it's abstracted o=
ut.
>=20
Hmm. That would work if we were just asking for a single page; but
when we're checking several pages (like 0x83 and 0x80) we'd need
either to pass in a page array or querying page 0 several times.
Neither of which is very appealing.

However, specifying additional flags for the individual pages might
work. I'll see what I can come up with.

>=20
> Also the ses code has another query for 0x83, which now could use the
> one attached to the scsi_device.
>=20
Ah. Missed that one. Will be converting it.

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
