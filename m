From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Wed, 05 Mar 2014 08:56:04 +0100
Message-ID: <5316D894.1000808@suse.de>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <1392287281-75002-3-git-send-email-hare@suse.de> <5312ED18.8080905@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaCEH4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 02:56:06 -0500
In-Reply-To: <5312ED18.8080905@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 03/02/2014 09:34 AM, Bart Van Assche wrote:
> On 02/13/14 11:28, Hannes Reinecke wrote:
>>  static ssize_t
>> -show_iostat_counterbits(struct device *dev, struct device_attribute=
 *attr, 				char *buf)
>> +show_vpd_pg(const unsigned char *pg_buf, int pg_len, char *buf)
>> +{
>> +	int len =3D 0, i;
>> +
>> +	if (!pg_buf)
>> +		return -EINVAL;
>> +
>> +	len =3D 0;
>> +	for (i =3D 0; i < pg_len; i +=3D 16) {
>> +		hex_dump_to_buffer(pg_buf + i, pg_len, 16, 1,
>> +				   buf + len, PAGE_SIZE, false);
>> +		strcat(buf + len, "\n");
>> +		len +=3D strlen(buf + len);
>> +	}
>> +	return len;
>> +}
>=20
> It might be a good idea to add the output buffer length as an argumen=
t
> in show_vpd_pg() and to check explicitly whether or not there is
> sufficient space left in the output buffer.
>=20
Good point. Will be doing so.

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
