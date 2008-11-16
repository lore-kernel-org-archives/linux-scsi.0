From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Sat, 15 Nov 2008 21:11:20 -0500
Message-ID: <491F8148.9000003@interlog.com>
References: <200811161211.212948789@firstfloor.org> <20081115231113.8F2AF3E6618@basil.firstfloor.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38961 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYKPCLf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 21:11:35 -0500
In-Reply-To: <20081115231113.8F2AF3E6618@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Andi Kleen wrote:
> Instead of using GFP_DMA directly.
> 
> Also I stubbed SG_SET_FORCE_LOW_DMA ioctls which don't make any sense
> because the kernel should always use the correct values on its own.

You propose removing a define from a public interface and thereby
might break existing code. A comment in sg.h might be appropriate.
Something that might trip:
   find <kernel_src_tree> -name '*.[hc]' -exec \
      grep SG_SET_FORCE_LOW_DMA {} \; -print

when the compiler gets upset.

Doug Gilbert


> Signed-off-by: Andi Kleen <ak@suse.de>
> Signed-off-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  drivers/scsi/sg.c |   36 ++++++++----------------------------
>  include/scsi/sg.h |    1 -
>  2 files changed, 8 insertions(+), 29 deletions(-)
> 
> Index: linux/drivers/scsi/sg.c
> ===================================================================
> --- linux.orig/drivers/scsi/sg.c	2008-11-15 22:37:09.000000000 +0100
> +++ linux/drivers/scsi/sg.c	2008-11-15 22:37:12.000000000 +0100
> @@ -49,6 +49,7 @@
>  #include <linux/delay.h>
>  #include <linux/blktrace_api.h>
>  #include <linux/smp_lock.h>
> +#include <linux/gfp.h>
>  
>  #include "scsi.h"
>  #include <scsi/scsi_dbg.h>
> @@ -151,7 +152,6 @@
>  	Sg_request *headrp;	/* head of request slist, NULL->empty */
>  	struct fasync_struct *async_qp;	/* used by asynchronous notification */
>  	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
> -	char low_dma;		/* as in parent but possibly overridden to 1 */
>  	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
>  	volatile char closed;	/* 1 -> fd closed but request(s) outstanding */
>  	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
> @@ -844,24 +844,9 @@
>  				/* strange ..., for backward compatibility */
>  		return sfp->timeout_user;
>  	case SG_SET_FORCE_LOW_DMA:
> -		result = get_user(val, ip);
> -		if (result)
> -			return result;
> -		if (val) {
> -			sfp->low_dma = 1;
> -			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
> -				val = (int) sfp->reserve.bufflen;
> -				sg_remove_scat(&sfp->reserve);
> -				sg_build_reserve(sfp, val);
> -			}
> -		} else {
> -			if (sdp->detached)
> -				return -ENODEV;
> -			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
> -		}
> -		return 0;
> +		return -EINVAL;
>  	case SG_GET_LOW_DMA:
> -		return put_user((int) sfp->low_dma, ip);
> +		return put_user(0, ip);
>  	case SG_GET_SCSI_ID:
>  		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
>  			return -EFAULT;
> @@ -1651,7 +1636,6 @@
>  
>  	if (sg_allow_dio && hp->flags & SG_FLAG_DIRECT_IO &&
>  	    dxfer_dir != SG_DXFER_UNKNOWN && !iov_count &&
> -	    !sfp->parentdp->device->host->unchecked_isa_dma &&
>  	    blk_rq_aligned(q, hp->dxferp, dxfer_len))
>  		md = NULL;
>  	else
> @@ -1727,6 +1711,7 @@
>  static int
>  sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>  {
> +	struct scsi_device *dev = sfp->parentdp->device;
>  	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
>  	int sg_tablesize = sfp->parentdp->sg_tablesize;
>  	int blk_size = buff_size, order;
> @@ -1755,9 +1740,6 @@
>  			scatter_elem_sz_prev = num;
>  	}
>  
> -	if (sfp->low_dma)
> -		gfp_mask |= GFP_DMA;
> -
>  	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>  		gfp_mask |= __GFP_ZERO;
>  
> @@ -1771,7 +1753,8 @@
>  		num = (rem_sz > scatter_elem_sz_prev) ?
>  			scatter_elem_sz_prev : rem_sz;
>  
> -		schp->pages[k] = alloc_pages(gfp_mask, order);
> +		schp->pages[k] = alloc_pages_mask(gfp_mask, num,
> +						  blk_q_mask(dev->request_queue));
>  		if (!schp->pages[k])
>  			goto out;
>  
> @@ -2063,8 +2046,6 @@
>  	sfp->timeout = SG_DEFAULT_TIMEOUT;
>  	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
>  	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
> -	sfp->low_dma = (SG_DEF_FORCE_LOW_DMA == 0) ?
> -	    sdp->device->host->unchecked_isa_dma : 1;
>  	sfp->cmd_q = SG_DEF_COMMAND_Q;
>  	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
>  	sfp->parentdp = sdp;
> @@ -2512,11 +2493,10 @@
>  
>  	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
>  		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
> -			   "(res)sgat=%d low_dma=%d\n", k + 1,
> +			   "(res)sgat=%d\n", k + 1,
>  			   jiffies_to_msecs(fp->timeout),
>  			   fp->reserve.bufflen,
> -			   (int) fp->reserve.k_use_sg,
> -			   (int) fp->low_dma);
> +			   (int) fp->reserve.k_use_sg);
>  		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=%d\n",
>  			   (int) fp->cmd_q, (int) fp->force_packid,
>  			   (int) fp->keep_orphan, (int) fp->closed);
> Index: linux/include/scsi/sg.h
> ===================================================================
> --- linux.orig/include/scsi/sg.h	2008-11-15 22:37:09.000000000 +0100
> +++ linux/include/scsi/sg.h	2008-11-15 22:37:12.000000000 +0100
> @@ -231,7 +231,6 @@
>  #define SG_DEFAULT_RETRIES 0
>  
>  /* Defaults, commented if they differ from original sg driver */
> -#define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
>  #define SG_DEF_FORCE_PACK_ID 0
>  #define SG_DEF_KEEP_ORPHAN 0
>  #define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

