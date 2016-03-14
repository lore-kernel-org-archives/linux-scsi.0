From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/22] atari_scsi: Allow can_queue to be increased for
 Falcon
Date: Mon, 14 Mar 2016 08:58:25 +0100
Message-ID: <56E66F21.2050308@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042706.096009019@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbcCNH6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:58:30 -0400
In-Reply-To: <20160314042706.096009019@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> The benefit of limiting can_queue to 1 is that atari_scsi shares the
> ST DMA chip more fairly with other drivers (e.g. falcon-ide).
>=20
> Unfortunately, this can limit SCSI bus utilization. On systems withou=
t
> IDE, atari_scsi should issue SCSI commands whenever it can arbitrate =
for
> the bus. Make that possible by making can_queue configurable.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/atari_scsi.c |   83 ++++++++++++-----------------------=
-----------
>  1 file changed, 22 insertions(+), 61 deletions(-)
>=20
Hmm. We actually have a similar reasoning in the aic7xxx driver,
where the driver core wants to setup pointers to the _next_ command.
So maybe it makes sense to add a pointer to the 'next' command
somewhere in the NCR core structure, to be submitted whenever bus
arbitration tells you so?

But in the end it really looks like a real issue somewhere in the
code, be it the driver or the block/scsi layer.

Nevertheless, setting it to '1' is certainly the correct way here.

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
