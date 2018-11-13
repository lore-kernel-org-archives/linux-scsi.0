From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 8/9] dmapool: improve accuracy of debug statistics
Date: Mon, 12 Nov 2018 22:30:37 -0800
Message-ID: <20181113063037.GS21824@bombadil.infradead.org>
References: <bb0ee76c-78ac-b75b-b32d-8c94d881f7d6@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bb0ee76c-78ac-b75b-b32d-8c94d881f7d6-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2018 at 10:45:58AM -0500, Tony Battersby wrote:
> +++ linux/mm/dmapool.c	2018-08-06 17:52:53.000000000 -0400
> @@ -61,6 +61,7 @@ struct dma_pool {		/* the pool */
>  	struct device *dev;
>  	unsigned int allocation;
>  	unsigned int boundary;
> +	unsigned int blks_per_alloc;
>  	char name[32];
>  	struct list_head pools;
>  };

This one I'm not totally happy with.  You're storing this value when
it could be easily calculated each time through the show_pools() code.
I appreciate this is a topic where reasonable people might have different
opinions about which solution is preferable.

> @@ -182,6 +182,9 @@ struct dma_pool *dma_pool_create(const c
>  	retval->size = size;
>  	retval->boundary = boundary;
>  	retval->allocation = allocation;
> +	retval->blks_per_alloc =
> +		(allocation / boundary) * (boundary / size) +
> +		(allocation % boundary) / size;
>  
>  	INIT_LIST_HEAD(&retval->pools);
>  
> 
