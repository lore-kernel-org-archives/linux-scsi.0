From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi: Fix wrong additional sense length in descriptor
 format
Date: Mon, 13 Jul 2015 16:05:54 +0200
Message-ID: <55A3C5C2.9020903@suse.de>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com> <1436697423-20611-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436697423-20611-2-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 07/12/2015 12:37 PM, Sagi Grimberg wrote:
> The sense header additional sense length should be the accumulated
> size of all the descriptors. Information descriptor size is 12 bytes.
> When setting the additional sense length we should add 0xc instead of
> 0xa.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/scsi/scsi_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 8cfb7ee..fbf137b 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -260,7 +260,7 @@ void scsi_set_sense_information(u8 *buf, u64 info=
)
>  		len =3D buf[7];
>  		ucp =3D (char *)scsi_sense_desc_find(buf, len + 8, 0);
>  		if (!ucp) {
> -			buf[7] =3D len + 0xa;
> +			buf[7] =3D len + 0xc;
>  			ucp =3D buf + 8 + len;
>  		}
>  		ucp[0] =3D 0;
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
