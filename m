From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: RE: [PATCH] qla2xxx: Fix ql_dump_buffer
Date: Fri, 3 Mar 2017 19:23:42 +0000
Message-ID: <SN1PR0701MB183741685AF2616384EB5A42F52B0@SN1PR0701MB1837.namprd07.prod.outlook.com>
References: <404b1c3a4bfd1f83211482b77b4a9680e755e32a.1488503664.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <404b1c3a4bfd1f83211482b77b4a9680e755e32a.1488503664.git.joe@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, March 2, 2017 5:15 PM
> To: qla2xxx-upstream@qlogic.com
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] qla2xxx: Fix ql_dump_buffer
>=20
> Recent printk changes for KERN_CONT cause this logging to be defectively
> emitted on multiple lines.  Fix it.
>=20
> Also reduces object size a trivial amount.
>=20
> $ size drivers/scsi/qla2xxx/qla_dbg.o*
>    text	   data	    bss	    dec	    hex	filename
>   39125	      0	      0	  39125	   98d5	drivers/scsi/qla2xxx/qla_dbg.o.ne=
w
>   39164	      0	      0	  39164	   98fc	drivers/scsi/qla2xxx/qla_dbg.o.ol=
d
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_db=
g.c
> index 21d9fb7fc887..51b4179469d1 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2707,13 +2707,9 @@ ql_dump_buffer(uint32_t level, scsi_qla_host_t
> *vha, int32_t id,
>  	    "%-+5d  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n", size);
>  	ql_dbg(level, vha, id,
>  	    "----- -----------------------------------------------\n");
> -	for (cnt =3D 0; cnt < size; cnt++, buf++) {
> -		if (cnt % 16 =3D=3D 0)
> -			ql_dbg(level, vha, id, "%04x:", cnt & ~0xFU);
> -		printk(" %02x", *buf);
> -		if (cnt % 16 =3D=3D 15)
> -			printk("\n");
> +	for (cnt =3D 0; cnt < size; cnt +=3D 16) {
> +		ql_dbg(level, vha, id, "%04x: ", cnt);
> +		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16,
> 1,
> +			       buf + cnt, min(16U, size - cnt), false);
>  	}
> -	if (cnt % 16 !=3D 0)
> -		printk("\n");
>  }
> --
> 2.10.0.rc2.1.g053435c

Looks Good.=20

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
