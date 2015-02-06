From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v4] scsi: NCR5380: harmonize jiffies conversion with msecs_to_jiffies
Date: Fri, 06 Feb 2015 19:57:16 +1300
Message-ID: <54D465CC.1040106@gmail.com>
References: <1423074621-13180-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32811 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbBFG5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 01:57:21 -0500
Received: by mail-pa0-f46.google.com with SMTP id lj1so15366333pab.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2015 22:57:21 -0800 (PST)
In-Reply-To: <1423074621-13180-1-git-send-email-hofrat@osadl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

The g_NCR5380.c USLEEP timing change restores driver behaviour to what
it was before the configurable HZ value introduced in 2005. The
g_NCR5380.c USLEEP timing settings date back to 1997, so this patch
fixes a bug with the driver timing introduced in 2005 when the
conversion from fixed jiffies count to the ms * HZ / 1000 form was
overlooked.

As no change to the original (i,e. 1997 vintage) driver behaviour is
introduced, I don't think further testing is required.

Acked-by: Michael Schmitz <schmitzmic@gmail.com>

On 05/02/15 07:30, Nicholas Mc Guire wrote:
> Instances of  var * HZ / 1000  are replaced by  msecs_to_jiffies(var).
> In addition some timing constants that assumed HZ 100 were adjusted
> to HZ independent settings based on review comments from Michael Schmitz
> <schmitzmic@gmail.com> and review of the original drivers in 1.0.31 and
> 2.2.16.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> 
> Converting milliseconds to jiffies by "val * HZ / 1000" is technically
> ok but msecs_to_jiffies(val) is the cleaner solution and handles all
> corner cases correctly. 
> 
> v2: The original patch was not taking care of all the dependencies
>     as reported by Finn Thain <fthain@telegraphics.com.au> - this
>     version now uses the suggested config to check the patch.
> v3: g_NCR5380.c changes fixed up based on feedback from Michael Schmitz
>     <schmitzmic@gmail.com> as these settings were from around 1.0.31
>     kernel (or earlier) where HZ was 100 only - thus the unit here is
>     actually 10s of microseconds. This was "verified" by checking the
>     setting changes against 2.2.16 indicating that it was forgotten in
>     1998/99.
> v4: Sync changed with atari_NCR5380.c as well as correct the patch 
>     description as suggested by Finn Thain <fthain@telegraphics.com.au>
> 
> This patch was only compile tested with i386_defconfig + CONFIG_ISA=y
> as well as all (except CONFIG_SCSI_ATARI) drivers enabled as modules:
> CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_GENERIC_NCR5380=m
> CONFIG_SCSI_DMX3191D=m, CONFIG_SCSI_DTC3280=m
> CONFIG_SCSI_GENERIC_NCR5380=m, CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
> CONFIG_SCSI_PAS16=m, CONFIG_SCSI_T128=m
> 
> Note that the change to atari_NCR5380.c was not even compile-tested 
> (crosstool-ng m68k-unknown-elf and m68k-unknown-uclinux-uclibc fail to
> build atari_defconfig or multi_defconfig (or I failed to build the 
> toolchain properly))
> 
> Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)
> 
>  drivers/scsi/NCR5380.c       |   10 +++++-----
>  drivers/scsi/atari_NCR5380.c |    2 +-
>  drivers/scsi/g_NCR5380.c     |    6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 8981701..a777e5c 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -474,11 +474,11 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
>   */
>  #ifndef USLEEP_SLEEP
>  /* 20 ms (reasonable hard disk speed) */
> -#define USLEEP_SLEEP (20*HZ/1000)
> +#define USLEEP_SLEEP msecs_to_jiffies(20)
>  #endif
>  /* 300 RPM (floppy speed) */
>  #ifndef USLEEP_POLL
> -#define USLEEP_POLL (200*HZ/1000)
> +#define USLEEP_POLL msecs_to_jiffies(200)
>  #endif
>  #ifndef USLEEP_WAITLONG
>  /* RvC: (reasonable time to wait on select error) */
> @@ -576,7 +576,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
>  		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
>  			trying_irqs |= mask;
>  
> -	timeout = jiffies + (250 * HZ / 1000);
> +	timeout = jiffies + msecs_to_jiffies(250);
>  	probe_irq = NO_IRQ;
>  
>  	/*
> @@ -634,7 +634,7 @@ static void prepare_info(struct Scsi_Host *instance)
>  	         "sg_tablesize %d, this_id %d, "
>  	         "flags { %s%s%s}, "
>  #if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
> -	         "USLEEP_POLL %d, USLEEP_WAITLONG %d, "
> +		 "USLEEP_POLL %lu, USLEEP_WAITLONG %lu, "
>  #endif
>  	         "options { %s} ",
>  	         instance->hostt->name, instance->io_port, instance->n_io_port,
> @@ -1346,7 +1346,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	 * selection.
>  	 */
>  
> -	timeout = jiffies + (250 * HZ / 1000);
> +	timeout = jiffies + msecs_to_jiffies(250);
>  
>  	/* 
>  	 * XXX very interesting - we're seeing a bounce where the BSY we 
> diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
> index a702554..db87ece 100644
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -1486,7 +1486,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	 * selection.
>  	 */
>  
> -	timeout = jiffies + (250 * HZ / 1000);
> +	timeout = jiffies + msecs_to_jiffies(250);
>  
>  	/*
>  	 * XXX very interesting - we're seeing a bounce where the BSY we
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f35792f..a11b152 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -57,9 +57,9 @@
>   */
>  
>  /* settings for DTC3181E card with only Mustek scanner attached */
> -#define USLEEP_POLL	1
> -#define USLEEP_SLEEP	20
> -#define USLEEP_WAITLONG	500
> +#define USLEEP_POLL	msecs_to_jiffies(10)
> +#define USLEEP_SLEEP	msecs_to_jiffies(200)
> +#define USLEEP_WAITLONG	msecs_to_jiffies(5000)
>  
>  #define AUTOPROBE_IRQ
>  
> 

