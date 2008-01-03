From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/2] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
Date: Thu, 3 Jan 2008 13:56:36 +0900
Message-ID: <20080103135905X.tomof@acm.org>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35262 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbYACE4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 23:56:47 -0500
In-Reply-To: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp

To remove sense_buffer array in scsi_cmnd structure, this replaces
sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in several LLDs.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/libata-scsi.c           |    4 ++--
 drivers/message/fusion/mptscsih.c   |    2 +-
 drivers/message/i2o/i2o_scsi.c      |    2 +-
 drivers/scsi/53c700.c               |   11 ++++++-----
 drivers/scsi/BusLogic.c             |    2 +-
 drivers/scsi/aacraid/aachba.c       |   12 ++++++------
 drivers/scsi/advansys.c             |   14 +++++++-------
 drivers/scsi/aha1542.c              |    4 ++--
 drivers/scsi/aha1740.c              |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c  |    6 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    6 +++---
 drivers/scsi/aic7xxx_old.c          |   12 ++++++------
 drivers/scsi/arcmsr/arcmsr_hba.c    |    6 +++---
 drivers/scsi/arm/fas216.c           |   10 +++++-----
 drivers/scsi/dc395x.c               |   16 +++++++---------
 drivers/scsi/dpt_i2o.c              |    2 +-
 drivers/scsi/eata.c                 |    4 ++--
 drivers/scsi/eata_pio.c             |    2 +-
 drivers/scsi/hptiop.c               |    2 +-
 drivers/scsi/ips.c                  |   10 ++++------
 drivers/scsi/ncr53c8xx.c            |    2 +-
 drivers/scsi/qla1280.c              |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c      |   12 ++++++------
 drivers/scsi/qlogicpti.c            |    2 +-
 drivers/scsi/scsi_error.c           |    6 +++---
 drivers/scsi/scsi_lib.c             |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 ++---
 drivers/scsi/tmscsim.c              |    6 +++---
 drivers/scsi/u14-34f.c              |    4 ++--
 drivers/scsi/ultrastor.c            |    2 +-
 30 files changed, 85 insertions(+), 89 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a883bb0..0afae6a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2330,7 +2330,7 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 	DPRINTK("ATAPI request sense\n");
 
 	/* FIXME: is this needed? */
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 	ap->ops->tf_read(ap, &qc->tf);
 
@@ -2340,7 +2340,7 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	ata_qc_reinit(qc);
 
-	ata_sg_init_one(qc, cmd->sense_buffer, sizeof(cmd->sense_buffer));
+	ata_sg_init_one(qc, cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 	qc->dma_dir = DMA_FROM_DEVICE;
 
 	memset(&qc->cdb, 0, qc->dev->cdb_len);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 626bb3c..5c614ec 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -111,7 +111,7 @@ int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
 int 		mptscsih_resume(struct pci_dev *pdev);
 #endif
 
-#define SNS_LEN(scp)	sizeof((scp)->sense_buffer)
+#define SNS_LEN(scp)	SCSI_SENSE_BUFFERSIZE
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index aa6fb94..1bcdbbb 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -370,7 +370,7 @@ static int i2o_scsi_reply(struct i2o_controller *c, u32 m,
 	 */
 	if (cmd->result)
 		memcpy(cmd->sense_buffer, &msg->body[3],
-		       min(sizeof(cmd->sense_buffer), (size_t) 40));
+		       min(SCSI_SENSE_BUFFERSIZE, 40));
 
 	/* only output error code if AdapterStatus is not HBA_SUCCESS */
 	if ((error >> 8) & 0xff)
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 71ff3fb..f4c4fe9 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -608,7 +608,8 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 			scsi_print_sense("53c700", SCp);
 
 #endif
-			dma_unmap_single(hostdata->dev, slot->dma_handle, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
+			dma_unmap_single(hostdata->dev, slot->dma_handle,
+					 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 			/* restore the old result if the request sense was
 			 * successful */
 			if (result == 0)
@@ -1010,7 +1011,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				cmnd[1] = (SCp->device->lun & 0x7) << 5;
 				cmnd[2] = 0;
 				cmnd[3] = 0;
-				cmnd[4] = sizeof(SCp->sense_buffer);
+				cmnd[4] = SCSI_SENSE_BUFFERSIZE;
 				cmnd[5] = 0;
 				/* Here's a quiet hack: the
 				 * REQUEST_SENSE command is six bytes,
@@ -1024,14 +1025,14 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				SCp->cmd_len = 6; /* command length for
 						   * REQUEST_SENSE */
 				slot->pCmd = dma_map_single(hostdata->dev, cmnd, MAX_COMMAND_SIZE, DMA_TO_DEVICE);
-				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
-				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | sizeof(SCp->sense_buffer));
+				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | SCSI_SENSE_BUFFERSIZE);
 				slot->SG[0].pAddr = bS_to_host(slot->dma_handle);
 				slot->SG[1].ins = bS_to_host(SCRIPT_RETURN);
 				slot->SG[1].pAddr = 0;
 				slot->resume_offset = hostdata->pScript;
 				dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG[0])*2, DMA_TO_DEVICE);
-				dma_cache_sync(hostdata->dev, SCp->sense_buffer, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
+				dma_cache_sync(hostdata->dev, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 				/* queue the command for reissue */
 				slot->state = NCR_700_SLOT_QUEUED;
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 49e1ffa..ead47c1 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2947,7 +2947,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		}
 	}
 	memcpy(CCB->CDB, CDB, CDB_Length);
-	CCB->SenseDataLength = sizeof(Command->sense_buffer);
+	CCB->SenseDataLength = SCSI_SENSE_BUFFERSIZE;
 	CCB->SenseDataPointer = pci_map_single(HostAdapter->PCI_Device, Command->sense_buffer, CCB->SenseDataLength, PCI_DMA_FROMDEVICE);
 	CCB->Command = Command;
 	Command->scsi_done = CompletionRoutine;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index cef764e..dd050b2 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -898,8 +898,8 @@ static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
 			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 			    0, 0);
 		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(cmd->sense_buffer))
-		    ? sizeof(cmd->sense_buffer)
+		  (sizeof(dev->fsa_dev[cid].sense_data) > SCSI_SENSE_BUFFERSIZE)
+		    ? SCSI_SENSE_BUFFERSIZE
 		    : sizeof(dev->fsa_dev[cid].sense_data));
 		cmd->scsi_done(cmd);
 		return 1;
@@ -1512,8 +1512,8 @@ static void io_callback(void *context, struct fib * fibptr)
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
-		    ? sizeof(scsicmd->sense_buffer)
+		  (sizeof(dev->fsa_dev[cid].sense_data) > SCSI_SENSE_BUFFERSIZE)
+		    ? SCSI_SENSE_BUFFERSIZE
 		    : sizeof(dev->fsa_dev[cid].sense_data));
 	}
 	aac_fib_complete(fibptr);
@@ -1726,8 +1726,8 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
 		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		  min(sizeof(dev->fsa_dev[cid].sense_data),
-			  sizeof(cmd->sense_buffer)));
+		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
+			     SCSI_SENSE_BUFFERSIZE));
 	}
 
 	aac_fib_complete(fibptr);
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 38a1ee2..374ed02 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8233,7 +8233,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 			if (scsiqp->scsi_status == SAM_STAT_CHECK_CONDITION) {
 				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
-						  sizeof(scp->sense_buffer));
+						  SCSI_SENSE_BUFFERSIZE);
 				/*
 				 * Note: The 'status_byte()' macro used by
 				 * target drivers defined in scsi.h shifts the
@@ -9136,7 +9136,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
 	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
-			sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
+			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	/*
 	 * 'qdonep' contains the command's ending status.
 	 */
@@ -9166,7 +9166,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 			if (qdonep->d3.scsi_stat == SAM_STAT_CHECK_CONDITION) {
 				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
-						  sizeof(scp->sense_buffer));
+						  SCSI_SENSE_BUFFERSIZE);
 				/*
 				 * Note: The 'status_byte()' macro used by
 				 * target drivers defined in scsi.h shifts the
@@ -9881,9 +9881,9 @@ static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
 {
 	struct asc_board *board = shost_priv(scp->device->host);
 	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
-				sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
+					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	dma_cache_sync(board->dev, scp->sense_buffer,
-				sizeof(scp->sense_buffer), DMA_FROM_DEVICE);
+		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
 }
 
@@ -9914,7 +9914,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	asc_scsi_q->q2.target_ix =
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
 	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
-	asc_scsi_q->q1.sense_len = sizeof(scp->sense_buffer);
+	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	/*
 	 * If there are any outstanding requests for the current target,
@@ -10173,7 +10173,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	scsiqp->target_lun = scp->device->lun;
 
 	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
-	scsiqp->sense_len = sizeof(scp->sense_buffer);
+	scsiqp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	/* Build ADV_SCSI_REQ_Q */
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 5b69a88..190568e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -536,7 +536,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id)
 		   we will still have it in the cdb when we come back */
 		if (ccb[mbo].tarstat == 2)
 			memcpy(SCtmp->sense_buffer, &ccb[mbo].cdb[ccb[mbo].cdblen],
-			       sizeof(SCtmp->sense_buffer));
+			       SCSI_SENSE_BUFFERSIZE);
 
 
 		/* is there mail :-) */
@@ -609,7 +609,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 #if 0
 		/* scsi_request_sense() provides a buffer of size 256,
 		   so there is no reason to expect equality */
-		if (bufflen != sizeof(SCpnt->sense_buffer))
+		if (bufflen != SCSI_SENSE_BUFFERSIZE)
 			printk(KERN_CRIT "aha1542: Wrong buffer length supplied "
 			       "for request sense (%d)\n", bufflen);
 #endif
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index f6722fd..be58a0b 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -286,7 +286,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 			   cdb when we come back */
 			if ( (adapstat & G2INTST_MASK) == G2INTST_CCBERROR ) {
 				memcpy(SCtmp->sense_buffer, ecbptr->sense, 
-				       sizeof(SCtmp->sense_buffer));
+				       SCSI_SENSE_BUFFERSIZE);
 				errstatus = aha1740_makecode(ecbptr->sense,ecbptr->status);
 			} else
 				errstatus = 0;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2d02040..0e4708f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1784,7 +1784,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 			if (scb->flags & SCB_SENSE) {
 				sense_size = min(sizeof(struct scsi_sense_data)
 					       - ahd_get_sense_residual(scb),
-						 (u_long)sizeof(cmd->sense_buffer));
+						 (u_long)SCSI_SENSE_BUFFERSIZE);
 				sense_offset = 0;
 			} else {
 				/*
@@ -1795,11 +1795,11 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 				    scb->sense_data;
 				sense_size = min_t(size_t,
 						scsi_4btoul(siu->sense_length),
-						sizeof(cmd->sense_buffer));
+						SCSI_SENSE_BUFFERSIZE);
 				sense_offset = SIU_SENSE_OFFSET(siu);
 			}
 
-			memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->sense_buffer,
 			       ahd_get_sense_buf(ahd, scb)
 			       + sense_offset, sense_size);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 390b0fc..e310e41 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1801,12 +1801,12 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 
 			sense_size = min(sizeof(struct scsi_sense_data)
 				       - ahc_get_sense_residual(scb),
-					 (u_long)sizeof(cmd->sense_buffer));
+					 (u_long)SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->sense_buffer,
 			       ahc_get_sense_buf(ahc, scb), sense_size);
-			if (sense_size < sizeof(cmd->sense_buffer))
+			if (sense_size < SCSI_SENSE_BUFFERSIZE)
 				memset(&cmd->sense_buffer[sense_size], 0,
-				       sizeof(cmd->sense_buffer) - sense_size);
+				       SCSI_SENSE_BUFFERSIZE - sense_size);
 			cmd->result |= (DRIVER_SENSE << 24);
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 8f8db5f..c0c0a6b 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -2696,7 +2696,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   {
     pci_unmap_single(p->pdev,
                      le32_to_cpu(scb->sg_list[0].address),
-                     sizeof(cmd->sense_buffer),
+                     SCSI_SENSE_BUFFERSIZE,
                      PCI_DMA_FROMDEVICE);
   }
   if (scb->flags & SCB_RECOVERY_SCB)
@@ -4267,13 +4267,13 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                        sizeof(generic_sense));
 
                 scb->sense_cmd[1] = (cmd->device->lun << 5);
-                scb->sense_cmd[4] = sizeof(cmd->sense_buffer);
+                scb->sense_cmd[4] = SCSI_SENSE_BUFFERSIZE;
 
                 scb->sg_list[0].length = 
-                  cpu_to_le32(sizeof(cmd->sense_buffer));
+                  cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
 		scb->sg_list[0].address =
                         cpu_to_le32(pci_map_single(p->pdev, cmd->sense_buffer,
-                                                   sizeof(cmd->sense_buffer),
+                                                   SCSI_SENSE_BUFFERSIZE,
                                                    PCI_DMA_FROMDEVICE));
 
                 /*
@@ -4296,7 +4296,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 hscb->residual_data_count[2] = 0;
 
                 scb->sg_count = hscb->SG_segment_count = 1;
-                scb->sg_length = sizeof(cmd->sense_buffer);
+                scb->sg_length = SCSI_SENSE_BUFFERSIZE;
                 scb->tag_action = 0;
                 scb->flags |= SCB_SENSE;
                 /*
@@ -10293,7 +10293,7 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
   aic7xxx_position(cmd) = scb->hscb->tag;
   cmd->scsi_done = fn;
   cmd->result = DID_OK;
-  memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+  memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
   aic7xxx_error(cmd) = DID_OK;
   aic7xxx_status(cmd) = 0;
   cmd->host_scribble = NULL;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d466a2d..d80dba9 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -634,9 +634,9 @@ static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 	pcmd->result = DID_OK << 16;
 	if (sensebuffer) {
 		int sense_data_length =
-			sizeof(struct SENSE_DATA) < sizeof(pcmd->sense_buffer)
-			? sizeof(struct SENSE_DATA) : sizeof(pcmd->sense_buffer);
-		memset(sensebuffer, 0, sizeof(pcmd->sense_buffer));
+			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
+			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
+		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fb5f202..3bf186e 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2009,7 +2009,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 		 * have valid data in the sense buffer that could
 		 * confuse the higher levels.
 		 */
-		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
+		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 //printk("scsi%d.%c: sense buffer: ", info->host->host_no, '0' + SCpnt->device->id);
 //{ int i; for (i = 0; i < 32; i++) printk("%02x ", SCpnt->sense_buffer[i]); printk("\n"); }
 	/*
@@ -2108,16 +2108,16 @@ request_sense:
 	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
 	SCpnt->cmnd[0] = REQUEST_SENSE;
 	SCpnt->cmnd[1] = SCpnt->device->lun << 5;
-	SCpnt->cmnd[4] = sizeof(SCpnt->sense_buffer);
+	SCpnt->cmnd[4] = SCSI_SENSE_BUFFERSIZE;
 	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
 	SCpnt->SCp.buffer = NULL;
 	SCpnt->SCp.buffers_residual = 0;
 	SCpnt->SCp.ptr = (char *)SCpnt->sense_buffer;
-	SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
-	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
+	SCpnt->SCp.this_residual = SCSI_SENSE_BUFFERSIZE;
+	SCpnt->SCp.phase = SCSI_SENSE_BUFFERSIZE;
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
+	SCpnt->request_bufflen = SCSI_SENSE_BUFFERSIZE;
 	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	SCpnt->use_sg = 0;
 	SCpnt->tag = 0;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index a9def6e..f93c73c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1629,8 +1629,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO,
-			      sizeof(srb->cmd->sense_buffer));
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, SCSI_SENSE_BUFFERSIZE);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 	} else {
 		ptr = (u8 *)srb->cmd->cmnd;
@@ -1915,8 +1914,7 @@ static void command_phase1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, (dcb->target_lun << 5));
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
-		DC395x_write8(acb, TRM_S1040_SCSI_FIFO,
-			      sizeof(srb->cmd->sense_buffer));
+		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, SCSI_SENSE_BUFFERSIZE);
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 0);
 	}
 	srb->state |= SRB_COMMAND;
@@ -3685,7 +3683,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	srb->target_status = 0;
 
 	/* KG: Can this prevent crap sense data ? */
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 	/* Save some data */
 	srb->segment_x[DC395x_MAX_SG_LISTENTRY - 1].address =
@@ -3694,15 +3692,15 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	    srb->segment_x[0].length;
 	srb->xferred = srb->total_xfer_length;
 	/* srb->segment_x : a one entry of S/G list table */
-	srb->total_xfer_length = sizeof(cmd->sense_buffer);
-	srb->segment_x[0].length = sizeof(cmd->sense_buffer);
+	srb->total_xfer_length = SCSI_SENSE_BUFFERSIZE;
+	srb->segment_x[0].length = SCSI_SENSE_BUFFERSIZE;
 	/* Map sense buffer */
 	srb->segment_x[0].address =
 	    pci_map_single(acb->dev, cmd->sense_buffer,
-			   sizeof(cmd->sense_buffer), PCI_DMA_FROMDEVICE);
+			   SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE);
 	dprintkdbg(DBG_SG, "request_sense: map buffer %p->%08x(%05x)\n",
 	       cmd->sense_buffer, srb->segment_x[0].address,
-	       sizeof(cmd->sense_buffer));
+	       SCSI_SENSE_BUFFERSIZE);
 	srb->sg_count = 1;
 	srb->sg_index = 0;
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 70f48a1..c6380c0 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2298,7 +2298,7 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 		// copy over the request sense data if it was a check
 		// condition status
 		if(dev_status == 0x02 /*CHECK_CONDITION*/) {
-			u32 len = sizeof(cmd->sense_buffer);
+			u32 len = SCSI_SENSE_BUFFERSIZE;
 			len = (len > 40) ?  40 : len;
 			// Copy over the sense data
 			memcpy_fromio(cmd->sense_buffer, (reply+28) , len);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 7ead521..05163ce 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1623,9 +1623,9 @@ static void map_dma(unsigned int i, struct hostdata *ha)
 	if (SCpnt->sense_buffer)
 		cpp->sense_addr =
 		    H2DEV(pci_map_single(ha->pdev, SCpnt->sense_buffer,
-			   sizeof SCpnt->sense_buffer, PCI_DMA_FROMDEVICE));
+			   SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE));
 
-	cpp->sense_len = sizeof SCpnt->sense_buffer;
+	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	count = scsi_dma_map(SCpnt);
 	BUG_ON(count < 0);
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 9579507..18f1dbc 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -369,7 +369,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 	cp = &hd->ccb[y];
 
 	memset(cp, 0, sizeof(struct eata_ccb));
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 	cp->status = USED;	/* claim free slot */
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index df1a764..e7b2f35 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -574,7 +574,7 @@ static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
 			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memcpy(&scp->sense_buffer, &req->sg_list,
-				min_t(size_t, sizeof(scp->sense_buffer),
+				min_t(size_t, SCSI_SENSE_BUFFERSIZE,
 					le32_to_cpu(req->dataxfer_length)));
 		break;
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e54d30c..243583b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2736,7 +2736,7 @@ ips_next(ips_ha_t * ha, int intr)
 		SC->result = DID_OK;
 		SC->host_scribble = NULL;
 
-		memset(SC->sense_buffer, 0, sizeof (SC->sense_buffer));
+		memset(SC->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 		scb->target_id = SC->device->id;
 		scb->lun = SC->device->lun;
@@ -3435,13 +3435,11 @@ ips_map_status(ips_ha_t * ha, ips_scb_t * scb, ips_stat_t * sp)
 					    (IPS_DCDB_TABLE_TAPE *) & scb->dcdb;
 					memcpy(scb->scsi_cmd->sense_buffer,
 					       tapeDCDB->sense_info,
-					       sizeof (scb->scsi_cmd->
-						       sense_buffer));
+                                               SCSI_SENSE_BUFFERSIZE);
 				} else {
 					memcpy(scb->scsi_cmd->sense_buffer,
 					       scb->dcdb.sense_info,
-					       sizeof (scb->scsi_cmd->
-						       sense_buffer));
+                                               SCSI_SENSE_BUFFERSIZE);
 				}
 				device_error = 2;	/* check condition */
 			}
@@ -3821,7 +3819,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 			/* attempted, a Check Condition occurred, and Sense   */
 			/* Data indicating an Invalid CDB OpCode is returned. */
 			sp = (char *) scb->scsi_cmd->sense_buffer;
-			memset(sp, 0, sizeof (scb->scsi_cmd->sense_buffer));
+			memset(sp, 0, SCSI_SENSE_BUFFERSIZE);
 
 			sp[0] = 0x70;	/* Error Code               */
 			sp[2] = ILLEGAL_REQUEST;	/* Sense Key 5 Illegal Req. */
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 016c462..c7abab4 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4963,7 +4963,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		**	Copy back sense data to caller's buffer.
 		*/
 		memcpy(cmd->sense_buffer, cp->sense_buf,
-		       min(sizeof(cmd->sense_buffer), sizeof(cp->sense_buf)));
+		       min(SCSI_SENSE_BUFFERSIZE, sizeof(cp->sense_buf)));
 
 		if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
 			u_char * p = (u_char*) & cmd->sense_buffer;
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 146d540..2842a66 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -528,7 +528,7 @@ __setup("qla1280=", qla1280_setup);
 #define	CMD_CDBLEN(Cmnd)	Cmnd->cmd_len
 #define	CMD_CDBP(Cmnd)		Cmnd->cmnd
 #define	CMD_SNSP(Cmnd)		Cmnd->sense_buffer
-#define	CMD_SNSLEN(Cmnd)	sizeof(Cmnd->sense_buffer)
+#define	CMD_SNSLEN(Cmnd)	SCSI_SENSE_BUFFERSIZE
 #define	CMD_RESULT(Cmnd)	Cmnd->result
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
 #define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
@@ -3715,7 +3715,7 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 			} else
 				sense_sz = 0;
 			memset(cmd->sense_buffer + sense_sz, 0,
-			       sizeof(cmd->sense_buffer) - sense_sz);
+			       SCSI_SENSE_BUFFERSIZE - sense_sz);
 
 			dprintk(2, "qla1280_status_entry: Check "
 				"condition Sense data, b %i, t %i, "
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 798b7e8..53cbaff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -977,13 +977,13 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			break;
 
 		/* Copy Sense Data into sense buffer. */
-		memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
+		memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		if (sense_len >= sizeof(cp->sense_buffer))
-			sense_len = sizeof(cp->sense_buffer);
+		if (sense_len >= SCSI_SENSE_BUFFERSIZE)
+			sense_len = SCSI_SENSE_BUFFERSIZE;
 
 		CMD_ACTUAL_SNSLEN(cp) = sense_len;
 		sp->request_sense_length = sense_len;
@@ -1061,13 +1061,13 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				break;
 
 			/* Copy Sense Data into sense buffer */
-			memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
+			memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			if (sense_len >= sizeof(cp->sense_buffer))
-				sense_len = sizeof(cp->sense_buffer);
+			if (sense_len >= SCSI_SENSE_BUFFERSIZE)
+				sense_len = SCSI_SENSE_BUFFERSIZE;
 
 			CMD_ACTUAL_SNSLEN(cp) = sense_len;
 			sp->request_sense_length = sense_len;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5bc8831..65455ab 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1142,7 +1142,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 
 		if (sts->state_flags & SF_GOT_SENSE)
 			memcpy(Cmnd->sense_buffer, sts->req_sense_data,
-			       sizeof(Cmnd->sense_buffer));
+			       SCSI_SENSE_BUFFERSIZE);
 
 		if (sts->hdr.entry_type == ENTRY_STATUS)
 			Cmnd->result =
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 169bc59..547e85a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -625,7 +625,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 
 	if (sense_bytes) {
 		scmd->request_bufflen = min_t(unsigned,
-		                       sizeof(scmd->sense_buffer), sense_bytes);
+		                       SCSI_SENSE_BUFFERSIZE, sense_bytes);
 		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
 		                                       scmd->request_bufflen);
 		scmd->request_buffer = &ses->sense_sgl;
@@ -657,7 +657,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	 * Zero the sense buffer.  The scsi spec mandates that any
 	 * untransferred sense data should be interpreted as being zero.
 	 */
-	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
+	memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_eh_prep_cmnd);
 
@@ -1820,7 +1820,7 @@ int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 				 struct scsi_sense_hdr *sshdr)
 {
 	return scsi_normalize_sense(cmd->sense_buffer,
-			sizeof(cmd->sense_buffer), sshdr);
+			SCSI_SENSE_BUFFERSIZE, sshdr);
 }
 EXPORT_SYMBOL(scsi_command_normalize_sense);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1a4671..6ee2ffc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -441,7 +441,7 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = 0;
 	cmd->resid = 0;
-	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
 }
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e6f3706..1b70399 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -207,10 +207,9 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 			/*
 			 *  Bounce back the sense data to user.
 			 */
-			memset(&cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+			memset(&cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->sense_buffer, cp->sns_bbuf,
-			      min(sizeof(cmd->sense_buffer),
-				  (size_t)SYM_SNS_BBUF_LEN));
+			       min(SCSI_SENSE_BUFFERSIZE, SYM_SNS_BBUF_LEN));
 #if 0
 			/*
 			 *  If the device reports a UNIT ATTENTION condition 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 4419304..5b04ddf 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -444,7 +444,7 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 
 	/* Map sense buffer */
 	if (pSRB->SRBFlag & AUTO_REQSENSE) {
-		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->sense_buffer, sizeof(pcmd->sense_buffer));
+		pSRB->pSegmentList	= dc390_sg_build_single(&pSRB->Segmentx, pcmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
 		pSRB->SGcount		= pci_map_sg(pdev, pSRB->pSegmentList, 1,
 						     DMA_FROM_DEVICE);
 		cmdp->saved_dma_handle	= sg_dma_address(pSRB->pSegmentList);
@@ -599,7 +599,7 @@ dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_sr
 	    DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
 	    DC390_write8 (ScsiFifo, 0);
 	    DC390_write8 (ScsiFifo, 0);
-	    DC390_write8 (ScsiFifo, sizeof(scmd->sense_buffer));
+	    DC390_write8 (ScsiFifo, SCSI_SENSE_BUFFERSIZE);
 	    DC390_write8 (ScsiFifo, 0);
 	    DEBUG1(printk (KERN_DEBUG "DC390: AutoReqSense !\n"));
 	  }
@@ -1389,7 +1389,7 @@ dc390_CommandPhase( struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus
 	DC390_write8 (ScsiFifo, pDCB->TargetLUN << 5);
 	DC390_write8 (ScsiFifo, 0);
 	DC390_write8 (ScsiFifo, 0);
-	DC390_write8 (ScsiFifo, sizeof(pSRB->pcmd->sense_buffer));
+	DC390_write8 (ScsiFifo, SCSI_SENSE_BUFFERSIZE);
 	DC390_write8 (ScsiFifo, 0);
 	DEBUG0(printk(KERN_DEBUG "DC390: AutoReqSense (CmndPhase)!\n"));
     }
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 7edd6ce..4bc5407 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1121,9 +1121,9 @@ static void map_dma(unsigned int i, unsigned int j) {
 
    if (SCpnt->sense_buffer)
       cpp->sense_addr = H2DEV(pci_map_single(HD(j)->pdev, SCpnt->sense_buffer,
-                           sizeof SCpnt->sense_buffer, PCI_DMA_FROMDEVICE));
+                           SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE));
 
-   cpp->sense_len = sizeof SCpnt->sense_buffer;
+   cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
    if (scsi_bufflen(SCpnt)) {
 	   count = scsi_dma_map(SCpnt);
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 6d1f0ed..1d3b029 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -741,7 +741,7 @@ static int ultrastor_queuecommand(struct scsi_cmnd *SCpnt,
     }
     my_mscp->command_link = 0;		/*???*/
     my_mscp->scsi_command_link_id = 0;	/*???*/
-    my_mscp->length_of_sense_byte = sizeof SCpnt->sense_buffer;
+    my_mscp->length_of_sense_byte = SCSI_SENSE_BUFFERSIZE;
     my_mscp->length_of_scsi_cdbs = SCpnt->cmd_len;
     memcpy(my_mscp->scsi_cdbs, SCpnt->cmnd, my_mscp->length_of_scsi_cdbs);
     my_mscp->adapter_status = 0;
-- 
1.5.3.4

