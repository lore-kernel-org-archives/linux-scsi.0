From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Wed, 16 Mar 2016 08:47:30 +0100
Message-ID: <56E90F92.8090105@suse.de>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
 <yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
 <yq1pouve84o.fsf@sermon.lab.mkp.net> <56E90D7F.7080106@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933878AbcCPHrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2016 03:47:32 -0400
In-Reply-To: <56E90D7F.7080106@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>

On 03/16/2016 08:38 AM, Hannes Reinecke wrote:
> On 03/15/2016 10:36 PM, Martin K. Petersen wrote:
>>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>>
>>>> I wonder how many non-compliant devices we would have to blacklist=
 as
>>>> a result of this change...
>>
>> Hannes> But it feels even sillier having to whitelist every
>> Hannes> standards-conformant device here; I certainly was when I fig=
ured
>> Hannes> that EMC Clariion won't work properly without this patch.
>>
>> Hannes> And the idea was to mark off _misbehaving_ drives, not the o=
ther
>> Hannes> way round.
>>
>> I understand. But my concern is that the number of broken USB doodad
>> model strings far outnumber enterprise storage vendor ditto. And the=
re
>> is no point in reversing the polarity if it increases the maintenanc=
e
>> burden.
>>
>> So I would be more comfortable with just widening the VPD whitelist =
and
>> assume that everything with an EMC, Dell, NetApp, whatever vendor ID=
 is
>> compliant.
>>
> Well, yes, that's the bugger. You never know until you try.
>=20
> But we have been asking for VPD pages per default for quite some
> time now from userspace (thanks to udev), and so far have had only a
> few bug reports for misbehaving devices.
>=20
> And again, it just feels wrong to punish every well-behaved device
> out there, for the sake of some buggy USB implementation of a few
> bucks worth.
>=20
And incidentally, for most USB drives VPD pages are already blanked out=
:

drivers/usb/storage/scsiglue.c:slave_configure()
[ .. ]
		/* Some devices don't handle VPD pages correctly */
		sdev->skip_vpd_pages =3D 1;


So it looks we're dealing with a non-issue here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
