From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] aacraid: add call to flush_kernel_dcache_page for
	architectures that require it.
Date: Fri, 11 Jan 2008 10:41:02 -0600
Message-ID: <1200069662.3286.21.camel@localhost.localdomain>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	 <20071101173221.2e1fea42.sfr@canb.auug.org.au>
	 <jefxzqqeha.fsf@sykes.suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC622@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41454 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbYAKQlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 11:41:07 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC622@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


On Tue, 2008-01-08 at 12:09 -0800, Salyzyn, Mark wrote:
> Some architectures require a call to flush_kernel_dcache_page for processor spoofed DMA operations.
> 
> This attached patch is against current scsi-misc-2.6.
> 
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments (inline gets damaged, use attachment).
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> 
>  aachba.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c     2008-01-08 15:01:21.503932722 -0500
> +++ b/drivers/scsi/aacraid/aachba.c     2008-01-08 15:02:35.849634368 -0500
> @@ -31,9 +31,9 @@
>  #include <linux/slab.h>
>  #include <linux/completion.h>
>  #include <linux/blkdev.h>
> -#include <linux/dma-mapping.h>
>  #include <asm/semaphore.h>
>  #include <asm/uaccess.h>
> +#include <linux/highmem.h> /* For flush_kernel_dcache_page */
> 
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -366,6 +366,9 @@
>         if (buf && transfer_len > 0)
>                 memcpy(buf + offset, data, transfer_len);
> 
> +#ifdef ARCH_HAS_FLUSH_ANON_PAGE
> +       flush_kernel_dcache_page(kmap_atomic_to_page(buf - sg->offset));
> +#endif

This #ifdef/#endif guard is unnecessary ... flush_kernel_dcache_page()
is available on all architectures (it's a nop on most).

However, ARCH_HAS_FLUSH_ANON_PAGE is the wrong guard anyway ... that's
for the flush_anon_page() function ...

James


