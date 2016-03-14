From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/22] ncr5380: Remove disused atari_NCR5380.c core driver
Date: Mon, 14 Mar 2016 08:42:16 +0100
Message-ID: <56E66B58.9030104@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042704.026027354@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933724AbcCNHmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:42:18 -0400
In-Reply-To: <20160314042704.026027354@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Now that atari_scsi and sun3_scsi have been converted to use the NCR5=
380.c
> core driver, remove atari_NCR5380.c. Also remove the last vestiges of=
 its
> Tagged Command Queueing implementation from the wrapper drivers.
>=20
> The TCQ support in atari_NCR5380.c is abandoned by this patch. It is =
not
> merged into the remaining core driver because,
>=20
> 1) atari_scsi defines SUPPORT_TAGS but leaves FLAG_TAGGED_QUEUING dis=
abled
> by default, which indicates that it is mostly undesirable.
>=20
> 2) I'm told that it doesn't work correctly when enabled.
>=20
> 3) The algorithm does not make use of block layer tags which it will =
have
> to do because scmd->tag is deprecated.
>=20
> 4) sun3_scsi doesn't define SUPPORT_TAGS at all, yet the the SUPPORT_=
TAGS
> macro interacts with the CONFIG_SUN3 macro in 'interesting' ways.
>=20
> 5) Compile-time configuration with macros like SUPPORT_TAGS caused th=
e
> configuration space to explode, leading to untestable and unmaintaina=
ble
> code that is too hard to reason about.
>=20
> The merge_contiguous_buffers() code is also abandoned. This was unuse=
d
> by sun3_scsi. Only atari_scsi used it and then only on TT, because on=
ly TT
> supports scatter/gather. I suspect that the TT would work fine with
> ENABLE_CLUSTERING instead. If someone can benchmark the difference th=
en
> perhaps the merge_contiguous_buffers() code can be be justified. Unti=
l
> then we are better off without the extra complexity.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c       |   22=20
>  drivers/scsi/NCR5380.h       |   19=20
>  drivers/scsi/atari_NCR5380.c | 2632 --------------------------------=
-----------
>  drivers/scsi/atari_scsi.c    |   11=20
>  drivers/scsi/mac_scsi.c      |    8=20
>  drivers/scsi/sun3_scsi.c     |   11=20
>  6 files changed, 4 insertions(+), 2699 deletions(-)
>=20
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
