From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm mpath: do not fail path on -ENOSPC
Date: Fri, 13 Sep 2013 07:58:35 +0200
Message-ID: <5232A98B.2080301@suse.de>
References: <5232A896.80803@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab3IMF6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 01:58:36 -0400
In-Reply-To: <5232A896.80803@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/13/2013 07:54 AM, Jun'ichi Nomura wrote:
> Since ENOSPC is a target-side error, dm-mpath should just pass the er=
ror
> information to upper layer instead of retrying itself with path failo=
ver.
> Otherwise it will end up failing all paths down while path checkers f=
ind
> all paths ok.
>=20
> ENOSPC can now be returned from SCSI device after commit a9d6ceb8
> ("[SCSI] return ENOSPC on thin provisioning failure").
>=20
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> The patch is not actually tested as I don't have such a storage at my=
 hand.
> Hannes, please let me know if you didn't change noretry_error() inten=
tionally.
>=20
No, you are correct. I've missed this bit when sending out the
enhanced I/O errors patch.

Acked-by: Hannes Reinecke <hare@suse.de>

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index b759a12..075747e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1268,6 +1268,7 @@ static int noretry_error(int error)
>  	case -EREMOTEIO:
>  	case -EILSEQ:
>  	case -ENODATA:
> +	case -ENOSPC:
>  		return 1;
>  	}
> =20
>=20

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
