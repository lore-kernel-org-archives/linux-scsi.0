From: Hannes Reinecke <hare@suse.de>
Subject: Re: T10 adds locally assigned UUID designation descriptor
Date: Tue, 9 Feb 2016 16:30:11 +0100
Message-ID: <56BA0603.1040003@suse.de>
References: <56B8D14D.7020502@interlog.com>
 <1454958000.2543.39.camel@HansenPartnership.com>
 <56B8F4BE.6050700@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbcBIPaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Feb 2016 10:30:13 -0500
In-Reply-To: <56B8F4BE.6050700@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Knight, Frederick" <Frederick.Knight@netapp.com>

On 02/08/2016 09:04 PM, Douglas Gilbert wrote:
> On 16-02-08 02:00 PM, James Bottomley wrote:
>> On Mon, 2016-02-08 at 12:33 -0500, Douglas Gilbert wrote:
>>> Recently, in draft spc5r08, T10 added a locally assigned RFC 4122
>>> UUID *** designation descriptor. That descriptor can now be
>>> returned for VPD page 0x83 (device identification) amongst others.
>>> It can be used anywhere SCSI needs a unique identifier expanding
>>> the previous set of preferred identifiers: EUI, NAA and SCSI_name
>>> (iSCSI).
>>>
>>> In the soon to be released sg3_utils version 1.42 the new UUID
>>> designation descriptor is decoded including Hannes' --export
>>> option found in sg_inq, for example:
>>>
>>> # sg_inq --export /dev/sg0
>>>     ...
>>>     SCSI_IDENT_LUN_UUID=3D11223344-5566-7788-aabb-ccddeeffffee
>>>
>>> Perhaps some udev work is needed to incorporate this new identifier=
=2E
>>
>> Hm, we're going to have to do this carefully.  With the move to GPT
>> partitions, both the UUID=3D designator in fstab and the /dev/disk/b=
y
>> -uuid/ of udev means the GPT UUID.  In theory the design of the UUID
>> space is to allow random selection without clashing, so we could jus=
t
>> place the SCSI ones in here as well and perhaps there won't be a
>> problem, but I'd like us to think about the consequences first.
>=20
> The UUID proposal (16-005r1 from Fred Knight and "Dr. Hannes Reinecke=
")
> was somewhat controversial with five T10 members voting against it. T=
he
> minutes state: "The members voting no stated concern that this propos=
al
> may result in market confusion, and those members intend to develop
> proposals to mitigate any confusion."
>=20
> Locally assigned identifiers are not new: there already is an 8 byte
> locally assigned NAA identifier (NAA=3D3). It is not much used, perha=
ps
> the new locally assigned UUID (which is 16 bytes long) will find
> more use. As for the 'sg_inq --export' naming, that seems to nail
> down the context of the new UUID pretty well:
>   SCSI_IDENT_[TARGET|PORT|LUN]_UUID
> with the identifier itself in canonical UUID format. So there should
> be no confusion there. And partitions are nested inside logical
> units and SCSI does not define those (apart from on tapes).
>=20
Precisely.

These uuids will show up under /dev/disk/by-id
(as this is a hardware ID coming from the device).
So the existing UUID=3D or /dev/disk/by-uuid won't be influenced.
And UUID handling is confusing already (with basically every
subsystem providing one), so adding one more won't matter much :-)

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
