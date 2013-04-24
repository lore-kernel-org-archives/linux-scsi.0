From: "Black, David" <david.black@emc.com>
Subject: RE: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 14:20:08 -0400
Message-ID: <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
 <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de>
 <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>
 <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hop-nat-141.emc.com ([168.159.213.141]:40559 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756537Ab3DXSYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 14:24:06 -0400
In-Reply-To: <5177EDB5.5000105@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>, "Black, David" <david.black@emc.com>

Jeremy,

It looks like, you, Paolo and Ric have hit the nail on the head here - =
this is
a nice summary, IMHO:

> On 4/24/2013 7:57 AM, Paolo Bonzini wrote:
>>> If the device can promise this, we don't care (and don't know) how =
it=20
>>> manages that promise. It can leave the data on battery backed DRAM,=
 can=20
>> archive it to flash or any other scheme that works.
>>=20
>> That's exactly the point of SYNC_NV=3D1.
>
>	Well its the point, but the specification is written such that the ve=
ndors can
> choose to implement it any way they wish, especially for split cache
> systems where there is both volatile and non volatile cache.

Independent of T10's best intentions at the time, the implementations a=
ren't
doing what's needed or intended, and I'd guess that the SYNC_NV bit is =
not
being set to 1 by [other people's ;-) ] software that should be setting=
 it
to 1 if it were paying attention to the standard.

This is further complicated by it being completely legitimate wrt the S=
CSI
standard to put non-volatile cache in a system and not have the SCSI in=
terface
admit that the non-volatile cache exists (WCE=3D0, SYNCHRONIZE CACHE is=
 a no-op
independent of the value of SYNC_NV).

I believe that Rob Elliot's 13-050 proposal to obsolete SYNC_NV and re-=
specify
SYNCHRONIZE CACHE to make all data non-volatile by whatever means the t=
arget
chooses is what T10 should do, and that matches Ric's summary:

>>> If the device can promise this, we don't care (and don't know) how =
it=20
>>> manages that promise. It can leave the data on battery backed DRAM,=
 can=20
>> archive it to flash or any other scheme that works.

Beyond that, attempting to manage drive removal from storage systems vi=
a the
SCSI interface with standard commands is a waste of time and effort, IM=
HO.
In a serious storage array (and even some fairly simple RAID controller=
s), some
vendor-specific "magic" is needed to get the array (or controller) to p=
repare
so that the drive can be removed cleanly.  To oversimplify, it's not en=
ough to
flush data to the drive; the array or controller is stateful, and hence=
 has
to be told to "forget" the drive, where "forget" involves things that a=
re
rather implementation-specific.

Thanks,
--David
----------------------------------------------------
David L. Black, Distinguished Engineer
EMC Corporation, 176 South St., Hopkinton, MA=A0 01748
+1 (508) 293-7953=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FAX: +1 (508) 293=
-7786
david.black@emc.com=A0=A0=A0=A0=A0=A0=A0 Mobile: +1 (978) 394-7754
----------------------------------------------------

> -----Original Message-----
> From: Jeremy Linton [mailto:jlinton@tributary.com]
> Sent: Wednesday, April 24, 2013 10:36 AM
> To: Paolo Bonzini
> Cc: Ric Wheeler; Hannes Reinecke; James Bottomley; linux-scsi@vger.ke=
rnel.org;
> Martin K. Petersen; Jeff Moyer; Tejun Heo; Mike Snitzer; Black, David=
;
> Elliott, Robert (Server Storage); Knight, Frederick
> Subject: Re: T10 WCE interpretation in Linux & device level access
>=20
> On 4/24/2013 7:57 AM, Paolo Bonzini wrote:
> >> If the device can promise this, we don't care (and don't know) how=
 it
> >> manages that promise. It can leave the data on battery backed DRAM=
, can
> >> archive it to flash or any other scheme that works.
> >
> > That's exactly the point of SYNC_NV=3D1.
>=20
> 	Well its the point, but the specification is written such that the
> vendors can
> choose to implement it any way they wish, especially for split cache
> systems where there is both volatile and non volatile cache.
>=20
> 	Flushing the NV cache to medium (as is the current behavior) may not=
 be
> a bad
> idea anyway.
>=20
> 	Thats because I know of a large vendors array where the non-volatile
> cache
> might be better described as the "sometimes" non-volatile cache. That=
 is
> because
> a failure to flush the volatile portions results in the non-volatile =
portions
> being considered invalid when power is restored. This fences the volu=
me, and
> the
> usual method for recovering the array is to call support and have the=
m
> invalidate the NV portions of the cache. Thereby negating the whole r=
eason for
> having a NV cache. I'm sure they don't tell customers this fact when =
they sell
> the array, when it happened in our lab I was in a state of shock for =
about a
> week.
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
