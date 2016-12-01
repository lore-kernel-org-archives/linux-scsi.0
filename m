From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 27/39] Annotate hardware config module parameters in
 drivers/scsi/
Date: Fri, 2 Dec 2016 09:05:41 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1612020903450.24840@nippy.intranet>
References: <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk> <148059559339.31612.16180464424786438715.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148059559339.31612.16180464424786438715.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>, Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, gnomes@lxorguk.ukuu.org.uk, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, minyard@acm.org, "Juergen E. Fischer" <fischer@norbit.de>, Dario Ballabio <ballabio_dario@emc.com>
List-Id: linux-scsi@vger.kernel.org


On Thu, 1 Dec 2016, David Howells wrote:

> When the kernel is running in secure boot mode, we lock down the kernel 
> to prevent userspace from modifying the running kernel image.  Whilst 
> this includes prohibiting access to things like /dev/mem, it must also 
> prevent access by means of configuring driver modules in such a way as 
> to cause a device to access or modify the kernel image.
> 

I can see how base addresses and IO ports are relevant, but the irq 
parameter changes below don't protect the kernel image AFAICT. What's the 
rationale for those changes? I think it should be stated here.

> To this end, annotate module_param* statements that refer to hardware 
> configuration and indicate for future reference what type of parameter 
> they specify.  The parameter parser in the core sees this information 
> and can skip such parameters with an error message if the kernel is 
> locked down. The module initialisation then runs as normal, but just 
> sees whatever the default values for those parameters is.
> 
> Note that we do still need to do the module initialisation because some 
> drivers have viable defaults set in case parameters aren't specified and 
> some drivers support automatic configuration (e.g. PNP or PCI) in 
> addition to manually coded parameters.
> 
> This patch annotates drivers in drivers/scsi/.
> 
> Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "Juergen E. Fischer" <fischer@norbit.de>
> cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> cc: Dario Ballabio <ballabio_dario@emc.com>
> cc: Finn Thain <fthain@telegraphics.com.au>
> cc: Michael Schmitz <schmitzmic@gmail.com>
> cc: Achim Leubner <achim_leubner@adaptec.com>
> cc: linux-scsi@vger.kernel.org
> ---
> 
>  drivers/scsi/aha152x.c   |    4 ++--
>  drivers/scsi/aha1542.c   |    2 +-
>  drivers/scsi/g_NCR5380.c |    8 ++++----
>  drivers/scsi/gdth.c      |    2 +-
>  drivers/scsi/qlogicfas.c |    4 ++--
>  5 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index f44d0487236e..ce5dc73d85bb 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -331,11 +331,11 @@ MODULE_LICENSE("GPL");
>  #if !defined(PCMCIA)
>  #if defined(MODULE)
>  static int io[] = {0, 0};
> -module_param_array(io, int, NULL, 0);
> +module_param_hw_array(io, int, ioport, NULL, 0);
>  MODULE_PARM_DESC(io,"base io address of controller");
>  
>  static int irq[] = {0, 0};
> -module_param_array(irq, int, NULL, 0);
> +module_param_hw_array(irq, int, irq, NULL, 0);
>  MODULE_PARM_DESC(irq,"interrupt for controller");
>  
>  static int scsiid[] = {7, 7};
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index 7db448ec8beb..a23cc9ac5acd 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -31,7 +31,7 @@ module_param(isapnp, bool, 0);
>  MODULE_PARM_DESC(isapnp, "enable PnP support (default=1)");
>  
>  static int io[MAXBOARDS] = { 0x330, 0x334, 0, 0 };
> -module_param_array(io, int, NULL, 0);
> +module_param_hw_array(io, int, ioport, NULL, 0);
>  MODULE_PARM_DESC(io, "base IO address of controller (0x130,0x134,0x230,0x234,0x330,0x334, default=0x330,0x334)");
>  
>  /* time AHA spends on the AT-bus during data transfer */
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index cbf010324c18..cf4fa7a2e738 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -44,8 +44,8 @@ static int ncr_53c400;
>  static int ncr_53c400a;
>  static int dtc_3181e;
>  static int hp_c2502;
> -module_param(ncr_irq, int, 0);
> -module_param(ncr_addr, int, 0);
> +module_param_hw(ncr_irq, int, irq, 0);
> +module_param_hw(ncr_addr, int, ioport, 0);
>  module_param(ncr_5380, int, 0);
>  module_param(ncr_53c400, int, 0);
>  module_param(ncr_53c400a, int, 0);
> @@ -53,11 +53,11 @@ module_param(dtc_3181e, int, 0);
>  module_param(hp_c2502, int, 0);
>  
>  static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> -module_param_array(irq, int, NULL, 0);
> +module_param_hw_array(irq, int, irq, NULL, 0);
>  MODULE_PARM_DESC(irq, "IRQ number(s)");
>  
>  static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
> -module_param_array(base, int, NULL, 0);
> +module_param_hw_array(base, int, ioport, NULL, 0);
>  MODULE_PARM_DESC(base, "base address(es)");
>  
>  static int card[] = { -1, -1, -1, -1, -1, -1, -1, -1 };
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 0a767740bf02..4ec08fb2dfa8 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -353,7 +353,7 @@ static int probe_eisa_isa = 0;
>  static int force_dma32 = 0;
>  
>  /* parameters for modprobe/insmod */
> -module_param_array(irq, int, NULL, 0);
> +module_param_hw_array(irq, int, irq, NULL, 0);
>  module_param(disable, int, 0);
>  module_param(reserve_mode, int, 0);
>  module_param_array(reserve_list, int, NULL, 0);
> diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
> index 61cac87fb86f..840823b99e51 100644
> --- a/drivers/scsi/qlogicfas.c
> +++ b/drivers/scsi/qlogicfas.c
> @@ -137,8 +137,8 @@ static struct Scsi_Host *__qlogicfas_detect(struct scsi_host_template *host,
>  static struct qlogicfas408_priv *cards;
>  static int iobase[MAX_QLOGICFAS];
>  static int irq[MAX_QLOGICFAS] = { [0 ... MAX_QLOGICFAS-1] = -1 };
> -module_param_array(iobase, int, NULL, 0);
> -module_param_array(irq, int, NULL, 0);
> +module_param_hw_array(iobase, int, ioport, NULL, 0);
> +module_param_hw_array(irq, int, irq, NULL, 0);
>  MODULE_PARM_DESC(iobase, "I/O address");
>  MODULE_PARM_DESC(irq, "IRQ");
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
