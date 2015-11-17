From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH, resend] scsi: advansys: fix big-endian builds
Date: Tue, 17 Nov 2015 07:46:01 +0100
Message-ID: <564ACD29.3090007@suse.de>
References: <4411376.blKgWIg75B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4411376.blKgWIg75B@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Matthew Wilcox <willy@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 11/16/2015 05:49 PM, Arnd Bergmann wrote:
> Building the advansys driver in a big-endian configuration such as
> ARM allmodconfig shows a warning:
>=20
>  drivers/scsi/advansys.c: In function 'adv_build_req':
>  include/uapi/linux/byteorder/big_endian.h:32:26: warning: large inte=
ger implicitly truncated to unsigned type [-Woverflow]
>   #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
>  drivers/scsi/advansys.c:7806:22: note: in expansion of macro 'cpu_to=
_le32'
>    scsiqp->sense_len =3D cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
>=20
> It turns out that the commit that introduced this used the cpu_to_le3=
2()
> incorrectly on an 8-bit field, which results in the sense_len to alwa=
ys
> be set to zero, as the SCSI_SENSE_BUFFERSIZE value gets moved to uppe=
r
> byte of the 32-bit intermediate.
>=20
> This removes the cpu_to_le32() call to restore the original version.
>=20
> I found this only by looking at the compiler output and have not done
> a full review for possible further endianess bugs in the same driver.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 811ddc057aac ("advansys: use DMA-API for mapping sense buffer"=
)
> Cc: stable@vger.kernel.org # v4.2+
> ---
> Using willy@linux.intel.com, as the address listed in MAINTAINERS
> failed:
>=20
> Failed to transport message. Message sending failed since the followi=
ng recipients were rejected by the server: matthew@wil.cx (The server r=
esponded: Requested action not taken: mailbox unavailable invalid DNS M=
X or A/AAAA resource record)
>=20
> Geert found the same bug and submitted the same patch earlier:
> https://lkml.org/lkml/2015/6/24/89
>=20
> Neither one has been reviewed or accepted so far. Can we get one of t=
he
> two merged please?
>=20
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 4305178e4e01..1c1cd657c380 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7803,7 +7803,7 @@ adv_build_req(struct asc_board *boardp, struct =
scsi_cmnd *scp,
>  		return ASC_BUSY;
>  	}
>  	scsiqp->sense_addr =3D cpu_to_le32(sense_addr);
> -	scsiqp->sense_len =3D cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
> +	scsiqp->sense_len =3D SCSI_SENSE_BUFFERSIZE;
> =20
>  	/* Build ADV_SCSI_REQ_Q */
> =20
>=20
Ho-hum. You are right.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
