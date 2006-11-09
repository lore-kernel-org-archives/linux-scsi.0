From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2/2] libsas fails to compile on s390
Date: Thu, 9 Nov 2006 00:34:07 -0800
Message-ID: <20061109003407.f2c5ea5b.akpm@osdl.org>
References: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34463 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1754769AbWKIIed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 03:34:33 -0500
In-Reply-To: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

On Wed, 08 Nov 2006 19:57:09 -0800
akpm@osdl.org wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Explicitly include scatterlist.h in sas_internal.h to avoid the implicit
> include dependency via the pci.h header.  For s390 the scatterlist.h header
> is not included because CONFIG_PCI=n.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/libsas/sas_internal.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/scsi/libsas/sas_internal.h~libsas-fails-to-compile-on-s390 drivers/scsi/libsas/sas_internal.h
> --- a/drivers/scsi/libsas/sas_internal.h~libsas-fails-to-compile-on-s390
> +++ a/drivers/scsi/libsas/sas_internal.h
> @@ -26,6 +26,7 @@
>  #ifndef _SAS_INTERNAL_H_
>  #define _SAS_INTERNAL_H_
>  
> +#include <linux/scatterlist.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_transport_sas.h>

err, please ignore this one....


In file included from include/linux/scatterlist.h:5,
                 from drivers/scsi/libsas/sas_internal.h:30,
                 from drivers/scsi/libsas/sas_phy.c:26:
include/asm/scatterlist.h:7: error: expected specifier-qualifier-list before 'dma_addr_t'
In file included from drivers/scsi/libsas/sas_internal.h:30,
                 from drivers/scsi/libsas/sas_phy.c:26:
include/linux/scatterlist.h: In function 'sg_set_buf':
include/linux/scatterlist.h:13: error: 'struct scatterlist' has no member named 'length'
In file included from include/linux/dma-mapping.h:35,
                 from include/asm-generic/pci-dma-compat.h:8,
                 from include/asm/pci.h:135,
                 from include/linux/pci.h:717,
                 from include/scsi/libsas.h:32,
                 from drivers/scsi/libsas/sas_internal.h:34,
                 from drivers/scsi/libsas/sas_phy.c:26:
include/asm/dma-mapping.h: In function 'dma_map_sg':
include/asm/dma-mapping.h:44: error: 'struct scatterlist' has no member named 'length'
include/asm/dma-mapping.h:44: warning: type defaults to 'int' in declaration of '__ret_warn_on'
include/asm/dma-mapping.h:44: error: 'struct scatterlist' has no member named 'length'
include/asm/dma-mapping.h:49: error: 'struct scatterlist' has no member named 'dma_address'
distcc[16143] ERROR: compile drivers/scsi/libsas/sas_phy.c on bix/32 failed
make[1]: *** [drivers/scsi/libsas/sas_phy.o] Error 1
make: *** [drivers/scsi/libsas/sas_phy.o] Error 2

