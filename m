From: Hannes Reinecke <hare@suse.de>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Thu, 12 Sep 2013 07:47:05 +0200
Message-ID: <52315559.3080708@suse.de>
References: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab3ILFrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Sep 2013 01:47:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, linux-scsi@vger.kernel.org

On 09/11/2013 04:14 PM, Alan Stern wrote:
> On Tue, 10 Sep 2013, Oliver Neukum wrote:
>=20
>> On Tue, 2013-09-10 at 13:25 -0400, Alan Stern wrote:
>>> On Tue, 10 Sep 2013, Oliver Neukum wrote:
>>>
>>>> Hi Hannes,
>>>>
>>>> you objected to this patch saying there's a possibilty that
>>>> HS devices may also need this feature, which would require
>>>> a quirk. Does this mean that the patch is acceptable only
>>>> with an additional predefined quirk, or do you insist that all
>>>> devices be handled with quirks?
>>>
>>> Indeed, we already know of one or two high-speed devices that suffe=
r
>>> from this bug:
>>>
>>> 	http://marc.info/?l=3Dlinux-usb&m=3D133586313307042&w=3D2
>>>
>>> This may influence your decision.  I'm not certain whether it is=20
>>> important enough to merit a new quirk flag, but people experiencing=
 the=20
>>> problem may have some strong opinions.
>>
>> What is the alternative?
>=20
> There are three possibilities: nothing, your proposed patch, and a ne=
w=20
> quirk flag.  The flag is safest, but also the hardest to maintain.
>=20
>> I think we can be sure that no drive enclosure will crash
>> with READ_CAPACITY_16.
>=20
> I wouldn't count on it, but I don't know of any examples.
>=20
Me neither. The whole issue just smells of some firmware coders
messing up their stuff. So I would think that other firmwares
might not have this problem.
(But as HS enclosures aren't that common chances are we've hit
 the same firmware by chance on every test machine we've had.)

I think it would warrant a quirk approach. Yes, it might be slightly
more coding, but at the same time it's more selective on where it
should trigger.
Also looking at scsiglue.c it would make things quite tricky if
you'd want to _disable_ this feature for HS devices; other firmware
from other vendors might not exhibit this issue after all.
And scsiglue.c already has tons of quirks set, adding one more
doesn't do any harm.

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
