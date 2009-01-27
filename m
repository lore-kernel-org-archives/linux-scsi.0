From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Tue, 27 Jan 2009 18:03:40 +0100 (CET)
Message-ID: <tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de>
References: <20090121074339N.fujita.tomonori@lab.ntt.co.jp>
	<4976D52F.5090109@s5r6.in-berlin.de>
	<20090127165508L.fujita.tomonori@lab.ntt.co.jp>
	<20090127183723W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20090127183723W.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 27 Jan, FUJITA Tomonori wrote at LSML and LKML:
[I wrote]
>> > *) The report does not sound like there was a DMA mappig leak caused by
>> > copying between usb-storage and firewire-sbp2.  Else he would have hit
>> > the problem again even with increased swiotlb default size.

> Hmm, we don't have leak here?
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] fw-sbp2: fix dma mapping leak on the failure path
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/firewire/fw-sbp2.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> index e88d506..d40910d 100644
> --- a/drivers/firewire/fw-sbp2.c
> +++ b/drivers/firewire/fw-sbp2.c
> @@ -1491,8 +1491,18 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
>  	orb->base.request_bus =
>  		dma_map_single(device->card->device, &orb->request,
>  			       sizeof(orb->request), DMA_TO_DEVICE);
> -	if (dma_mapping_error(device->card->device, orb->base.request_bus))
> +	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
> +		if (scsi_sg_count(cmd)) {
> +			dma_unmap_sg(device->card->device, scsi_sglist(cmd),
> +				     scsi_sg_count(cmd),
> +				     cmd->sc_data_direction);
> +			dma_unmap_single(device->card->device,
> +					 orb->page_table_bus,
> +					 sizeof(orb->page_table),
> +					 DMA_TO_DEVICE);
> +		}
>  		goto out;
> +	}
>  
>  	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
>  		      lu->command_block_agent_address + SBP2_ORB_POINTER);

Yes, we do have a leak there.  Thanks a lot for checking the code.

There is one thing missing in the fix:  Even with scsi_sg_count(cmd) !=
0, there is sometimes no orb->page_table to unmap.  It's when the
scatterlist was mapped into a single physical segment.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: sbp2: fix DMA mapping leak on the failure path

Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
who also provided a first version of the fix.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1323,6 +1323,19 @@ static unsigned int sbp2_status_to_sense
 	}
 }
 
+static void sbp2_unmap_scatterlist(struct device *card_device,
+				   struct sbp2_command_orb *orb)
+{
+	if (scsi_sg_count(orb->cmd))
+		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
+			     scsi_sg_count(orb->cmd),
+			     orb->cmd->sc_data_direction);
+
+	if (orb->page_table_bus)
+		dma_unmap_single(card_device, orb->page_table_bus,
+				 sizeof(orb->page_table), DMA_TO_DEVICE);
+}
+
 static void complete_command_orb(struct sbp2_orb *base_orb,
 				 struct sbp2_status *status)
 {
@@ -1364,15 +1377,7 @@ static void complete_command_orb(struct 
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
-
-	if (scsi_sg_count(orb->cmd) > 0)
-		dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
-			     scsi_sg_count(orb->cmd),
-			     orb->cmd->sc_data_direction);
-
-	if (orb->page_table_bus != 0)
-		dma_unmap_single(device->card->device, orb->page_table_bus,
-				 sizeof(orb->page_table), DMA_TO_DEVICE);
+	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
 	orb->done(orb->cmd);
@@ -1493,8 +1498,10 @@ static int sbp2_scsi_queuecommand(struct
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(device->card->device, orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
+		sbp2_unmap_scatterlist(device->card->device, orb);
 		goto out;
+	}
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);


-- 
Stefan Richter
-=====-==--= ---= ==-==
http://arcgraph.de/sr/


------------------------------------------------------------------------------
This SF.net email is sponsored by:
SourcForge Community
SourceForge wants to tell your story.
http://p.sf.net/sfu/sf-spreadtheword
