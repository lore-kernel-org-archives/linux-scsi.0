From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/1] sg: SG_IO 64k page fix
Date: Tue, 19 Sep 2006 11:34:57 -0400
Message-ID: <45100E21.3070604@torque.net>
References: <200609191445.k8JEjZv0030677@d01av03.pok.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17348 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751339AbWISPfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 11:35:10 -0400
In-Reply-To: <200609191445.k8JEjZv0030677@d01av03.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Brian King wrote:
> When attempting to use SG_IO for a large data transfer to a scsi device,
> on a PPC64 machine with 64k page support enabled, the following oops was
> encountered:
> 
> Unable to handle kernel paging request for data at address 0x6e6669672f707063
> Faulting instruction address: 0xc0000000000d5e88
> cpu 0x3: Vector: 300 (Data Access) at [c00000003a1e7130]
>     pc: c0000000000d5e88: .kmem_cache_free+0x64/0x2d4
>     lr: c0000000000ac310: .mempool_free_slab+0x1c/0x30
>     sp: c00000003a1e73b0
>    msr: 8000000000009032
>    dar: 6e6669672f707063
>  dsisr: 40000000
>   current = 0xc000000002aef610
>   paca    = 0xc000000000494980
>     pid   = 23041, comm = iprconfig
> enter ? for help
> 3:mon> t
> [c00000003a1e7460] c0000000000ac310 .mempool_free_slab+0x1c/0x30
> [c00000003a1e74e0] c0000000000ac3e4 .mempool_free+0xc0/0xe0
> [c00000003a1e7570] c0000000000e5f48 .bio_free+0x48/0x74
> [c00000003a1e7600] c0000000000e5b08 .bio_put+0x80/0x94
> [c00000003a1e7680] d0000000000e7460 .scsi_execute_async+0x1d8/0x4a0 [scsi_mod]
> [c00000003a1e7790] d0000000003b28d8 .sg_common_write+0x8b4/0x958 [sg]
> [c00000003a1e78c0] d0000000003b2bfc .sg_new_write+0x280/0x2ec [sg]
> [c00000003a1e7990] d0000000003b4d50 .sg_ioctl+0x224/0x1024 [sg]
> [c00000003a1e7a80] c0000000000f8310 .do_ioctl+0xbc/0xf0
> [c00000003a1e7b20] c0000000000f879c .vfs_ioctl+0x458/0x498
> [c00000003a1e7bd0] c0000000000f8874 .sys_ioctl+0x98/0xe0
> [c00000003a1e7c80] c000000000121f58 .sg_ioctl_trans+0x4fc/0x610
> [c00000003a1e7d70] c00000000011c62c .compat_sys_ioctl+0x330/0x3b4
> [c00000003a1e7e30] c00000000000871c syscall_exit+0x0/0x40
> 
> The problem appears to be in the definition of SG_SCATTER_SZ. The comment
> states that it must be a power of 2, must be less than PAGE_SIZE * 32,
> and must be at least as large as PAGE_SIZE. For 64k pages, this is not
> true. Increasing SG_SCATTER_SZ to 64k fixed the oops in my configuration.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  linux-2.6-bjking1/include/scsi/sg.h |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN include/scsi/sg.h~sg_large_page_support include/scsi/sg.h
> --- linux-2.6/include/scsi/sg.h~sg_large_page_support	2006-09-19 09:24:06.000000000 -0500
> +++ linux-2.6-bjking1/include/scsi/sg.h	2006-09-19 09:27:00.000000000 -0500
> @@ -238,7 +238,7 @@ typedef struct sg_req_info { /* used by 
>  #define SG_GET_ACCESS_COUNT 0x2289  
>  
>  
> -#define SG_SCATTER_SZ (8 * 4096)  /* PAGE_SIZE not available to user */
> +#define SG_SCATTER_SZ (16 * 4096)  /* PAGE_SIZE not available to user */
>  /* Largest size (in bytes) a single scatter-gather list element can have.
>     The value must be a power of 2 and <= (PAGE_SIZE * 32) [131072 bytes on
>     i386]. The minimum value is PAGE_SIZE. If scatter-gather not supported
> _

Brian,
Yes that obviously needs to be fixed. However the patch
is a bit fragile, for example if some architecture decides
to have an option for 128 KB page size or larger.

I've got a patch to add a sysfs/boottime attribute for
setting max_scatter_elem_sz. If that logic made an additional
check, adjusting max_scatter_elem_sz up to PAGE_SIZE if
necessary. The SG_SCATTER_SZ define could stay as is,
apart from an additional note that it will be forced to
PAGE_SIZE if necessary.

Doug Gilbert


