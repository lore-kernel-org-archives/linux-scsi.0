From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Wed, 30 Aug 2006 08:31:16 -0700
Message-ID: <20060830083116.172069a2.rdunlap@xenotime.net>
References: <1156945459.3735.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:55503 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750986AbWH3P16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 11:27:58 -0400
Received: from midway.site ([71.117.233.155]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2006 08:27:52 -0700
In-Reply-To: <1156945459.3735.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ed Lin <ed.lin@promise.com>, Jens Axboe <axboe@suse.de>

On Wed, 30 Aug 2006 09:44:18 -0400 James Bottomley wrote:

> [PATCH] block: add support for shared tag maps
> 
> The current block queue implementation already contains most of the
> machinery for shared tag maps.  The only remaining pieces are a way to
> allocate and destroy a tag map independently of the queues (so that
> the maps can be managed on the life cycle of the overseeing entity)
> 

kernel-doc only:  no blank line between the function name
and its parameter(s) list.

> Index: linux-2.6/block/ll_rw_blk.c
> ===================================================================
> --- linux-2.6.orig/block/ll_rw_blk.c
> +++ linux-2.6/block/ll_rw_blk.c
> @@ -848,6 +848,34 @@ struct request *blk_queue_find_tag(reque
>  EXPORT_SYMBOL(blk_queue_find_tag);
>  
>  /**
> + * __blk_free_tags - release a given set of tag maintenance info
> + *

drop

> + * @bqt:	the tag map to free
> + *
> + * Tries to free the specified @bqt@.  Returns true if it was
> + * actually freed and false if there are still references using it
> + */
> +static int __blk_free_tags(struct blk_queue_tag *bqt)
> +{
> +}
> +
> @@ -862,23 +890,28 @@ static void __blk_queue_free_tags(reques
>  
> +
> +/**
> + * blk_free_tags - release a given set of tag maintenance info
> + *

drop

> + * @bqt:	the tag map to free
> + *
> + * For externally managed @bqt@ frees the map.  Callers of this
> + * function must guarantee to have released all the queues that
> + * might have been using this tag map.
> + */
> +void blk_free_tags(struct blk_queue_tag *bqt)
> +{
> +	if (unlikely(!__blk_free_tags(bqt)))
> +		BUG();
> +}
> +
>  /**
>   * blk_queue_free_tags - release tag maintenance info
>   * @q:  the request queue for the device
> @@ -927,6 +960,38 @@ fail:
> +
> +/**
> + * blk_init_tags - initialize the tag info for an external tag map
> + *

drop

> + * @depth:	the maximum queue depth supported
> + * @tags: the tag to use
> + **/
> +struct blk_queue_tag *blk_init_tags(int depth)
> +{
> +	return __blk_queue_init_tags(NULL, depth);
> +}
> +EXPORT_SYMBOL(blk_init_tags);


---
~Randy
