From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some tmscsim consolidation
Date: Sun, 6 Jun 2004 14:41:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606124156.GA30931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:11210 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263540AbUFFMl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:41:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

I've looked through my old tmscsim patch queue and found this one:

 - merge dc390_initDCB into dc390_slave_alloc
 - merge DC390_release and dc390_shutdown into dc390_remove_one,
   use del_timer_sync to make sure the timer is really deleted on
   removal, adjust locking accordingly
 - some tiny related cleanups


--- 1.38/drivers/scsi/tmscsim.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-06-06 14:22:25 +02:00
@@ -340,11 +340,8 @@
 static irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);
 
 static int    dc390_initAdapter( PSH psh, ULONG io_port, UCHAR Irq, UCHAR index );
-static void   dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun);
 static void   dc390_updateDCB (PACB pACB, PDCB pDCB);
 
-static int DC390_release(struct Scsi_Host *host);
-static int dc390_shutdown (struct Scsi_Host *host);
 static int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
 			    off_t offset, int length, int inout);
 
@@ -1527,94 +1524,6 @@
 
 #include "scsiiom.c"
 
-
-/***********************************************************************
- * Function : static void dc390_initDCB()
- *
- * Purpose :  initialize the internal structures for a DCB (to be malloced)
- *
- * Inputs : SCSI id and lun
- ***********************************************************************/
-
-static void dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun )
-{
-    PEEprom	prom;
-    UCHAR	index;
-    PDCB pDCB, pDCB2;
-
-    pDCB = kmalloc (sizeof(DC390_DCB), GFP_ATOMIC);
-    DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n",	\
-		     id, lun, pDCB));
- 
-    *ppDCB = pDCB;
-    if (!pDCB) return;
-    pDCB2 = 0;
-    if( pACB->DCBCnt == 0 )
-    {
-	pACB->pLinkDCB = pDCB;
-	pACB->pDCBRunRobin = pDCB;
-    }
-    else
-    {
-	pACB->pLastDCB->pNextDCB = pDCB;
-    }
-   
-    pACB->DCBCnt++;
-   
-    pDCB->pNextDCB = pACB->pLinkDCB;
-    pACB->pLastDCB = pDCB;
-
-    pDCB->pDCBACB = pACB;
-    pDCB->TargetID = id;
-    pDCB->TargetLUN = lun;
-    pDCB->pWaitingSRB = NULL;
-    pDCB->pGoingSRB = NULL;
-    pDCB->GoingSRBCnt = 0;
-    pDCB->WaitSRBCnt = 0;
-    pDCB->pActiveSRB = NULL;
-    pDCB->TagMask = 0;
-    pDCB->MaxCommand = 1;
-    index = pACB->AdapterIndex;
-    pDCB->DCBFlag = 0;
-
-    /* Is there a corresp. LUN==0 device ? */
-    if (lun != 0)
-	pDCB2 = dc390_findDCB (pACB, id, 0);
-    prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
-    /* Some values are for all LUNs: Copy them */
-    /* In a clean way: We would have an own structure for a SCSI-ID */
-    if (pDCB2)
-    {
-      pDCB->DevMode = pDCB2->DevMode;
-      pDCB->SyncMode = pDCB2->SyncMode;
-      pDCB->SyncPeriod = pDCB2->SyncPeriod;
-      pDCB->SyncOffset = pDCB2->SyncOffset;
-      pDCB->NegoPeriod = pDCB2->NegoPeriod;
-      
-      pDCB->CtrlR3 = pDCB2->CtrlR3;
-      pDCB->CtrlR4 = pDCB2->CtrlR4;
-      pDCB->Inquiry7 = pDCB2->Inquiry7;
-    }
-    else
-    {		
-      pDCB->DevMode = prom->EE_MODE1;
-      pDCB->SyncMode = 0;
-      pDCB->SyncPeriod = 0;
-      pDCB->SyncOffset = 0;
-      pDCB->NegoPeriod = (dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
-            
-      pDCB->CtrlR3 = FAST_CLK;
-      
-      pDCB->CtrlR4 = pACB->glitch_cfg | CTRL4_RESERVED;
-      if( dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION)
-	pDCB->CtrlR4 |= NEGATE_REQACKDATA | NEGATE_REQACK;
-      pDCB->Inquiry7 = 0;
-    }
-
-    pACB->DCBmap[id] |= (1 << lun);
-    dc390_updateDCB(pACB, pDCB);
-}
-
 /***********************************************************************
  * Function : static void dc390_updateDCB()
  *
@@ -1900,34 +1809,84 @@
  *
  * @scsi_device: The new scsi device that we need to handle.
  */
-static int dc390_slave_alloc(struct scsi_device *scsi_device)
+static int dc390_slave_alloc(struct scsi_device *sdev)
 {
-	PDCB pDCB;
-	PACB pACB = (PACB) scsi_device->host->hostdata;
-	dc390_initDCB(pACB, &pDCB, scsi_device->id, scsi_device->lun);
-	if (pDCB != NULL) {
-		scsi_device->hostdata = pDCB;
-		pACB->scan_devices = 1;
-		return 0;
+	PACB pACB = (PACB) sdev->host->hostdata;
+	PDCB pDCB, pDCB2 = NULL;
+	uint id =  sdev->id;
+	uint lun = sdev->lun;
+
+	pDCB = kmalloc(sizeof(DC390_DCB), GFP_KERNEL);
+	if (!pDCB)
+		return -ENOMEM;
+	memset(pDCB, 0, sizeof(*pDCB));
+
+	if (!pACB->DCBCnt++) {
+		pACB->pLinkDCB = pDCB;
+		pACB->pDCBRunRobin = pDCB;
+	} else {
+		pACB->pLastDCB->pNextDCB = pDCB;
+	}
+   
+	pDCB->pNextDCB = pACB->pLinkDCB;
+	pACB->pLastDCB = pDCB;
+
+	pDCB->pDCBACB = pACB;
+	pDCB->TargetID = id;
+	pDCB->TargetLUN = lun;
+	pDCB->MaxCommand = 1;
+	
+	/*
+	 * Some values are for all LUNs: Copy them 
+	 * In a clean way: We would have an own structure for a SCSI-ID 
+	 */
+	if (lun && (pDCB2 = dc390_findDCB(pACB, id, 0))) {
+		pDCB->DevMode = pDCB2->DevMode;
+		pDCB->SyncMode = pDCB2->SyncMode;
+		pDCB->SyncPeriod = pDCB2->SyncPeriod;
+		pDCB->SyncOffset = pDCB2->SyncOffset;
+		pDCB->NegoPeriod = pDCB2->NegoPeriod;
+      
+		pDCB->CtrlR3 = pDCB2->CtrlR3;
+		pDCB->CtrlR4 = pDCB2->CtrlR4;
+		pDCB->Inquiry7 = pDCB2->Inquiry7;
+	} else {		
+		u8 index = pACB->AdapterIndex;
+		PEEprom	prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
+
+		pDCB->DevMode = prom->EE_MODE1;
+		pDCB->NegoPeriod =
+			(dc390_clock_period1[prom->EE_SPEED] * 25) >> 2;
+ 
+		pDCB->CtrlR3 = FAST_CLK;
+		pDCB->CtrlR4 = pACB->glitch_cfg | CTRL4_RESERVED;
+		
+		if (dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION)
+			pDCB->CtrlR4 |= NEGATE_REQACKDATA | NEGATE_REQACK;
 	}
-	return -ENOMEM;
+
+	pACB->DCBmap[id] |= (1 << lun);
+	dc390_updateDCB(pACB, pDCB);
+
+	pACB->scan_devices = 1;
+
+	sdev->hostdata = pDCB;
+	return 0;
 }
 
 /**
  * dc390_slave_destroy - Called by the scsi mid layer to tell us about a
  * device that is going away.
  *
- * @scsi_device: The scsi device that we need to remove.
+ * @sdev: The scsi device that we need to remove.
  */
-static void dc390_slave_destroy(struct scsi_device *scsi_device)
+static void dc390_slave_destroy(struct scsi_device *sdev)
 {
-	PACB pACB = (PACB) scsi_device->host->hostdata;
-	PDCB pDCB = (PDCB) scsi_device->hostdata;
+	PACB pACB = (PACB) sdev->host->hostdata;
+	PDCB pDCB = (PDCB) sdev->hostdata;
+
 	pACB->scan_devices = 0;
-	if (pDCB != NULL)
-		dc390_remove_dev(pACB, pDCB);
-	else
-		printk(KERN_ERR"%s() called for non-existing device!\n", __FUNCTION__);
+	dc390_remove_dev(pACB, pDCB);
 }
 
 static int dc390_slave_configure(struct scsi_device *scsi_device)
@@ -2010,15 +1969,32 @@
  *
  * @dev: The PCI device to remove.
  */
-static void __devexit dc390_remove_one(struct pci_dev *dev)
+static void __devexit dc390_remove_one(struct pci_dev *pdev)
 {
-	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	PACB pACB = (PACB) shost->hostdata;
+	u8 bval;
+	DC390_IFLAGS;
 
-	scsi_remove_host(scsi_host);
-	DC390_release(scsi_host);
-	pci_disable_device(dev);
-	scsi_host_put(scsi_host);
-	pci_set_drvdata(dev, NULL);
+	scsi_remove_host(shost);
+
+	DC390_LOCK_IO(shost);
+	pACB->ACBFlag = RESET_DEV;
+	bval = DC390_read8(CtrlReg1) | DIS_INT_ON_SCSI_RST;
+	DC390_write8(CtrlReg1, bval);	/* disable interrupt */
+	if (pACB->Gmode2 & RST_SCSI_BUS)
+		dc390_ResetSCSIBus(pACB);
+	DC390_UNLOCK_IO(shost);
+
+	del_timer_sync(&pACB->Waiting_Timer);
+
+	free_irq(pdev->irq, pACB);
+	release_region(shost->io_port, shost->n_io_port);
+
+	scsi_host_put(shost);
+
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 }
 
 /********************************************************************
@@ -2166,75 +2142,6 @@
 
 #undef YESNO
 #undef SPRINTF
-
-/***********************************************************************
- * Function : static int dc390_shutdown (struct Scsi_Host *host)
- *
- * Purpose : does a clean (we hope) shutdown of the SCSI chip.
- *	     Use prior to dumping core, unloading the driver, etc.
- *
- * Returns : 0 on success
- ***********************************************************************/
-static int dc390_shutdown (struct Scsi_Host *host)
-{
-    UCHAR    bval;
-    PACB pACB = (PACB) host->hostdata;
-   
-/*  pACB->soft_reset(host); */
-
-    printk(KERN_INFO "DC390: shutdown\n");
-
-    pACB->ACBFlag = RESET_DEV;
-    bval = DC390_read8 (CtrlReg1);
-    bval |= DIS_INT_ON_SCSI_RST;
-    DC390_write8 (CtrlReg1, bval);	/* disable interrupt */
-    if (pACB->Gmode2 & RST_SCSI_BUS)
-		dc390_ResetSCSIBus (pACB);
-
-    if (timer_pending (&pACB->Waiting_Timer)) del_timer (&pACB->Waiting_Timer);
-    return( 0 );
-}
-
-static void dc390_freeDCBs (struct Scsi_Host *host)
-{
-    PDCB pDCB, nDCB;
-    PACB pACB = (PACB) host->hostdata;
-    
-    pDCB = pACB->pLinkDCB;
-    if (!pDCB) return;
-    do
-    {
-	nDCB = pDCB->pNextDCB;
-	DCBDEBUG(printk (KERN_INFO "DC390: Free DCB (ID %i, LUN %i): %p\n",\
-			 pDCB->TargetID, pDCB->TargetLUN, pDCB));
-	//kfree (pDCB);
-	dc390_remove_dev (pACB, pDCB);
-	pDCB = nDCB;
-    } while (pDCB && pACB->pLinkDCB);
-
-}
-
-static int DC390_release (struct Scsi_Host *host)
-{
-    DC390_IFLAGS;
-    PACB pACB = (PACB) host->hostdata;
-
-    DC390_LOCK_IO(host);
-
-    /* TO DO: We should check for outstanding commands first. */
-    dc390_shutdown (host);
-
-    if (host->irq != SCSI_IRQ_NONE)
-    {
-	DEBUG0(printk(KERN_INFO "DC390: Free IRQ %i\n",host->irq));
-	free_irq (host->irq, pACB);
-    }
-
-    release_region(host->io_port,host->n_io_port);
-    dc390_freeDCBs (host);
-    DC390_UNLOCK_IO(host);
-    return( 1 );
-}
 
 static struct pci_driver dc390_driver = {
 	.name           = "tmscsim",
