From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/22] ncr5380: Adopt uniform DMA setup convention
Date: Mon, 14 Mar 2016 08:36:22 +0100
Message-ID: <56E669F6.8070407@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042702.976019738@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042702.976019738@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Standardize the DMA setup hooks so that the DMA implementation in
> atari_NCR5380.c can be reconciled with pseudo DMA implementation in
> NCR5380.c.
>=20
> Calls to NCR5380_dma_recv_setup() and NCR5380_dma_send_setup() return
> a negative value on failure, zero on PDMA transfer success and a posi=
tive
> byte count for DMA setup success.
>=20
> This convention is not entirely new, but is now applied consistently.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c      |   21 ++++++++++-----------
>  drivers/scsi/arm/cumana_1.c |   10 ++++++++--
>  drivers/scsi/arm/oak.c      |    4 ++--
>  drivers/scsi/atari_scsi.c   |    3 ---
>  4 files changed, 20 insertions(+), 18 deletions(-)
>=20
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:34.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:37.000000000 +1100
> @@ -1431,7 +1431,7 @@ static int NCR5380_transfer_dma(struct S
>  	register unsigned char p =3D *phase;
>  	register unsigned char *d =3D *data;
>  	unsigned char tmp;
> -	int foo;
> +	int result;
> =20
>  	if ((tmp =3D (NCR5380_read(STATUS_REG) & PHASE_MASK)) !=3D p) {
>  		*phase =3D tmp;
> @@ -1505,9 +1505,9 @@ static int NCR5380_transfer_dma(struct S
>   */
> =20
>  	if (p & SR_IO) {
> -		foo =3D NCR5380_dma_recv_setup(instance, d,
> +		result =3D NCR5380_dma_recv_setup(instance, d,
>  			hostdata->flags & FLAG_DMA_FIXUP ? c - 1 : c);
> -		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
> +		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
>  			/*
>  			 * The workaround was to transfer fewer bytes than we
>  			 * intended to with the pseudo-DMA read function, wait for
> @@ -1525,19 +1525,19 @@ static int NCR5380_transfer_dma(struct S
> =20
>  			if (NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
>  			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
> -				foo =3D -1;
> +				result =3D -1;
>  				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
>  			}
>  			if (NCR5380_poll_politely(instance, STATUS_REG,
>  			                          SR_REQ, 0, HZ) < 0) {
> -				foo =3D -1;
> +				result =3D -1;
>  				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
>  			}
>  			d[c - 1] =3D NCR5380_read(INPUT_DATA_REG);
>  		}
>  	} else {
> -		foo =3D NCR5380_dma_send_setup(instance, d, c);
> -		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
> +		result =3D NCR5380_dma_send_setup(instance, d, c);
> +		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
>  			/*
>  			 * Wait for the last byte to be sent.  If REQ is being asserted f=
or
>  			 * the byte we're interested, we'll ACK it and it will go false.
> @@ -1545,7 +1545,7 @@ static int NCR5380_transfer_dma(struct S
>  			if (NCR5380_poll_politely2(instance,
>  			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
>  			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
> -				foo =3D -1;
> +				result =3D -1;
>  				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase time=
out\n");
>  			}
>  		}
> @@ -1555,8 +1555,7 @@ static int NCR5380_transfer_dma(struct S
>  	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
>  	*data =3D d + c;
>  	*count =3D 0;
> -	*phase =3D NCR5380_read(STATUS_REG) & PHASE_MASK;
> -	return foo;
> +	return result;
>  }
> =20
>  /*

Don't you miss a phase update here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
