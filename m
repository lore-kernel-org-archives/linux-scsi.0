From: akpm@linux-foundation.org
Subject: [patch 05/30] ips: remove ips_ha members that duplicate struct pci_dev members
Date: Thu, 13 Dec 2007 16:14:07 -0800
Message-ID: <200712140014.lBE0E7xG026180@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763607AbXLNATD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:19:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, mark_salyzyn@adaptec.com

From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |  178 ++++++++++++++++++++-----------------------
 drivers/scsi/ips.h |   20 +---
 2 files changed, 91 insertions(+), 107 deletions(-)

diff -puN drivers/scsi/ips.c~ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members
+++ a/drivers/scsi/ips.c
@@ -707,7 +707,7 @@ ips_release(struct Scsi_Host *sh)
 		release_region(ha->io_addr, ha->io_len);
 
 	/* free IRQ */
-	free_irq(ha->irq, ha);
+	free_irq(ha->pcidev->irq, ha);
 
 	scsi_host_put(sh);
 
@@ -1637,7 +1637,7 @@ ips_make_passthru(ips_ha_t *ha, struct s
 				return (IPS_FAILURE);
 			}
 
-			if (ha->device_id == IPS_DEVICEID_COPPERHEAD &&
+			if (ha->pcidev->device == IPS_DEVICEID_COPPERHEAD &&
 			    pt->CoppCP.cmd.flashfw.op_code ==
 			    IPS_CMD_RW_BIOSFW) {
 				ret = ips_flash_copperhead(ha, pt, scb);
@@ -2021,7 +2021,7 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_
 	pt->ExtendedStatus = scb->extended_status;
 	pt->AdapterType = ha->ad_type;
 
-	if (ha->device_id == IPS_DEVICEID_COPPERHEAD &&
+	if (ha->pcidev->device == IPS_DEVICEID_COPPERHEAD &&
 	    (scb->cmd.flashfw.op_code == IPS_CMD_DOWNLOAD ||
 	     scb->cmd.flashfw.op_code == IPS_CMD_RW_BIOSFW))
 		ips_free_flash_copperhead(ha);
@@ -2075,7 +2075,7 @@ ips_host_info(ips_ha_t * ha, char *ptr, 
 			  ha->mem_ptr);
 	}
 
-	copy_info(&info, "\tIRQ number                        : %d\n", ha->irq);
+	copy_info(&info, "\tIRQ number                        : %d\n", ha->pcidev->irq);
 
     /* For the Next 3 lines Check for Binary 0 at the end and don't include it if it's there. */
     /* That keeps everything happy for "text" operations on the proc file.                    */
@@ -2232,31 +2232,31 @@ ips_identify_controller(ips_ha_t * ha)
 {
 	METHOD_TRACE("ips_identify_controller", 1);
 
-	switch (ha->device_id) {
+	switch (ha->pcidev->device) {
 	case IPS_DEVICEID_COPPERHEAD:
-		if (ha->revision_id <= IPS_REVID_SERVERAID) {
+		if (ha->pcidev->revision <= IPS_REVID_SERVERAID) {
 			ha->ad_type = IPS_ADTYPE_SERVERAID;
-		} else if (ha->revision_id == IPS_REVID_SERVERAID2) {
+		} else if (ha->pcidev->revision == IPS_REVID_SERVERAID2) {
 			ha->ad_type = IPS_ADTYPE_SERVERAID2;
-		} else if (ha->revision_id == IPS_REVID_NAVAJO) {
+		} else if (ha->pcidev->revision == IPS_REVID_NAVAJO) {
 			ha->ad_type = IPS_ADTYPE_NAVAJO;
-		} else if ((ha->revision_id == IPS_REVID_SERVERAID2)
+		} else if ((ha->pcidev->revision == IPS_REVID_SERVERAID2)
 			   && (ha->slot_num == 0)) {
 			ha->ad_type = IPS_ADTYPE_KIOWA;
-		} else if ((ha->revision_id >= IPS_REVID_CLARINETP1) &&
-			   (ha->revision_id <= IPS_REVID_CLARINETP3)) {
+		} else if ((ha->pcidev->revision >= IPS_REVID_CLARINETP1) &&
+			   (ha->pcidev->revision <= IPS_REVID_CLARINETP3)) {
 			if (ha->enq->ucMaxPhysicalDevices == 15)
 				ha->ad_type = IPS_ADTYPE_SERVERAID3L;
 			else
 				ha->ad_type = IPS_ADTYPE_SERVERAID3;
-		} else if ((ha->revision_id >= IPS_REVID_TROMBONE32) &&
-			   (ha->revision_id <= IPS_REVID_TROMBONE64)) {
+		} else if ((ha->pcidev->revision >= IPS_REVID_TROMBONE32) &&
+			   (ha->pcidev->revision <= IPS_REVID_TROMBONE64)) {
 			ha->ad_type = IPS_ADTYPE_SERVERAID4H;
 		}
 		break;
 
 	case IPS_DEVICEID_MORPHEUS:
-		switch (ha->subdevice_id) {
+		switch (ha->pcidev->subsystem_device) {
 		case IPS_SUBDEVICEID_4L:
 			ha->ad_type = IPS_ADTYPE_SERVERAID4L;
 			break;
@@ -2285,7 +2285,7 @@ ips_identify_controller(ips_ha_t * ha)
 		break;
 
 	case IPS_DEVICEID_MARCO:
-		switch (ha->subdevice_id) {
+		switch (ha->pcidev->subsystem_device) {
 		case IPS_SUBDEVICEID_6M:
 			ha->ad_type = IPS_ADTYPE_SERVERAID6M;
 			break;
@@ -2332,20 +2332,20 @@ ips_get_bios_version(ips_ha_t * ha, int 
 
 	strncpy(ha->bios_version, "       ?", 8);
 
-	if (ha->device_id == IPS_DEVICEID_COPPERHEAD) {
+	if (ha->pcidev->device == IPS_DEVICEID_COPPERHEAD) {
 		if (IPS_USE_MEMIO(ha)) {
 			/* Memory Mapped I/O */
 
 			/* test 1st byte */
 			writel(0, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			if (readb(ha->mem_ptr + IPS_REG_FLDP) != 0x55)
 				return;
 
 			writel(1, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			if (readb(ha->mem_ptr + IPS_REG_FLDP) != 0xAA)
@@ -2353,20 +2353,20 @@ ips_get_bios_version(ips_ha_t * ha, int 
 
 			/* Get Major version */
 			writel(0x1FF, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			major = readb(ha->mem_ptr + IPS_REG_FLDP);
 
 			/* Get Minor version */
 			writel(0x1FE, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 			minor = readb(ha->mem_ptr + IPS_REG_FLDP);
 
 			/* Get SubMinor version */
 			writel(0x1FD, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 			subminor = readb(ha->mem_ptr + IPS_REG_FLDP);
 
@@ -2375,14 +2375,14 @@ ips_get_bios_version(ips_ha_t * ha, int 
 
 			/* test 1st byte */
 			outl(0, ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			if (inb(ha->io_addr + IPS_REG_FLDP) != 0x55)
 				return;
 
 			outl(cpu_to_le32(1), ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			if (inb(ha->io_addr + IPS_REG_FLDP) != 0xAA)
@@ -2390,21 +2390,21 @@ ips_get_bios_version(ips_ha_t * ha, int 
 
 			/* Get Major version */
 			outl(cpu_to_le32(0x1FF), ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			major = inb(ha->io_addr + IPS_REG_FLDP);
 
 			/* Get Minor version */
 			outl(cpu_to_le32(0x1FE), ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			minor = inb(ha->io_addr + IPS_REG_FLDP);
 
 			/* Get SubMinor version */
 			outl(cpu_to_le32(0x1FD), ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			subminor = inb(ha->io_addr + IPS_REG_FLDP);
@@ -4903,7 +4903,7 @@ ips_init_copperhead(ips_ha_t * ha)
 	/* Enable busmastering */
 	outb(IPS_BIT_EBM, ha->io_addr + IPS_REG_SCPR);
 
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		/* fix for anaconda64 */
 		outl(0, ha->io_addr + IPS_REG_NDAE);
 
@@ -4997,7 +4997,7 @@ ips_init_copperhead_memio(ips_ha_t * ha)
 	/* Enable busmastering */
 	writeb(IPS_BIT_EBM, ha->mem_ptr + IPS_REG_SCPR);
 
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		/* fix for anaconda64 */
 		writel(0, ha->mem_ptr + IPS_REG_NDAE);
 
@@ -5142,7 +5142,7 @@ ips_reset_copperhead(ips_ha_t * ha)
 	METHOD_TRACE("ips_reset_copperhead", 1);
 
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead: io addr: %x, irq: %d",
-		  ips_name, ha->host_num, ha->io_addr, ha->irq);
+		  ips_name, ha->host_num, ha->io_addr, ha->pcidev->irq);
 
 	reset_counter = 0;
 
@@ -5187,7 +5187,7 @@ ips_reset_copperhead_memio(ips_ha_t * ha
 	METHOD_TRACE("ips_reset_copperhead_memio", 1);
 
 	DEBUG_VAR(1, "(%s%d) ips_reset_copperhead_memio: mem addr: %x, irq: %d",
-		  ips_name, ha->host_num, ha->mem_addr, ha->irq);
+		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
 	reset_counter = 0;
 
@@ -5233,7 +5233,7 @@ ips_reset_morpheus(ips_ha_t * ha)
 	METHOD_TRACE("ips_reset_morpheus", 1);
 
 	DEBUG_VAR(1, "(%s%d) ips_reset_morpheus: mem addr: %x, irq: %d",
-		  ips_name, ha->host_num, ha->mem_addr, ha->irq);
+		  ips_name, ha->host_num, ha->mem_addr, ha->pcidev->irq);
 
 	reset_counter = 0;
 
@@ -6196,32 +6196,32 @@ ips_erase_bios(ips_ha_t * ha)
 
 	/* Clear the status register */
 	outl(0, ha->io_addr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	outb(0x50, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Setup */
 	outb(0x20, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Confirm */
 	outb(0xD0, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Status */
 	outb(0x70, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	timeout = 80000;	/* 80 seconds */
 
 	while (timeout > 0) {
-		if (ha->revision_id == IPS_REVID_TROMBONE64) {
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 			outl(0, ha->io_addr + IPS_REG_FLAP);
 			udelay(25);	/* 25 us */
 		}
@@ -6241,13 +6241,13 @@ ips_erase_bios(ips_ha_t * ha)
 
 		/* try to suspend the erase */
 		outb(0xB0, ha->io_addr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		/* wait for 10 seconds */
 		timeout = 10000;
 		while (timeout > 0) {
-			if (ha->revision_id == IPS_REVID_TROMBONE64) {
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 				outl(0, ha->io_addr + IPS_REG_FLAP);
 				udelay(25);	/* 25 us */
 			}
@@ -6277,12 +6277,12 @@ ips_erase_bios(ips_ha_t * ha)
 	/* Otherwise, we were successful */
 	/* clear status */
 	outb(0x50, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* enable reads */
 	outb(0xFF, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	return (0);
@@ -6308,32 +6308,32 @@ ips_erase_bios_memio(ips_ha_t * ha)
 
 	/* Clear the status register */
 	writel(0, ha->mem_ptr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	writeb(0x50, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Setup */
 	writeb(0x20, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Confirm */
 	writeb(0xD0, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* Erase Status */
 	writeb(0x70, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	timeout = 80000;	/* 80 seconds */
 
 	while (timeout > 0) {
-		if (ha->revision_id == IPS_REVID_TROMBONE64) {
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 			writel(0, ha->mem_ptr + IPS_REG_FLAP);
 			udelay(25);	/* 25 us */
 		}
@@ -6353,13 +6353,13 @@ ips_erase_bios_memio(ips_ha_t * ha)
 
 		/* try to suspend the erase */
 		writeb(0xB0, ha->mem_ptr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		/* wait for 10 seconds */
 		timeout = 10000;
 		while (timeout > 0) {
-			if (ha->revision_id == IPS_REVID_TROMBONE64) {
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 				writel(0, ha->mem_ptr + IPS_REG_FLAP);
 				udelay(25);	/* 25 us */
 			}
@@ -6389,12 +6389,12 @@ ips_erase_bios_memio(ips_ha_t * ha)
 	/* Otherwise, we were successful */
 	/* clear status */
 	writeb(0x50, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	/* enable reads */
 	writeb(0xFF, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	return (0);
@@ -6423,21 +6423,21 @@ ips_program_bios(ips_ha_t * ha, char *bu
 	for (i = 0; i < buffersize; i++) {
 		/* write a byte */
 		outl(cpu_to_le32(i + offset), ha->io_addr + IPS_REG_FLAP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		outb(0x40, ha->io_addr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		outb(buffer[i], ha->io_addr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		/* wait up to one second */
 		timeout = 1000;
 		while (timeout > 0) {
-			if (ha->revision_id == IPS_REVID_TROMBONE64) {
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 				outl(0, ha->io_addr + IPS_REG_FLAP);
 				udelay(25);	/* 25 us */
 			}
@@ -6454,11 +6454,11 @@ ips_program_bios(ips_ha_t * ha, char *bu
 		if (timeout == 0) {
 			/* timeout error */
 			outl(0, ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			outb(0xFF, ha->io_addr + IPS_REG_FLDP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			return (1);
@@ -6468,11 +6468,11 @@ ips_program_bios(ips_ha_t * ha, char *bu
 		if (status & 0x18) {
 			/* programming error */
 			outl(0, ha->io_addr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			outb(0xFF, ha->io_addr + IPS_REG_FLDP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			return (1);
@@ -6481,11 +6481,11 @@ ips_program_bios(ips_ha_t * ha, char *bu
 
 	/* Enable reading */
 	outl(0, ha->io_addr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	outb(0xFF, ha->io_addr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	return (0);
@@ -6514,21 +6514,21 @@ ips_program_bios_memio(ips_ha_t * ha, ch
 	for (i = 0; i < buffersize; i++) {
 		/* write a byte */
 		writel(i + offset, ha->mem_ptr + IPS_REG_FLAP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		writeb(0x40, ha->mem_ptr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		writeb(buffer[i], ha->mem_ptr + IPS_REG_FLDP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		/* wait up to one second */
 		timeout = 1000;
 		while (timeout > 0) {
-			if (ha->revision_id == IPS_REVID_TROMBONE64) {
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64) {
 				writel(0, ha->mem_ptr + IPS_REG_FLAP);
 				udelay(25);	/* 25 us */
 			}
@@ -6545,11 +6545,11 @@ ips_program_bios_memio(ips_ha_t * ha, ch
 		if (timeout == 0) {
 			/* timeout error */
 			writel(0, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			writeb(0xFF, ha->mem_ptr + IPS_REG_FLDP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			return (1);
@@ -6559,11 +6559,11 @@ ips_program_bios_memio(ips_ha_t * ha, ch
 		if (status & 0x18) {
 			/* programming error */
 			writel(0, ha->mem_ptr + IPS_REG_FLAP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			writeb(0xFF, ha->mem_ptr + IPS_REG_FLDP);
-			if (ha->revision_id == IPS_REVID_TROMBONE64)
+			if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 				udelay(25);	/* 25 us */
 
 			return (1);
@@ -6572,11 +6572,11 @@ ips_program_bios_memio(ips_ha_t * ha, ch
 
 	/* Enable reading */
 	writel(0, ha->mem_ptr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	writeb(0xFF, ha->mem_ptr + IPS_REG_FLDP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	return (0);
@@ -6601,14 +6601,14 @@ ips_verify_bios(ips_ha_t * ha, char *buf
 
 	/* test 1st byte */
 	outl(0, ha->io_addr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	if (inb(ha->io_addr + IPS_REG_FLDP) != 0x55)
 		return (1);
 
 	outl(cpu_to_le32(1), ha->io_addr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 	if (inb(ha->io_addr + IPS_REG_FLDP) != 0xAA)
 		return (1);
@@ -6617,7 +6617,7 @@ ips_verify_bios(ips_ha_t * ha, char *buf
 	for (i = 2; i < buffersize; i++) {
 
 		outl(cpu_to_le32(i + offset), ha->io_addr + IPS_REG_FLAP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		checksum = (uint8_t) checksum + inb(ha->io_addr + IPS_REG_FLDP);
@@ -6650,14 +6650,14 @@ ips_verify_bios_memio(ips_ha_t * ha, cha
 
 	/* test 1st byte */
 	writel(0, ha->mem_ptr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 
 	if (readb(ha->mem_ptr + IPS_REG_FLDP) != 0x55)
 		return (1);
 
 	writel(1, ha->mem_ptr + IPS_REG_FLAP);
-	if (ha->revision_id == IPS_REVID_TROMBONE64)
+	if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 		udelay(25);	/* 25 us */
 	if (readb(ha->mem_ptr + IPS_REG_FLDP) != 0xAA)
 		return (1);
@@ -6666,7 +6666,7 @@ ips_verify_bios_memio(ips_ha_t * ha, cha
 	for (i = 2; i < buffersize; i++) {
 
 		writel(i + offset, ha->mem_ptr + IPS_REG_FLAP);
-		if (ha->revision_id == IPS_REVID_TROMBONE64)
+		if (ha->pcidev->revision == IPS_REVID_TROMBONE64)
 			udelay(25);	/* 25 us */
 
 		checksum =
@@ -6837,9 +6837,9 @@ ips_register_scsi(int index)
 	}
 	ha = IPS_HA(sh);
 	memcpy(ha, oldha, sizeof (ips_ha_t));
-	free_irq(oldha->irq, oldha);
+	free_irq(oldha->pcidev->irq, oldha);
 	/* Install the interrupt handler with the new ha */
-	if (request_irq(ha->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
+	if (request_irq(ha->pcidev->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
 		scsi_host_put(sh);
@@ -6851,10 +6851,7 @@ ips_register_scsi(int index)
 	ips_ha[index] = ha;
 
 	/* Store away needed values for later use */
-	sh->io_port = ha->io_addr;
-	sh->n_io_port = ha->io_addr ? 255 : 0;
 	sh->unique_id = (ha->io_addr) ? ha->io_addr : ha->mem_addr;
-	sh->irq = ha->irq;
 	sh->sg_tablesize = sh->hostt->sg_tablesize;
 	sh->can_queue = sh->hostt->can_queue;
 	sh->cmd_per_lun = sh->hostt->cmd_per_lun;
@@ -6992,8 +6989,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	uint32_t mem_len;
 	uint8_t bus;
 	uint8_t func;
-	uint8_t irq;
-	uint16_t subdevice_id;
 	int j;
 	int index;
 	dma_addr_t dma_address;
@@ -7014,7 +7009,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		return -1;
 
 	/* stuff that we get in dev */
-	irq = pci_dev->irq;
 	bus = pci_dev->bus->number;
 	func = pci_dev->devfn;
 
@@ -7068,8 +7062,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 		}
 	}
 
-	subdevice_id = pci_dev->subsystem_device;
-
 	/* found a controller */
 	ha = kzalloc(sizeof (ips_ha_t), GFP_KERNEL);
 	if (ha == NULL) {
@@ -7084,7 +7076,6 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	ha->active = 1;
 
 	/* Store info in HA structure */
-	ha->irq = irq;
 	ha->io_addr = io_addr;
 	ha->io_len = io_len;
 	ha->mem_addr = mem_addr;
@@ -7092,10 +7083,7 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	ha->mem_ptr = mem_ptr;
 	ha->ioremap_ptr = ioremap_ptr;
 	ha->host_num = (uint32_t) index;
-	ha->revision_id = pci_dev->revision;
 	ha->slot_num = PCI_SLOT(pci_dev->devfn);
-	ha->device_id = pci_dev->device;
-	ha->subdevice_id = subdevice_id;
 	ha->pcidev = pci_dev;
 
 	/*
@@ -7240,7 +7228,7 @@ ips_init_phase2(int index)
 	}
 
 	/* Install the interrupt handler */
-	if (request_irq(ha->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
+	if (request_irq(ha->pcidev->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
 		return ips_abort_init(ha, index);
@@ -7253,14 +7241,14 @@ ips_init_phase2(int index)
 	if (!ips_allocatescbs(ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to allocate a CCB\n");
-		free_irq(ha->irq, ha);
+		free_irq(ha->pcidev->irq, ha);
 		return ips_abort_init(ha, index);
 	}
 
 	if (!ips_hainit(ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to initialize controller\n");
-		free_irq(ha->irq, ha);
+		free_irq(ha->pcidev->irq, ha);
 		return ips_abort_init(ha, index);
 	}
 	/* Free the temporary SCB */
@@ -7270,7 +7258,7 @@ ips_init_phase2(int index)
 	if (!ips_allocatescbs(ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to allocate CCBs\n");
-		free_irq(ha->irq, ha);
+		free_irq(ha->pcidev->irq, ha);
 		return ips_abort_init(ha, index);
 	}
 
diff -puN drivers/scsi/ips.h~ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members
+++ a/drivers/scsi/ips.h
@@ -60,14 +60,14 @@
     */
    #define IPS_HA(x)                   ((ips_ha_t *) x->hostdata)
    #define IPS_COMMAND_ID(ha, scb)     (int) (scb - ha->scbs)
-   #define IPS_IS_TROMBONE(ha)         (((ha->device_id == IPS_DEVICEID_COPPERHEAD) && \
-                                         (ha->revision_id >= IPS_REVID_TROMBONE32) && \
-                                         (ha->revision_id <= IPS_REVID_TROMBONE64)) ? 1 : 0)
-   #define IPS_IS_CLARINET(ha)         (((ha->device_id == IPS_DEVICEID_COPPERHEAD) && \
-                                         (ha->revision_id >= IPS_REVID_CLARINETP1) && \
-                                         (ha->revision_id <= IPS_REVID_CLARINETP3)) ? 1 : 0)
-   #define IPS_IS_MORPHEUS(ha)         (ha->device_id == IPS_DEVICEID_MORPHEUS)
-   #define IPS_IS_MARCO(ha)            (ha->device_id == IPS_DEVICEID_MARCO)
+   #define IPS_IS_TROMBONE(ha)         (((ha->pcidev->device == IPS_DEVICEID_COPPERHEAD) && \
+                                         (ha->pcidev->revision >= IPS_REVID_TROMBONE32) && \
+                                         (ha->pcidev->revision <= IPS_REVID_TROMBONE64)) ? 1 : 0)
+   #define IPS_IS_CLARINET(ha)         (((ha->pcidev->device == IPS_DEVICEID_COPPERHEAD) && \
+                                         (ha->pcidev->revision >= IPS_REVID_CLARINETP1) && \
+                                         (ha->pcidev->revision <= IPS_REVID_CLARINETP3)) ? 1 : 0)
+   #define IPS_IS_MORPHEUS(ha)         (ha->pcidev->device == IPS_DEVICEID_MORPHEUS)
+   #define IPS_IS_MARCO(ha)            (ha->pcidev->device == IPS_DEVICEID_MARCO)
    #define IPS_USE_I2O_DELIVER(ha)     ((IPS_IS_MORPHEUS(ha) || \
                                          (IPS_IS_TROMBONE(ha) && \
                                           (ips_force_i2o))) ? 1 : 0)
@@ -1034,7 +1034,6 @@ typedef struct ips_ha {
    uint8_t            ha_id[IPS_MAX_CHANNELS+1];
    uint32_t           dcdb_active[IPS_MAX_CHANNELS];
    uint32_t           io_addr;            /* Base I/O address           */
-   uint8_t            irq;                /* IRQ for adapter            */
    uint8_t            ntargets;           /* Number of targets          */
    uint8_t            nbus;               /* Number of buses            */
    uint8_t            nlun;               /* Number of Luns             */
@@ -1066,10 +1065,7 @@ typedef struct ips_ha {
    int                ioctl_reset;        /* IOCTL Requested Reset Flag */
    uint16_t           reset_count;        /* number of resets           */
    time_t             last_ffdc;          /* last time we sent ffdc info*/
-   uint8_t            revision_id;        /* Revision level             */
-   uint16_t           device_id;          /* PCI device ID              */
    uint8_t            slot_num;           /* PCI Slot Number            */
-   uint16_t           subdevice_id;       /* Subsystem device ID        */
    int                ioctl_len;          /* size of ioctl buffer       */
    dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
    uint8_t            bios_version[8];    /* BIOS Revision              */
_
