From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH] scsi: ultrastor.c depends on ISA_DMA_API
Date: Thu, 19 May 2016 14:53:35 -0400
Message-ID: <20160519185335.GA18253@sophia>
References: <20160519164501.4cc8bc4f@canb.auug.org.au>
 <573DFE8B.2070808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <573DFE8B.2070808@infradead.org>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 19, 2016 at 10:57:31AM -0700, Randy Dunlap wrote:
>From: Randy Dunlap <rdunlap@infradead.org>
>
>Fix build when CONFIG_ISA_DMA_API is not enabled. Fixes these
>build errors (on x86_64):
>
>../drivers/scsi/ultrastor.c: In function 'ultrastor_14f_detect':
>../drivers/scsi/ultrastor.c:519:5: error: implicit declaration of function 'request_dma' [-Werror=implicit-function-declaration]
>     if (config.dma_channel && request_dma(config.dma_channel,"Ultrastor")) {
>     ^
>../drivers/scsi/ultrastor.c: In function 'ultrastor_release':
>../drivers/scsi/ultrastor.c:658:3: error: implicit declaration of function 'free_dma' [-Werror=implicit-function-declaration]
>   free_dma(shost->dma_channel);
>   ^
>
>Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>---
> drivers/scsi/Kconfig |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Found in linux-next but also applies to mainline.
>
>--- linux-next-20160519.orig/drivers/scsi/Kconfig
>+++ linux-next-20160519/drivers/scsi/Kconfig
>@@ -1433,7 +1433,7 @@ config SCSI_U14_34F_MAX_TAGS
> 
> config SCSI_ULTRASTOR
> 	tristate "UltraStor SCSI support"
>-	depends on X86 && ISA && SCSI
>+	depends on X86 && ISA && SCSI && ISA_DMA_API
> 	---help---
> 	  This is support for the UltraStor 14F, 24F and 34F SCSI-2 host
> 	  adapter family.  This driver is explained in section 3.12 of the

The CONFIG_ISA dependency may be removed from the CONFIG_SCSI_ULTRASTOR
Kconfig depends line; the drivers/scsi/ultrastor.c file does not appear
to use the ISA bus driver symbols at all.

Although request_dma and free_dma are conditionally dependent on
CONFIG_ISA_DMA_API inside the arch/x86/include/asm/dma.h file, they are
defined inside the kernel/dma.c file which depends on
CONFIG_GENERIC_ISA_DMA in order to build on X86. Therefore,
GENERIC_ISA_DMA should be in the depends line for SCSI_ULTRASTOR instead
of ISA_DMA_API.

William Breathitt Gray
