From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Mon, 2 May 2016 12:05:34 +0200
Message-ID: <5727266E.7040905@suse.de>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbcEBKFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 06:05:36 -0400
In-Reply-To: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On 04/29/2016 02:49 PM, Jinpu Wang wrote:
> Hi, all
>=20
> We hit IO error on fsync, it turns out was because sd treat succeeded
> SYNC as error. From what I checked in SBC spec there is no indication
> we should fail IO in this case, so we create this patch.
>=20
>=20
> Best Regards,
>=20
> Jack Wang
>=20
> v2:
> No change on patch itself, only resend in body as suggested by Bart,
> still keep the attachment in case mail client break the format.
>=20
> From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17 00:00:00 200=
1
> From: Jack Wang <jinpu.wang@profitbricks.com>
> Date: Mon, 25 Apr 2016 12:05:22 +0200
> Subject: [PATCH] sd: Don't treat succeeded SYNC as error
>=20
> We hit IO error in our production on multipath devices during resize
> device on target side, the problem turns out sd driver passes up as I=
O
> error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
> Capacity data has changed, even storage side sync the data properly.
>=20
> In order to fix this check in sd_done, report success if condition
> matches.
>=20
> Sebastian Parschauer report/analyze the bug here:
> https://sourceforge.net/p/scst/mailman/message/34953416/
>=20
> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/sd.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
Well.
Is there anything which guarantees us that 'capacity data has
changed' will be the only sense code which we'll be seeing as a
response to SYNCHRONIZE CACHE?
I sincerely doubt so.
So why don't you fall back to the default action (ie retry the
command) whenever you hit an UNIT ATTENTION?
This way we would cove any resulting sense code, _and_ would get rid
of the rather ugly special case here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
