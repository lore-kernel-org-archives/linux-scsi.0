From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Fri, 22 May 2009 20:32:54 +0200
Message-ID: <200905222032.55869.bzolnier@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com> <a998340033c8f89ec028b354ebe2956239144049.1242855716.git.wuzhangjin@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <a998340033c8f89ec028b354ebe2956239144049.1242855716.git.wuzhangjin@gmail.com>
Content-Disposition: inline
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Yan hua <yanh@lemote.com>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This is originally from the to-mips branch from
> http://dev.lemote.com/code/linux_loongson

Sadly, the patch description lacks all the important information.

What is the original problem that this fixup tries to address?

Is it limited to amd74xx controllers?

[ We are generalizing quirk_drives handling currently... ]

> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  drivers/ide/amd74xx.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
> index 77267c8..8f488b8 100644
> --- a/drivers/ide/amd74xx.c
> +++ b/drivers/ide/amd74xx.c
> @@ -23,6 +23,11 @@
>  
>  #define DRV_NAME "amd74xx"
>  
> +static const char *am74xx_quirk_drives[] = {
> +	"FUJITSU MHZ2160BH G2",
> +	NULL
> +};
> +
>  enum {
>  	AMD_IDE_CONFIG		= 0x41,
>  	AMD_CABLE_DETECT	= 0x42,
> @@ -112,6 +117,19 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
>  	amd_set_drive(drive, XFER_PIO_0 + pio);
>  }
>  
> +static void amd_quirkproc(ide_drive_t *drive)
> +{
> +	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
> +
> +	for (list = am74xx_quirk_drives; *list != NULL; list++)
> +			if (strstr(m, *list) != NULL) {
> +				drive->quirk_list = 2;
> +				return;
> +			}
> +
> +	drive->quirk_list = 0;
> +}
> +
>  static void amd7409_cable_detect(struct pci_dev *dev)
>  {
>  	/* no host side cable detection */
> @@ -194,6 +212,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
>  static const struct ide_port_ops amd_port_ops = {
>  	.set_pio_mode		= amd_set_pio_mode,
>  	.set_dma_mode		= amd_set_drive,
> +	.quirkproc		= amd_quirkproc,
>  	.cable_detect		= amd_cable_detect,
>  };
