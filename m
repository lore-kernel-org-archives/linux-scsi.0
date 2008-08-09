From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: check for DMA mapping failures
Date: Sat, 9 Aug 2008 20:16:24 +0200 (CEST)
Message-ID: <tkrat.5d82e68d3f5ebb38@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
	<48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
	<48986B55.80403@s5r6.in-berlin.de> <489871B7.5050904@panasas.com>
	<tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
	<tkrat.5ee0a38d3bbf7b46@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.5ee0a38d3bbf7b46@s5r6.in-berlin.de>
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
Cc: linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On  8 Aug, Stefan Richter wrote:
> On a related note, sbp2 lacks error checks for the DMA mapping when the
> ORB pool is created and when the request buffer is mapped.  I leave that
> as a ToDo for sometime later.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: check for DMA mapping failures

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   94 +++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 35 deletions(-)

Index: linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
@@ -526,26 +526,41 @@ static void sbp2util_write_doorbell(stru
 
 static int sbp2util_create_command_orb_pool(struct sbp2_lu *lu)
 {
-	struct sbp2_fwhost_info *hi = lu->hi;
 	struct sbp2_command_info *cmd;
+	struct device *dmadev = lu->hi->host->device.parent;
 	int i, orbs = sbp2_serialize_io ? 2 : SBP2_MAX_CMDS;
 
 	for (i = 0; i < orbs; i++) {
 		cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 		if (!cmd)
-			return -ENOMEM;
-		cmd->command_orb_dma = dma_map_single(hi->host->device.parent,
-						&cmd->command_orb,
-						sizeof(struct sbp2_command_orb),
-						DMA_TO_DEVICE);
-		cmd->sge_dma = dma_map_single(hi->host->device.parent,
-					&cmd->scatter_gather_element,
-					sizeof(cmd->scatter_gather_element),
-					DMA_TO_DEVICE);
+			goto failed_alloc;
+
+		cmd->command_orb_dma =
+		    dma_map_single(dmadev, &cmd->command_orb,
+				   sizeof(struct sbp2_command_orb),
+				   DMA_TO_DEVICE);
+		if (dma_mapping_error(dmadev, cmd->command_orb_dma))
+			goto failed_orb;
+
+		cmd->sge_dma =
+		    dma_map_single(dmadev, &cmd->scatter_gather_element,
+				   sizeof(cmd->scatter_gather_element),
+				   DMA_TO_DEVICE);
+		if (dma_mapping_error(dmadev, cmd->sge_dma))
+			goto failed_sge;
+
 		INIT_LIST_HEAD(&cmd->list);
 		list_add_tail(&cmd->list, &lu->cmd_orb_completed);
 	}
 	return 0;
+
+failed_sge:
+	dma_unmap_single(dmadev, cmd->command_orb_dma,
+			 sizeof(struct sbp2_command_orb), DMA_TO_DEVICE);
+failed_orb:
+	kfree(cmd);
+failed_alloc:
+	return -ENOMEM;
 }
 
 static void sbp2util_remove_command_orb_pool(struct sbp2_lu *lu,
@@ -1483,14 +1498,16 @@ static int sbp2_agent_reset(struct sbp2_
 	return 0;
 }
 
-static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
-				     struct sbp2_fwhost_info *hi,
-				     struct sbp2_command_info *cmd,
-				     unsigned int scsi_use_sg,
-				     struct scatterlist *sg,
-				     u32 orb_direction,
-				     enum dma_data_direction dma_dir)
+static int sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
+				    struct sbp2_fwhost_info *hi,
+				    struct sbp2_command_info *cmd,
+				    unsigned int scsi_use_sg,
+				    struct scatterlist *sg,
+				    u32 orb_direction,
+				    enum dma_data_direction dma_dir)
 {
+	struct device *dmadev = hi->host->device.parent;
+
 	cmd->dma_dir = dma_dir;
 	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
@@ -1500,9 +1517,12 @@ static void sbp2_prep_command_orb_sg(str
 
 		cmd->dma_size = sg->length;
 		cmd->dma_type = CMD_DMA_PAGE;
-		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
-					    sg_page(sg), sg->offset,
+		cmd->cmd_dma = dma_map_page(dmadev, sg_page(sg), sg->offset,
 					    cmd->dma_size, cmd->dma_dir);
+		if (dma_mapping_error(dmadev, cmd->cmd_dma)) {
+			cmd->cmd_dma = 0;
+			return -ENOMEM;
+		}
 
 		orb->data_descriptor_lo = cmd->cmd_dma;
 		orb->misc |= ORB_SET_DATA_SIZE(cmd->dma_size);
@@ -1512,8 +1532,7 @@ static void sbp2_prep_command_orb_sg(str
 						&cmd->scatter_gather_element[0];
 		u32 sg_count, sg_len;
 		dma_addr_t sg_addr;
-		int i, count = dma_map_sg(hi->host->device.parent, sg,
-					  scsi_use_sg, dma_dir);
+		int i, count = dma_map_sg(dmadev, sg, scsi_use_sg, dma_dir);
 
 		cmd->dma_size = scsi_use_sg;
 		cmd->sge_buffer = sg;
@@ -1522,7 +1541,7 @@ static void sbp2_prep_command_orb_sg(str
 		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
 		orb->data_descriptor_lo = cmd->sge_dma;
 
-		dma_sync_single_for_cpu(hi->host->device.parent, cmd->sge_dma,
+		dma_sync_single_for_cpu(dmadev, cmd->sge_dma,
 					sizeof(cmd->scatter_gather_element),
 					DMA_TO_DEVICE);
 
@@ -1553,22 +1572,23 @@ static void sbp2_prep_command_orb_sg(str
 				(sizeof(struct sbp2_unrestricted_page_table)) *
 				sg_count);
 
-		dma_sync_single_for_device(hi->host->device.parent,
-					   cmd->sge_dma,
+		dma_sync_single_for_device(dmadev, cmd->sge_dma,
 					   sizeof(cmd->scatter_gather_element),
 					   DMA_TO_DEVICE);
 	}
+	return 0;
 }
 
-static void sbp2_create_command_orb(struct sbp2_lu *lu,
-				    struct sbp2_command_info *cmd,
-				    struct scsi_cmnd *SCpnt)
+static int sbp2_create_command_orb(struct sbp2_lu *lu,
+				   struct sbp2_command_info *cmd,
+				   struct scsi_cmnd *SCpnt)
 {
 	struct device *dmadev = lu->hi->host->device.parent;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
-	u32 orb_direction;
 	unsigned int scsi_request_bufflen = scsi_bufflen(SCpnt);
 	enum dma_data_direction dma_dir = SCpnt->sc_data_direction;
+	u32 orb_direction;
+	int ret;
 
 	dma_sync_single_for_cpu(dmadev, cmd->command_orb_dma,
 				sizeof(struct sbp2_command_orb), DMA_TO_DEVICE);
@@ -1602,11 +1622,13 @@ static void sbp2_create_command_orb(stru
 		orb->data_descriptor_hi = 0x0;
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
-	} else
-		sbp2_prep_command_orb_sg(orb, lu->hi, cmd, scsi_sg_count(SCpnt),
-					 scsi_sglist(SCpnt),
-					 orb_direction, dma_dir);
-
+		ret = 0;
+	} else {
+		ret = sbp2_prep_command_orb_sg(orb, lu->hi, cmd,
+					       scsi_sg_count(SCpnt),
+					       scsi_sglist(SCpnt),
+					       orb_direction, dma_dir);
+	}
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
 
 	memset(orb->cdb, 0, sizeof(orb->cdb));
@@ -1614,6 +1636,7 @@ static void sbp2_create_command_orb(stru
 
 	dma_sync_single_for_device(dmadev, cmd->command_orb_dma,
 			sizeof(struct sbp2_command_orb), DMA_TO_DEVICE);
+	return ret;
 }
 
 static void sbp2_link_orb_command(struct sbp2_lu *lu,
@@ -1694,9 +1717,10 @@ static int sbp2_send_command(struct sbp2
 	if (!cmd)
 		return -EIO;
 
-	sbp2_create_command_orb(lu, cmd, SCpnt);
-	sbp2_link_orb_command(lu, cmd);
+	if (sbp2_create_command_orb(lu, cmd, SCpnt))
+		return -ENOMEM;
 
+	sbp2_link_orb_command(lu, cmd);
 	return 0;
 }
 
-- 
Stefan Richter
-=====-==--- =--- -=--=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
