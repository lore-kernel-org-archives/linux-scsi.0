From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/22] atari_NCR5380: Remove DMA_MIN_SIZE macro
Date: Mon, 14 Mar 2016 08:25:53 +0100
Message-ID: <56E66781.8000009@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042701.626031027@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbcCNHZz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:25:55 -0400
In-Reply-To: <20160314042701.626031027@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Only the atari_scsi and sun3_scsi drivers define DMA_MIN_SIZE.
> Both drivers also define NCR5380_dma_xfer_len, which means
> DMA_MIN_SIZE is redundant.
>=20
> This removes another discrepancy between the two core drivers.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/atari_NCR5380.c |   16 ++++++++--------
>  drivers/scsi/atari_scsi.c    |    4 +++-
>  drivers/scsi/sun3_scsi.c     |   16 ++++++----------
>  3 files changed, 17 insertions(+), 19 deletions(-)
>=20
> Index: linux/drivers/scsi/atari_NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_NCR5380.c	2016-03-14 15:26:23.00000=
0000 +1100
> +++ linux/drivers/scsi/atari_NCR5380.c	2016-03-14 15:26:26.000000000 =
+1100
> @@ -1857,12 +1857,11 @@ static void NCR5380_information_transfer
>  					d =3D cmd->SCp.ptr;
>  				}
>  				/* this command setup for dma yet? */
> -				if ((count >=3D DMA_MIN_SIZE) && (sun3_dma_setup_done !=3D cmd))=
 {
> -					if (cmd->request->cmd_type =3D=3D REQ_TYPE_FS) {
> -						sun3scsi_dma_setup(instance, d, count,
> -						                   rq_data_dir(cmd->request));
> -						sun3_dma_setup_done =3D cmd;
> -					}
> +				if (sun3_dma_setup_done !=3D cmd &&
> +				    sun3scsi_dma_xfer_len(count, cmd) > 0) {
> +					sun3scsi_dma_setup(instance, d, count,
> +					                   rq_data_dir(cmd->request));
> +					sun3_dma_setup_done =3D cmd;
>  				}
>  #ifdef SUN3_SCSI_VME
>  				dregs->csr |=3D CSR_INTR;
> @@ -1927,7 +1926,7 @@ static void NCR5380_information_transfer
>  #endif
>  					transfersize =3D NCR5380_dma_xfer_len(instance, cmd, phase);
> =20
> -				if (transfersize >=3D DMA_MIN_SIZE) {
> +				if (transfersize > 0) {
>  					len =3D transfersize;
>  					cmd->SCp.phase =3D phase;
>  					if (NCR5380_transfer_dma(instance, &phase,
> @@ -2366,7 +2365,8 @@ static void NCR5380_reselect(struct Scsi
>  			d =3D tmp->SCp.ptr;
>  		}
>  		/* setup this command for dma if not already */
> -		if ((count >=3D DMA_MIN_SIZE) && (sun3_dma_setup_done !=3D tmp)) {
> +		if (sun3_dma_setup_done !=3D tmp &&
> +		    sun3scsi_dma_xfer_len(count, tmp) > 0) {
>  			sun3scsi_dma_setup(instance, d, count,
>  			                   rq_data_dir(tmp->request));
>  			sun3_dma_setup_done =3D tmp;
> Index: linux/drivers/scsi/atari_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_scsi.c	2016-03-14 15:26:23.00000000=
0 +1100
> +++ linux/drivers/scsi/atari_scsi.c	2016-03-14 15:26:26.000000000 +11=
00
> @@ -87,7 +87,6 @@
> =20
>  #define SUPPORT_TAGS
>  #define MAX_TAGS                        32
> -#define DMA_MIN_SIZE                    32
> =20
>  #define NCR5380_implementation_fields   /* none */
> =20
> @@ -605,6 +604,9 @@ static unsigned long atari_dma_xfer_len(
>  {
>  	unsigned long	possible_len, limit;
> =20
> +	if (wanted_len < 32)
> +		return 0;
> +
>  	if (IS_A_TT())
>  		/* TT SCSI DMA can transfer arbitrary #bytes */
>  		return wanted_len;
> Index: linux/drivers/scsi/sun3_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/sun3_scsi.c	2016-03-14 15:26:23.000000000=
 +1100
> +++ linux/drivers/scsi/sun3_scsi.c	2016-03-14 15:26:26.000000000 +110=
0
> @@ -39,9 +39,6 @@
>  /* Definitions for the core NCR5380 driver. */
> =20
>  /* #define SUPPORT_TAGS */
> -/* minimum number of bytes to do dma on */
> -#define DMA_MIN_SIZE                    129
> -
>  /* #define MAX_TAGS                     32 */
> =20
>  #define NCR5380_implementation_fields   /* none */
> @@ -61,7 +58,7 @@
>  #define NCR5380_dma_residual(instance) \
>          sun3scsi_dma_residual(instance)
>  #define NCR5380_dma_xfer_len(instance, cmd, phase) \
> -        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase)=
 & SR_IO))
> +        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd)
> =20
>  #define NCR5380_acquire_dma_irq(instance)    (1)
>  #define NCR5380_release_dma_irq(instance)
> @@ -262,14 +259,13 @@ static inline unsigned long sun3scsi_dma
>  	return last_residual;
>  }
> =20
> -static inline unsigned long sun3scsi_dma_xfer_len(unsigned long want=
ed,
> -						  struct scsi_cmnd *cmd,
> -						  int write_flag)
> +static inline unsigned long sun3scsi_dma_xfer_len(unsigned long want=
ed_len,
> +                                                  struct scsi_cmnd *=
cmd)
>  {
> -	if (cmd->request->cmd_type =3D=3D REQ_TYPE_FS)
> - 		return wanted;
> -	else
> +	if (wanted_len < 129 || cmd->request->cmd_type !=3D REQ_TYPE_FS)
>  		return 0;
> +
> +	return wanted_len;
>  }
> =20
>  static inline int sun3scsi_dma_start(unsigned long count, unsigned c=
har *data)
>=20
>=20
I still would keep the 'DMA_MIN_LEN' definition around for
sun3_scsi.c; makes it a bit more obvious what the magic number '129'
is supposed to mean.

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
