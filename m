From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Thu, 26 Jul 2018 22:45:58 +0300
Message-ID: <CAHp75VcpM5W7+xgVy6nZf2hOXD8ghy5bwoJpAFse_ccp7OopNA@mail.gmail.com>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1288e597-a67a-25b3-b7c6-db883ca67a25-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2018 at 9:54 PM, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> wrote:
> dma_pool_free() scales poorly when the pool contains many pages because
> pool_find_page() does a linear scan of all allocated pages.  Improve its
> scalability by replacing the linear scan with a red-black tree lookup.
> In big O notation, this improves the algorithm from O(n^2) to O(n * log n).

Few style related comments.

> I moved some code from dma_pool_destroy() into pool_free_page() to avoid code
> repetition.

I would rather split that part as a separate preparatory change which
doesn't change the behaviour.

>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/wait.h>

> +#include <linux/rbtree.h>

It looks misordered.

> +               struct dma_page *this_page =
> +                       container_of(*node, struct dma_page, page_node);

#define to_dma_page() container_of() ?

> +                       WARN(1,
> +                            "%s: %s: DMA address overlap: old 0x%llx new 0x%llx len %zu\n",
> +                            pool->dev ? dev_name(pool->dev) : "(nodev)",
> +                            pool->name, (u64) this_page->dma, (u64) dma,

Use proper %p extensions for the DMA addresses:
https://elixir.bootlin.com/linux/latest/source/Documentation/core-api/printk-formats.rst#L150

-- 
With Best Regards,
Andy Shevchenko
