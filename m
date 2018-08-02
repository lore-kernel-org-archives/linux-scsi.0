From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 8/9] dmapool: reduce footprint in struct page
Date: Thu, 2 Aug 2018 16:56:26 -0700
Message-ID: <20180802235626.GA5773@bombadil.infradead.org>
References: <0ccfd31b-0a3f-9ae8-85c8-e176cd5453a9@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0ccfd31b-0a3f-9ae8-85c8-e176cd5453a9-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2018 at 04:01:12PM -0400, Tony Battersby wrote:
> This is my attempt to shrink 'dma_free_o' and 'dma_in_use' in 'struct
> page' (originally 'offset' and 'in_use' in 'struct dma_page') to 16-bit
> so that it is unnecessary to use the '_mapcount' field of 'struct
> page'.  However, it adds complexity and makes allocating and freeing up
> to 20% slower for little gain, so I am NOT recommending that it be
> merged at this time.  I am posting it just for reference in case someone
> finds it useful in the future.

I spy some interesting pieces in here that I'd love you to submit as
patches for merging.

> One of the nice things about this is that dma_pool_free() can do some
> additional sanity checks:
> *) Check that the offset of the passed-in address corresponds to a valid
> block offset.

Can't we do that already?  Subtract the base address of the page from
the passed-in vaddr and check it's a multiple of pool->size?

>  struct dma_pool {		/* the pool */
>  #define POOL_FULL_IDX   0
>  #define POOL_AVAIL_IDX  1
>  #define POOL_N_LISTS    2
>  	struct list_head page_list[POOL_N_LISTS];
>  	spinlock_t lock;
> -	size_t size;
>  	struct device *dev;
> -	size_t allocation;
> -	size_t boundary;
> +	unsigned int size;
> +	unsigned int allocation;
> +	unsigned int boundary_shift;
> +	unsigned int blks_per_boundary;
> +	unsigned int blks_per_alloc;

s/size_t/unsigned int/ is a good saving on 64-bit systems.  We recently
did something similar for slab/slub.

> @@ -141,6 +150,7 @@ static DEVICE_ATTR(pools, 0444, show_pool
>  struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  				 size_t size, size_t align, size_t boundary)
>  {

We should change the API here too.
