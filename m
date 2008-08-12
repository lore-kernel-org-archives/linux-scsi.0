From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ieee1394: sbp2: enforce s/g segment size limit
Date: Wed, 13 Aug 2008 08:44:48 +0900
Message-ID: <20080813084514K.fujita.tomonori@lab.ntt.co.jp>
References: <20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
	<da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: grundler@google.com
Cc: fujita.tomonori@lab.ntt.co.jp, stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Aug 2008 10:04:14 -0700
"Grant Grundler" <grundler@google.com> wrote:

> On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > 1. We don't need to round the SBP-2 segment size limit down to a
> >   multiple of 4 kB (0xffff -> 0xf000).  It is only necessary to
> >   ensure quadlet alignment (0xffff -> 0xfffc).
> >
> > 2. Use dma_set_max_seg_size() to tell the DMA mapping infrastructure
> >   and the block IO layer about the restriction.  This way we can
> >   remove the size checks and segment splitting in the queuecommand
> >   path.
> >
> >   This assumes that no other code in the ieee1394 stack uses
> >   dma_map_sg() with conflicting requirements.  It furthermore assumes
> >   that the controller device's platform actually allows us to set the
> >   segment size to our liking.  Assert the latter with a BUG_ON().
> >
> > 3. Also use blk_queue_max_segment_size() to tell the block IO layer
> >   about it.  It cannot know it because our scsi_add_host() does not
> >   point to the FireWire controller's device.
> >
> > We can also uniformly use dma_map_sg() for the single segment case just
> > like for the multi segment case, to further simplify the code.
> >
> > Also clean up how the page table is converted to big endian.
> >
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > ---
> >
> > Applicable after
> >   [PATCH update] ieee1394: sbp2: stricter dma_sync
> >   [PATCH] ieee1394: sbp2: check for DMA mapping failures
> > from a few minutes ago.
> >
> >  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
> >  drivers/ieee1394/sbp2.h |   37 +++++--------
> >  2 files changed, 52 insertions(+), 91 deletions(-)
> ...
> > +               for_each_sg(sg, sg, sg_count, i) {
> > +                       len = sg_dma_len(sg);
> > +                       if (len == 0)
> > +                               continue;
> >
> > -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
> > +                       pt[j].high = cpu_to_be32(len << 16);
> > +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
> > +                       j++;
> > +               }
> 
> While this code will probably work correctly, I believe if the
> sg_dma_len() returns 0, one has walked off the end of the
> "bus address" list.
>
> pci_map_sg() returns how many DMA addr/len pairs are used
> and that count could (should?) be used when pulling the
> dma_len/addr pairs out of the sg list.

Yeah, from a quick look, seems that this patch wrongly handles
sg_count.

This patch sets scsi_sg_count(sc) to sg_count, right? for_each_sg is
expected to be used with a return value of pci_map_sg.

Then this patch can simply do something like:

for_each_sg(sg, sg, sg_count, i) {
        pt[i].high = cpu_to_be32(sg_dma_len(sg) << 16);
        pt[i].low = cpu_to_be32(sg_dma_address(sg));
}

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
