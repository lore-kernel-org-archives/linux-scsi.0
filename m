From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tmscsim: back out bogus eeprom reading changes
Date: Tue, 28 Sep 2004 16:22:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928142251.GA9334@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52666 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267851AbUI1OWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:22:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.52/drivers/scsi/tmscsim.c	2004-08-18 00:51:27 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-09-26 19:09:46 +02:00
@@ -989,164 +989,204 @@
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cmd)
+/***********************************************************************
+ * Functions for access to DC390 EEPROM
+ * and some to emulate it
+ *
+ **********************************************************************/
+
+
+static void __devinit dc390_EnDisableCE(u8 mode, struct pci_dev *pdev, u8 *regval)
 {
-	u8 carryFlag = 1, j = 0x80, i, bval, regval;
+    u8 bval;
 
-	for (i = 0; i < 9; i++) {
-		if (carryFlag) {
-			bval = 0x40;
-			regval = 0x80;
-		
-			pci_write_config_byte(pdev, regval, bval);
-		} else {
-			bval = 0;
-			regval = 0xc0;
-		}
-
-		udelay(160);
-		pci_write_config_byte(pdev, regval, bval | 0x80);
-		udelay(160);
-		pci_write_config_byte(pdev, regval, 0);
-		udelay(160);
+    bval = 0;
+    if(mode == ENABLE_CE)
+	*regval = 0xc0;
+    else
+	*regval = 0x80;
+    pci_write_config_byte(pdev, *regval, bval);
+    if(mode == DISABLE_CE)
+        pci_write_config_byte(pdev, *regval, bval);
+    udelay(160);
+}
 
-		carryFlag = (cmd & j) ? 1 : 0;
-		j >>= 1;
-	}
+
+/* Override EEprom values with explicitly set values */
+static void __devinit dc390_EEprom_Override (u8 index)
+{
+    u8 *ptr = (u8 *) dc390_eepromBuf[index];
+    u8 id;
+    
+    /* Adapter Settings */
+    if (tmscsim[0] != -2)
+	ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0];	/* Adapter ID */
+    if (tmscsim[3] != -2)
+	ptr[EE_MODE2] = (u8)tmscsim[3];
+    if (tmscsim[5] != -2)
+	ptr[EE_DELAY] = tmscsim[5];			/* Reset delay */
+    if (tmscsim[4] != -2)
+	ptr[EE_TAG_CMD_NUM] = (u8)tmscsim[4];	/* Tagged Cmds */
+    
+    /* Device Settings */
+    for (id = 0; id < MAX_SCSI_ID; id++)
+    {
+	if (tmscsim[2] != -2)
+		ptr[id<<2] = (u8)tmscsim[2];		/* EE_MODE1 */
+	if (tmscsim[1] != -2)
+		ptr[(id<<2) + 1] = (u8)tmscsim[1];	/* EE_Speed */
+    }
 }
 
-static u16 __devinit dc390_eeprom_get_data(struct pci_dev *pdev)
+/* Handle "-1" case */
+static void __devinit dc390_check_for_safe_settings (void)
 {
-	u8 wval = 0, bval, i;
+	if (tmscsim[0] == -1 || tmscsim[0] > 15) /* modules-2.0.0 passes -1 as string */
+	{
+		tmscsim[0] = 7; tmscsim[1] = 4;
+		tmscsim[2] = 0x09; tmscsim[3] = 0x0f;
+		tmscsim[4] = 2; tmscsim[5] = 10;
+		printk (KERN_INFO "DC390: Using safe settings.\n");
+	}
+}
 
-	for (i = 0; i < 16; i++) {
-		wval <<= 1;
 
-		pci_write_config_byte(pdev, 0x80, 0x80);
-		udelay(160);
-		pci_write_config_byte(pdev, 0x80, 0x40);
-		udelay(160);
-		pci_read_config_byte(pdev, 0x00, &bval);
+static int __initdata tmscsim_def[] = {7, 0 /* 10MHz */,
+		PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_
+		| SYNC_NEGO_ | TAG_QUEUEING_,
+		MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION
+		/* | NO_SEEK */
+# ifdef CONFIG_SCSI_MULTI_LUN
+		| LUN_CHECK
+# endif
+		, 3 /* 16 Tags per LUN */, 1 /* s delay after Reset */ };
 
-		wval |= ((bval == 0x22) ? 1 : 0);
+/* Copy defaults over set values where missing */
+static void __devinit dc390_fill_with_defaults (void)
+{
+	int i;
+	PARSEDEBUG(printk(KERN_INFO "DC390: setup %08x %08x %08x %08x %08x %08x\n", tmscsim[0],\
+			  tmscsim[1], tmscsim[2], tmscsim[3], tmscsim[4], tmscsim[5]));
+	for (i = 0; i < 6; i++)
+	{
+		if (tmscsim[i] < 0 || tmscsim[i] > 255)
+			tmscsim[i] = tmscsim_def[i];
 	}
-
-	return wval;
+	/* Sanity checks */
+	if (tmscsim[0] >   7) tmscsim[0] =   7;
+	if (tmscsim[1] >   7) tmscsim[1] =   4;
+	if (tmscsim[4] >   5) tmscsim[4] =   4;
+	if (tmscsim[5] > 180) tmscsim[5] = 180;
 }
 
-static void __devinit dc390_read_eeprom(struct pci_dev *pdev, u16 *ptr)
+static void __devinit dc390_EEpromOutDI(struct pci_dev *pdev, u8 *regval, u8 Carry)
 {
-	u8 cmd = EEPROM_READ, i;
+    u8 bval;
 
-	for (i = 0; i < 0x40; i++) {
-		pci_write_config_byte(pdev, 0xc0, 0);
-		udelay(160);
+    bval = 0;
+    if(Carry)
+    {
+	bval = 0x40;
+	*regval = 0x80;
+	pci_write_config_byte(pdev, *regval, bval);
+    }
+    udelay(160);
+    bval |= 0x80;
+    pci_write_config_byte(pdev, *regval, bval);
+    udelay(160);
+    bval = 0;
+    pci_write_config_byte(pdev, *regval, bval);
+    udelay(160);
+}
 
-		dc390_eeprom_prepare_read(pdev, cmd++);
-		*ptr++ = dc390_eeprom_get_data(pdev);
 
-		pci_write_config_byte(pdev, 0x80, 0);
-		pci_write_config_byte(pdev, 0x80, 0);
-		udelay(160);
-	}
+static u8 __devinit dc390_EEpromInDO(struct pci_dev *pdev)
+{
+    u8 bval;
+
+    pci_write_config_byte(pdev, 0x80, 0x80);
+    udelay(160);
+    pci_write_config_byte(pdev, 0x80, 0x40);
+    udelay(160);
+    pci_read_config_byte(pdev, 0x00, &bval);
+    if(bval == 0x22)
+	return(1);
+    else
+	return(0);
 }
 
-/* Override EEprom values with explicitly set values */
-static void __devinit dc390_eeprom_override(u8 index)
+
+static u16 __devinit dc390_EEpromGetData1(struct pci_dev *pdev)
 {
-	u8 *ptr = (u8 *) dc390_eepromBuf[index], id;
-    
-	/* Adapter Settings */
-	if (tmscsim[0] != -2)
-		ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0];	/* Adapter ID */
-	if (tmscsim[3] != -2)
-		ptr[EE_MODE2] = (u8)tmscsim[3];
-	if (tmscsim[5] != -2)
-		ptr[EE_DELAY] = tmscsim[5];		/* Reset delay */
-	if (tmscsim[4] != -2)
-		ptr[EE_TAG_CMD_NUM] = (u8)tmscsim[4];	/* Tagged Cmds */
-    
-	/* Device Settings */
-	for (id = 0; id < MAX_SCSI_ID; id++) {
-		if (tmscsim[2] != -2)
-			ptr[id<<2] = (u8)tmscsim[2];	/* EE_MODE1 */
-		if (tmscsim[1] != -2)
-			ptr[(id<<2) + 1] = (u8)tmscsim[1];/* EE_Speed */
-	}
+    u8 i;
+    u8 carryFlag;
+    u16 wval;
+
+    wval = 0;
+    for(i=0; i<16; i++)
+    {
+	wval <<= 1;
+	carryFlag = dc390_EEpromInDO(pdev);
+	wval |= carryFlag;
+    }
+    return(wval);
 }
 
-static int __devinitdata tmscsim_def[] = {
-	7,
-	0 /* 10MHz */,
-	PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_ | SYNC_NEGO_ | TAG_QUEUEING_,
-	MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION | LUN_CHECK,
-	3 /* 16 Tags per LUN */,
-	1 /* s delay after Reset */,
-};
 
-/* Copy defaults over set values where missing */
-static void __devinit dc390_fill_with_defaults (void)
+static void __devinit dc390_Prepare(struct pci_dev *pdev, u8 *regval, u8 EEpromCmd)
 {
+    u8 i,j;
+    u8 carryFlag;
 
-	int i;
+    carryFlag = 1;
+    j = 0x80;
+    for(i=0; i<9; i++)
+    {
+	dc390_EEpromOutDI(pdev, regval, carryFlag);
+	carryFlag = (EEpromCmd & j) ? 1 : 0;
+	j >>= 1;
+    }
+}
 
-	for (i = 0; i < 6; i++) {
-		if (tmscsim[i] < 0 || tmscsim[i] > 255)
-			tmscsim[i] = tmscsim_def[i];
-	}
 
-	/* Sanity checks */
-	if (tmscsim[0] >  7)
-		tmscsim[0] = 7;
-	if (tmscsim[1] >  7)
-		tmscsim[1] = 4;
-	if (tmscsim[4] > 5)
-		tmscsim[4] = 4;
-	if (tmscsim[5] > 180)
-		tmscsim[5] = 180;
-}
-
-static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 index)
-{
-	char interpd[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
-	char EEbuf[128];
-	u16 *ptr = (u16 *)EEbuf, wval = 0;
-	u8  i;
-
-	dc390_read_eeprom(pdev, ptr);
-	memcpy(dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
-	memcpy(&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
-	       &EEbuf[REAL_EE_ADAPT_SCSI_ID],
-	       EE_LEN - EE_ADAPT_SCSI_ID);
-
-	dc390_eepromBuf[index][EE_DELAY] =
-		interpd[dc390_eepromBuf[index][EE_DELAY]];
- 
-	for (i = 0; i < 0x40; i++, ptr++)
-		wval += *ptr;
+static void __devinit dc390_ReadEEprom(struct pci_dev *pdev, u16 *ptr)
+{
+    u8   regval,cmd;
+    u8   i;
 
-	/* no Tekram EEprom found */
-	if (wval != 0x1234) {
-		int speed;
+    cmd = EEPROM_READ;
+    for(i=0; i<0x40; i++)
+    {
+	dc390_EnDisableCE(ENABLE_CE, pdev, &regval);
+	dc390_Prepare(pdev, &regval, cmd++);
+	*ptr++ = dc390_EEpromGetData1(pdev);
+	dc390_EnDisableCE(DISABLE_CE, pdev, &regval);
+    }
+}
 
-		printk(KERN_INFO "DC390_init: No EEPROM found! "
-				"Trying default settings ...\n");
 
-		/*
-		 * XXX(hch): bogus, because we might have tekram and
-		 *           non-tekram hbas in a single machine.
-		 */
-		dc390_fill_with_defaults();
+static void __devinit dc390_interpret_delay (u8 index)
+{
+    char interpd [] = {1,3,5,10,16,30,60,120};
+    dc390_eepromBuf[index][EE_DELAY] = interpd [dc390_eepromBuf[index][EE_DELAY]];
+}
 
-		speed = dc390_clock_speed[tmscsim[1]];
-		printk(KERN_INFO "DC390: Used defaults: AdaptID=%i, "
-				"SpeedIdx=%i (%i.%i MHz),"
-				" DevMode=0x%02x, AdaptMode=0x%02x, "
-				"TaggedCmnds=%i (%i), DelayReset=%is\n", 
-		       tmscsim[0], tmscsim[1], speed/10, speed%10,
-		       (u8)tmscsim[2], (u8)tmscsim[3], tmscsim[4],
-		       2 << (tmscsim[4]), tmscsim[5]);
-	}
+static u8 __devinit dc390_CheckEEpromCheckSum(struct pci_dev *pdev, u8 index)
+{
+    u8  i;
+    char  EEbuf[128];
+    u16 wval, *ptr = (u16 *)EEbuf;
+
+    dc390_ReadEEprom(pdev, ptr);
+    memcpy (dc390_eepromBuf[index], EEbuf, EE_ADAPT_SCSI_ID);
+    memcpy (&dc390_eepromBuf[index][EE_ADAPT_SCSI_ID], 
+	    &EEbuf[REAL_EE_ADAPT_SCSI_ID], EE_LEN - EE_ADAPT_SCSI_ID);
+    dc390_interpret_delay (index);
+    
+    wval = 0;
+    for(i=0; i<0x40; i++, ptr++)
+	wval += *ptr;
+    return (wval == 0x1234 ? 0 : 1);
 }
 
 static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
@@ -1220,8 +1260,21 @@
 	pACB = (struct dc390_acb *)shost->hostdata;
 	memset(pACB, 0, sizeof(struct dc390_acb));
 
-	dc390_check_eeprom(pdev, dc390_adapterCnt);
-	dc390_eeprom_override(dc390_adapterCnt);
+	if (dc390_CheckEEpromCheckSum(pdev, dc390_adapterCnt)) {
+		int speed;
+		printk(KERN_INFO "DC390_init: No EEPROM found! Trying default settings ...\n");
+		dc390_check_for_safe_settings();
+		dc390_fill_with_defaults();
+		dc390_EEprom_Override(dc390_adapterCnt);
+		speed = dc390_clock_speed[tmscsim[1]];
+		printk(KERN_INFO "DC390: Used defaults: AdaptID=%i, SpeedIdx=%i (%i.%i MHz),"
+		       " DevMode=0x%02x, AdaptMode=0x%02x, TaggedCmnds=%i (%i), DelayReset=%is\n", 
+		       tmscsim[0], tmscsim[1], speed/10, speed%10,
+		       (u8)tmscsim[2], (u8)tmscsim[3], tmscsim[4], 2 << (tmscsim[4]), tmscsim[5]);
+	} else {
+		dc390_check_for_safe_settings();
+		dc390_EEprom_Override(dc390_adapterCnt);
+	}
 
 	io_port = pci_resource_start(pdev, 0);
 
