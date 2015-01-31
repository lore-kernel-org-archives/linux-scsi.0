From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2] scsi: NCR5380: use msecs_to_jiffies for conversions
Date: Sun, 1 Feb 2015 10:20:35 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1502010957150.30584@nippy.intranet>
References: <1422692020-6607-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:56142 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbAaXVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jan 2015 18:21:11 -0500
In-Reply-To: <1422692020-6607-1-git-send-email-der.herr@hofr.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org


On Sat, 31 Jan 2015, Nicholas Mc Guire wrote:

> This is only an API consolidation to make things more readable.
> 
> Instances of  var * HZ / 1000  are replaced by  msecs_to_jiffies(var).

... and some instances of "value" are replaced by "msecs_to_jiffies(value)"
which seems to be completely wrong.

> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> 
> v2: the original patch was not taking care of all the dependencies
>     as reported by Finn Thain <fthain@telegraphics.com.au> - this
>     version now uses the suggested config to check the patch.

No. The original patch introduced compiler warnings. v2 changed the format 
specifiers as advised by me. And it also changed g_NCR5380.c (for some 
unstated reason).

The patch revision history should go after a "---" cut line, as is 
described in Documentation/SubmittingPatches.

> 
> Converting milliseconds to jiffies by "val * HZ / 1000" is technically
> ok but msecs_to_jiffies(val) is the cleaner solution and handles all
> corner cases correctly. This is a minor API cleanup only.

Do these corner cases affect constants like 1, 20, 200, 250 or 500 ms?

> 
> This patch was only compile tested with i386_defconfig + CONFIG_ISA=y
> as well as all dependent drivers enabled:
> CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_GENERIC_NCR5380=m
> CONFIG_SCSI_DMX3191D=m, CONFIG_SCSI_DTC3280=m
> CONFIG_SCSI_GENERIC_NCR5380=m, CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
> CONFIG_SCSI_PAS16=m, CONFIG_SCSI_T128=m
> 
> Patch is against 3.19.0-rc6 -next-20150130
> 
> ---
>  drivers/scsi/NCR5380.c   |   10 +++++-----
>  drivers/scsi/g_NCR5380.c |    6 +++---
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 36244d6..35bb93b 100644
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
> @@ -1348,7 +1348,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	 * selection.
>  	 */
>  
> -	timeout = jiffies + (250 * HZ / 1000);
> +	timeout = jiffies + msecs_to_jiffies(250);
>  
>  	/* 
>  	 * XXX very interesting - we're seeing a bounce where the BSY we 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f35792f..9f978ad 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -57,9 +57,9 @@
>   */
>  
>  /* settings for DTC3181E card with only Mustek scanner attached */
> -#define USLEEP_POLL	1
> -#define USLEEP_SLEEP	20
> -#define USLEEP_WAITLONG	500
> +#define USLEEP_POLL	msecs_to_jiffies(1)
> +#define USLEEP_SLEEP	msecs_to_jiffies(20)
> +#define USLEEP_WAITLONG	msecs_to_jiffies(500)
>  
>  #define AUTOPROBE_IRQ
>  
> 

-- 
