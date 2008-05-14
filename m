From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 17:01:57 +0200
Message-ID: <482AFEE5.2090300@suse.de>
References: <1210700704.16304.1.camel@localhost.localdomain> <482A87EF.4010002@suse.de> <482AF9B0.7090307@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbYENPB6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 11:01:58 -0400
In-Reply-To: <482AF9B0.7090307@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Hi James,

James Smart wrote:
>=20
>=20
> Hannes Reinecke wrote:
>>> This patch was cut against scsi-misc-2.6, and depends on Mike=20
>>> Christies patches contained in the original thread.
>>>
>> Hmph.
>>
>> I don't quite agree with this one.
>> For once, /proc/scsi/scsi has been marked as 'obsolete' for quite so=
me=20
>> time now,
>> so adding other usages to this is of questionable value.
>=20
> Um... I didn't think I added a new use for it.  The existing data had=
 to
> be extended by an additional argument.
>=20
Well, extending the existing structure comes quite close to adding anot=
her
usage ...

>>
>> And we've actually have a similar issue when developing the SCSI=20
>> device_handler stuff where we also have a device list to maintain.
>>
>> Seeing there is quite some overlap between those two cases I think w=
e=20
>> should come up with a way of handling these things properly, ie tied
>> into sysfs.
>=20
> Ok - but I see it as a two part process. I am not signing up for repl=
acing
> the device list infrastructure.  But, now that there is target queue =
depth
> management in the midlayer, I believe we should be taking advantage o=
f it.
> I'd rather see the additional field go in, then see a separate effort=
 to
> replace/collapse the device lists...
>=20
Ok, agreed. It makes sense to have it now and update the infrastructure
later.

>> So, what we should do here is
>> a) add a 'can_queue' sysfs attribute to the starget (which we can=20
>> nowadays, as the starget is a proper sysfs object)
>=20
> Um, it exists under the /sys/devices tree (the base object) but there=
 is no
> class representation. Are you requesting this goes on the base object=
 ?
> I thought we avoided this.
Yes. Although I can't figure out _why_.
We nowadays have perfectly valid scsi_target kobj, which can (and will =
if
CONFIG_SYSFS_DEPRECATED is not set) be displayed in sysfs.

> I guess it can, but as it's scsi-ish, I would
> think it more appropriate to formally create a scsi_target class and =
put
> scsi attributes there.  (but I was avoiding that too)
>=20
We don't have to. It's just the once upon a time a class object was
used to access the underlying object. But nowadays the destinction
between class_objects and 'normal' objects is gone so there's hardly
any point in creating one.

I personally don't have a problem with putting the 'generic' SCSI
sysfs attributes into the kobj itself and getting rid of the class
devices for it (or rather, make it a link).
And, actually, plan to do some patches for it :-)

But that's slightly off-topic here.
And as we don't have a consensus about the future sysfs layout
yet it hardly makes any sense to discuss the placement of target
specific attributes.

So:
Acked-by: Hannes Reinecke <hare@suse.de>

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
