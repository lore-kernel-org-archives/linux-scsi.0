From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] Fix endianity in A100U2W SCSI driver
Date: Tue, 15 Jul 2008 10:11:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYGOOLb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 10:11:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

(sending to Linus, because there's no maintainer for this driver)

Support big endian systems.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
  drivers/scsi/a100u2w.c |   36 ++++++++++++++++++------------------
  1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.26-rc8/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/scsi/a100u2w.c	2008-06-25 03:58:20.000000000 +0200
+++ linux-2.6.26-rc8/drivers/scsi/a100u2w.c	2008-07-01 18:51:20.000000000 +0200
@@ -389,7 +389,7 @@ static u8 orc_load_firmware(struct orc_h

  	outb(PRGMRST | DOWNLOAD, host->base + ORC_RISCCTL);	/* Enable SRAM programming */
  	data32_ptr = (u8 *) & data32;
-	data32 = 0;		/* Initial FW address to 0 */
+	data32 = cpu_to_le32(0);		/* Initial FW address to 0 */
  	outw(0x0010, host->base + ORC_EBIOSADR0);
  	*data32_ptr = inb(host->base + ORC_EBIOSDATA);		/* Read from BIOS */
  	outw(0x0011, host->base + ORC_EBIOSADR0);
@@ -397,18 +397,18 @@ static u8 orc_load_firmware(struct orc_h
  	outw(0x0012, host->base + ORC_EBIOSADR0);
  	*(data32_ptr + 2) = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
  	outw(*(data32_ptr + 2), host->base + ORC_EBIOSADR2);
-	outl(data32, host->base + ORC_FWBASEADR);		/* Write FW address */
+	outl(le32_to_cpu(data32), host->base + ORC_FWBASEADR);		/* Write FW address */

  	/* Copy the code from the BIOS to the SRAM */

-	bios_addr = (u16) data32;	/* FW code locate at BIOS address + ? */
+	bios_addr = (u16) le32_to_cpu(data32);	/* FW code locate at BIOS address + ? */
  	for (i = 0, data32_ptr = (u8 *) & data32;	/* Download the code    */
  	     i < 0x1000;	/* Firmware code size = 4K      */
  	     i++, bios_addr++) {
  		outw(bios_addr, host->base + ORC_EBIOSADR0);
  		*data32_ptr++ = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
  		if ((i % 4) == 3) {
-			outl(data32, host->base + ORC_RISCRAM);	/* Write every 4 bytes */
+			outl(le32_to_cpu(data32), host->base + ORC_RISCRAM);	/* Write every 4 bytes */
  			data32_ptr = (u8 *) & data32;
  		}
  	}
@@ -423,7 +423,7 @@ static u8 orc_load_firmware(struct orc_h
  		outw(bios_addr, host->base + ORC_EBIOSADR0);
  		*data32_ptr++ = inb(host->base + ORC_EBIOSDATA);	/* Read from BIOS */
  		if ((i % 4) == 3) {
-			if (inl(host->base + ORC_RISCRAM) != data32) {
+			if (inl(host->base + ORC_RISCRAM) != le32_to_cpu(data32)) {
  				outb(PRGMRST, host->base + ORC_RISCCTL);	/* Reset program to 0 */
  				outb(data, host->base + ORC_GCFG);	/*Disable EEPROM programming */
  				return 0;
@@ -459,8 +459,8 @@ static void setup_SCBs(struct orc_host *

  	for (i = 0; i < ORC_MAXQUEUE; i++) {
  		escb_phys = (host->escb_phys + (sizeof(struct orc_extended_scb) * i));
-		scb->sg_addr = (u32) escb_phys;
-		scb->sense_addr = (u32) escb_phys;
+		scb->sg_addr = cpu_to_le32((u32) escb_phys);
+		scb->sense_addr = cpu_to_le32((u32) escb_phys);
  		scb->escb = escb;
  		scb->scbidx = i;
  		scb++;
@@ -642,8 +642,8 @@ static int orc_device_reset(struct orc_h
  	scb->link = 0xFF;
  	scb->reserved0 = 0;
  	scb->reserved1 = 0;
-	scb->xferlen = 0;
-	scb->sg_len = 0;
+	scb->xferlen = cpu_to_le32(0);
+	scb->sg_len = cpu_to_le32(0);

  	escb->srb = NULL;
  	escb->srb = cmd;
@@ -858,9 +858,9 @@ static void inia100_build_scb(struct orc
  	scb->lun = cmd->device->lun;
  	scb->reserved0 = 0;
  	scb->reserved1 = 0;
-	scb->sg_len = 0;
+	scb->sg_len = cpu_to_le32(0);

-	scb->xferlen = (u32) scsi_bufflen(cmd);
+	scb->xferlen = cpu_to_le32((u32) scsi_bufflen(cmd));
  	sgent = (struct orc_sgent *) & escb->sglist[0];

  	count_sg = scsi_dma_map(cmd);
@@ -868,18 +868,18 @@ static void inia100_build_scb(struct orc

  	/* Build the scatter gather lists */
  	if (count_sg) {
-		scb->sg_len = (u32) (count_sg * 8);
+		scb->sg_len = cpu_to_le32((u32) (count_sg * 8));
  		scsi_for_each_sg(cmd, sg, count_sg, i) {
-			sgent->base = (u32) sg_dma_address(sg);
-			sgent->length = (u32) sg_dma_len(sg);
+			sgent->base = cpu_to_le32((u32) sg_dma_address(sg));
+			sgent->length = cpu_to_le32((u32) sg_dma_len(sg));
  			sgent++;
  		}
  	} else {
-		scb->sg_len = 0;
-		sgent->base = 0;
-		sgent->length = 0;
+		scb->sg_len = cpu_to_le32(0);
+		sgent->base = cpu_to_le32(0);
+		sgent->length = cpu_to_le32(0);
  	}
-	scb->sg_addr = (u32) scb->sense_addr;
+	scb->sg_addr = (u32) scb->sense_addr;	/* sense_addr is already little endian */
  	scb->hastat = 0;
  	scb->tastat = 0;
  	scb->link = 0xFF;
