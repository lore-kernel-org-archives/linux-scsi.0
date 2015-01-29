From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: ncr5380: use msecs_to_jiffies for conversions
Date: Thu, 29 Jan 2015 18:26:42 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1501291826000.7510@nippy.intranet>
References: <1421926937-1535-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:37779 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbA2H1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 02:27:18 -0500
In-Reply-To: <1421926937-1535-1-git-send-email-der.herr@hofr.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org


NAK. Does your compiler not warn?

  CC      drivers/scsi/pas16.o
In file included from drivers/scsi/pas16.c:557:0:
drivers/scsi/NCR5380.c: In function 'prepare_info':
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 16 has type 'long unsigned int' [-Wformat]
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 17 has type 'long unsigned int' [-Wformat]
  CC      drivers/scsi/t128.o
In file included from drivers/scsi/t128.c:392:0:
drivers/scsi/NCR5380.c: In function 'prepare_info':
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 16 has type 'long unsigned int' [-Wformat]
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 17 has type 'long unsigned int' [-Wformat]
  CC      drivers/scsi/dmx3191d.o
In file included from drivers/scsi/dmx3191d.c:52:0:
drivers/scsi/NCR5380.c: In function 'prepare_info':
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 16 has type 'long unsigned int' [-Wformat]
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 17 has type 'long unsigned int' [-Wformat]
  CC      drivers/scsi/dtc.o
In file included from drivers/scsi/dtc.c:425:0:
drivers/scsi/NCR5380.c: In function 'prepare_info':
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 16 has type 'long unsigned int' [-Wformat]
drivers/scsi/NCR5380.c:674:11: warning: format '%d' expects argument of 
type 'int', but argument 17 has type 'long unsigned int' [-Wformat]


On Thu, 22 Jan 2015, Nicholas Mc Guire wrote:

> This is only an API consolidation to make things more readable
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> Converting milliseconds to jiffies by "val * HZ / 1000" is technically
> ok but msecs_to_jiffies(val) is the cleaner solution and handles all 
> corner cases correctly. This is a minor API cleanup only.
> 
> This patch was only compile tested with i386_defconfig + CONFIG_ISA=y,
> CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_GENERIC_NCR5380=m
> 
> Patch is against 3.19.0-rc5 -next-20150119
> 
>  drivers/scsi/NCR5380.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 36244d6..5008a0e 100644
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
> @@ -1348,7 +1348,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
>  	 * selection.
>  	 */
>  
> -	timeout = jiffies + (250 * HZ / 1000);
> +	timeout = jiffies + msecs_to_jiffies(250);
>  
>  	/* 
>  	 * XXX very interesting - we're seeing a bounce where the BSY we 
> 
