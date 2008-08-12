From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] ieee1394: sbp2: enforce s/g segment size limit
Date: Tue, 12 Aug 2008 10:04:14 -0700
Message-ID: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
References: <489CB8D8.60908@s5r6.in-berlin.de>
	<20080809063159F.fujita.tomonori@lab.ntt.co.jp>
	<489CC17F.7000208@s5r6.in-berlin.de>
	<20080809071744I.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.8f7aa8cea95d423b@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 9, 2008 at 11:20 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> 1. We don't need to round the SBP-2 segment size limit down to a
>   multiple of 4 kB (0xffff -> 0xf000).  It is only necessary to
>   ensure quadlet alignment (0xffff -> 0xfffc).
>
> 2. Use dma_set_max_seg_size() to tell the DMA mapping infrastructure
>   and the block IO layer about the restriction.  This way we can
>   remove the size checks and segment splitting in the queuecommand
>   path.
>
>   This assumes that no other code in the ieee1394 stack uses
>   dma_map_sg() with conflicting requirements.  It furthermore assumes
>   that the controller device's platform actually allows us to set the
>   segment size to our liking.  Assert the latter with a BUG_ON().
>
> 3. Also use blk_queue_max_segment_size() to tell the block IO layer
>   about it.  It cannot know it because our scsi_add_host() does not
>   point to the FireWire controller's device.
>
> We can also uniformly use dma_map_sg() for the single segment case just
> like for the multi segment case, to further simplify the code.
>
> Also clean up how the page table is converted to big endian.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Applicable after
>   [PATCH update] ieee1394: sbp2: stricter dma_sync
>   [PATCH] ieee1394: sbp2: check for DMA mapping failures
> from a few minutes ago.
>
>  drivers/ieee1394/sbp2.c |  106 +++++++++++++---------------------------
>  drivers/ieee1394/sbp2.h |   37 +++++--------
>  2 files changed, 52 insertions(+), 91 deletions(-)
...
> +               for_each_sg(sg, sg, sg_count, i) {
> +                       len = sg_dma_len(sg);
> +                       if (len == 0)
> +                               continue;
>
> -               orb->misc |= ORB_SET_DATA_SIZE(sg_count);
> +                       pt[j].high = cpu_to_be32(len << 16);
> +                       pt[j].low = cpu_to_be32(sg_dma_address(sg));
> +                       j++;
> +               }

While this code will probably work correctly, I believe if the
sg_dma_len() returns 0, one has walked off the end of the
"bus address" list.

pci_map_sg() returns how many DMA addr/len pairs are used
and that count could (should?) be used when pulling the
dma_len/addr pairs out of the sg list.

Effectively, the SG list is really two lists with seperate counts:
the original list with virtual addresses/len/count and the "DMA mapped"
list with it's own count of addresses/len pairs. When no IOMMU
is used those lists are 1:1.

hth,
grant

> -               sbp2util_cpu_to_be32_buffer(sg_element,
> -                               (sizeof(struct sbp2_unrestricted_page_table)) *
> -                               sg_count);
> +               orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1) |
> +                            ORB_SET_DATA_SIZE(j);
> +               orb->data_descriptor_lo = cmd->sge_dma;
>
>                dma_sync_single_for_device(dmadev, cmd->sge_dma,
>                                           sizeof(cmd->scatter_gather_element),
> @@ -2037,6 +2003,8 @@ static int sbp2scsi_slave_configure(stru
>                sdev->start_stop_pwr_cond = 1;
>        if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
>                blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
> +
> +       blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
>        return 0;
>  }
>
>
> --
> Stefan Richter
> -=====-==--- =--- -=--=
> http://arcgraph.de/sr/
>
>

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
