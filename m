From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/6] g_NCR5380: Autoprobe IRQ by default
Date: Wed, 2 Nov 2016 18:47:43 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611011234400.25806@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-6-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477945112-25659-6-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 31 Oct 2016, Ondrej Zary wrote:

> IRQ probing seems to work fine now. Default to autoprobe for IRQ instead
> of disabling it.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 27fc499..6a08d3e 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -52,9 +52,9 @@
>  module_param(dtc_3181e, int, 0);
>  module_param(hp_c2502, int, 0);
>  
> -static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> +static int irq[] = { IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO };
>  module_param_array(irq, int, NULL, 0);
> -MODULE_PARM_DESC(irq, "IRQ number(s)");
> +MODULE_PARM_DESC(irq, "IRQ number(s) (0=disable, 254=auto [default])");
>  
>  static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
>  module_param_array(base, int, NULL, 0);
> 

I think this patch is incomplete and you should add these changes:

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 7299ad9..0bf0322 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -44,7 +44,7 @@ static int ncr_53c400;
 static int ncr_53c400a;
 static int dtc_3181e;
 static int hp_c2502;
-module_param(ncr_irq, int, 0);
+module_param(ncr_irq, int, IRQ_AUTO);
 module_param(ncr_addr, int, 0);
 module_param(ncr_5380, int, 0);
 module_param(ncr_53c400, int, 0);
@@ -597,7 +597,7 @@ static int __init generic_NCR5380_init(void)
 	int ret = 0;
 
 	/* compatibility with old-style parameters */
-	if (irq[0] == 0 && base[0] == 0 && card[0] == -1) {
+	if (irq[0] == IRQ_AUTO && base[0] == 0 && card[0] == -1) {
 		irq[0] = ncr_irq;
 		base[0] = ncr_addr;
 		if (ncr_5380)

-- 
