From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: add in sas transport
Date: Wed, 21 Oct 2015 08:01:00 +0200
Message-ID: <56272A1C.2050608@suse.de>
References: <20150929221748.6433.53593.stgit@brunhilda> <20150929222154.6433.60590.stgit@brunhilda> <560B941B.8000802@suse.de> <07F70BBF6832E34FA1C923241E8833AB7CD46B3E@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbJUGBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 02:01:03 -0400
In-Reply-To: <07F70BBF6832E34FA1C923241E8833AB7CD46B3E@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <Don.Brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/20/2015 10:07 PM, Don Brace wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Wednesday, September 30, 2015 2:50 AM
>> To: Don Brace; linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH] hpsa: add in sas transport
>>
>> On 09/30/2015 12:21 AM, Don Brace wrote:
>>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>>
>>> customers want lsscsi -t to show sas addresses when
>>> enumerating sas devices. The sas addresses are used
>>> mainly to light drive LEDs for location.
>>>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>>  drivers/scsi/hpsa.c     |  704
>> ++++++++++++++++++++++++++++++++++++++++++-----
>>>  drivers/scsi/hpsa.h     |   37 ++
>>>  drivers/scsi/hpsa_cmd.h |   14 +
>>>  3 files changed, 677 insertions(+), 78 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index 3b35de0..ae811a7 100644
>>>  	/* Notify scsi mid layer of any added devices */
>>>  	for (i =3D 0; i < nadded; i++) {
>>> -		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
>>> +		if (!(added[i]->expose_device))
>>>  			continue;
>>> -		if (scsi_add_device(sh, added[i]->bus,
>>> -			added[i]->target, added[i]->lun) =3D=3D 0)
>>> +		if (hpsa_add_device(h, added[i]) =3D=3D 0)
>>>  			continue;
>>>  		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
>>>  					"addition failed, device not added.");
>> Sigh. Here we go again.
>>
>> I've probably asked you (or Mike Miller :-) about this several times
>> now, but couldn't you use the _real_ LUN addresses?
>>
>> Especially as you're now exposing 'real' devices, where is the point
>> of creating an internal LUN mapping table?
>>
>> If you were expose the devices with the actual LUN address (by eg
>> arranging the target/RAID controller on bus '0', the RAID devices on
>> bus '1', and the exposed devices on bus '2') you could remove the
>> internal LUN mapping table and quite some complexity would go away .=
=2E.
>>
>=20
> This can be done.
>=20
> However, at this point, I do not want to change hpsa without more tes=
ting.=20
> I'll make another patch and send it up after it has a chance to be te=
sted in our labs.
> Hope this is OK.
>=20
Sure. Just wanted to raise this (again :-), as I think it'd be a
good cleanup.

> I split out the other changes to separate patches as you recommended.
>=20
Please, go ahead.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
