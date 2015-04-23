From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] 3w-xxxx: fix command completion race
Date: Thu, 23 Apr 2015 09:48:50 +0200
Message-ID: <1429775331-1017-3-git-send-email-hch@lst.de>
References: <1429775331-1017-1-git-send-email-hch@lst.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1429775331-1017-1-git-send-email-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Torsten Luettgert <ml-lkml@enda.eu>, Bernd Kardatzki <Bernd.Kardatzki@med.uni-tuebingen.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The 3w-xxxx driver needs to tear down the dma mappings before returning
the command to the midlayer, as there is no guarantee the sglist and
count are valid after that point.  Also remove the dma mapping helpers
which have another inherent race due to the request_id index.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/3w-xxxx.c | 42 ++++++------------------------------------
 drivers/scsi/3w-xxxx.h |  5 -----
 2 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c75f204..2940bd7 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1271,32 +1271,6 @@ static int tw_initialize_device_extension(TW_Device_Extension *tw_dev)
 	return 0;
 } /* End tw_initialize_device_extension() */
 
-static int tw_map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	int use_sg;
-
-	dprintk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data()\n");
-
-	use_sg = scsi_dma_map(cmd);
-	if (use_sg < 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.\n");
-		return 0;
-	}
-
-	cmd->SCp.phase = TW_PHASE_SGLIST;
-	cmd->SCp.have_data_in = use_sg;
-
-	return use_sg;
-} /* End tw_map_scsi_sg_data() */
-
-static void tw_unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	dprintk(KERN_WARNING "3w-xxxx: tw_unmap_scsi_data()\n");
-
-	if (cmd->SCp.phase == TW_PHASE_SGLIST)
-		scsi_dma_unmap(cmd);
-} /* End tw_unmap_scsi_data() */
-
 /* This function will reset a device extension */
 static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 {
@@ -1319,8 +1293,8 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 			srb = tw_dev->srb[i];
 			if (srb != NULL) {
 				srb->result = (DID_RESET << 16);
-				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
-				tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[i]);
+				scsi_dma_unmap(srb);
+				srb->scsi_done(srb);
 			}
 		}
 	}
@@ -1767,8 +1741,8 @@ static int tw_scsiop_read_write(TW_Device_Extension *tw_dev, int request_id)
 	command_packet->byte8.io.lba = lba;
 	command_packet->byte6.block_count = num_sectors;
 
-	use_sg = tw_map_scsi_sg_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
-	if (!use_sg)
+	use_sg = scsi_dma_map(srb);
+	if (use_sg <= 0)
 		return 1;
 
 	scsi_for_each_sg(tw_dev->srb[request_id], sg, use_sg, i) {
@@ -1955,9 +1929,6 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 	/* Save the scsi command for use by the ISR */
 	tw_dev->srb[request_id] = SCpnt;
 
-	/* Initialize phase to zero */
-	SCpnt->SCp.phase = TW_PHASE_INITIAL;
-
 	switch (*command) {
 		case READ_10:
 		case READ_6:
@@ -2185,12 +2156,11 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 
 				/* Now complete the io */
 				if ((error != TW_ISR_DONT_COMPLETE)) {
+					scsi_dma_unmap(tw_dev->srb[request_id]);
+					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 					tw_dev->state[request_id] = TW_S_COMPLETED;
 					tw_state_request_finish(tw_dev, request_id);
 					tw_dev->posted_request_count--;
-					tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
-					
-					tw_unmap_scsi_data(tw_dev->tw_pci_dev, tw_dev->srb[request_id]);
 				}
 			}
 				
diff --git a/drivers/scsi/3w-xxxx.h b/drivers/scsi/3w-xxxx.h
index 29b0b84e..6f65e66 100644
--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -195,11 +195,6 @@ static unsigned char tw_sense_table[][4] =
 #define TW_AEN_SMART_FAIL        0x000F
 #define TW_AEN_SBUF_FAIL         0x0024
 
-/* Phase defines */
-#define TW_PHASE_INITIAL 0
-#define TW_PHASE_SINGLE 1
-#define TW_PHASE_SGLIST 2
-
 /* Misc defines */
 #define TW_ALIGNMENT_6000		      64 /* 64 bytes */
 #define TW_ALIGNMENT_7000                     4  /* 4 bytes */
-- 
1.9.1
