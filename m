From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Wed, 26 Jan 2011 16:54:24 +0100
Message-ID: <4D4043B0.5070209@suse.de>
References: <4D385C0A.3000901@suse.de>  <4D385F69.5060209@interlog.com> <1295541361.3014.8.camel@mulgrave.site> <4D3C100C.1010609@panasas.com> <4D3D327F.1040807@suse.de> <4D3D43BB.1060805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1AZPrG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2011 10:47:06 -0500
In-Reply-To: <4D3D43BB.1060805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 01/24/2011 10:17 AM, Boaz Harrosh wrote:
> On 01/24/2011 10:04 AM, Hannes Reinecke wrote:
[ .. ]
>> Ah, if it were so easy. Currently sense codes have two problems:
>>
>> - They are limited to 96 bytes. Anything larger than that will just
>>   be discarded (or crash with your patch above :-)
>=20
> It will not crash.
>=20
Oh, indeed. You are right.

> I have a patchset here that expands the request/scsi_cmnd sense_buffe=
r
> support to the maximum 260 bytes supported by the std.
>=20
> If you want I can revive it. It is a sweep of all drivers, but a smal=
l
> one, nothing like the accessors changes.
>=20
Please. Can you send it to me?
I have a prototype working right now, and expanding the sense buffer
would be a good idea here.

>> - They inherit the same lifetime than the scsi command. But for any
>>   decent handling you really need to push them into some
>>   asynchronous context as you might well be within an interrupt
>>   handler here.
>=20
> No that's fine. request->sense is a user supplied buffer that extends
> the life of scsi_cmnd. above code just copies from a scsi-layer dma-a=
ble
> buffer to the request->sense buffer. interrupt-time is fine.
>=20
>> I'm currently working on a handling framework using relayfs
>> (basically blktrace for SCSI Unit Attention); I can be doing a short
>> presentation at LSF if requested.
>>
>=20
> That would be interesting. Thanks
>=20
Ok, will then be doing it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
