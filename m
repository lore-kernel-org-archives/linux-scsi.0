From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Mon, 10 Feb 2014 15:55:08 +0100
Message-ID: <52F8E84C.60602@suse.de>
References: <1392030699-105348-1-git-send-email-hare@suse.de> <20140210141534.GA17671@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaBJOzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Feb 2014 09:55:11 -0500
In-Reply-To: <20140210141534.GA17671@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 02/10/2014 03:15 PM, Christoph Hellwig wrote:
> On Mon, Feb 10, 2014 at 12:11:39PM +0100, Hannes Reinecke wrote:
>> +	int vpd_len =3D 255;
>> +	unsigned char *buffer;
>> +retry:
>> +	buffer =3D kmalloc(vpd_len, GFP_KERNEL);
>> +	if (!buffer)
>> +		return;
>> +
>> +	ret =3D scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
>> +	if (ret) {
>> +		kfree(buffer);
>> +		return;
>> +	}
>> +
>> +	vpd_len =3D (buffer[2] << 8) + buffer[3];
>> +	if (vpd_len > 255) {
>> +		kfree(buffer);
>> +		goto retry;
>=20
> Won't this create an infinite loop if the VPD is longer than 255 byte=
s?
>=20
Hmm. Sort of.

Gnaa.

Will be redoing the patch.

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
