From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RESEND PATCH 3/3] dm mpath: add ability to disable
 partition creation
Date: Fri, 27 Jul 2012 16:00:53 +0200
Message-ID: <50129F15.9010705@suse.de>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com> <1340735525-21083-4-git-send-email-snitzer@redhat.com> <20120711151839.GC2095@agk-dp.fab.redhat.com> <500FE047.8060009@suse.de> <20120726170328.GD5299@ether.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2G0OAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2012 10:00:54 -0400
In-Reply-To: <20120726170328.GD5299@ether.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Peter Rajnoha <prajnoha@redhat.com>

On 07/26/2012 07:03 PM, Benjamin Marzinski wrote:
> On Wed, Jul 25, 2012 at 02:02:15PM +0200, Hannes Reinecke wrote:
[ .. ]
>> But that would mean one would have to maintain _two_ configuration
>> files, one for multipath and one for kpartx.
>>
>> Also kpartx initially doesn't have any clue about device names, SCSI
>> WWIDs etc. It just takes a device-mapper device and acts upon it.
>> The only information it's got is the device-mapper name (which could
>> be anything) and the device-mapper UUID if present.
>>
>> Same goes for udev rules; one would have to traverse the device
>> stack backwards to retrieve any information about the hardware.
>>
>> So when moving the configuration into kpartx we would lose quite
>> some flexibility. And reliability, methinks.
>>
>> Flexilibity is a valid goal, but not when it can achieved only by
>> adding complexity to other pieces.
>=20
> Kpartx does already grab the dm device name, uuid and target type
> (although it doesn't currently use the target type for anything). So,
> aside from adding code to read a config file, we don't really have to
> add any complexity to be able to have kpartx configure a device based=
 on
> dm name (which admittedly probably isn't that useful), dm UUID, or
> target type.  We could also have it configure based on the blkid
> results, which should be present when it's called by udev. When
> called manually, kpartx could use libblkid.
>=20
Hmpf. Feels like a waste; multipath already has this information ...
Anyway.

> We do lose the ability to have kpartx easily configure a device based=
 on
> hardware type.  However, that's not really essential.  Multipath need=
s
> it because it can't even finish setting up a device until it knows th=
e
> hardware type.  For kpartx, it could make configuration simpler in ca=
ses
> where all of the LUNs from a particular hardware type needed to be
> configured the same way.  This may be handy, but its not necessary, a=
nd
> you could achieve the same results using UUIDs. What we gain is the
> ability to set this property for non-multipath devices, which current=
ly
> isn't possible.  Also, blkid based (fs type, fs uuid, and fs label)
> configuration seems to me like it would be the most useful.=20
>=20
Oh. Right.
Yes, indeed, other target types beside from multipath will benefit
from this approach, too.

> Now I'm not arguing that adding configuration file handling isn't add=
ing
> complexity, and adding libblkid calls would add more. But since
> multipath always sets the UUID, I don't see this losing any reliabili=
ty,
> and I does gain the fexibility to work with any dm target type. I
> don't feel strongly about this one way or the other, but do see the
> benefits of having kpartx own this configuration setting.
>=20
The main problem I have with the kpartx approach is that none of the
information in the device-mapper device is well-defined.
The name certainly isn't, and even the UUID is a case of "let's hope
no-one else is daft enough using this".

Did we ever get around formalizing how the UUID should look like?
If so, and if we could enforce this policy, then we can be sure the
UUID is actually meaningful.

But if we can't then kpartx would have to crawl back to the parent
device to grab some information from there.
blkid notwithstanding.
And that's just horrible.

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
