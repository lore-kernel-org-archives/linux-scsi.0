From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/5] scsi: Move sense handling routines to scsi_common
Date: Wed, 08 Jul 2015 17:06:04 +0200
Message-ID: <559D3C5C.4020903@suse.de>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com> <1436367534-15995-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbbGHPGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 11:06:08 -0400
In-Reply-To: <1436367534-15995-4-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 07/08/2015 04:58 PM, Sagi Grimberg wrote:
> Sense data handling is also done in the target stack.
> Hence, move sense handling routines to scsi_common so
> the target will be able to use them as well.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_common.c | 98 ++++++++++++++++++++++++++++++++++++=
+++++++++
>  drivers/scsi/scsi_error.c  | 99 +-----------------------------------=
----------
>  include/scsi/scsi_common.h |  5 +++
>  include/scsi/scsi_eh.h     |  7 +---
>  4 files changed, 105 insertions(+), 104 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 2ff0922..41432c1 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -5,6 +5,7 @@
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> +#include <asm/unaligned.h>
>  #include <scsi/scsi_common.h>
> =20
>  /* NB: These are exposed through /proc/scsi/scsi and form part of th=
e ABI.
> @@ -176,3 +177,100 @@ bool scsi_normalize_sense(const u8 *sense_buffe=
r, int sb_len,
>  	return true;
>  }
>  EXPORT_SYMBOL(scsi_normalize_sense);
> +
> +/**
> + * scsi_sense_desc_find - search for a given descriptor type in	desc=
riptor sense data format.
> + * @sense_buffer:	byte array of descriptor format sense data
> + * @sb_len:		number of valid bytes in sense_buffer
> + * @desc_type:		value of descriptor type to find
> + *			(e.g. 0 -> information)
> + *
> + * Notes:
> + *	only valid when sense data is in descriptor format
> + *
> + * Return value:
> + *	pointer to start of (first) descriptor if found else NULL
> + */
> +const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
> +				int desc_type)
> +{
> +	int add_sen_len, add_len, desc_len, k;
> +	const u8 * descp;
> +
> +	if ((sb_len < 8) || (0 =3D=3D (add_sen_len =3D sense_buffer[7])))
> +		return NULL;
> +	if ((sense_buffer[0] < 0x72) || (sense_buffer[0] > 0x73))
> +		return NULL;
> +	add_sen_len =3D (add_sen_len < (sb_len - 8)) ?
> +			add_sen_len : (sb_len - 8);
> +	descp =3D &sense_buffer[8];
> +	for (desc_len =3D 0, k =3D 0; k < add_sen_len; k +=3D desc_len) {
> +		descp +=3D desc_len;
> +		add_len =3D (k < (add_sen_len - 1)) ? descp[1]: -1;
> +		desc_len =3D add_len + 2;
> +		if (descp[0] =3D=3D desc_type)
> +			return descp;
> +		if (add_len < 0) // short descriptor ??
> +			break;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL(scsi_sense_desc_find);
> +
> +/**
> + * scsi_build_sense_buffer - build sense data in a buffer
> + * @desc:	Sense format (non zero =3D=3D descriptor format,
> + *              0 =3D=3D fixed format)
> + * @buf:	Where to build sense data
> + * @key:	Sense key
> + * @asc:	Additional sense code
> + * @ascq:	Additional sense code qualifier
> + *
> + **/
> +void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 a=
scq)
> +{
> +	if (desc) {
> +		buf[0] =3D 0x72;	/* descriptor, current */
> +		buf[1] =3D key;
> +		buf[2] =3D asc;
> +		buf[3] =3D ascq;
> +		buf[7] =3D 0;
> +	} else {
> +		buf[0] =3D 0x70;	/* fixed, current */
> +		buf[2] =3D key;
> +		buf[7] =3D 0xa;
> +		buf[12] =3D asc;
> +		buf[13] =3D ascq;
> +	}
> +}
> +EXPORT_SYMBOL(scsi_build_sense_buffer);
> +
> +/**
> + * scsi_set_sense_information - set the information field in a
> + *		formatted sense data buffer
> + * @buf:	Where to build sense data
> + * @info:	64-bit information value to be set
> + *
> + **/
> +void scsi_set_sense_information(u8 *buf, u64 info)
> +{
> +	if ((buf[0] & 0x7f) =3D=3D 0x72) {
> +		u8 *ucp, len;
> +
> +		len =3D buf[7];
> +		ucp =3D (char *)scsi_sense_desc_find(buf, len + 8, 0);
> +		if (!ucp) {
> +			buf[7] =3D len + 0xa;
> +			ucp =3D buf + 8 + len;
> +		}
We're adding extra fields here, so we need to make sure to not
overflow the buffer. You probably have to pass in the buffersize
to avoid an overflow ...
Yeah, I know, it's theoretical at the moment.
But there's nothing which prevents anyone to add other fields to it,
so this field might be the one causing the overflow.

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
