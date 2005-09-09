From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] transport API for tmscsim
Date: Fri, 9 Sep 2005 22:26:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0509092216060.12483@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:10640 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030439AbVIIU1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 16:27:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Hi

Here's an attempt of a SCSI transport API implementation for tmscsim. 
Please, comment.

Test booted with 3 sync devices on the bus, tried to changed period from 
100ns to 150ns (148 was set), read throughput fell from 7900000 to 5900000 
bytes/sec (measured with dd). Is it about the expected drop?

Not sure if I chose a good place for spi_display_xfer_agreement() - it now 
happens 8 times (!) per target...

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Index: linux-2.6.13/drivers/scsi/tmscsim.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/tmscsim.c,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 tmscsim.c
--- linux-2.6.13/drivers/scsi/tmscsim.c	2 Sep 2005 19:16:29 -0000	1.1.1.9
+++ linux-2.6.13/drivers/scsi/tmscsim.c	9 Sep 2005 20:04:25 -0000
@@ -243,7 +243,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_tcq.h>
-
+#include <scsi/scsi_transport_spi.h>
 
 #define DC390_BANNER "Tekram DC390/AM53C974"
 #define DC390_VERSION "2.1d 2004-05-27"
@@ -277,6 +277,8 @@ static void dc390_EnableMsgOut_Abort(str
 static void dc390_dumpinfo(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB);
 static void dc390_ResetDevParam(struct dc390_acb* pACB);
 
+static struct scsi_transport_template *dc390_transport_template;
+
 static u32	dc390_laststatus = 0;
 static u8	dc390_adapterCnt = 0;
 
@@ -519,7 +521,7 @@ dc390_StartSCSI( struct dc390_acb* pACB,
     /* TODO: error handling */
     DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
     DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-    DC390_write8 (Sync_Offset, pDCB->SyncOffset);
+    DC390_write8 (Sync_Offset, spi_offset(pDCB->starget));
     DC390_write8 (CtrlReg1, pDCB->CtrlR1);
     DC390_write8 (CtrlReg3, pDCB->CtrlR3);
     DC390_write8 (CtrlReg4, pDCB->CtrlR4);
@@ -565,7 +567,7 @@ dc390_StartSCSI( struct dc390_acb* pACB,
 
     if (try_sync_nego)
       { 
-	u8 Sync_Off = pDCB->SyncOffset;
+	u8 Sync_Off = spi_offset(pDCB->starget);
         DEBUG0(printk (KERN_INFO "DC390: NEW Sync Nego code triggered (%i %i)\n", pDCB->TargetID, pDCB->TargetLUN));
 	pSRB->MsgOutBuf[0] = EXTENDED_MESSAGE;
 	pSRB->MsgOutBuf[1] = 3;
@@ -1038,10 +1040,11 @@ static void __inline__
 dc390_reprog (struct dc390_acb* pACB, struct dc390_dcb* pDCB)
 {
   DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-  DC390_write8 (Sync_Offset, pDCB->SyncOffset);
+  DC390_write8 (Sync_Offset, spi_offset(pDCB->starget));
   DC390_write8 (CtrlReg3, pDCB->CtrlR3);
   DC390_write8 (CtrlReg4, pDCB->CtrlR4);
   dc390_SetXferRate (pACB, pDCB);
+  spi_display_xfer_agreement(pDCB->starget);
 }
 
 
@@ -1123,7 +1126,8 @@ dc390_MsgIn_set_async (struct dc390_acb*
   pSRB->SRBState &= ~DO_SYNC_NEGO;
   pDCB->SyncMode &= ~(SYNC_ENABLE+SYNC_NEGO_DONE);
   pDCB->SyncPeriod = 0;
-  pDCB->SyncOffset = 0;
+  spi_period(pDCB->starget) = 0;
+  spi_offset(pDCB->starget) = 0;
   //pDCB->NegoPeriod = 50; /* 200ns <=> 5 MHz */
   pDCB->CtrlR3 = FAST_CLK;	/* fast clock / normal scsi */
   pDCB->CtrlR4 &= 0x3f;
@@ -1139,7 +1143,7 @@ dc390_MsgIn_set_sync (struct dc390_acb* 
   u16 wval, wval1;
   struct dc390_dcb* pDCB = pSRB->pSRBDCB;
   u8 oldsyncperiod = pDCB->SyncPeriod;
-  u8 oldsyncoffset = pDCB->SyncOffset;
+  u8 oldsyncoffset = spi_offset(pDCB->starget);
   
   if (!(pSRB->SRBState & DO_SYNC_NEGO))
     {
@@ -1168,8 +1172,8 @@ dc390_MsgIn_set_sync (struct dc390_acb* 
 
   pSRB->SRBState &= ~DO_SYNC_NEGO;
   pDCB->SyncMode |= SYNC_ENABLE+SYNC_NEGO_DONE;
-  pDCB->SyncOffset &= 0x0f0;
-  pDCB->SyncOffset |= pSRB->MsgInBuf[4];
+  spi_offset(pDCB->starget) &= 0xf0;
+  spi_offset(pDCB->starget) |= pSRB->MsgInBuf[4];
   pDCB->NegoPeriod = pSRB->MsgInBuf[3];
 
   wval = (u16) pSRB->MsgInBuf[3];
@@ -1193,14 +1197,15 @@ dc390_MsgIn_set_sync (struct dc390_acb* 
 
   pDCB->CtrlR3 = bval;
   pDCB->SyncPeriod = (u8)wval1;
-  
-  if ((oldsyncperiod != wval1 || oldsyncoffset != pDCB->SyncOffset) && pDCB->TargetLUN == 0)
+  spi_period(pDCB->starget) = pSRB->MsgInBuf[3];
+  if ((oldsyncperiod != wval1 || oldsyncoffset != spi_offset(pDCB->starget)) &&
+      pDCB->TargetLUN == 0)
     {
       if (! (bval & FAST_SCSI)) wval1++;
       printk (KERN_INFO "DC390: Target %i: Sync transfer %i.%1i MHz, Offset %i\n", pDCB->TargetID, 
-	      40/wval1, ((40%wval1)*10+wval1/2)/wval1, pDCB->SyncOffset & 0x0f);
+	      40/wval1, ((40%wval1)*10+wval1/2)/wval1, spi_offset(pDCB->starget) & 0x0f);
     }
-  
+ 
   dc390_reprog (pACB, pDCB);
 }
 
@@ -1529,8 +1534,8 @@ mop1:
 	DC390_write8 (ScsiFifo, 3);	/*    ;length of extended msg */
 	DC390_write8 (ScsiFifo, EXTENDED_SDTR);	/*    ; sync nego */
 	DC390_write8 (ScsiFifo, pDCB->NegoPeriod);
-	if (pDCB->SyncOffset & 0x0f)
-		    DC390_write8 (ScsiFifo, pDCB->SyncOffset);
+	if (spi_offset(pDCB->starget) & 0x0f)
+		    DC390_write8 (ScsiFifo, spi_offset(pDCB->starget));
 	else
 		    DC390_write8 (ScsiFifo, SYNC_NEGO_OFFSET);		    
 	pSRB->SRBState |= DO_SYNC_NEGO;
@@ -1580,7 +1585,8 @@ dc390_SetXferRate( struct dc390_acb* pAC
 		if( ptr->TargetID == bval )
 		{
 		    ptr->SyncPeriod = pDCB->SyncPeriod;
-		    ptr->SyncOffset = pDCB->SyncOffset;
+		    spi_period(ptr->starget) = spi_period(pDCB->starget);
+		    spi_offset(ptr->starget) = spi_offset(pDCB->starget);
 		    ptr->CtrlR3 = pDCB->CtrlR3;
 		    ptr->CtrlR4 = pDCB->CtrlR4;
 		    ptr->SyncMode = pDCB->SyncMode;
@@ -1738,7 +1744,7 @@ dc390_Reselect( struct dc390_acb* pACB )
     pSRB->ScsiPhase = SCSI_NOP0;
     DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
     DC390_write8 (Sync_Period, pDCB->SyncPeriod);
-    DC390_write8 (Sync_Offset, pDCB->SyncOffset);
+    DC390_write8 (Sync_Offset, spi_offset(pDCB->starget));
     DC390_write8 (CtrlReg1, pDCB->CtrlR1);
     DC390_write8 (CtrlReg3, pDCB->CtrlR3);
     DC390_write8 (CtrlReg4, pDCB->CtrlR4);	/* ; Glitch eater */
@@ -2103,7 +2109,8 @@ static void dc390_ResetDevParam( struct 
     {
 	pDCB->SyncMode &= ~SYNC_NEGO_DONE;
 	pDCB->SyncPeriod = 0;
-	pDCB->SyncOffset = 0;
+	spi_period(pDCB->starget) = 0;
+	spi_offset(pDCB->starget) = 0;
 	pDCB->TagMask = 0;
 	pDCB->CtrlR3 = FAST_CLK;
 	pDCB->CtrlR4 &= NEGATE_REQACKDATA | CTRL4_RESERVED | NEGATE_REQACK;
@@ -2180,6 +2187,10 @@ static int dc390_slave_alloc(struct scsi
 	pDCB->pDCBACB = pACB;
 	pDCB->TargetID = id;
 	pDCB->TargetLUN = lun;
+	pDCB->starget = scsi_device->sdev_target;
+
+	spi_width(pDCB->starget) = 0;
+	spi_max_width(pDCB->starget) = 0;
 
 	/*
 	 * Some values are for all LUNs: Copy them 
@@ -2189,9 +2200,10 @@ static int dc390_slave_alloc(struct scsi
 		pDCB->DevMode = pDCB2->DevMode;
 		pDCB->SyncMode = pDCB2->SyncMode & SYNC_NEGO_DONE;
 		pDCB->SyncPeriod = pDCB2->SyncPeriod;
-		pDCB->SyncOffset = pDCB2->SyncOffset;
+		spi_period(pDCB->starget) = spi_period(pDCB2->starget);
+		spi_offset(pDCB->starget) = spi_offset(pDCB2->starget);
 		pDCB->NegoPeriod = pDCB2->NegoPeriod;
-      
+
 		pDCB->CtrlR3 = pDCB2->CtrlR3;
 		pDCB->CtrlR4 = pDCB2->CtrlR4;
 	} else {
@@ -2211,7 +2223,7 @@ static int dc390_slave_alloc(struct scsi
 		pDCB->SyncMode |= SYNC_ENABLE;
 	else {
 		pDCB->SyncMode = 0;
-		pDCB->SyncOffset &= ~0x0f;
+		spi_offset(pDCB->starget) &= ~0x0f;
 	}
 
 	pDCB->CtrlR1 = pACB->pScsiHost->this_id;
@@ -2275,6 +2287,9 @@ static int dc390_slave_configure(struct 
 		scsi_activate_tcq(sdev, acb->TagMaxNum);
 	}
 
+	if (!spi_initial_dv(sdev->sdev_target))
+		spi_dv_device(sdev);
+
 	return 0;
 }
 
@@ -2537,7 +2552,8 @@ static int __devinit dc390_probe_one(str
 	shost->base = io_port;
 	shost->unique_id = io_port;
 	shost->last_reset = jiffies;
-	
+	shost->transportt = dc390_transport_template;
+
 	pACB->pScsiHost = shost;
 	pACB->IOPortBase = (u16) io_port;
 	pACB->IRQLevel = pdev->irq;
@@ -2592,6 +2608,8 @@ static int __devinit dc390_probe_one(str
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
 		goto out_free_irq;
+
+	spi_signalling(shost) = SPI_SIGNAL_SE;
 	scsi_scan_host(shost);
 	return 0;
 
@@ -2637,6 +2655,60 @@ static void __devexit dc390_remove_one(s
 	pci_set_drvdata(dev, NULL);
 }
 
+static void dc390_set_offset(struct scsi_target *starget, int offset)
+{
+	if (!spi_period(starget))
+		return;
+
+	if (offset > 15)
+		offset = 15;
+	else if (offset < 0)
+		offset = 0;
+
+	spi_offset(starget) = offset;
+}
+
+static void dc390_set_period(struct scsi_target *starget, int period)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct dc390_acb *pACB = (struct dc390_acb *)shost->hostdata;
+	struct dc390_dcb *pDCB = pACB->pLinkDCB;
+	u16 wval;
+
+	if (!spi_period(starget))
+		return;
+
+	if (!pDCB)
+		return;
+
+	while (pDCB->starget != starget) {
+		pDCB = pDCB->pNextDCB;
+		if (pDCB == pACB->pLinkDCB)
+			return;
+	}
+
+	if (period < pDCB->NegoPeriod)
+		period = pDCB->NegoPeriod;
+
+	/* See calculations in dc390_MsgIn_set_sync() for reference */
+	wval = (period << 2) - 3;
+	wval = ((wval + 24) / 25);
+
+	if (wval >= 8)
+		wval--;
+
+	spi_period(starget) = period;
+	pDCB->SyncPeriod = (u8)wval;
+}
+
+static struct spi_function_template dc390_transport_functions = {
+	.set_offset	= dc390_set_offset,
+	.show_offset	= 1,
+	.set_period	= dc390_set_period,
+	.show_period	= 1,
+	.show_width	= 1,
+};
+
 static struct pci_device_id tmscsim_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
@@ -2653,6 +2725,8 @@ static struct pci_driver dc390_driver = 
 
 static int __init dc390_module_init(void)
 {
+	int err;
+
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;
 		tmscsim[1] = 4;
@@ -2663,12 +2737,22 @@ static int __init dc390_module_init(void
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	dc390_transport_template = spi_attach_transport(&dc390_transport_functions);
+	if (!dc390_transport_template)
+		return -ENODEV;
+
+	err = pci_register_driver(&dc390_driver);
+
+	if (err)
+		spi_release_transport(dc390_transport_template);
+
+	return err;
 }
 
 static void __exit dc390_module_exit(void)
 {
 	pci_unregister_driver(&dc390_driver);
+	spi_release_transport(dc390_transport_template);
 }
 
 module_init(dc390_module_init);
Index: linux-2.6.13/drivers/scsi/tmscsim.h
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/tmscsim.h,v
retrieving revision 1.1.1.6
diff -u -p -r1.1.1.6 tmscsim.h
--- linux-2.6.13/drivers/scsi/tmscsim.h	13 Jan 2005 21:10:01 -0000	1.1.1.6
+++ linux-2.6.13/drivers/scsi/tmscsim.h	8 Sep 2005 20:51:00 -0000
@@ -82,6 +82,7 @@ struct dc390_dcb
 {
 struct dc390_dcb	*pNextDCB;
 struct dc390_acb	*pDCBACB;
+struct scsi_target	*starget;
 
 /* Queued SRBs */
 struct dc390_srb	*pGoingSRB;
@@ -103,7 +104,6 @@ u8		CtrlR4;
 u8		SyncMode;	/*; 0:async mode */
 u8		NegoPeriod;	/*;for nego. */
 u8		SyncPeriod;	/*;for reg. */
-u8		SyncOffset;	/*;for reg. and nego.(low nibble) */
 };
 
 
