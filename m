From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: NCR5380: no longer mark irq probing as __init
Date: Tue, 11 Oct 2016 20:39:57 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610112038160.17850@nippy.intranet>
References: <20161011092356.2872181-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161011092356.2872181-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

Thanks.

On Tue, 11 Oct 2016, Arnd Bergmann wrote:

> The g_NCR5380 has been converted to more regular probing, which
> means its probe function can now be invoked after the __init section
> is discarded, as pointed out by this kbuild warning:
> 
> WARNING: drivers/scsi/built-in.o(.text+0x3a105): Section mismatch in reference from the function generic_NCR5380_isa_match() to the function .init.text:probe_intr()
> WARNING: drivers/scsi/built-in.o(.text+0x3a145): Section mismatch in reference from the function generic_NCR5380_isa_match() to the variable .init.data:probe_irq
> 
> To make sure this works correctly in all cases, let's remove
> the __init and __initdata annotations.
> 
> Fixes: a8cfbcaec0c1 ("scsi: g_NCR5380: Stop using scsi_module.c")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/NCR5380.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 7053de5bd468..61f34aca2fa0 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -353,7 +353,7 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
>  #endif
>  
>  
> -static int probe_irq __initdata;
> +static int probe_irq;
>  
>  /**
>   * probe_intr	-	helper for IRQ autoprobe
> @@ -365,7 +365,7 @@ static int probe_irq __initdata;
>   * used by the IRQ probe code.
>   */
>  
> -static irqreturn_t __init probe_intr(int irq, void *dev_id)
> +static irqreturn_t probe_intr(int irq, void *dev_id)
>  {
>  	probe_irq = irq;
>  	return IRQ_HANDLED;
> @@ -380,7 +380,7 @@ static irqreturn_t __init probe_intr(int irq, void *dev_id)
>   * and then looking to see what interrupt actually turned up.
>   */
>  
> -static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
> +static int __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
>  						int possible)
>  {
>  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> 
