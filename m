From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: convert to new SCSI data buffer accessors
Date: Mon, 16 Jul 2007 21:05:41 +0200 (CEST)
Message-ID: <tkrat.23ca54e2497904fd@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Depends on "[SCSI] scsi_lib: add scatter/gather data buffer accessors",
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=824d7b570b4dec49e868c251d670941b02a1e489

Only compile-tested at the moment.

 drivers/firewire/fw-sbp2.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: x/drivers/firewire/fw-sbp2.c
===================================================================
--- x.orig/drivers/firewire/fw-sbp2.c
+++ x/drivers/firewire/fw-sbp2.c
@@ -840,7 +840,6 @@ complete_command_orb(struct sbp2_orb *ba
 		container_of(base_orb, struct sbp2_command_orb, base);
 	struct fw_unit *unit = orb->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
-	struct scatterlist *sg;
 	int result;
 
 	if (status != NULL) {
@@ -876,11 +875,10 @@ complete_command_orb(struct sbp2_orb *ba
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
 
-	if (orb->cmd->use_sg > 0) {
-		sg = (struct scatterlist *)orb->cmd->request_buffer;
-		dma_unmap_sg(device->card->device, sg, orb->cmd->use_sg,
+	if (scsi_sg_count(orb->cmd) > 0)
+		dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
+			     scsi_sg_count(orb->cmd),
 			     orb->cmd->sc_data_direction);
-	}
 
 	if (orb->page_table_bus != 0)
 		dma_unmap_single(device->card->device, orb->page_table_bus,
@@ -901,8 +899,8 @@ static int sbp2_command_orb_map_scatterl
 	int sg_len, l, i, j, count;
 	dma_addr_t sg_addr;
 
-	sg = (struct scatterlist *)orb->cmd->request_buffer;
-	count = dma_map_sg(device->card->device, sg, orb->cmd->use_sg,
+	sg = scsi_sglist(orb->cmd);
+	count = dma_map_sg(device->card->device, sg, scsi_sg_count(orb->cmd),
 			   orb->cmd->sc_data_direction);
 	if (count == 0)
 		goto fail;
@@ -971,7 +969,7 @@ static int sbp2_command_orb_map_scatterl
 	return 0;
 
  fail_page_table:
-	dma_unmap_sg(device->card->device, sg, orb->cmd->use_sg,
+	dma_unmap_sg(device->card->device, sg, scsi_sg_count(orb->cmd),
 		     orb->cmd->sc_data_direction);
  fail:
 	return -ENOMEM;
@@ -1031,7 +1029,7 @@ static int sbp2_scsi_queuecommand(struct
 		orb->request.misc |=
 			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA);
 
-	if (cmd->use_sg && sbp2_command_orb_map_scatterlist(orb) < 0)
+	if (scsi_sg_count(cmd) && sbp2_command_orb_map_scatterlist(orb) < 0)
 		goto fail_mapping;
 
 	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));

-- 
Stefan Richter
-=====-=-=== -=== =----
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
