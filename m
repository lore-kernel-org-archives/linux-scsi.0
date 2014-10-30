From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 20/36] mac_scsi: Cleanup PDMA code
Date: Thu, 30 Oct 2014 08:46:09 +0100
Message-ID: <5451ECC1.9030103@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.955142205@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052611.955142205@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Fix whitespace, remove pointless volatile qualifiers and improve code=
 style
> by use of INPUT_DATA_REG and OUTPUT_DATA_REG macros.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/mac_scsi.c |  122 ++++++++++++++++++++++++-------------=
-----------
>  1 file changed, 62 insertions(+), 60 deletions(-)
>=20
> Index: linux/drivers/scsi/mac_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:42.000000000 =
+1100
> +++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:43.000000000 +1100
> @@ -86,9 +86,9 @@ module_param(setup_hostid, int, 0);
>  #define	AFTER_RESET_DELAY	(HZ/2)
>  #endif
> =20
> -static volatile unsigned char *mac_scsi_regp =3D NULL;
> -static volatile unsigned char *mac_scsi_drq  =3D NULL;
> -static volatile unsigned char *mac_scsi_nodrq =3D NULL;
> +static unsigned char *mac_scsi_regp;
> +static unsigned char *mac_scsi_drq;
> +static unsigned char *mac_scsi_nodrq;
> =20
> =20
>  /*
> @@ -262,6 +262,7 @@ static void mac_scsi_reset_boot(struct S
>  }
>  #endif
> =20
> +#ifdef PSEUDO_DMA
>  /*=20
>     Pseudo-DMA: (Ove Edlund)
>     The code attempts to catch bus errors that occur if one for examp=
le
> @@ -331,38 +332,38 @@ __asm__ __volatile__					\
>       : "0"(s), "1"(d), "2"(len)				\
>       : "d0")
> =20
> -
> -static int macscsi_pread (struct Scsi_Host *instance,
> -			  unsigned char *dst, int len)
> +static int macscsi_pread(struct Scsi_Host *instance,
> +                         unsigned char *dst, int len)
>  {
> -   unsigned char *d;
> -   volatile unsigned char *s;
> +	unsigned char *d;
> +	unsigned char *s;
> +
> +	NCR5380_local_declare();
> +	NCR5380_setup(instance);
> +
> +	s =3D mac_scsi_drq + (INPUT_DATA_REG << 4);
> +	d =3D dst;
> =20
> -   NCR5380_local_declare();
> -   NCR5380_setup(instance);
> +	/* These conditions are derived from MacOS */
> =20
> -   s =3D mac_scsi_drq+0x60;
> -   d =3D dst;
> +	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
> +	       !(NCR5380_read(STATUS_REG) & SR_REQ))
> +		;
> +
> +	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
> +	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
> +		pr_err("Error in macscsi_pread\n");
> +		return -1;
> +	}
> =20
> -/* These conditions are derived from MacOS */
> -
> -   while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)=20
> -         && !(NCR5380_read(STATUS_REG) & SR_REQ))
> -      ;
> -   if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)=20
> -         && (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
> -      printk(KERN_ERR "Error in macscsi_pread\n");
> -      return -1;
> -   }
> -
> -   CP_IO_TO_MEM(s, d, len);
> -  =20
> -   if (len !=3D 0) {
> -      printk(KERN_NOTICE "Bus error in macscsi_pread\n");
> -      return -1;
> -   }
> -  =20
> -   return 0;
> +	CP_IO_TO_MEM(s, d, len);
> +
> +	if (len !=3D 0) {
> +		pr_notice("Bus error in macscsi_pread\n");
> +		return -1;
> +	}
> +
> +	return 0;
>  }
> =20
> =20
> @@ -424,39 +425,40 @@ __asm__ __volatile__					\
>       : "0"(s), "1"(d), "2"(len)				\
>       : "d0")
> =20
> -static int macscsi_pwrite (struct Scsi_Host *instance,
> -				  unsigned char *src, int len)
> +static int macscsi_pwrite(struct Scsi_Host *instance,
> +                          unsigned char *src, int len)
>  {
> -   unsigned char *s;
> -   volatile unsigned char *d;
> +	unsigned char *s;
> +	unsigned char *d;
> +
> +	NCR5380_local_declare();
> +	NCR5380_setup(instance);
> =20
> -   NCR5380_local_declare();
> -   NCR5380_setup(instance);
> +	s =3D src;
> +	d =3D mac_scsi_drq + (OUTPUT_DATA_REG << 4);
> =20
> -   s =3D src;
> -   d =3D mac_scsi_drq;
> -  =20
> -/* These conditions are derived from MacOS */
> -
> -   while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)=20
> -         && (!(NCR5380_read(STATUS_REG) & SR_REQ)=20
> -            || (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)=
))=20
> -      ;
> -   if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)) {
> -      printk(KERN_ERR "Error in macscsi_pwrite\n");
> -      return -1;
> -   }
> -
> -   CP_MEM_TO_IO(s, d, len);  =20
> -
> -   if (len !=3D 0) {
> -      printk(KERN_NOTICE "Bus error in macscsi_pwrite\n");
> -      return -1;
> -   }
> -  =20
> -   return 0;
> -}
> +	/* These conditions are derived from MacOS */
> +
> +	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
> +	       (!(NCR5380_read(STATUS_REG) & SR_REQ) ||
> +	        (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)))
> +		;
> +
> +	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)) {
> +		pr_err("Error in macscsi_pwrite\n");
> +		return -1;
> +	}
> +
> +	CP_MEM_TO_IO(s, d, len);
> =20
> +	if (len !=3D 0) {
> +		pr_notice("Bus error in macscsi_pwrite\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +#endif
> =20
>  #include "NCR5380.c"
> =20
>=20
>=20
Any reason why you didn't re-indent macscsi_indent?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
