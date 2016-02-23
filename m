From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Tue, 23 Feb 2016 18:27:43 +0800
Message-ID: <56CC341F.2000407@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
 <56C8834F.50304@sandisk.com> <56C9750B.9010200@suse.de>
 <56CA9252.8030007@sandisk.com> <56CAB1E4.9060809@suse.de>
 <56CB2AA2.9090505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbcBWK1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 05:27:53 -0500
In-Reply-To: <56CB2AA2.9090505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/22/2016 11:34 PM, Bart Van Assche wrote:
> On 02/21/16 22:59, Hannes Reinecke wrote:
>> The main reason why I need the 'access_state' attribute is to decoup=
le
>> the multipath daemon; at the moment the multipath daemon has to issu=
e
>> REPORT TARGET PORT GROUPS frequently to figure out the status, which=
 is
>> causing quite some load on the target. When using the 'access_state'
>> attribute we would avoid doing I/O for that and have a consistent vi=
ew,
>> both on the kernel and the multipath daemon side.
>>
>> But it's actually a good thing to have the 'access_state' patch in a
>> different series; I've got some more patches converting the remainin=
g
>> device_handler to also supply the 'access_state' values.
>=20
> Hello Hannes,
>=20
> The above sounds very interesting to me. Will multipathd recognize at
> run-time whether or not the kernel supports the sysfs ALUA state
> attribute ?
That was the plan.
(Not that I've got any idea _how_ to do this ATM :-)

> Will ALUA state changes be reported through udev or will
> multipathd poll the sysfs ALUA state attributes ?=20
Polling. udev events will be too unreliable here, as each uevent
potentially causes I/O during uevent processing which might stall as th=
e
path might be down.
So we might never get events for failed/transitioning paths, however,
these are precisely the cases which we're interested in ...

> And if the netlink
> buffer that is used in multipathd to receive udev events overflows
> (ENOBUFS), will multipathd resynchronize its state ? As far as I can =
see
> in source file libmultipath/uevent.c today multipathd ignores netlink
> buffer overflows.
>=20
Which, thankfully, doesn't apply as multipathd will be polling the sysf=
s
attribute directly :-)

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
