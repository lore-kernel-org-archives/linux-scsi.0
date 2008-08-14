From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
Date: Thu, 14 Aug 2008 09:55:22 +0900
Message-ID: <20080814095549S.fujita.tomonori@lab.ntt.co.jp>
References: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
	<20080813084514K.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.a77de871a8213efc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.a77de871a8213efc@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, grundler@google.com, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 13 Aug 2008 12:19:59 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On 13 Aug, FUJITA Tomonori wrote:
> > On Tue, 12 Aug 2008 10:04:14 -0700
> > "Grant Grundler" <grundler@google.com> wrote:
> > 
> >> On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
> >> <stefanr@s5r6.in-berlin.de> wrote:
> >> >  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
> >> >  drivers/ieee1394/sbp2.h |   37 +++++--------
> >> >  2 files changed, 52 insertions(+), 91 deletions(-)
> >> ...
> >> > +               for_each_sg(sg, sg, sg_count, i) {
> >> > +                       len = sg_dma_len(sg);
> >> > +                       if (len == 0)
> >> > +                               continue;
> >> >
> >> > -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
> >> > +                       pt[j].high = cpu_to_be32(len << 16);
> >> > +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
> >> > +                       j++;
> >> > +               }
> >> 
> >> While this code will probably work correctly, I believe if the
> >> sg_dma_len() returns 0, one has walked off the end of the
> >> "bus address" list.
> >>
> >> pci_map_sg() returns how many DMA addr/len pairs are used
> >> and that count could (should?) be used when pulling the
> >> dma_len/addr pairs out of the sg list.
> > 
> > Yeah, from a quick look, seems that this patch wrongly handles
> > sg_count.
> > 
> > This patch sets scsi_sg_count(sc) to sg_count, right?
> 
> Well, I keep the original scsi_sg_count to call dma_unmap_sg with it
> later.

You need to keep it? You can access to it via scsi_sg_count when
calling dma_unmap_sg? Seems that firewire code does.


> According to Corbet/ Rubini/ Kroah-Hartman: LDD3, dma_unmap_sg
> is to be called with the number of s/g elements before DMA-mapping.

Are you talking about?

=
To unmap a scatterlist, just call:

	pci_unmap_sg(pdev, sglist, nents, direction);

Again, make sure DMA activity has already finished.

PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
              the _same_ one you passed into the pci_map_sg call,
	      it should _NOT_ be the 'count' value _returned_ from the
              pci_map_sg call.


This is from Documentation/DMA-mapping.txt


> From a quick look at some dma_unmap_sg implementations, this seems still
> to be the case; or it doesn't actually matter.

I think that all the IOMMUs are fine even if you call dma_unmap_sg
with a 'nents' value that dma_map_sg returned. But, well, it's against
the rule.

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
