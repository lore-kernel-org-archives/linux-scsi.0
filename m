From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] firewire: fw-sbp2: prepare for s/g chaining
Date: Fri, 18 Jan 2008 12:33:41 +0900
Message-ID: <20080118123341D.fujita.tomonori@lab.ntt.co.jp>
References: <1200419579.9273.39.camel@localhost.localdomain>
	<tkrat.dd08f05252acff9a@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.dd08f05252acff9a@s5r6.in-berlin.de>
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
Cc: James.Bottomley@HansenPartnership.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 15 Jan 2008 21:10:50 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> 
> Replacement of patch "firewire: fw-sbp2: enable s/g chaining".
> 
> It's the same, minus '+ .use_sg_chaining = ENABLE_SG_CHAINING,' hunk
> to prevent conflicts when James is going to remove .use_sg_chaining.
> 
> 
>  drivers/firewire/fw-sbp2.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/firewire/fw-sbp2.c
> ===================================================================
> --- linux.orig/drivers/firewire/fw-sbp2.c
> +++ linux/drivers/firewire/fw-sbp2.c
> @@ -1107,9 +1107,9 @@ sbp2_map_scatterlist(struct sbp2_command
>  	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
>  	 * during DMA mapping, and Linux currently doesn't prevent this.
>  	 */

On a relate note, I fixed the IOMMU merge issue. The patches have been
-mm though I'm not sure whether they will go into v2.6.25. The patches
enable you to remove the following workaround if you configure the
maximum sg element length.

>From a quick look, fw-sbp2 uses scsi-ml in a different way so it would
be a bit trick to configure the maximum sg element length.

You call dma_map_sg with pci_dev::dev but don't call scsi_add_host
with pci_dev::dev.

If you set the maximum sg element length to pci_dev::dev, and then
call scsi_add_host with it, the block layer and the IOMMU send you
proper size sg elements.


> -	for (i = 0, j = 0; i < count; i++) {
> -		sg_len = sg_dma_len(sg + i);
> -		sg_addr = sg_dma_address(sg + i);
> +	for (i = 0, j = 0; i < count; i++, sg = sg_next(sg)) {
> +		sg_len = sg_dma_len(sg);
> +		sg_addr = sg_dma_address(sg);
>  		while (sg_len) {
>  			/* FIXME: This won't get us out of the pinch. */
>  			if (unlikely(j >= ARRAY_SIZE(orb->page_table))) {
> 
> -- 
> Stefan Richter
> -=====-==--- ---= -====
> http://arcgraph.de/sr/
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
