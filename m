From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Sun, 21 Feb 2016 09:27:55 +0100
Message-ID: <56C9750B.9010200@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
 <56C8834F.50304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbcBURXm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Feb 2016 12:23:42 -0500
In-Reply-To: <56C8834F.50304@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/20/2016 04:16 PM, Bart Van Assche wrote:
> On 02/20/16 00:03, Hannes Reinecke wrote:
>> Also when using your suggestion the 'access_state' attribute will on=
ly
>> be created _after_ the 'ADD' uevent, making it impossible to use it =
from
>> udev events.
>
> Can you give an example in which it would be useful to read the ALUA
> state from a udev handler ? I'm not sure such an example exists.
>
When evaluating the 'access_state' from an uevent we can avoid sending=20
I/O if the path is unavailable; eg if the path is in 'transitioning' I/=
O=20
will be queued until that path becomes available again.
Which means that the uevent will be delayed during udev processing, so=20
that the event will never be read by multipathing (as it's being invoke=
d
only after udev event processing has finished).
And in extreme cases (like OnTap takeover/giveback) it will even drop=20
the event completely due to a timeout.

>> If you're absolutely against it we can drop the 'access_state' patch=
es
>> (ie patch 20-22) and have them folded into a separate patchset.
>
> That sounds like a good idea to me.
>
Ok, let's do this.

Martin, can you please ignore patches 20-22 when pulling the patchset?
I'll be resubmitting a new patchset with them once these issues are=20
sorted out.
Or do you need a new patch submission?

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
