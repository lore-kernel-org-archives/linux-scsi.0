From: viro@www.linux.org.uk
Subject: [PATCH] more NULL noise removal in drivers/scsi
Date: Wed, 06 Oct 2004 13:19:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CFAlp-0004Jf-G6@www.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39130 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269213AbUJFMTu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 08:19:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org

trivial junk that had been hanging arond in my tree for months now...
Signed-off-by: Al Viro <viro@parcelfarce.linux.org.uk
----
diff -urN RC9-rc3-bk5-struct/drivers/scsi/3w-xxxx.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/3w-xxxx.c
--- RC9-rc3-bk5-struct/drivers/scsi/3w-xxxx.c	Sat Aug 14 03:46:23 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/3w-xxxx.c	Tue Oct  5 20:11:29 2004
@@ -551,7 +551,7 @@
 	/* Now post the command packet */
 	if ((status_reg_value & TW_STATUS_COMMAND_QUEUE_FULL) == 0) {
 		dprintk(KERN_WARNING "3w-xxxx: tw_aen_read_queue(): Post succeeded.\n");
-		tw_dev->srb[request_id] = 0; /* Flag internal command */
+		tw_dev->srb[request_id] = NULL; /* Flag internal command */
 		tw_dev->state[request_id] = TW_S_POSTED;
 		outl(command_que_value, command_que_addr);
 	} else {
@@ -718,7 +718,7 @@
 			tw_state_request_start(tw_dev, &request_id);
 
 			/* Flag internal command */
-			tw_dev->srb[request_id] = 0;
+			tw_dev->srb[request_id] = NULL;
 
 			/* Flag chrdev ioctl */
 			tw_dev->chrdev_request_id = request_id;
@@ -2692,7 +2692,7 @@
 	/* Fake like we just shut down, so notify the card that
 	 * we "shut down cleanly".
 	 */
-	tw_halt(0, 0, 0);  // parameters aren't actually used
+	tw_halt(NULL, 0, NULL);  // parameters aren't actually used
 
 	/* Free up the IO region */
 	release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
diff -urN RC9-rc3-bk5-struct/drivers/scsi/NCR53C9x.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/NCR53C9x.c
--- RC9-rc3-bk5-struct/drivers/scsi/NCR53C9x.c	Sat Aug 14 03:46:23 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/NCR53C9x.c	Tue Oct  5 20:11:35 2004
@@ -94,7 +94,7 @@
 };
 
 /* The master ring of all esp hosts we are managing in this driver. */
-struct NCR_ESP *espchain = 0;
+struct NCR_ESP *espchain;
 int nesps = 0, esps_in_use = 0, esps_running = 0;
 
 irqreturn_t esp_intr(int irq, void *dev_id, struct pt_regs *pregs);
@@ -555,7 +555,7 @@
 	} else {
 		espchain = esp;
 	}
-	esp->next = 0;
+	esp->next = NULL;
 
 	return esp;
 }
@@ -565,7 +565,7 @@
 	struct NCR_ESP *elink;
 
 	if(espchain == esp) {
-		espchain = 0;
+		espchain = NULL;
 	} else {
 		for(elink = espchain; elink && (elink->next != esp); elink = elink->next);
 		if(elink) 
@@ -708,9 +708,9 @@
 	}				
 
 	/* Initialize the command queues */
-	esp->current_SC = 0;
-	esp->disconnected_SC = 0;
-	esp->issue_SC = 0;
+	esp->current_SC = NULL;
+	esp->disconnected_SC = NULL;
+	esp->issue_SC = NULL;
 
 	/* Clear the state machines. */
 	esp->targets_present = 0;
@@ -1728,7 +1728,7 @@
 		ESPLOG(("esp%d: Weird, being reselected but disconnected "
 			"command queue is empty.\n", esp->esp_id));
 	esp->snip = 0;
-	esp->current_SC = 0;
+	esp->current_SC = NULL;
 	sp->SCp.phase = not_issued;
 	append_SC(&esp->issue_SC, sp);
 }
@@ -3393,7 +3393,7 @@
 }
 
 static espfunc_t isvc_vector[] = {
-	0,
+	NULL,
 	esp_do_phase_determine,
 	esp_do_resetbus,
 	esp_finish_reset,
diff -urN RC9-rc3-bk5-struct/drivers/scsi/atp870u.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/atp870u.c
--- RC9-rc3-bk5-struct/drivers/scsi/atp870u.c	Sat Aug 14 03:46:23 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/atp870u.c	Tue Oct  5 20:11:44 2004
@@ -363,7 +363,7 @@
 			/*
 			 *      Clear it off the queue
 			 */
-			dev->id[target_id].curr_req = 0;
+			dev->id[target_id].curr_req = NULL;
 			dev->working--;
 			spin_unlock_irqrestore(dev->host->host_lock, flags);
 			/*
@@ -2263,10 +2263,10 @@
 	dev->in_snd = 0;
 	dev->in_int = 0;
 	for (k = 0; k < qcnt; k++) {
-		dev->querequ[k] = 0;
+		dev->querequ[k] = NULL;
 	}
 	for (k = 0; k < 16; k++) {
-		dev->id[k].curr_req = 0;
+		dev->id[k].curr_req = NULL;
 		dev->sp[k] = 0x04;
 	}
 	return 0;
diff -urN RC9-rc3-bk5-struct/drivers/scsi/dc395x.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/dc395x.c
--- RC9-rc3-bk5-struct/drivers/scsi/dc395x.c	Thu Sep 30 04:39:05 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/dc395x.c	Tue Oct  5 20:11:53 2004
@@ -989,7 +989,7 @@
 	srb->sg_count = 0;
 	srb->total_xfer_length = 0;
 	srb->sg_bus_addr = 0;
-	srb->virt_addr = 0;
+	srb->virt_addr = NULL;
 	srb->sg_index = 0;
 	srb->adapter_status = 0;
 	srb->target_status = 0;
@@ -2016,7 +2016,7 @@
 	}
 
 	dprintkl(KERN_ERR, "sg_update_list: sg_to_virt failed\n");
-	srb->virt_addr = 0;
+	srb->virt_addr = NULL;
 }
 
 
@@ -3656,7 +3656,7 @@
 	} else {
 		acb->acb_flag |= RESET_DETECT;
 		reset_dev_param(acb);
-		doing_srb_done(acb, DID_RESET, 0, 1);
+		doing_srb_done(acb, DID_RESET, NULL, 1);
 		/*DC395x_RecoverSRB( acb ); */
 		acb->active_dcb = NULL;
 		acb->acb_flag = 0;
diff -urN RC9-rc3-bk5-struct/drivers/scsi/ips.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/ips.c
--- RC9-rc3-bk5-struct/drivers/scsi/ips.c	Thu Sep 30 04:39:05 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/ips.c	Tue Oct  5 20:12:03 2004
@@ -215,7 +215,7 @@
 #endif
 #else
 #define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \
-                                     page_address((sg)->page)+(sg)->offset : 0)
+                                   page_address((sg)->page)+(sg)->offset : NULL)
 #define IPS_LOCK_SAVE(lock,flags) do{spin_lock(lock);(void)flags;}while(0)
 #define IPS_UNLOCK_RESTORE(lock,flags) do{spin_unlock(lock);(void)flags;}while(0)
 #endif
@@ -6854,8 +6854,8 @@
 {
 	ha->active = 0;
 	ips_free(ha);
-	ips_ha[index] = 0;
-	ips_sh[index] = 0;
+	ips_ha[index] = NULL;
+	ips_sh[index] = NULL;
 	return -1;
 }
 
diff -urN RC9-rc3-bk5-struct/drivers/scsi/mca_53c9x.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/mca_53c9x.c
--- RC9-rc3-bk5-struct/drivers/scsi/mca_53c9x.c	Sat Aug 14 03:46:24 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/mca_53c9x.c	Tue Oct  5 20:12:11 2004
@@ -238,15 +238,15 @@
 
 			/* Optional functions */
 
-			esp->dma_barrier = 0;
-			esp->dma_drain = 0;
-			esp->dma_invalidate = 0;
-			esp->dma_irq_entry = 0;
-			esp->dma_irq_exit = 0;
+			esp->dma_barrier = NULL;
+			esp->dma_drain = NULL;
+			esp->dma_invalidate = NULL;
+			esp->dma_irq_entry = NULL;
+			esp->dma_irq_exit = NULL;
 			esp->dma_led_on = dma_led_on;
 			esp->dma_led_off = dma_led_off;
-			esp->dma_poll = 0;
-			esp->dma_reset = 0;
+			esp->dma_poll = NULL;
+			esp->dma_reset = NULL;
 
 			/* Set the command buffer */
 
diff -urN RC9-rc3-bk5-struct/drivers/scsi/pcmcia/nsp_cs.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/pcmcia/nsp_cs.c
--- RC9-rc3-bk5-struct/drivers/scsi/pcmcia/nsp_cs.c	Sat Aug 14 03:46:24 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/pcmcia/nsp_cs.c	Tue Oct  5 20:11:16 2004
@@ -1528,7 +1528,7 @@
 	thislength = pos - (buffer + offset);
 
 	if(thislength < 0) {
-		*start = 0;
+		*start = NULL;
                 return 0;
         }
 
diff -urN RC9-rc3-bk5-struct/drivers/scsi/qla2xxx/qla_init.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/qla2xxx/qla_init.c
--- RC9-rc3-bk5-struct/drivers/scsi/qla2xxx/qla_init.c	Thu Sep 30 04:39:05 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/qla2xxx/qla_init.c	Tue Oct  5 20:11:22 2004
@@ -841,7 +841,7 @@
 
 	/* Clear outstanding commands array. */
 	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
-		ha->outstanding_cmds[cnt] = 0;
+		ha->outstanding_cmds[cnt] = NULL;
 
 	ha->current_outstanding_cmd = 0;
 
@@ -4131,7 +4131,7 @@
 		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 			sp = ha->outstanding_cmds[cnt];
 			if (sp) {
-				ha->outstanding_cmds[cnt] = 0;
+				ha->outstanding_cmds[cnt] = NULL;
 				if (ha->actthreads)
 					ha->actthreads--;
 				sp->lun_queue->out_cnt--;
diff -urN RC9-rc3-bk5-struct/drivers/scsi/scsiiom.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/scsiiom.c
--- RC9-rc3-bk5-struct/drivers/scsi/scsiiom.c	Thu Sep 30 04:39:05 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/scsiiom.c	Tue Oct  5 20:12:19 2004
@@ -1155,7 +1155,7 @@
      }
     DC390_write8 (ScsiCmd, EN_SEL_RESEL);
     pSRB = pDCB->pActiveSRB;
-    pACB->pActiveDCB = 0;
+    pACB->pActiveDCB = NULL;
     pSRB->ScsiPhase = SCSI_NOP0;
     if( pSRB->SRBState & SRB_UNEXPECT_RESEL )
     {
@@ -1175,7 +1175,7 @@
 	    dc390_Free_insert (pACB, pSRB);
 	    pSRB = psrb;
 	}
-	pDCB->pGoingSRB = 0;
+	pDCB->pGoingSRB = NULL;
 	dc390_Waiting_process (pACB);
     }
     else
@@ -1204,7 +1204,7 @@
 	{
 disc1:
 	    dc390_freetag (pDCB, pSRB);
-	    pDCB->pActiveSRB = 0;
+	    pDCB->pActiveSRB = NULL;
 	    pSRB->SRBState = SRB_FREE;
 	    dc390_SRBdone( pACB, pDCB, pSRB);
 	}
@@ -1644,7 +1644,7 @@
 	pACB->ACBFlag |= RESET_DETECT;
 
 	dc390_ResetDevParam( pACB );
-	dc390_DoingSRB_Done( pACB, 0 );
+	dc390_DoingSRB_Done( pACB, NULL );
 	//dc390_RecoverSRB( pACB );
 	pACB->pActiveDCB = NULL;
 	pACB->ACBFlag = 0;
diff -urN RC9-rc3-bk5-struct/drivers/scsi/tmscsim.c RC9-rc3-bk5-scsi-NULL/drivers/scsi/tmscsim.c
--- RC9-rc3-bk5-struct/drivers/scsi/tmscsim.c	Thu Sep 30 04:39:05 2004
+++ RC9-rc3-bk5-scsi-NULL/drivers/scsi/tmscsim.c	Tue Oct  5 20:12:31 2004
@@ -604,12 +604,12 @@
  **********************************************************************/
 static struct dc390_dcb __inline__ *dc390_findDCB ( struct dc390_acb* pACB, u8 id, u8 lun)
 {
-   struct dc390_dcb* pDCB = pACB->pLinkDCB; if (!pDCB) return 0;
+   struct dc390_dcb* pDCB = pACB->pLinkDCB; if (!pDCB) return NULL;
    while (pDCB->TargetID != id || pDCB->TargetLUN != lun)
      {
 	pDCB = pDCB->pNextDCB;
 	if (pDCB == pACB->pLinkDCB)
-	     return 0;
+	     return NULL;
      }
    DCBDEBUG1( printk (KERN_DEBUG "DCB %p (%02x,%02x) found.\n",	\
 		      pDCB, pDCB->TargetID, pDCB->TargetLUN));
@@ -1382,7 +1382,7 @@
 static int dc390_slave_alloc(struct scsi_device *scsi_device)
 {
 	struct dc390_acb *pACB = (struct dc390_acb*) scsi_device->host->hostdata;
-	struct dc390_dcb *pDCB, *pDCB2 = 0;
+	struct dc390_dcb *pDCB, *pDCB2 = NULL;
 	uint id = scsi_device->id;
 	uint lun = scsi_device->lun;
 
