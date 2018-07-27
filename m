From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Thu, 26 Jul 2018 17:07:08 -0700
Message-ID: <20180727000708.GA785@bombadil.infradead.org>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
	<20180726194209.GB12992@bombadil.infradead.org>
	<b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2018 at 04:06:05PM -0400, Tony Battersby wrote:
> On 07/26/2018 03:42 PM, Matthew Wilcox wrote:
> > On Thu, Jul 26, 2018 at 02:54:56PM -0400, Tony Battersby wrote:
> >> dma_pool_free() scales poorly when the pool contains many pages because
> >> pool_find_page() does a linear scan of all allocated pages.  Improve i=
ts
> >> scalability by replacing the linear scan with a red-black tree lookup. =

> >> In big O notation, this improves the algorithm from O(n^2) to O(n * lo=
g n).
> > This is a lot of code to get us to O(n * log(n)) when we can use less
> > code to go to O(n).  dma_pool_free() is passed the virtual address.
> > We can go from virtual address to struct page with virt_to_page().
> > In struct page, we have 5 words available (20/40 bytes), and it's trivi=
al
> > to use one of them to point to the struct dma_page.
> >
> Thanks for the tip.=A0 I will give that a try.

If you're up for more major surgery, then I think we can put all the
information currently stored in dma_page into struct page.  Something
like this:

+++ b/include/linux/mm_types.h
@@ -152,6 +152,12 @@ struct page {
                        unsigned long hmm_data;
                        unsigned long _zd_pad_1;        /* uses mapping */
                };
+               struct {        /* dma_pool pages */
+                       struct list_head dma_list;
+                       unsigned short in_use;
+                       unsigned short offset;
+                       dma_addr_t dma;
+               };
 =

                /** @rcu_head: You can use this to free a page by RCU. */
                struct rcu_head rcu_head;

page_list -> dma_list
vaddr goes away (page_to_virt() exists)
dma -> dma
in_use and offset shrink from 4 bytes to 2.

Some 32-bit systems have a 64-bit dma_addr_t, and on those systems,
this will be 8 + 2 + 2 + 8 =3D 20 bytes.  On 64-bit systems, it'll be
16 + 2 + 2 + 4 bytes of padding + 8 =3D 32 bytes (we have 40 available).
