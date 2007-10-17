From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] swiotlb: fix map_sg failure handling
Date: Wed, 17 Oct 2007 10:05:34 +0200
Message-ID: <20071017080534.GB5043@kernel.dk>
References: <20071017170329B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXJQIGE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 04:06:04 -0400
Content-Disposition: inline
In-Reply-To: <20071017170329B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tomof@acm.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> sg list elements might not be continuous.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  lib/swiotlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index c419ecf..752fd95 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -696,7 +696,7 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
>  				/* Don't panic here, we expect map_sg users
>  				   to do proper error handling. */
>  				swiotlb_full(hwdev, sg->length, dir, 0);
> -				swiotlb_unmap_sg(hwdev, sg - i, i, dir);
> +				swiotlb_unmap_sg(hwdev, sgl, i, dir);
>  				sgl[0].dma_length = 0;
>  				return 0;
>  			}

Auch indeed, no math on sg entries! Applied.

-- 
Jens Axboe

