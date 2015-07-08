From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 5/5] target: Return ABORTED_COMMAND sense key for PI
 errors
Date: Wed, 08 Jul 2015 17:07:54 +0200
Message-ID: <559D3CCA.50208@suse.de>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com> <1436367534-15995-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbGHPH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 11:07:56 -0400
In-Reply-To: <1436367534-15995-6-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 07/08/2015 04:58 PM, Sagi Grimberg wrote:
> PI errors were reported with ILLEGAL_REQUEST sense key but
> there was actually no problem with the request. Target
> detected PI errors should be reported with aborted command
> sense key.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/target/target_core_transport.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/=
target_core_transport.c
> index 923e69d..1847fdc 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2705,19 +2705,19 @@ static const struct sense_info sense_info_tab=
le[] =3D {
>  		.ascq =3D 0x00,
>  	},
>  	[TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] =3D {
> -		.key =3D ILLEGAL_REQUEST,
> +		.key =3D ABORTED_COMMAND,
>  		.asc =3D 0x10,
>  		.ascq =3D 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
>  		.add_sector_info =3D true,
>  	},
>  	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] =3D {
> -		.key =3D ILLEGAL_REQUEST,
> +		.key =3D ABORTED_COMMAND,
>  		.asc =3D 0x10,
>  		.ascq =3D 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
>  		.add_sector_info =3D true,
>  	},
>  	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] =3D {
> -		.key =3D ILLEGAL_REQUEST,
> +		.key =3D ABORTED_COMMAND,
>  		.asc =3D 0x10,
>  		.ascq =3D 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
>  		.add_sector_info =3D true,
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
