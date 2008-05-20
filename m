From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Tue, 20 May 2008 14:41:42 +0200
Message-ID: <4832C706.5040202@suse.de>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>	 <1210964001.21974.351.camel@chandra-ubuntu>  <483154B0.7020500@suse.de> <1211221247.21974.382.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:40358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYETMlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 08:41:44 -0400
In-Reply-To: <1211221247.21974.382.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hi Chandra,

Chandra Seetharaman wrote:
> On Mon, 2008-05-19 at 12:21 +0200, Hannes Reinecke wrote:
>> Hi Chandra,
>>
[ .. ]
>> Yes, but this only verifies that the _handler_ exist, not that it is
>> attached to this sdev
>=20
> Agreed. And it works properly with the original design.
>=20
> Here is my thinking on how it would work with the new feature (abilit=
y
> to attach any device using dh_state) you added:
>  - User adds a new device
>  - User knows which scsi hardware handler their device can attach to,
>    lets say, "mydev".
>  - User attaches the device with scsi hardware handler (writing "myde=
v"
>    to "dh_state").
>    Device is now attached to "mydev"
>  - User updates his/her multipath.conf file with "mydev" for the
>    specific device.
>  - User invokes multipath, which checks for the existence of "mydev"
>    and allows the table insertion.
>  - When pg_init was required in the future, multipath calls "activate=
"
>    for "mydev" correctly.
>=20
> Wouldn't this work ?
>=20
> Note: In the absence of this patch (7/7) only.
>=20
Yes, but only for the first time. After reboot the user would
have to do the reconfiguration again.

>>> Hardware handler module is attached to the device itself (thru
>>> try_module_get() in attach), so, the module will exist as long as t=
he
>>> device exists.
>>>
>> Not quite. It's only attached automatically if the device map has
>> an entry for this module.
>> However, given this patchset we can now easily manually attach any
>> device to the device handler. Or at least try to do so.
>> It's then up to the device handler to refuse binding if none of
>> the necessary pages/information etc. was found.
>=20
> Doesn't dh_state solve this issue ?
>=20
In theory, yes.

>>> Hence, there is no need to attach it again from the multipath layer=
=2E
>>>
>> Yes, you do. The user might have it's own custom configuration file,
>> covering new/unknown/unhandled/testing devices, which out of necessi=
ty
>> are _not_ hardcoded in the device table of the device handler.
>> So multipath has to have a way of attaching device handler to those
>> devices, too.
>=20
> dh_state allows the user to do this, in which case why do we need to =
do
> this in multipath layer ?
>=20
Because then we (read: I) don't have to modify multipath-tools.
If we don't take this patch we'll have to modify multipath-tools
to check for the dh_state attribute explicitly and activate
the hardware handler directly via sysfs.

But this also means that existing multipath-tools programs won't
be able to correctly activate the hardware handler in
_some_ cases (ie those cases, where the hardware table for the
device_handler doesn't contain the device in question).
And I can just imagine the bugs I'll be getting ...
So if we decide to take that road we should kill the hardware
handler feature from the device-mapper multipath interface
altogether to notify the user that the programs won't work
anymore. Otherwise it's just heading for trouble.

So I'd rather keep the userland interface stable here and add
some code to the kernel.

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
