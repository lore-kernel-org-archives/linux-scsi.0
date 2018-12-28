From: LEROY Christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Fri, 28 Dec 2018 17:38:46 +0100
Message-ID: <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>
References: <cover.1545784679.git.fthain@telegraphics.com.au>
 <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Michael Schmitz <schmitzmic@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

Finn Thain <fthain@telegraphics.com.au> a écrit :

> On powerpc, setting CONFIG_NVRAM=n builds a kernel with no NVRAM support.
> Setting CONFIG_NVRAM=m enables the /dev/nvram misc device module without
> enabling NVRAM support in drivers. Setting CONFIG_NVRAM=y enables the
> misc device (built-in) and also enables NVRAM support in drivers.
>
> m68k shares the valkyriefb driver with powerpc, and since that driver uses
> NVRAM, it is affected by CONFIG_ATARI_SCSI, because of the use of
> "select NVRAM".
>
> Adopt the powerpc convention on m68k to avoid surprises.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Christian T. Steigies <cts@debian.org>
> ---
> This patch temporarily disables CONFIG_NVRAM on Atari, to prevent build
> failures when bisecting the rest of this patch series. It gets enabled
> again with the introduction of CONFIG_HAVE_ARCH_NVRAM_OPS, once the
> nvram_* global functions have been moved to an ops struct.
> ---
>  drivers/char/Kconfig      | 5 +----
>  drivers/scsi/Kconfig      | 6 +++---
>  drivers/scsi/atari_scsi.c | 7 ++++---
>  3 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 9d03b2ff5df6..5b54595dfe30 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -236,7 +236,7 @@ source "drivers/char/hw_random/Kconfig"
>
>  config NVRAM
>  	tristate "/dev/nvram support"
> -	depends on ATARI || X86 || GENERIC_NVRAM
> +	depends on X86 || GENERIC_NVRAM
>  	---help---
>  	  If you say Y here and create a character special file /dev/nvram
>  	  with major number 10 and minor number 144 using mknod ("man mknod"),
> @@ -254,9 +254,6 @@ config NVRAM
>  	  should NEVER idly tamper with it. See Ralf Brown's interrupt list
>  	  for a guide to the use of CMOS bytes by your BIOS.
>
> -	  On Atari machines, /dev/nvram is always configured and does not need
> -	  to be selected.
> -
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nvram.
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 640cd1b31a18..924eb69e7fc4 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1381,14 +1381,14 @@ config ATARI_SCSI
>  	tristate "Atari native SCSI support"
>  	depends on ATARI && SCSI
>  	select SCSI_SPI_ATTRS
> -	select NVRAM
>  	---help---
>  	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
>  	  Falcon, ...) say Y to get it supported. Of course also, if you have
>  	  a compatible SCSI controller (e.g. for Medusa).
>
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called atari_scsi.
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called atari_scsi. If you also enable NVRAM support, the SCSI
> +	  host's ID is taken from the setting in TT RTC NVRAM.
>
>  	  This driver supports both styles of NCR integration into the
>  	  system: the TT style (separate DMA), and the Falcon style (via
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 89f5154c40b6..99e5729d910d 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -755,9 +755,10 @@ static int __init atari_scsi_probe(struct  
> platform_device *pdev)
>  	if (ATARIHW_PRESENT(TT_SCSI) && setup_sg_tablesize >= 0)
>  		atari_scsi_template.sg_tablesize = setup_sg_tablesize;
>
> -	if (setup_hostid >= 0) {
> +	if (setup_hostid >= 0)
>  		atari_scsi_template.this_id = setup_hostid & 7;
> -	} else {
> +#ifdef CONFIG_NVRAM
> +	else

Such ifdefs should be avoided in C files.
It would be better to use

} else if (IS_ENABLED(CONFIG_NVRAM)) {

>  		/* Test if a host id is set in the NVRam */
>  		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
>  			unsigned char b = nvram_read_byte(16);
> @@ -768,7 +769,7 @@ static int __init atari_scsi_probe(struct  
> platform_device *pdev)
>  			if (b & 0x80)
>  				atari_scsi_template.this_id = b & 7;
>  		}
> -	}
> +#endif
>
>  	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
>  	 * memory block, since there's always ST-Ram in a Falcon), then
> --
> 2.19.2
