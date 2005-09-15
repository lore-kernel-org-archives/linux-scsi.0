From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC/RFT 1/4]  add some block layer helpers
Date: Thu, 15 Sep 2005 01:19:44 -0500
Message-ID: <43291280.5060506@cs.wisc.edu>
References: <1126736384.16778.24.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:15045 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932536AbVIOGTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 02:19:46 -0400
Received: from [192.168.0.4] (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8F6JjWr023357
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 01:19:45 -0500
In-Reply-To: <1126736384.16778.24.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mike Christie wrote:
> add blk_rq_map_kern_iov() which takes a iovec of buffers then
> maps them into bios and a request. It can make them into multiple
> bios to support sg and st's large requests and avoid the BIO_MAX_PAGES
> limit.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
> --- a/drivers/block/ll_rw_blk.c
> +++ b/drivers/block/ll_rw_blk.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include <linux/swap.h>
>  #include <linux/writeback.h>
> +#include <linux/uio.h>
>  #include <linux/blkdev.h>
>  
>  /*
> @@ -2278,6 +2279,70 @@ int blk_rq_map_kern(request_queue_t *q, 
>  EXPORT_SYMBOL(blk_rq_map_kern);
>  
>  /**
> + * blk_rq_map_kern_iov - map kernel data to a request, for REQ_BLOCK_PC usage
> + * @q:		request queue where request should be inserted
> + * @rq:		request to fill
> + * @vec:	pointer to kvec
> + * @vec_count:	number of elements in kvec
> + * @gfp_mask:	memory allocation flags
> + *
> + * blk_rq_map_kern_iov maps a kvec into a multiple bio request so that
> + * it can create very large requests.
> + *
> + * For now we assume that each element will fit in one bio
> + */
> +int blk_rq_map_kern_iov(request_queue_t *q, struct request *rq,
> +			struct kvec *vec, int vec_count, unsigned int gfp)
> +{

On second thought, I think this function should work on pages and not 
kernel addresses. It also has a leak in the error path.
