From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/8] dm-mpath, scsi_dh: don't let dm detach device handlers
Date: Mon, 11 May 2015 14:51:59 +0200
Message-ID: <5550A5EF.1060904@suse.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de> <1431283260-13406-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbbEKMwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 08:52:01 -0400
In-Reply-To: <1431283260-13406-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 05/10/2015 08:40 PM, Christoph Hellwig wrote:
> While allowing dm-mpath to attach device handlers is a functionality =
we need
> for backwards compatibility reason there is no reason to reference co=
unt
> them and detach them if dm-mpath stops using the device for some reas=
on.
>=20
> If the device handler works for the given device it can just stay att=
ached,
> and we can take the retain_hw_handler codepath.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[ .. ]
>=20
> @@ -597,20 +595,14 @@ static struct pgpath *parse_path(struct dm_arg_=
set *as, struct path_selector *ps
>  	}
> =20
>  	if (m->hw_handler_name) {
> -		/*
> -		 * Increments scsi_dh reference, even when using an
> -		 * already-attached handler.
> -		 */
>  		r =3D scsi_dh_attach(q, m->hw_handler_name);
>  		if (r =3D=3D -EBUSY) {
> -			/*
> -			 * Already attached to different hw_handler:
> -			 * try to reattach with correct one.
> -			 */
> -			scsi_dh_detach(q);
> -			r =3D scsi_dh_attach(q, m->hw_handler_name);
> +			char b[BDEVNAME_SIZE];
> +=09

Whitespace error ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
