From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix check_region usage in eata_pio
Date: Mon, 31 May 2004 14:00:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531120010.GA16293@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:39852 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264312AbUEaMAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 08:00:13 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

I'd love to rework the init sequence a bit more, but without beeing able
to actually test the driver I'd rather stick to the bulletproof fix.


--- 1.21/drivers/scsi/eata_pio.c	2003-08-16 16:01:30 +02:00
+++ edited/drivers/scsi/eata_pio.c	2004-05-31 13:30:48 +02:00
@@ -593,14 +593,14 @@
 	int z;
 	unsigned short *p;
 
-	if (check_region(base, 9))
-		return (FALSE);
+	if (!request_region(base, 8, "eata_pio"))
+		return 0;
 
 	memset(buf, 0, sizeof(struct get_conf));
 
 	while (inb(base + HA_RSTATUS) & HA_SBUSY)
 		if (--loop == 0)
-			return (FALSE);
+			goto fail;
 
 	DBG(DBG_PIO && DBG_PROBE, printk(KERN_DEBUG "Issuing PIO READ CONFIG to HBA at %#x\n", base));
 	eata_pio_send_command(base, EATA_CMD_PIO_READ_CONFIG);
@@ -609,30 +609,40 @@
 	for (p = (unsigned short *) buf; (long) p <= ((long) buf + (sizeof(struct get_conf) / 2)); p++) {
 		while (!(inb(base + HA_RSTATUS) & HA_SDRQ))
 			if (--loop == 0)
-				return (FALSE);
+				goto fail;
 
 		loop = HZ / 2;
 		*p = inw(base + HA_RDATA);
 	}
-	if (!(inb(base + HA_RSTATUS) & HA_SERROR)) {	/* Error ? */
-		if (htonl(EATA_SIGNATURE) == buf->signature) {
-			DBG(DBG_PIO && DBG_PROBE, printk(KERN_NOTICE "EATA Controller found " "at %#4x EATA Level: %x\n", base, (uint) (buf->version)));
-
-			while (inb(base + HA_RSTATUS) & HA_SDRQ)
-				inw(base + HA_RDATA);
-			if (ALLOW_DMA_BOARDS == FALSE) {
-				for (z = 0; z < MAXISA; z++)
-					if (base == ISAbases[z]) {
-						buf->IRQ = ISAirqs[z];
-						break;
-					}
+	if (inb(base + HA_RSTATUS) & HA_SERROR) {
+		DBG(DBG_PROBE, printk("eata_dma: get_conf_PIO, error during "
+					"transfer for HBA at %x\n", base));
+		goto fail;
+	}
+
+	if (htonl(EATA_SIGNATURE) != buf->signature)
+		goto fail;
+
+	DBG(DBG_PIO && DBG_PROBE, printk(KERN_NOTICE "EATA Controller found "
+				"at %#4x EATA Level: %x\n",
+				base, (uint) (buf->version)));
+
+	while (inb(base + HA_RSTATUS) & HA_SDRQ)
+		inw(base + HA_RDATA);
+
+	if (ALLOW_DMA_BOARDS == FALSE) {
+		for (z = 0; z < MAXISA; z++)
+			if (base == ISAbases[z]) {
+				buf->IRQ = ISAirqs[z];
+				break;
 			}
-			return (TRUE);
-		}
-	} else {
-		DBG(DBG_PROBE, printk("eata_dma: get_conf_PIO, error during transfer " "for HBA at %x\n", base));
 	}
-	return (FALSE);
+
+	return 1;
+
+ fail:
+	release_region(base, 8);
+	return 0;
 }
 
 static void print_pio_config(struct get_conf *gc)
@@ -689,23 +699,19 @@
 
 	if ((buff = get_pio_board_data((uint) base, gc->IRQ, gc->scsi_id[3], cplen = (htonl(gc->cplen) + 1) / 2, cppadlen = (htons(gc->cppadlen) + 1) / 2)) == NULL) {
 		printk("HBA at %#lx didn't react on INQUIRY. Sorry.\n", (unsigned long) base);
-		return (FALSE);
+		return 0;
 	}
 
 	if (print_selftest(base) == FALSE && ALLOW_DMA_BOARDS == FALSE) {
 		printk("HBA at %#lx failed while performing self test & setup.\n", (unsigned long) base);
-		return (FALSE);
+		return 0;
 	}
 
-	request_region(base, 8, "eata_pio");
-
 	size = sizeof(hostdata) + (sizeof(struct eata_ccb) * ntohs(gc->queuesiz));
 
 	sh = scsi_register(tpnt, size);
-	if (sh == NULL) {
-		release_region(base, 8);
-		return FALSE;
-	}
+	if (sh == NULL)
+		return 0;
 
 	if (!reg_IRQ[gc->IRQ]) {	/* Interrupt already registered ? */
 		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, SA_INTERRUPT, "EATA-PIO", sh)) {
@@ -714,14 +720,12 @@
 				reg_IRQL[gc->IRQ] = TRUE;	/* IRQ is edge triggered */
 		} else {
 			printk("Couldn't allocate IRQ %d, Sorry.\n", gc->IRQ);
-			release_region(base, 8);
-			return (FALSE);
+			return 0;
 		}
 	} else {		/* More than one HBA on this IRQ */
 		if (reg_IRQL[gc->IRQ] == TRUE) {
 			printk("Can't support more than one HBA on this IRQ,\n" "  if the IRQ is edge triggered. Sorry.\n");
-			release_region(base, 8);
-			return (FALSE);
+			return 0;
 		} else
 			reg_IRQ[gc->IRQ]++;
 	}
@@ -816,12 +820,14 @@
 	int i;
 
 	for (i = 0; i < MAXISA; i++) {
-		if (ISAbases[i]) {
-			if (get_pio_conf_PIO(ISAbases[i], buf) == TRUE) {
-				register_pio_HBA(ISAbases[i], buf, tpnt);
-			}
+		if (!ISAbases[i])
+			continue;
+		if (!get_pio_conf_PIO(ISAbases[i], buf))
+			continue;
+		if (!register_pio_HBA(ISAbases[i], buf, tpnt))
+			release_region(ISAbases[i], 8);
+		else
 			ISAbases[i] = 0;
-		}
 	}
 	return;
 }
@@ -847,12 +853,15 @@
 			if (((pal1 == 0x12) && (pal2 == 0x14)) || ((pal1 == 0x38) && (pal2 == 0xa3) && (pal3 == 0x82)) || ((pal1 == 0x06) && (pal2 == 0x94) && (pal3 == 0x24))) {
 				DBG(DBG_PROBE, printk(KERN_NOTICE "EISA EATA id tags found: " "%x %x %x \n", (int) pal1, (int) pal2, (int) pal3));
 #endif
-				if (get_pio_conf_PIO(base, buf) == TRUE) {
+				if (get_pio_conf_PIO(base, buf)) {
 					DBG(DBG_PROBE && DBG_EISA, print_pio_config(buf));
 					if (buf->IRQ) {
-						register_pio_HBA(base, buf, tpnt);
-					} else
+						if (!register_pio_HBA(base, buf, tpnt))
+							release_region(base, 8);
+					} else {
 						printk(KERN_NOTICE "eata_dma: No valid IRQ. HBA " "removed from list\n");
+						release_region(base, 8);
+					}
 				}
 				/* Nothing found here so we take it from the list */
 				EISAbases[i] = 0;
@@ -889,16 +898,21 @@
 		base += 0x10;	/* Now, THIS is the real address */
 		if (base != 0x1f8) {
 			/* We didn't find it in the primary search */
-			if (get_pio_conf_PIO(base, buf) == TRUE) {
-				if (buf->FORCADR)	/* If the address is forced */
+			if (get_pio_conf_PIO(base, buf)) {
+				if (buf->FORCADR) {	/* If the address is forced */
+					release_region(base, 8);
 					continue;	/* we'll find it later      */
+				}
 
 				/* OK. We made it till here, so we can go now  
 				 * and register it. We  only have to check and 
 				 * eventually remove it from the EISA and ISA list 
 				 */
 
-				register_pio_HBA(base, buf, tpnt);
+				if (!register_pio_HBA(base, buf, tpnt)) {
+					release_region(base, 8);
+					continue;
+				}
 
 				if (base < 0x1000) {
 					for (x = 0; x < MAXISA; ++x) {
