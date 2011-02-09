From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Wed, 09 Feb 2011 16:44:07 +0100
Message-ID: <4D52B647.9060601@suse.de>
References: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA097@BLRX7MCDC203.AMER.DELL.COM>	<AANLkTimm-MC6kNGRgvFvrPh+YGTW5M6MPLrEd3C9K4vC@mail.gmail.com>	<DBFB1B45AF80394ABD1C807E9F28D1570264CAA563@BLRX7MCDC203.AMER.DELL.COM> <AANLkTinGE6v2DiTSf9VxjFD6EY=3kQz7QCxpaaF=Mr5T@mail.gmail.com> <DBFB1B45AF80394ABD1C807E9F28D1570264CAA99E@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1BIPfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2011 10:35:48 -0500
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D1570264CAA99E@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: realrichardsharpe@gmail.com, linux-scsi@vger.kernel.org

Hi all,

On 02/09/2011 06:02 AM, Shyam_Iyer@Dell.com wrote:
[ .. ]
>=20
> I get you there. The ioctl implementation to inform the driver will
> not plug the storage from sending the UAs.
>=20
> The LUN could be multipathed so then if you have UAs come through
> one sdX path and not through the other that is adding complication.
> Also, if you are using persistent reservations and one of the path
> goes down the UAs could be going to a path that has been excluded.
> We are introducing scenarios for bugs here.
>=20
Hence using debugfs; with this we would be getting an entire
configfs space for free which would allow us to set this kind of things=
=2E
ioctls are evil. Avoid at all cost.

>>
>>> Even if registering for UAs per vendor was envisioned there are
>>> scenarios that can cause a flurry of UAs too..
>>> (I initially opined to have a vendor specific implementation of
>>> logging scsi_netlink events from the scsi_device handler,
>>> it was gloriously shot down ;-))
>>>
>>> Consider this scenario..
>>>
>>> Above water mark.. --> Unit Attention
>>> Discard to free up space
>>> Below water mark ... -> Unit Attention
>>>
>>> Consider a ripple scenario where this repeats..
>>> (Although this can not happen too often it is very much akin to a
>>> thrashing scenario)
>>>
>>> The UA should be hints for the filesystem to optimize online. Here =
is
>>> where the thin profile can reduce the UAs.
>>>
>>> Also, you delete a file - select a good age time to discard the
>>> associated blocks(debatable and worth any good algorithm writer's
>>> salt).
>>> Now I am not sure if the filesystem should run an inkernel thread t=
o
>>> do this profile management..
>>>
>>>> It might be more useful to allow user-land utilities to perform th=
e
>>>> re-scanning.
>>>>
>>>> I would imagine that you will get unit attentions saying that
>>>> REPORTED LUNS DATA HAS CHANGED, but what other UNIT ATTENTIONS wou=
ld
>>>> you get?
>>>> If you add storage to a LUN, then perhaps CAPACITY DATA HAS CHANGE=
D.
>>>>
>>>> Perhaps there is also a need to say things like, for these ASC/ASC=
Q
>>>> values, take the device off line, and all the rest are just adviso=
ry
>>>> but pass them all to user land as well.
>>>>
>>>
>>> This is a kind of policy that needs to go into the thin profile
>>> although Storage Arrays do take the device offline on reaching
>>> certain hard limits there is nothing like mounting a filesystem rea=
d-
>>> only ;-)
>>
>> Well, yes, but Ext3/4 and XFS tend to remount the fs RO when writes =
to
>> the journal fail as well because the SCSI stack takes the device
>> offline :-(
>>
>> If the device has lied in its response to a READ_CAPACITY or
>> READ_CAPACITY16 that is hard to prevent unless the file system has t=
he
>> concept of a lying reserve ...
> The lying reserve is again a profile/policy setting aka like a SWAP c=
oncept.
>=20
> If the device has lied in either READ_CAPACITY_16 or GET_LBA_STATUS..
> then we are anyways not consistent to the tee on the profile. Putting
> my open-source hat on that is a Carrot and stick bait.

Quite. Currently we know of about three events / event classes which
need to be handled:

REPORTED LUNS DATA HAS CHANGED
CAPACITY DATA HAS CHANGED
thin provisioning water mark warnings

Everything else is pretty much handled by the SCSI stack nowadays
anyway.

However, currently we don't handle them at all and hence don't have
any experience as to how often they would occur. Which would be
pretty much vendor-specific anyway.
So we need to design something which is
a) capable of handling even large number of events
b) selectable per device
c) modular enough to have further sense codes added

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
