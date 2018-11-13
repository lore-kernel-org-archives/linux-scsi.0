From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 6/9] dmapool: improve scalability of dma_pool_free
Date: Mon, 12 Nov 2018 22:25:07 -0800
Message-ID: <20181113062507.GQ21824@bombadil.infradead.org>
References: <4c3c25ab-5793-c394-9fe4-221b81805536@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4c3c25ab-5793-c394-9fe4-221b81805536-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2018 at 10:44:40AM -0500, Tony Battersby wrote:
> dma_pool_free() scales poorly when the pool contains many pages because
> pool_find_page() does a linear scan of all allocated pages.  Improve its
> scalability by replacing the linear scan with virt_to_page() and storing
> dmapool private data directly in 'struct page', thereby eliminating
> 'struct dma_page'.  In big O notation, this improves the algorithm from
> O(n^2) to O(n) while also reducing memory usage.
> 
> Thanks to Matthew Wilcox for the suggestion to use struct page.
> 
> Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>

Acked-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
