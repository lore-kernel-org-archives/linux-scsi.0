From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] dm-mpath: check kstrdup return value in parse_hw_handler
Date: Thu, 30 Apr 2015 20:35:25 +0200
Message-ID: <554275ED.3030904@suse.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbbD3Sf2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 14:35:28 -0400
In-Reply-To: <1430415151-30948-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 04/30/2015 07:32 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-mpath.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 6395347..01e5f8e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -732,6 +732,9 @@ static int parse_hw_handler(struct dm_arg_set *as=
, struct multipath *m)
>  		return 0;
> =20
>  	m->hw_handler_name =3D kstrdup(dm_shift_arg(as), GFP_KERNEL);
> +	if (!m->hw_handler_name)
> +		return -ENOMEM;
> +
>  	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_na=
me),
>  				     "scsi_dh_%s", m->hw_handler_name)) {
>  		ti->error =3D "unknown hardware handler type";
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
