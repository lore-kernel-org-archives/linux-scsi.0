From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] dmapool: improve scalability of dma_pool_alloc
Date: Thu, 26 Jul 2018 22:37:15 +0300
Message-ID: <CAHp75VcXVgAtUWY5yRBFg85C5NPN2BAFyAfAkPLkKq5+SsNHpg@mail.gmail.com>
References: <15ff502d-d840-1003-6c45-bc17f0d81262@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <15ff502d-d840-1003-6c45-bc17f0d81262-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
> dma_pool_alloc() scales poorly when allocating a large number of pages
> because it does a linear scan of all previously-allocated pages before
> allocating a new one.  Improve its scalability by maintaining a separate
> list of pages that have free blocks ready to (re)allocate.  In big O
> notation, this improves the algorithm from O(n^2) to O(n).



>         spin_lock_irqsave(&pool->lock, flags);
> -       list_for_each_entry(page, &pool->page_list, page_list) {
> -               if (page->offset < pool->allocation)
> -                       goto ready;

> +       if (!list_empty(&pool->avail_page_list)) {
> +               page = list_first_entry(&pool->avail_page_list,
> +                                       struct dma_page,
> +                                       avail_page_link);
> +               goto ready;
>         }

It looks like

page = list_first_entry_or_null();
if (page)
 goto ready;

Though I don't know which one produces better code in the result.

>From reader prospective of view I would go with my variant.


> +       /* This test checks if the page is already in avail_page_list. */
> +       if (list_empty(&page->avail_page_link))
> +               list_add(&page->avail_page_link, &pool->avail_page_list);

How can you be sure that the page you are testing for is the first one?

It seems you are relying on the fact that in the list should be either
0 or 1 page. In that case what's the point to have a list?

-- 
With Best Regards,
Andy Shevchenko
