From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 4/9] dmapool: improve scalability of dma_pool_alloc
Date: Thu, 2 Aug 2018 13:08:04 -0700
Message-ID: <20180802200804.GA14318@bombadil.infradead.org>
References: <1dbe6204-17fc-efd9-2381-48186cae2b94@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1dbe6204-17fc-efd9-2381-48186cae2b94-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2018 at 03:58:40PM -0400, Tony Battersby wrote:
> @@ -339,11 +360,16 @@ void *dma_pool_alloc(struct dma_pool *po
>  
>  	spin_lock_irqsave(&pool->lock, flags);
>  
> -	list_add(&page->page_list, &pool->page_list);
> +	list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);
>   ready:
>  	page->in_use++;
>  	offset = page->offset;
>  	page->offset = *(int *)(page->vaddr + offset);
> +	if (page->offset >= pool->allocation) {
> +		/* Move page from the "available" list to the "full" list. */
> +		list_del(&page->dma_list);
> +		list_add(&page->dma_list, &pool->page_list[POOL_FULL_IDX]);

I think this should be:

		list_move_tail(&page->dma_list,
				&pool->page_list[POOL_FULL_IDX]);

> @@ -444,6 +476,11 @@ void dma_pool_free(struct dma_pool *pool
>  #endif
>  
>  	page->in_use--;
> +	if (page->offset >= pool->allocation) {
> +		/* Move page from the "full" list to the "available" list. */
> +		list_del(&page->dma_list);
> +		list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);

This one probably wants to be
		list_move(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);

so that it's first-in-line to be allocated from for cache warmth purposes.
