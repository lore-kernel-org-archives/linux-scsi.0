From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] refactor tmscsim inititalization code
Date: Sat, 4 Sep 2004 15:02:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040904130235.GA20552@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:24526 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267881AbUIDNCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2004 09:02:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

this one I still had in my pipe.  This greatly streamlines the setup
code.


===== drivers/scsi/tmscsim.c 1.48 vs edited =====
--- 1.48/drivers/scsi/tmscsim.c	2004-08-17 23:17:27 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-08-24 19:38:24 +02:00
@@ -179,9 +179,6 @@
  *				suggested by CH.			*
  ***********************************************************************/
 
-/* Uncomment SA_INTERRUPT, if the driver refuses to share its IRQ with other devices */
-#define DC390_IRQ SA_SHIRQ /* | SA_INTERRUPT */
-
 /* DEBUG options */
 //#define DC390_DEBUG0
 //#define DC390_DEBUG1
@@ -252,18 +249,6 @@
 
 #define PCI_DEVICE_ID_AMD53C974 	PCI_DEVICE_ID_AMD_SCSI
 
-
- static struct pci_device_id tmscsim_pci_tbl[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD53C974,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
-	{ }		/* Terminating entry */
-};
-MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
-
 #include "tmscsim.h"
 
 static u8 dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB );
@@ -292,7 +277,6 @@
 static void dc390_EnableMsgOut_Abort(struct dc390_acb*, struct dc390_srb*);
 static irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);
 
-static int    dc390_initAdapter(struct Scsi_Host *psh, unsigned long io_port, u8 Irq, u8 index );
 static void   dc390_updateDCB (struct dc390_acb* pACB, struct dc390_dcb* pDCB);
 
 static struct dc390_acb*	dc390_pACB_start= NULL;
@@ -367,237 +351,11 @@
        "HP      C3323-300       4269"};
 #define BADDEVCNT	2
 
-static char*  dc390_adapname = "DC390";
 static u8  dc390_eepromBuf[MAX_ADAPTER_NUM][EE_LEN];
 static u8  dc390_clock_period1[] = {4, 5, 6, 7, 8, 10, 13, 20};
 static u8  dc390_clock_speed[] = {100,80,67,57,50, 40, 31, 20};
 
 /***********************************************************************
- * Functions for access to DC390 EEPROM
- * and some to emulate it
- *
- **********************************************************************/
-
-
-static void __devinit dc390_EnDisableCE(u8 mode, struct pci_dev *pdev, u8 *regval)
-{
-    u8 bval;
-
-    bval = 0;
-    if(mode == ENABLE_CE)
-	*regval = 0xc0;
-    else
-	*regval = 0x80;
-    pci_write_config_byte(pdev, *regval, bval);
-    if(mode == DISABLE_CE)
-        pci_write_config_byte(pdev, *regval, bval);
-    udelay(160);
-}
-
-
-/* Override EEprom values with explicitly set values */
-static void __devinit dc390_EEprom_Override (u8 index)
-{
-    u8 *ptr = (u8 *) dc390_eepromBuf[index];
-    u8 id;
-    
-    /* Adapter Settings */
-    if (tmscsim[0] != -2)
-	ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0];	/* Adapter ID */
-    if (tmscsim[3] != -2)
-	ptr[EE_MODE2] = (u8)tmscsim[3];
-    if (tmscsim[5] != -2)
-	ptr[EE_DELAY] = tmscsim[5];			/* Reset delay */
-    if (tmscsim[4] != -2)
-	ptr[EE_TAG_CMD_NUM] = (u8)tmscsim[4];	/* Tagged Cmds */
-    
-    /* Device Settings */
-    for (id = 0; id < MAX_SCSI_ID; id++)
-    {
-	if (tmscsim[2] != -2)
-		ptr[id<<2] = (u8)tmscsim[2];		/* EE_MODE1 */
-	if (tmscsim[1] != -2)
-		ptr[(id<<2) + 1] = (u8)tmscsim[1];	/* EE_Speed */
-    }
-}
-
-/* Handle "-1" case */
-static void __devinit dc390_check_for_safe_settings (void)
-{
-	if (tmscsim[0] == -1 || tmscsim[0] > 15) /* modules-2.0.0 passes -1 as string */
-	{
-		tmscsim[0] = 7; tmscsim[1] = 4;
-		tmscsim[2] = 0x09; tmscsim[3] = 0x0f;
-		tmscsim[4] = 2; tmscsim[5] = 10;
-		printk (KERN_INFO "DC390: Using safe settings.\n");
-	}
-}
-
-
-static int __initdata tmscsim_def[] = {7, 0 /* 10MHz */,
-		PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_
-		| SYNC_NEGO_ | TAG_QUEUEING_,
-		MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION
-		/* | NO_SEEK */
-# ifdef CONFIG_SCSI_MULTI_LUN
-		| LUN_CHECK
-# endif
-		, 3 /* 16 Tags per LUN */, 1 /* s delay after Reset */ };
-
-/* Copy defaults over set values where missing */
-static void __devinit dc390_fill_with_defaults (void)
-{
-	int i;
-	PARSEDEBUG(printk(KERN_INFO "DC390: setup %08x %08x %08x %08x %08x %08x\n", tmscsim[0],\
-			  tmscsim[1], tmscsim[2], tmscsim[3], tmscsim[4], tmscsim[5]));
-	for (i = 0; i < 6; i++)
-	{
-		if (tmscsim[i] < 0 || tmscsim[i] > 255)
-			tmscsim[i] = tmscsim_def[i];
-	}
-	/* Sanity checks */
-	if (tmscsim[0] >   7) tmscsim[0] =   7;
-	if (tmscsim[1] >   7) tmscsim[1] =   4;
-	if (tmscsim[4] >   5) tmscsim[4] =   4;
-	if (tmscsim[5] > 180) tmscsim[5] = 180;
-}
-
-#ifndef MODULE
-/* Override defaults on cmdline:
- * tmscsim: AdaptID, MaxSpeed (Index), DevMode (Bitmapped), AdaptMode (Bitmapped)
- */
-static int __init dc390_setup (char *str)
-{	
-	int ints[8];
-	int i, im;
-	(void)get_options (str, ARRAY_SIZE(ints), ints);
-	im = ints[0];
-	if (im > 6)
-	{
-		printk (KERN_NOTICE "DC390: ignore extra params!\n");
-		im = 6;
-	}
-	for (i = 0; i < im; i++)
-		tmscsim[i] = ints[i+1];
-	/* dc390_checkparams (); */
-	return 1;
-}
-
-__setup("tmscsim=", dc390_setup);
-#endif
-
-static void __devinit dc390_EEpromOutDI(struct pci_dev *pdev, u8 *regval, u8 Carry)
-{
-    u8 bval;
-
-    bval = 0;
-    if(Carry)
-    {
-	bval = 0x40;
-	*regval = 0x80;
-	pci_write_config_byte(pdev, *regval, bval);
-    }
-    udelay(160);
-    bval |= 0x80;
-    pci_write_config_byte(pdev, *regval, bval);
-    udelay(160);
-    bval = 0;
-    pci_write_config_byte(pdev, *regval, bval);
-    udelay(160);
-}
-
-
-static u8 __devinit dc390_EEpromInDO(struct pci_dev *pdev)
-{
-    u8 bval;
-
-    pci_write_config_byte(pdev, 0x80, 0x80);
-    udelay(160);
-    pci_write_config_byte(pdev, 0x80, 0x40);
-    udelay(160);
-    pci_read_config_byte(pdev, 0x00, &bval);
-    if(bval == 0x22)
-	return(1);
-    else
-	return(0);
-}
-
-
-static u16 __devinit dc390_EEpromGetData1(struct pci_dev *pdev)
-{
-    u8 i;
-    u8 carryFlag;
-    u16 wval;
-
-    wval = 0;
-    for(i=0; i<16; i++)
-    {
-	wval <<= 1;
-	carryFlag = dc390_EEpromInDO(pdev);
-	wval |= carryFlag;
-    }
-    return(wval);
-}
-
-
-static void __devinit dc390_Prepare(struct pci_dev *pdev, u8 *regval, u8 EEpromCmd)
-{
-    u8 i,j;
-    u8 carryFlag;
-
-    carryFlag = 1;
-    j = 0x80;
-    for(i=0; i<9; i++)
-    {
-	dc390_EEpromOutDI(pdev, regval, carryFlag);
-	carryFlag = (EEpromCmd & j) ? 1 : 0;
-	j >>= 1;
-    }
-}
-
-
-static void __devinit dc390_ReadEEprom(struct pci_dev *pdev, u16 *ptr)
-{
-    u8   regval,cmd;
-    u8   i;
-
-    cmd = EEPROM_READ;
-    for(i=0; i<0x40; i++)
-    {
-	dc390_EnDisableCE(ENABLE_CE, pdev, &regval);
-	dc390_Prepare(pdev, &regval, cmd++);
-	*ptr++ = dc390_EEpromGetData1(pdev);
-	dc390_EnDisableCE(DISABLE_CE, pdev, &regval);
-    }
-}
-
-
-static void __devinit dc390_interpret_delay (u8 index)
-{
-    char interpd [] = {1,3,5,10,16,30,60,120};
-    dc390_eepromBuf[index][EE_DELAY] = interpd [dc390_eepromBuf[index][EE_DELAY]];
-}
-
-static u8 __devinit dc390_CheckEEpromCheckSum(struct pci_dev *pdev, u8 index)
-{
-    u8  i;
-    char  EEbuf[128];
-    u16 wval, *ptr = (u16 *)EEbuf;
-
-    dc390_ReadEEprom(pdev, ptr);
-    memcpy (dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
-    memcpy (&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
-	    &EEbuf[REAL_EE_ADAPT_SCSI_ID], EE_LEN - EE_ADAPT_SCSI_ID);
-    dc390_interpret_delay (index);
-    
-    wval = 0;
-    for(i=0; i<0x40; i++, ptr++)
-	wval += *ptr;
-    return (wval == 0x1234 ? 0 : 1);
-}
-
-
-/***********************************************************************
  * Functions for the management of the internal structures 
  * (DCBs, SRBs, Queueing)
  *
@@ -1185,194 +943,6 @@
 	pDCB->CtrlR1 |= PARITY_ERR_REPO;
 }  
 
-/***********************************************************************
- * Function : static void dc390_initSRB()
- *
- * Purpose :  initialize the internal structures for a given SRB
- *
- * Inputs : psrb - pointer to this scsi request block structure
- ***********************************************************************/
-
-static void __inline__ dc390_initSRB( struct dc390_srb* psrb )
-{
-  /* psrb->PhysSRB = virt_to_phys( psrb ); */
-}
-
-
-static void dc390_linkSRB( struct dc390_acb* pACB )
-{
-    u32   count, i;
-
-    count = pACB->SRBCount;
-    for( i=0; i<count; i++)
-    {
-	if( i != count-1 )
-	    pACB->SRB_array[i].pNextSRB = &pACB->SRB_array[i+1];
-	else
-	    pACB->SRB_array[i].pNextSRB = NULL;
-	dc390_initSRB( &pACB->SRB_array[i] );
-    }
-}
-
-
-/***********************************************************************
- * Function : static void dc390_initACB ()
- *
- * Purpose :  initialize the internal structures for a given SCSI host
- *
- * Inputs : psh - pointer to this host adapter's structure
- *	    io_port, Irq, index: Resources and adapter index
- ***********************************************************************/
-
-static void __devinit dc390_initACB (struct Scsi_Host *psh, unsigned long io_port, u8 Irq, u8 index)
-{
-    struct dc390_acb*    pACB;
-
-    psh->can_queue = MAX_CMD_QUEUE;
-    psh->cmd_per_lun = MAX_CMD_PER_LUN;
-    psh->this_id = (int) dc390_eepromBuf[index][EE_ADAPT_SCSI_ID];
-    psh->io_port = io_port;
-    psh->n_io_port = 0x80;
-    psh->irq = Irq;
-    psh->base = io_port;
-    psh->unique_id = io_port;
-    psh->dma_channel = -1;
-    psh->last_reset = jiffies;
-	
-    pACB = (struct dc390_acb*) psh->hostdata;
-
-    pACB->pScsiHost = psh;
-    pACB->IOPortBase = (u16) io_port;
-    pACB->IRQLevel = Irq;
-
-    DEBUG0(printk (KERN_INFO "DC390: Adapter index %i, ID %i, IO 0x%08x, IRQ 0x%02x\n",	\
-		   index, psh->this_id, (int)io_port, Irq));
-   
-    psh->max_id = 8;
-
-    if( psh->max_id - 1 == dc390_eepromBuf[index][EE_ADAPT_SCSI_ID] )
-	psh->max_id--;
-    psh->max_lun = 1;
-    if( dc390_eepromBuf[index][EE_MODE2] & LUN_CHECK )
-	psh->max_lun = 8;
-
-    pACB->pLinkDCB = NULL;
-    pACB->pDCBRunRobin = NULL;
-    pACB->pActiveDCB = NULL;
-    pACB->pFreeSRB = pACB->SRB_array;
-    pACB->SRBCount = MAX_SRB_CNT;
-    pACB->AdapterIndex = index;
-    pACB->status = 0;
-    pACB->DCBCnt = 0;
-    pACB->TagMaxNum = 2 << dc390_eepromBuf[index][EE_TAG_CMD_NUM];
-    pACB->ACBFlag = 0;
-    pACB->scan_devices = 1;
-    pACB->MsgLen = 0;
-    pACB->Ignore_IRQ = 0;
-    pACB->Gmode2 = dc390_eepromBuf[index][EE_MODE2];
-    dc390_linkSRB( pACB );
-    pACB->pTmpSRB = &pACB->TmpSRB;
-    dc390_initSRB( pACB->pTmpSRB );
-    pACB->sel_timeout = SEL_TIMEOUT;
-    pACB->glitch_cfg = EATER_25NS;
-    pACB->Cmds = pACB->CmdInQ = pACB->CmdOutOfSRB = 0;
-    pACB->SelLost = pACB->SelConn = 0;
-    init_timer (&pACB->Waiting_Timer);
-}
-
-
-/***********************************************************************
- * Function : static int dc390_initAdapter ()
- *
- * Purpose :  initialize the SCSI chip ctrl registers
- *
- * Inputs : psh - pointer to this host adapter's structure
- *	    io_port, Irq, index: Resources
- *
- * Outputs: 0 on success, -1 on error
- ***********************************************************************/
-
-static int __devinit dc390_initAdapter (struct Scsi_Host *psh, unsigned long io_port, u8 Irq, u8 index)
-{
-    struct dc390_acb *pACB, *pACB2;
-    u8  dstate;
-    int    i;
-    
-    pACB = (struct dc390_acb*) psh->hostdata;
-
-    if (request_region (io_port, psh->n_io_port, "tmscsim") == NULL) {
-	printk(KERN_ERR "DC390: register IO ports error!\n");
-	return( -1 );
-    }
-
-    DC390_read8_ (INT_Status, io_port);		/* Reset Pending INT */
-
-    if( (i = request_irq(Irq, do_DC390_Interrupt, DC390_IRQ, "tmscsim", pACB) ))
-      {
-	printk(KERN_ERR "DC390: register IRQ error!\n");
-	release_region (io_port, psh->n_io_port);
-	return( -1 );
-      }
-
-    if( !dc390_pACB_start )
-      {
-	pACB2 = NULL;
-	dc390_pACB_start = pACB;
-	dc390_pACB_current = pACB;
-	pACB->pNextACB = NULL;
-      }
-    else
-      {
-	pACB2 = dc390_pACB_current;
-	dc390_pACB_current->pNextACB = pACB;
-	dc390_pACB_current = pACB;
-	pACB->pNextACB = NULL;
-      }
-
-    DC390_write8 (CtrlReg1, DIS_INT_ON_SCSI_RST | psh->this_id);	/* Disable SCSI bus reset interrupt */
-
-    if (pACB->Gmode2 & RST_SCSI_BUS)
-    {
-	dc390_ResetSCSIBus( pACB );
-	udelay (1000);
-	pACB->pScsiHost->last_reset = jiffies + HZ/2
-		    + HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
-	/*
-	for( i=0; i<(500 + 1000*dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY]); i++ )
-		udelay(1000);
-	 */
-    }
-    pACB->ACBFlag = 0;
-    DC390_read8 (INT_Status);				/* Reset Pending INT */
-    
-    DC390_write8 (Scsi_TimeOut, SEL_TIMEOUT);		/* 250ms selection timeout */
-    DC390_write8 (Clk_Factor, CLK_FREQ_40MHZ);		/* Conversion factor = 0 , 40MHz clock */
-    DC390_write8 (ScsiCmd, NOP_CMD);			/* NOP cmd - clear command register */
-    DC390_write8 (CtrlReg2, EN_FEATURE+EN_SCSI2_CMD);	/* Enable Feature and SCSI-2 */
-    DC390_write8 (CtrlReg3, FAST_CLK);			/* fast clock */
-    DC390_write8 (CtrlReg4, pACB->glitch_cfg |			/* glitch eater */
-		(dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ? NEGATE_REQACKDATA : 0);	/* Negation */
-    DC390_write8 (CtcReg_High, 0);			/* Clear Transfer Count High: ID */
-    DC390_write8 (DMA_Cmd, DMA_IDLE_CMD);
-    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
-    DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
-    dstate = DC390_read8 (DMA_Status);
-    DC390_write8 (DMA_Status, dstate);	/* clear */
-
-    return(0);
-}
-
-
-static void __devinit dc390_set_pci_cfg (struct pci_dev *pdev)
-{
-	u16 cmd;
-
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_IO;
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);
-	pci_write_config_word(pdev, PCI_STATUS, (PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_DETECTED_PARITY));
-}
-
 /**
  * dc390_slave_alloc - Called by the scsi mid layer to tell us about a new
  * scsi device that we need to deal with.
@@ -1505,77 +1075,332 @@
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-static int __devinit dc390_init_one(struct pci_dev *dev,
-				    const struct pci_device_id *id)
+static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cd)
 {
-	struct Scsi_Host *scsi_host;
-	unsigned long io_port;
-	u8 irq;
-	struct dc390_acb*  pACB;
-	int ret = -ENOMEM;
+	u8 carryFlag = 1, j = 0x80, i, bval, regval;
 
-	if (pci_enable_device(dev))
-		return -ENODEV;
+	for (i = 0; i < 9; i++) {
+		if (carryFlag) {
+			bval = 0x40;
+			regval = 0x80;
+		
+			pci_write_config_byte(pdev, regval, bval);
+		} else {
+			bval = 0;
+			regval = 0xc0;
+		}
 
-	io_port = pci_resource_start(dev, 0);
-	irq = dev->irq;
+		udelay(160);
+		pci_write_config_byte(pdev, regval, bval | 0x80);
+		udelay(160);
+		pci_write_config_byte(pdev, regval, 0);
+		udelay(160);
 
-	/* allocate scsi host information (includes out adapter) */
-	scsi_host = scsi_host_alloc(&driver_template, sizeof(struct dc390_acb));
-	if (!scsi_host)
-		goto nomem;
+		carryFlag = (cmd & j) ? 1 : 0;
+		j >>= 1;
+	}
+}
 
-	pACB = (struct dc390_acb*) scsi_host->hostdata;
+static u16 __devinit dc390_eeprom_get_data(struct pci_dev *pdev)
+{
+	u8 wval = 0, bval, i;
+
+	for (i = 0; i < 16; i++) {
+		wval <<= 1;
+
+		pci_write_config_byte(pdev, 0x80, 0x80);
+		udelay(160);
+		pci_write_config_byte(pdev, 0x80, 0x40);
+		udelay(160);
+		pci_read_config_byte(pdev, 0x00, &bval);
+
+		wval |= ((bval == 0x22) ? 1 : 0);
+	}
+
+	return wval;
+}
+
+static void __devinit dc390_read_eeprom(struct pci_dev *pdev, u16 *ptr)
+{
+	u8 cmd = EEPROM_READ, i;
+
+	for (i = 0; i < 0x40; i++) {
+		pci_write_config_byte(pdev, 0xc0, 0);
+		udelay(160);
+
+		dc390_eeprom_prepare_read(pdev, cmd++);
+		*ptr++ = dc390_eeprom_get_data(pdev);
+
+		pci_write_config_byte(pdev, 0x80, 0);
+		pci_write_config_byte(pdev, 0x80, 0);
+		udelay(160);
+	}
+}
+
+/* Override EEprom values with explicitly set values */
+static void __devinit dc390_eeprom_override(u8 index)
+{
+	u8 *ptr = (u8 *) dc390_eepromBuf[index], id;
+    
+	/* Adapter Settings */
+	if (tmscsim[0] != -2)
+		ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0];	/* Adapter ID */
+	if (tmscsim[3] != -2)
+		ptr[EE_MODE2] = (u8)tmscsim[3];
+	if (tmscsim[5] != -2)
+		ptr[EE_DELAY] = tmscsim[5];		/* Reset delay */
+	if (tmscsim[4] != -2)
+		ptr[EE_TAG_CMD_NUM] = (u8)tmscsim[4];	/* Tagged Cmds */
+    
+	/* Device Settings */
+	for (id = 0; id < MAX_SCSI_ID; id++) {
+		if (tmscsim[2] != -2)
+			ptr[id<<2] = (u8)tmscsim[2];	/* EE_MODE1 */
+		if (tmscsim[1] != -2)
+			ptr[(id<<2) + 1] = (u8)tmscsim[1];/* EE_Speed */
+	}
+}
+
+static int __devinitdata tmscsim_def[] = {
+	7,
+	0 /* 10MHz */,
+	PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_ | SYNC_NEGO_ | TAG_QUEUEING_,
+	MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION | LUN_CHECK,
+	3 /* 16 Tags per LUN */,
+	1 /* s delay after Reset */,
+};
+
+/* Copy defaults over set values where missing */
+static void __devinit dc390_fill_with_defaults (void)
+{
+
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		if (tmscsim[i] < 0 || tmscsim[i] > 255)
+			tmscsim[i] = tmscsim_def[i];
+	}
+
+	/* Sanity checks */
+	if (tmscsim[0] >  7)
+		tmscsim[0] = 7;
+	if (tmscsim[1] >  7)
+		tmscsim[1] = 4;
+	if (tmscsim[4] > 5)
+		tmscsim[4] = 4;
+	if (tmscsim[5] > 180)
+		tmscsim[5] = 180;
+}
+
+static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 index)
+{
+	char interpd[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
+	char EEbuf[128];
+	u16 *ptr = (u16 *)EEbuf, wval = 0;
+	u8  i;
+
+	dc390_read_eeprom(pdev, ptr);
+	memcpy(dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
+	memcpy(&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
+	       &EEbuf[REAL_EE_ADAPT_SCSI_ID],
+	       EE_LEN - EE_ADAPT_SCSI_ID);
+
+	dc390_eepromBuf[index][EE_DELAY] =
+		interpd[dc390_eepromBuf[index][EE_DELAY]];
+ 
+	for (i = 0; i < 0x40; i++, ptr++)
+		wval += *ptr;
 
-	if (dc390_CheckEEpromCheckSum (dev, dc390_adapterCnt)) {
+	/* no Tekram EEprom found */
+	if (wval != 0x1234) {
 		int speed;
-		dc390_adapname = "AM53C974";
-		printk(KERN_INFO "DC390_init: No EEPROM found! Trying default settings ...\n");
-		dc390_check_for_safe_settings();
+
+		printk(KERN_INFO "DC390_init: No EEPROM found! "
+				"Trying default settings ...\n");
+
+		/*
+		 * XXX(hch): bogus, because we might have tekram and
+		 *           non-tekram hbas in a single machine.
+		 */
 		dc390_fill_with_defaults();
-		dc390_EEprom_Override(dc390_adapterCnt);
+
 		speed = dc390_clock_speed[tmscsim[1]];
-		printk(KERN_INFO "DC390: Used defaults: AdaptID=%i, SpeedIdx=%i (%i.%i MHz),"
-		       " DevMode=0x%02x, AdaptMode=0x%02x, TaggedCmnds=%i (%i), DelayReset=%is\n", 
+		printk(KERN_INFO "DC390: Used defaults: AdaptID=%i, "
+				"SpeedIdx=%i (%i.%i MHz),"
+				" DevMode=0x%02x, AdaptMode=0x%02x, "
+				"TaggedCmnds=%i (%i), DelayReset=%is\n", 
 		       tmscsim[0], tmscsim[1], speed/10, speed%10,
-		       (u8)tmscsim[2], (u8)tmscsim[3], tmscsim[4], 2 << (tmscsim[4]), tmscsim[5]);
-	} else {
-		dc390_check_for_safe_settings();
-		dc390_EEprom_Override(dc390_adapterCnt);
+		       (u8)tmscsim[2], (u8)tmscsim[3], tmscsim[4],
+		       2 << (tmscsim[4]), tmscsim[5]);
 	}
+}
 
-	DEBUG0(printk(KERN_INFO "DC390: pSH = %8x, Index %02i\n", (u32) scsi_host, dc390_adapterCnt));
+static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
+{
+	struct Scsi_Host *shost = pACB->pScsiHost;
+	u8 dstate;
+
+	/* Disable SCSI bus reset interrupt */
+	DC390_write8(CtrlReg1, DIS_INT_ON_SCSI_RST | shost->this_id);
+
+	if (pACB->Gmode2 & RST_SCSI_BUS) {
+		dc390_ResetSCSIBus(pACB);
+		udelay(1000);
+		shost->last_reset = jiffies + HZ/2 +
+			HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
+	}
 
-	dc390_initACB(scsi_host, io_port, irq, dc390_adapterCnt);
+	pACB->ACBFlag = 0;
 
-	pACB->pdev = dev;
+	/* Reset Pending INT */
+	DC390_read8(INT_Status);
+	
+	/* 250ms selection timeout */
+	DC390_write8(Scsi_TimeOut, SEL_TIMEOUT);
+	
+	/* Conversion factor = 0 , 40MHz clock */
+	DC390_write8(Clk_Factor, CLK_FREQ_40MHZ);
+	
+	/* NOP cmd - clear command register */
+	DC390_write8(ScsiCmd, NOP_CMD);
+	
+	/* Enable Feature and SCSI-2 */
+	DC390_write8(CtrlReg2, EN_FEATURE+EN_SCSI2_CMD);
+	
+	/* Fast clock */
+	DC390_write8(CtrlReg3, FAST_CLK);
 
-	if (dc390_initAdapter(scsi_host, io_port, irq, dc390_adapterCnt)) {
-		scsi_unregister(scsi_host);
-		ret = -EBUSY;
-		goto busy;
+	/* Negation */
+	DC390_write8(CtrlReg4, pACB->glitch_cfg | /* glitch eater */
+		(dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
+		 NEGATE_REQACKDATA : 0);
+	
+	/* Clear Transfer Count High: ID */
+	DC390_write8(CtcReg_High, 0);
+	DC390_write8(DMA_Cmd, DMA_IDLE_CMD);
+	DC390_write8(ScsiCmd, CLEAR_FIFO_CMD);
+	DC390_write32(DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
+
+	dstate = DC390_read8(DMA_Status);
+	DC390_write8(DMA_Status, dstate);
+}
+
+static int __devinit dc390_probe_one(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
+{
+	struct dc390_acb *pACB, *pACB2;
+	struct Scsi_Host *shost;
+	unsigned long io_port;
+	int error = -ENODEV, i;
+
+	if (pci_enable_device(pdev))
+		goto out;
+
+	pci_set_master(pdev);
+
+	error = -ENOMEM;
+	shost = scsi_host_alloc(&driver_template, sizeof(struct dc390_acb));
+	if (!shost)
+		goto out_disable_device;
+
+	pACB = (struct dc390_acb *)shost->hostdata;
+	memset(pACB, 0, sizeof(struct dc390_acb));
+
+	dc390_check_eeprom(pdev, dc390_adapterCnt);
+	dc390_eeprom_override(dc390_adapterCnt);
+
+	io_port = pci_resource_start(pdev, 0);
+
+	shost->can_queue = MAX_CMD_QUEUE;
+	shost->cmd_per_lun = MAX_CMD_PER_LUN;
+	shost->this_id = dc390_eepromBuf[dc390_adapterCnt][EE_ADAPT_SCSI_ID];
+	shost->io_port = io_port;
+	shost->n_io_port = 0x80;
+	shost->irq = pdev->irq;
+	shost->base = io_port;
+	shost->unique_id = io_port;
+	shost->last_reset = jiffies;
+	
+	pACB->pScsiHost = shost;
+	pACB->IOPortBase = (u16) io_port;
+	pACB->IRQLevel = pdev->irq;
+	
+	shost->max_id = 8;
+
+	if (shost->max_id - 1 ==
+	    dc390_eepromBuf[dc390_adapterCnt][EE_ADAPT_SCSI_ID])
+		shost->max_id--;
+
+	if (dc390_eepromBuf[dc390_adapterCnt][EE_MODE2] & LUN_CHECK)
+		shost->max_lun = 8;
+	else
+		shost->max_lun = 1;
+
+	pACB->pFreeSRB = pACB->SRB_array;
+	pACB->SRBCount = MAX_SRB_CNT;
+	pACB->AdapterIndex = dc390_adapterCnt;
+	pACB->TagMaxNum =
+		2 << dc390_eepromBuf[dc390_adapterCnt][EE_TAG_CMD_NUM];
+	pACB->Gmode2 = dc390_eepromBuf[dc390_adapterCnt][EE_MODE2];
+
+	for (i = 0; i < pACB->SRBCount-1; i++)
+		pACB->SRB_array[i].pNextSRB = &pACB->SRB_array[i+1];
+	pACB->SRB_array[pACB->SRBCount-1].pNextSRB = NULL;
+	pACB->pTmpSRB = &pACB->TmpSRB;
+
+	pACB->sel_timeout = SEL_TIMEOUT;
+	pACB->glitch_cfg = EATER_25NS;
+	pACB->pdev = pdev;
+	init_timer(&pACB->Waiting_Timer);
+
+	if (!request_region(io_port, shost->n_io_port, "tmscsim")) {
+		printk(KERN_ERR "DC390: register IO ports error!\n");
+		goto out_host_put;
 	}
 
-	pci_set_master(dev);
-	dc390_set_pci_cfg(dev);
-	dc390_adapterCnt++;
+	/* Reset Pending INT */
+	DC390_read8_(INT_Status, io_port);
 
-	/* get the scsi mid level to scan for new devices on the bus */
-	if (scsi_add_host(scsi_host, &dev->dev)) {
-		ret = -ENODEV;
-		goto nodev;
+	if (request_irq(pdev->irq, do_DC390_Interrupt, SA_SHIRQ,
+				"tmscsim", pACB)) {
+		printk(KERN_ERR "DC390: register IRQ error!\n");
+		goto out_release_region;
 	}
-	pci_set_drvdata(dev, scsi_host);
-	scsi_scan_host(scsi_host);
 
+	if (!dc390_pACB_start) {
+		pACB2 = NULL;
+		dc390_pACB_start = pACB;
+		dc390_pACB_current = pACB;
+		pACB->pNextACB = NULL;
+	} else {
+		pACB2 = dc390_pACB_current;
+		dc390_pACB_current->pNextACB = pACB;
+		dc390_pACB_current = pACB;
+		pACB->pNextACB = NULL;
+	}
+
+	dc390_init_hw(pACB, dc390_adapterCnt);
+	
+	dc390_adapterCnt++;
+
+	pci_set_drvdata(pdev, shost);
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_free_irq;
+	scsi_scan_host(shost);
 	return 0;
 
-nodev:
-busy:
-	scsi_host_put(scsi_host);
-nomem:
-	pci_disable_device(dev);
-	return ret;
+ out_free_irq:
+	free_irq(pdev->irq, pACB);
+ out_release_region:
+	release_region(io_port, shost->n_io_port);
+ out_host_put:
+	scsi_host_put(shost);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return error;
 }
 
 /**
@@ -1610,15 +1435,32 @@
 	pci_set_drvdata(dev, NULL);
 }
 
+static struct pci_device_id tmscsim_pci_tbl[] = {
+	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
+
 static struct pci_driver dc390_driver = {
 	.name           = "tmscsim",
 	.id_table       = tmscsim_pci_tbl,
-	.probe          = dc390_init_one,
+	.probe          = dc390_probe_one,
 	.remove         = __devexit_p(dc390_remove_one),
 };
 
 static int __init dc390_module_init(void)
 {
+	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
+		tmscsim[0] = 7;
+		tmscsim[1] = 4;
+		tmscsim[2] = 0x09;
+		tmscsim[3] = 0x0f;
+		tmscsim[4] = 2;
+		tmscsim[5] = 10;
+		printk(KERN_INFO "DC390: Using safe settings.\n");
+	}
+
 	return pci_module_init(&dc390_driver);
 }
 
@@ -1629,3 +1471,25 @@
 
 module_init(dc390_module_init);
 module_exit(dc390_module_exit);
+
+#ifndef MODULE
+static int __init dc390_setup (char *str)
+{	
+	int ints[8],i, im;
+
+	get_options(str, ARRAY_SIZE(ints), ints);
+	im = ints[0];
+
+	if (im > 6) {
+		printk (KERN_NOTICE "DC390: ignore extra params!\n");
+		im = 6;
+	}
+
+	for (i = 0; i < im; i++)
+		tmscsim[i] = ints[i+1];
+	/* dc390_checkparams (); */
+	return 1;
+}
+
+__setup("tmscsim=", dc390_setup);
+#endif
