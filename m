From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Fri, 27 Jul 2018 08:23:22 -0700
Message-ID: <20180727152322.GB13348@bombadil.infradead.org>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
	<20180726194209.GB12992@bombadil.infradead.org>
	<b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83@cybernetics.com>
	<20180727000708.GA785@bombadil.infradead.org>
	<cae33099-3147-5014-ab4e-c22a4d66dc49@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cae33099-3147-5014-ab4e-c22a4d66dc49-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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

On Fri, Jul 27, 2018 at 09:23:30AM -0400, Tony Battersby wrote:
> On 07/26/2018 08:07 PM, Matthew Wilcox wrote:
> > If you're up for more major surgery, then I think we can put all the
> > information currently stored in dma_page into struct page.  Something
> > like this:
> >
> > +++ b/include/linux/mm_types.h
> > @@ -152,6 +152,12 @@ struct page {
> >                         unsigned long hmm_data;
> >                         unsigned long _zd_pad_1;        /* uses mapping=
 */
> >                 };
> > +               struct {        /* dma_pool pages */
> > +                       struct list_head dma_list;
> > +                       unsigned short in_use;
> > +                       unsigned short offset;
> > +                       dma_addr_t dma;
> > +               };
> >  =

> >                 /** @rcu_head: You can use this to free a page by RCU. =
*/
> >                 struct rcu_head rcu_head;
> >
> > page_list -> dma_list
> > vaddr goes away (page_to_virt() exists)
> > dma -> dma
> > in_use and offset shrink from 4 bytes to 2.
> >
> > Some 32-bit systems have a 64-bit dma_addr_t, and on those systems,
> > this will be 8 + 2 + 2 + 8 =3D 20 bytes.  On 64-bit systems, it'll be
> > 16 + 2 + 2 + 4 bytes of padding + 8 =3D 32 bytes (we have 40 available).
> >
> >
> offset at least needs more bits, since allocations can be multi-page.=A0

Ah, rats.  That means we have to use the mapcount union too:

+++ b/include/linux/mm_types.h
@@ -152,6 +152,11 @@ struct page {
                        unsigned long hmm_data;
                        unsigned long _zd_pad_1;        /* uses mapping */
                };
+               struct {        /* dma_pool pages */
+                       struct list_head dma_list;
+                       unsigned int dma_in_use;
+                       dma_addr_t dma;
+               };
 =

                /** @rcu_head: You can use this to free a page by RCU. */
                struct rcu_head rcu_head;
@@ -174,6 +179,7 @@ struct page {
 =

                unsigned int active;            /* SLAB */
                int units;                      /* SLOB */
+               unsigned int dma_offset;        /* dma_pool */
        };
 =

        /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */


> See the following from mpt3sas:
> =

> cat /sys/devices/pci0000:80/0000:80:07.0/0000:85:00.0/pools
> (manually cleaned up column alignment)
> poolinfo - 0.1
> reply_post_free_array pool  1      21     192     1
> reply_free pool             1      1      41728   1
> reply pool                  1      1      1335296 1
> sense pool                  1      1      970272  1
> chain pool                  373959 386048 128     12064
> reply_post_free pool        12     12     166528  12
>                                           ^size^

Wow, that's a pretty weird way to use the dmapool.  It'd be more efficient
to just call dma_alloc_coherent() directly.
