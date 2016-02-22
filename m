From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Mon, 22 Feb 2016 07:59:48 +0100
Message-ID: <56CAB1E4.9060809@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
 <56C8834F.50304@sandisk.com> <56C9750B.9010200@suse.de>
 <56CA9252.8030007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbcBVG7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 01:59:52 -0500
In-Reply-To: <56CA9252.8030007@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/22/2016 05:45 AM, Bart Van Assche wrote:
> On 02/21/16 00:27, Hannes Reinecke wrote:
>> On 02/20/2016 04:16 PM, Bart Van Assche wrote:
>>> On 02/20/16 00:03, Hannes Reinecke wrote:
>>>> Also when using your suggestion the 'access_state' attribute will =
only
>>>> be created _after_ the 'ADD' uevent, making it impossible to use i=
t
>>>> from
>>>> udev events.
>>>
>>> Can you give an example in which it would be useful to read the ALU=
A
>>> state from a udev handler ? I'm not sure such an example exists.
>>>
>> When evaluating the 'access_state' from an uevent we can avoid sendi=
ng
>> I/O if the path is unavailable; eg if the path is in 'transitioning'=
 I/O
>> will be queued until that path becomes available again.
>> Which means that the uevent will be delayed during udev processing, =
so
>> that the event will never be read by multipathing (as it's being inv=
oked
>> only after udev event processing has finished).
>> And in extreme cases (like OnTap takeover/giveback) it will even dro=
p
>> the event completely due to a timeout.
>=20
> Hello Hannes,
>=20
> Thanks for the feedback.
>=20
> Please split the access_state attribute in two sysfs attributes - one
> for the ALUA state and one for the "preferred" state. This will make =
it
> easier for shell scripts to process these sysfs attributes.
>=20
Okay, agreed.

> I agree with using the 'is_visible' callback. But since using that
> callback will cause the ALUA sysfs attributes to become only visible
> after the ALUA handler has been attached I don't see why not to move =
the
> implementation of the ALUA sysfs attributes into the ALUA device hand=
ler
> source file.
>=20
Thing is, there are others (like the vpg_pg attributes) which will
benefit from using the 'is_visible' callback. And move the
'access_state' attribute into the generic functions makes the footprint
smaller, as the required infrastructure is already present.
Plus I would really like to have the 'access_state' variable part of th=
e
scsi_device, to avoid the intrinsics of having to look it up from the
device_handler data.

> BTW, since the ALUA state can change at any time after the access_sta=
te
> sysfs attribute has been read and before I/O is submitted my preferen=
ce
> is to avoid triggering any SCSI commands from a udev rule that depend=
 on
> the ALUA state.
>=20
Yes, I thought about it some more, too.
The main reason why I need the 'access_state' attribute is to decouple
the multipath daemon; at the moment the multipath daemon has to issue
REPORT TARGET PORT GROUPS frequently to figure out the status, which is
causing quite some load on the target. When using the 'access_state'
attribute we would avoid doing I/O for that and have a consistent view,
both on the kernel and the multipath daemon side.

But it's actually a good thing to have the 'access_state' patch in a
different series; I've got some more patches converting the remaining
device_handler to also supply the 'access_state' values.
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
