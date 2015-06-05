From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] advansys: fix compilation errors and warnings when CONFIG_PCI
 is not set
Date: Fri, 05 Jun 2015 15:09:20 +0200
Message-ID: <55719F80.8010702@suse.de>
References: <CA+r1ZhgMztLi-9E6cV=W1xJkMYG_rTtaJFj4Bv0TFPHmjSU+oQ@mail.gmail.com> <1433318202-1455-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1433318202-1455-1-git-send-email-jthumshirn@suse.de>
Sender: linux-next-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, JBottomley@odin.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/03/2015 09:56 AM, Johannes Thumshirn wrote:
> Fix compilation errors on forgotten #include <linux/dmapool.h> and wa=
rnings when
> CONFIG_PCI is not set.
>=20
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/advansys.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 14d3aa5..4305178 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -37,6 +37,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/firmware.h>
> +#include <linux/dmapool.h>
> =20
>  #include <asm/io.h>
>  #include <asm/dma.h>
> @@ -9435,6 +9436,7 @@ static int AscInitSetConfig(struct pci_dev *pde=
v, struct Scsi_Host *shost)
>   * on big-endian platforms so char fields read as words are actually=
 being
>   * unswapped on big-endian platforms.
>   */
> +#ifdef CONFIG_PCI
>  static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config =3D {
>  	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
>  	0x0000,			/* cfg_msw */
> @@ -9771,7 +9773,6 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Con=
fig_Field_IsChar =3D {
>  	0			/* 63 reserved */
>  };
> =20
> -#ifdef CONFIG_PCI
>  /*
>   * Wait for EEPROM command to complete
>   */
> @@ -11385,7 +11386,9 @@ static int advansys_board_found(struct Scsi_H=
ost *shost, unsigned int iop,
>   err_unmap:
>  	if (boardp->ioremap_addr)
>  		iounmap(boardp->ioremap_addr);
> +#ifdef CONFIG_PCI
>   err_shost:
> +#endif
>  	return ret;
>  }
> =20
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
