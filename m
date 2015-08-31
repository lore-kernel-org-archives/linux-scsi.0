From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/10] dm-mpath, scsi_dh: request scsi_dh modules in
 scsi_dh, not dm-mpath
Date: Mon, 31 Aug 2015 08:39:35 +0200
Message-ID: <55E3F6A7.3050207@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
 <1440677823-11695-3-git-send-email-hare@suse.de>
 <1440791597.2202.49.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbbHaGji (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2015 02:39:38 -0400
In-Reply-To: <1440791597.2202.49.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On 08/28/2015 09:53 PM, James Bottomley wrote:
> On Thu, 2015-08-27 at 14:16 +0200, Hannes Reinecke wrote:
>> @@ -158,7 +171,7 @@ store_dh_state(struct device *dev, struct device=
_attribute *attr,
>>  		/*
>>  		 * Attach to a device handler
>>  		 */
>> -		if (!(scsi_dh =3D get_device_handler(buf)))
>> +		if (!(scsi_dh =3D scsi_dh_lookup(buf)))
>=20
> This one's a checkpatch error:
>=20
> ERROR: do not use assignment in if condition
> #71: FILE: drivers/scsi/device_handler/scsi_dh.c:174:
> +               if (!(scsi_dh =3D scsi_dh_lookup(buf)))
>=20
>=20
> For very good reason.  The meaning is obvious from the previous code,=
 so
> I fixed it up as
>=20
> 		scsi_dh =3D scsi_dh_lookup(buf);
> 		if (!scsi_dh)
>=20
> But running the series through checkpatch and acting on at least the
> errors would have been appreciated.
>=20
You're right, sorry. Thanks for fixing it up.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
