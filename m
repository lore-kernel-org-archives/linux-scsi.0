From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 28 Jan 2009 01:03:34 +0100 (CET)
Message-ID: <tkrat.511cc93cd769cafe@s5r6.in-berlin.de>
References: <20090127165508L.fujita.tomonori@lab.ntt.co.jp>
 <20090127183723W.fujita.tomonori@lab.ntt.co.jp>
 <tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de>
 <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
 <497F9CC5.8080807@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57394 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZA1ADt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 19:03:49 -0500
In-Reply-To: <497F9CC5.8080807@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> FUJITA Tomonori wrote:
>> On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
>> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>> +	if (orb->page_table_bus)
>>> +		dma_unmap_single(card_device, orb->page_table_bus,
>>> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
>> 
>> Well, this does not look correct since zero can be a valid dma
>> address.


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
+	if (orb->request.misc & cpu_to_be32(COMMAND_ORB_PAGE_TABLE_PRESENT))
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
-=====-==--= ---= ===--
http://arcgraph.de/sr/

