From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] don't export bio_map_kern
Date: Mon, 20 Jun 2005 12:37:51 +0200
Message-ID: <20050620103750.GB15021@suse.de>
References: <20050619093113.GB16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2269 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261158AbVFTKgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:36:31 -0400
Content-Disposition: inline
In-Reply-To: <20050619093113.GB16872@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jun 19 2005, Christoph Hellwig wrote:
> Modules should use the higher-level blk_rq_map_kern, which they
> currently do anyway.
> 
> 
> Index: linux-2.6/fs/bio.c
> ===================================================================
> --- linux-2.6.orig/fs/bio.c	2005-06-18 17:26:42.000000000 +0200
> +++ linux-2.6/fs/bio.c	2005-06-18 17:49:31.000000000 +0200
> @@ -1201,7 +1201,6 @@
>  EXPORT_SYMBOL(bio_add_page);
>  EXPORT_SYMBOL(bio_get_nr_vecs);
>  EXPORT_SYMBOL(bio_unmap_user);
> -EXPORT_SYMBOL(bio_map_kern);
>  EXPORT_SYMBOL(bio_pair_release);
>  EXPORT_SYMBOL(bio_split);
>  EXPORT_SYMBOL(bio_split_pool);

Why? It would be perfectly legit for stacking driver to set up their own
bio with kernel mapped data. As with bio_map_user(), blk_rq_map_kern
isn't the only valid user of bio_map_kern().

-- 
Jens Axboe

