From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/22] ncr5380: Fix register decoding for debugging
Date: Mon, 14 Mar 2016 08:46:11 +0100
Message-ID: <56E66C43.4030208@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042704.806019139@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042704.806019139@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Decode all bits in the chip registers. They are all useful at times.
> Fix printk severity so that this output can be suppressed along with
> the other debugging output.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c |   42 +++++++++++++++++++++++++-------------=
----
>  1 file changed, 25 insertions(+), 17 deletions(-)
>=20
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:48.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:50.000000000 +1100
> @@ -256,12 +256,20 @@ static struct {
>  	{0, NULL}
>  },
>  basrs[] =3D {
> +	{BASR_END_DMA_TRANSFER, "END OF DMA"},
> +	{BASR_DRQ, "DRQ"},
> +	{BASR_PARITY_ERROR, "PARITY ERROR"},
> +	{BASR_IRQ, "IRQ"},
> +	{BASR_PHASE_MATCH, "PHASE MATCH"},
> +	{BASR_BUSY_ERROR, "BUSY ERROR"},
>  	{BASR_ATN, "ATN"},
>  	{BASR_ACK, "ACK"},
>  	{0, NULL}
>  },
>  icrs[] =3D {
>  	{ICR_ASSERT_RST, "ASSERT RST"},
> +	{ICR_ARBITRATION_PROGRESS, "ARB. IN PROGRESS"},
> +	{ICR_ARBITRATION_LOST, "LOST ARB."},
>  	{ICR_ASSERT_ACK, "ASSERT ACK"},
>  	{ICR_ASSERT_BSY, "ASSERT BSY"},
>  	{ICR_ASSERT_SEL, "ASSERT SEL"},
> @@ -270,14 +278,14 @@ icrs[] =3D {
>  	{0, NULL}
>  },
>  mrs[] =3D {
> -	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"},
> -	{MR_TARGET, "MODE TARGET"},
> -	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
> -	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
> -	{MR_ENABLE_EOP_INTR, "MODE EOP INTR"},
> -	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
> -	{MR_DMA_MODE, "MODE DMA"},
> -	{MR_ARBITRATE, "MODE ARBITRATION"},
> +	{MR_BLOCK_DMA_MODE, "BLOCK DMA MODE"},
> +	{MR_TARGET, "TARGET"},
> +	{MR_ENABLE_PAR_CHECK, "PARITY CHECK"},
> +	{MR_ENABLE_PAR_INTR, "PARITY INTR"},
> +	{MR_ENABLE_EOP_INTR, "EOP INTR"},
> +	{MR_MONITOR_BSY, "MONITOR BSY"},
> +	{MR_DMA_MODE, "DMA MODE"},
> +	{MR_ARBITRATE, "ARBITRATE"},
>  	{0, NULL}
>  };
> =20
> @@ -298,23 +306,23 @@ static void NCR5380_print(struct Scsi_Ho
>  	icr =3D NCR5380_read(INITIATOR_COMMAND_REG);
>  	basr =3D NCR5380_read(BUS_AND_STATUS_REG);
> =20
> -	printk("STATUS_REG: %02x ", status);
> +	printk(KERN_DEBUG "SR =3D   0x%02x : ", status);
>  	for (i =3D 0; signals[i].mask; ++i)
>  		if (status & signals[i].mask)
> -			printk(",%s", signals[i].name);
> -	printk("\nBASR: %02x ", basr);
> +			printk(KERN_CONT "%s, ", signals[i].name);
> +	printk(KERN_CONT "\nBASR =3D 0x%02x : ", basr);
>  	for (i =3D 0; basrs[i].mask; ++i)
>  		if (basr & basrs[i].mask)
> -			printk(",%s", basrs[i].name);
> -	printk("\nICR: %02x ", icr);
> +			printk(KERN_CONT "%s, ", basrs[i].name);
> +	printk(KERN_CONT "\nICR =3D  0x%02x : ", icr);
>  	for (i =3D 0; icrs[i].mask; ++i)
>  		if (icr & icrs[i].mask)
> -			printk(",%s", icrs[i].name);
> -	printk("\nMODE: %02x ", mr);
> +			printk(KERN_CONT "%s, ", icrs[i].name);
> +	printk(KERN_CONT "\nMR =3D   0x%02x : ", mr);
>  	for (i =3D 0; mrs[i].mask; ++i)
>  		if (mr & mrs[i].mask)
> -			printk(",%s", mrs[i].name);
> -	printk("\n");
> +			printk(KERN_CONT "%s, ", mrs[i].name);
> +	printk(KERN_CONT "\n");
>  }
> =20
>  static struct {
>=20
>=20
Well ... using individual printk() like here might end up in each
call to be broken up into individual lines.
You might want to consider using a line buffer here or, better
still, move to seq_file or debugfs output.

But as the original code did that, too:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
