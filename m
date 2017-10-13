From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/8] lib: Introduce sgl_alloc() and sgl_free()
Date: Fri, 13 Oct 2017 10:43:43 -0700
Message-ID: <a249d319-83fa-d2c3-5723-21de238787d5@infradead.org>
References: <20171012224550.25440-1-bart.vanassche@wdc.com>
 <20171012224550.25440-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171012224550.25440-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/12/17 15:45, Bart Van Assche wrote:

> diff --git a/lib/sgl_alloc.c b/lib/sgl_alloc.c
> new file mode 100644
> index 000000000000..d96b395dd5c8
> --- /dev/null
> +++ b/lib/sgl_alloc.c
> @@ -0,0 +1,102 @@

> +/**
> + * sgl_free_order - free a scatterlist and its pages
> + * @sg: Scatterlist with one or more elements

      @sgl:

> + * @order: Second argument for __free_pages()
> + */
> +void sgl_free_order(struct scatterlist *sgl, int order)
> +{
> +	struct scatterlist *sg;
> +	struct page *page;
> +
> +	for (sg = sgl; sg; sg = sg_next(sg)) {
> +		page = sg_page(sg);
> +		if (page)
> +			__free_pages(page, order);
> +	}
> +	kfree(sgl);
> +}
> +EXPORT_SYMBOL(sgl_free_order);
> +
> +/**
> + * sgl_free - free a scatterlist and its pages
> + * @sg: Scatterlist with one or more elements

      @sgl:

> + */
> +void sgl_free(struct scatterlist *sgl)
> +{
> +	sgl_free_order(sgl, 0);
> +}
> +EXPORT_SYMBOL(sgl_free);
> 

ta.
-- 
~Randy
