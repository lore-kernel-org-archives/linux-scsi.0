From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/15]  qla2xxx: Remove flash routines
Date: Thu, 6 May 2004 22:50:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055015.GA4881@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:3570 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261991AbUEGFsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:48:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1923 04/04/29 14:40:24 andrew.vasquez@apc.qlogic.com +4 -0
  Remove flash support from embedded driver:
  
  	o Remove unused option-rom variables from host structure.
  	o Remove flash manipulation routines.

 drivers/scsi/qla2xxx/qla_def.h  |    2 
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 
 drivers/scsi/qla2xxx/qla_init.c |    3 
 drivers/scsi/qla2xxx/qla_sup.c  |  446 ----------------------------------------
 4 files changed, 459 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:13:09 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:13:09 2004
@@ -2340,8 +2340,6 @@
 
 	uint8_t     node_name[WWN_SIZE];
 	uint8_t     nvram_version; 
-	uint8_t     optrom_major; 
-	uint8_t     optrom_minor; 
 	uint32_t    isp_abort_cnt;
 
 	/* Adapter I/O statistics for failover */
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Mon May  3 15:13:09 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Mon May  3 15:13:09 2004
@@ -255,14 +255,6 @@
 extern void qla2x00_unlock_nvram_access(scsi_qla_host_t *);
 extern uint16_t qla2x00_get_nvram_word(scsi_qla_host_t *, uint32_t);
 extern void qla2x00_write_nvram_word(scsi_qla_host_t *, uint32_t, uint16_t);
-extern void qla2x00_flash_enable(scsi_qla_host_t *);
-extern void qla2x00_flash_disable(scsi_qla_host_t *);
-extern uint8_t qla2x00_read_flash_byte(scsi_qla_host_t *, uint32_t);
-extern uint8_t qla2x00_get_flash_manufacturer(scsi_qla_host_t *);
-extern uint16_t qla2x00_get_flash_version(scsi_qla_host_t *);
-extern uint16_t qla2x00_get_flash_image(scsi_qla_host_t *, uint8_t *);
-extern uint16_t qla2x00_set_flash_image(scsi_qla_host_t *, uint8_t *);
-
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:09 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:13:09 2004
@@ -133,9 +133,6 @@
 	/* Initialize target map database. */
 	qla2x00_init_tgt_map(ha);
 
-	/* Get Flash Version */
-	qla2x00_get_flash_version(ha);
-
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 	qla2x00_nvram_config(ha);
 
diff -Nru a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c	Mon May  3 15:13:09 2004
+++ b/drivers/scsi/qla2xxx/qla_sup.c	Mon May  3 15:13:09 2004
@@ -24,20 +24,6 @@
 static void qla2x00_nv_deselect(scsi_qla_host_t *);
 static void qla2x00_nv_write(scsi_qla_host_t *, uint16_t);
 
-uint8_t qla2x00_read_flash_byte(scsi_qla_host_t *, uint32_t);
-static void qla2x00_write_flash_byte(scsi_qla_host_t *, uint32_t, uint8_t);
-static uint8_t qla2x00_poll_flash(scsi_qla_host_t *ha,
-		uint32_t addr, uint8_t poll_data, uint8_t mid);
-static uint8_t qla2x00_program_flash_address(scsi_qla_host_t *ha,
-		uint32_t addr, uint8_t data, uint8_t mid);
-static uint8_t qla2x00_erase_flash_sector(scsi_qla_host_t *ha,
-		uint32_t addr, uint32_t sec_mask, uint8_t mid);
-
-uint8_t qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha);
-uint16_t qla2x00_get_flash_version(scsi_qla_host_t *);
-uint16_t qla2x00_get_flash_image(scsi_qla_host_t *ha, uint8_t *image);
-uint16_t qla2x00_set_flash_image(scsi_qla_host_t *ha, uint8_t *image);
-
 
 /*
  * NVRAM support routines
@@ -279,435 +265,3 @@
 	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
 }
 
-/*
- * Flash support routines
- */
-
-/**
- * qla2x00_flash_enable() - Setup flash for reading and writing.
- * @ha: HA context
- */
-void
-qla2x00_flash_enable(scsi_qla_host_t *ha)
-{
-	uint16_t	data;
-	device_reg_t	*reg = ha->iobase;
-
-	data = RD_REG_WORD(&reg->ctrl_status);
-	data |= CSR_FLASH_ENABLE;
-	WRT_REG_WORD(&reg->ctrl_status, data);
-	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-}
-
-/**
- * qla2x00_flash_disable() - Disable flash and allow RISC to run.
- * @ha: HA context
- */
-void
-qla2x00_flash_disable(scsi_qla_host_t *ha)
-{
-	uint16_t	data;
-	device_reg_t	*reg = ha->iobase;
-
-	data = RD_REG_WORD(&reg->ctrl_status);
-	data &= ~(CSR_FLASH_ENABLE);
-	WRT_REG_WORD(&reg->ctrl_status, data);
-	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-}
-
-/**
- * qla2x00_read_flash_byte() - Reads a byte from flash
- * @ha: HA context
- * @addr: Address in flash to read
- *
- * A word is read from the chip, but, only the lower byte is valid.
- *
- * Returns the byte read from flash @addr.
- */
-uint8_t
-qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
-{
-	uint16_t	data;
-	uint16_t	bank_select;
-	device_reg_t	*reg = ha->iobase;
-
-	/* Setup bit 16 of flash address. */
-	bank_select = RD_REG_WORD(&reg->ctrl_status);
-	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
-		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
-	} else if (((addr & BIT_16) == 0) &&
-	    (bank_select & CSR_FLASH_64K_BANK)) {
-		bank_select &= ~(CSR_FLASH_64K_BANK);
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
-	}
-
-	/* The ISP2312 v2 chip cannot access the FLASH registers via MMIO. */
-	if (IS_QLA2312(ha) && ha->product_id[3] == 0x2 && ha->pio_address) {
-		uint16_t data2;
-
-		reg = (device_reg_t *)ha->pio_address;
-		outw((uint16_t)addr, (unsigned long)(&reg->flash_address));
-		do {
-			data = inw((unsigned long)(&reg->flash_data));
-			barrier();
-			cpu_relax();
-			data2 = inw((unsigned long)(&reg->flash_data));
-		} while (data != data2);
-	} else {
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
-		data = qla2x00_debounce_register(&reg->flash_data);
-	}
-
-	return ((uint8_t)data);
-}
-
-/**
- * qla2x00_write_flash_byte() - Write a byte to flash
- * @ha: HA context
- * @addr: Address in flash to write
- * @data: Data to write
- */
-static void
-qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
-{
-	uint16_t	bank_select;
-	device_reg_t	*reg = ha->iobase;
-
-	/* Setup bit 16 of flash address. */
-	bank_select = RD_REG_WORD(&reg->ctrl_status);
-	if ((addr & BIT_16) && ((bank_select & CSR_FLASH_64K_BANK) == 0)) {
-		bank_select |= CSR_FLASH_64K_BANK;
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
-	} else if (((addr & BIT_16) == 0) &&
-	    (bank_select & CSR_FLASH_64K_BANK)) {
-		bank_select &= ~(CSR_FLASH_64K_BANK);
-		WRT_REG_WORD(&reg->ctrl_status, bank_select);
-		RD_REG_WORD(&reg->ctrl_status);	/* PCI Posting. */
-	}
-
-	/* The ISP2312 v2 chip cannot access the FLASH registers via MMIO. */
-	if (IS_QLA2312(ha) && ha->product_id[3] == 0x2 && ha->pio_address) {
-		reg = (device_reg_t *)ha->pio_address;
-		outw((uint16_t)addr, (unsigned long)(&reg->flash_address));
-		outw((uint16_t)data, (unsigned long)(&reg->flash_data));
-	} else {
-		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-		WRT_REG_WORD(&reg->flash_data, (uint16_t)data);
-		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-	}
-}
-
-/**
- * qla2x00_poll_flash() - Polls flash for completion.
- * @ha: HA context
- * @addr: Address in flash to poll
- * @poll_data: Data to be polled
- * @mid: Flash manufacturer ID
- *
- * This function polls the device until bit 7 of what is read matches data
- * bit 7 or until data bit 5 becomes a 1.  If that hapens, the flash ROM timed
- * out (a fatal error).  The flash book recommeds reading bit 7 again after
- * reading bit 5 as a 1.
- *
- * Returns 0 on success, else non-zero.
- */
-static uint8_t
-qla2x00_poll_flash(scsi_qla_host_t *ha,
-    uint32_t addr, uint8_t poll_data, uint8_t mid)
-{
-	uint8_t		status;
-	uint8_t		flash_data;
-	uint32_t	cnt;
-	int		failed_pass;
-
-	status = 1;
-	failed_pass = 1;
-
-	/* Wait for 30 seconds for command to finish. */
-	poll_data &= BIT_7;
-	for (cnt = 3000000; cnt; cnt--) {
-		flash_data = qla2x00_read_flash_byte(ha, addr);
-		if ((flash_data & BIT_7) == poll_data) {
-			status = 0;
-			break;
-		}
-
-		if (mid != 0x40 && mid != 0xda) {
-			if (flash_data & BIT_5)
-				failed_pass--;
-			if (failed_pass < 0)
-				break;
-		}
-		udelay(10);
-		barrier();
-	}
-	return (status);
-}
-
-/**
- * qla2x00_program_flash_address() - Programs a flash address
- * @ha: HA context
- * @addr: Address in flash to program
- * @data: Data to be written in flash
- * @mid: Flash manufacturer ID
- *
- * Returns 0 on success, else non-zero.
- */
-static uint8_t
-qla2x00_program_flash_address(scsi_qla_host_t *ha,
-    uint32_t addr, uint8_t data, uint8_t mid)
-{
-	/* Write Program Command Sequence */
-	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
-	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
-	qla2x00_write_flash_byte(ha, 0x5555, 0xa0);
-	qla2x00_write_flash_byte(ha, addr, data);
-
-	/* Wait for write to complete. */
-	return (qla2x00_poll_flash(ha, addr, data, mid));
-}
-
-/**
- * qla2x00_erase_flash_sector() - Erase a flash sector.
- * @ha: HA context
- * @addr: Flash sector to erase
- * @sec_mask: Sector address mask
- * @mid: Flash manufacturer ID
- *
- * Returns 0 on success, else non-zero.
- */
-static uint8_t
-qla2x00_erase_flash_sector(scsi_qla_host_t *ha,
-    uint32_t addr, uint32_t sec_mask, uint8_t mid)
-{
-	/* Individual Sector Erase Command Sequence */
-	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
-	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
-	qla2x00_write_flash_byte(ha, 0x5555, 0x80);
-	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
-	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
-
-	if (mid == 0xda)
-		qla2x00_write_flash_byte(ha, addr & sec_mask, 0x10);
-	else
-		qla2x00_write_flash_byte(ha, addr & sec_mask, 0x30);
-
-	udelay(150);
-
-	/* Wait for erase to complete. */
-	return (qla2x00_poll_flash(ha, addr, 0x80, mid));
-}
-
-/**
- * qla2x00_get_flash_manufacturer() - Read manufacturer ID from flash chip.
- * @ha: HA context
- *
- * Returns the manufacturer's ID read from the flash chip.
- */
-uint8_t
-qla2x00_get_flash_manufacturer(scsi_qla_host_t *ha)
-{
-	uint8_t	manuf_id;
-
-	qla2x00_write_flash_byte(ha, 0x5555, 0xaa);
-	qla2x00_write_flash_byte(ha, 0x2aaa, 0x55);
-	qla2x00_write_flash_byte(ha, 0x5555, 0x90);
-	manuf_id = qla2x00_read_flash_byte(ha, 0x0001);
-
-	return (manuf_id);
-}
-
-/**
- * qla2x00_get_flash_version() - Read version information from flash.
- * @ha: HA context
- *
- * Returns QLA_SUCCESS on successful retrieval of flash version.
- */
-uint16_t
-qla2x00_get_flash_version(scsi_qla_host_t *ha)
-{
-	uint16_t	ret = QLA_SUCCESS;
-	uint32_t	loop_cnt = 1;  /* this is for error exit only */
-	uint32_t	pcir_adr;
-
-	/* The ISP2312 v2 chip cannot access the FLASH registers via MMIO. */
-	if (IS_QLA2312(ha) && ha->product_id[3] == 0x2 && !ha->pio_address)
-		ret = QLA_FUNCTION_FAILED;
-
-	qla2x00_flash_enable(ha);
-	do {	/* Loop once to provide quick error exit */
-		/* Match signature */
-		if (!(qla2x00_read_flash_byte(ha, 0) == 0x55 &&
-		    qla2x00_read_flash_byte(ha, 1) == 0xaa)) {
-			/* No signature */
-			DEBUG2(printk("scsi(%ld): No matching FLASH "
-			    "signature.\n", ha->host_no));
-			ret = QLA_FUNCTION_FAILED;
-			break;
-		}
-
-		pcir_adr = qla2x00_read_flash_byte(ha, 0x18) & 0xff;
-
-		/* validate signature of PCI data structure */
-		if ((qla2x00_read_flash_byte(ha, pcir_adr)) == 'P' &&
-		    (qla2x00_read_flash_byte(ha, pcir_adr + 1)) == 'C' &&
-		    (qla2x00_read_flash_byte(ha, pcir_adr + 2)) == 'I' &&
-		    (qla2x00_read_flash_byte(ha, pcir_adr + 3)) == 'R') {
-
-			/* Read version */
-			ha->optrom_minor =
-			    qla2x00_read_flash_byte(ha, pcir_adr + 0x12);
-			ha->optrom_major =
-			    qla2x00_read_flash_byte(ha, pcir_adr + 0x13);
-			DEBUG3(printk("%s(): got %d.%d.\n",
-			    __func__, ha->optrom_major, ha->optrom_minor));
-		} else {
-			/* error */
-			DEBUG2(printk("%s(): PCI data struct not found. "
-			    "pcir_adr=%x.\n",
-			    __func__, pcir_adr));
-			ret = QLA_FUNCTION_FAILED;
-			break;
-		}
-
-	} while (--loop_cnt);
-	qla2x00_flash_disable(ha);
-
-	return (ret);
-}
-
-/**
- * qla2x00_get_flash_image() - Read image from flash chip.
- * @ha: HA context
- * @image: Buffer to receive flash image
- *
- * Returns 0 on success, else non-zero.
- */
-uint16_t
-qla2x00_get_flash_image(scsi_qla_host_t *ha, uint8_t *image)
-{
-	uint32_t	addr;
-	uint32_t	midpoint;
-	uint8_t		*data;
-	device_reg_t	*reg = ha->iobase;
-
-	midpoint = FLASH_IMAGE_SIZE / 2;
-
-	qla2x00_flash_enable(ha);
-	WRT_REG_WORD(&reg->nvram, 0);
-	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
-	for (addr = 0, data = image; addr < FLASH_IMAGE_SIZE; addr++, data++) {
-		if (addr == midpoint)
-			WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-
-		*data = qla2x00_read_flash_byte(ha, addr);
-	}
-	qla2x00_flash_disable(ha);
-
-	return (0);
-}
-
-/**
- * qla2x00_set_flash_image() - Write image to flash chip.
- * @ha: HA context
- * @image: Source image to write to flash
- *
- * Returns 0 on success, else non-zero.
- */
-uint16_t
-qla2x00_set_flash_image(scsi_qla_host_t *ha, uint8_t *image)
-{
-	uint16_t	status;
-	uint32_t	addr;
-	uint32_t	midpoint;
-	uint32_t	sec_mask;
-	uint32_t	rest_addr;
-	uint8_t		mid;
-	uint8_t		sec_number;
-	uint8_t		data;
-	device_reg_t	*reg = ha->iobase;
-
-	status = 0;
-	sec_number = 0;
-
-	/* Reset ISP chip. */
-	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
-	RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-
-	qla2x00_flash_enable(ha);
-	do {	/* Loop once to provide quick error exit */
-		/* Structure of flash memory based on manufacturer */
-		mid = qla2x00_get_flash_manufacturer(ha);
-		if (mid == 0x6d) {
-			// Am29LV001 part
-			rest_addr = 0x1fff;
-			sec_mask = 0x1e000;
-		} else if (mid == 0x40) {
-			// Mostel v29c51001 part
-			rest_addr = 0x1ff;
-			sec_mask = 0x1fe00;
-		} else if (mid == 0xbf) {
-			// SST39sf10 part
-			rest_addr = 0xfff;
-			sec_mask = 0x1f000;
-		} else if (mid == 0xda) {
-			// Winbond W29EE011 part
-			rest_addr = 0x7f;
-			sec_mask = 0x1ff80;
-			addr = 0;
-			if (qla2x00_erase_flash_sector(ha, addr, sec_mask,
-			    mid)) {
-				status = 1;
-				break;
-			}
-		} else {
-			// Am29F010 part
-			rest_addr = 0x3fff;
-			sec_mask = 0x1c000;
-		}
-
-		midpoint = FLASH_IMAGE_SIZE / 2;
-		for (addr = 0; addr < FLASH_IMAGE_SIZE; addr++) {
-			data = *image++;
-			/* Are we at the beginning of a sector? */
-			if (!(addr & rest_addr)) {
-				if (addr == midpoint)
-					WRT_REG_WORD(&reg->nvram, NVR_SELECT);
-
-				/* Then erase it */
-				if (qla2x00_erase_flash_sector(ha, addr,
-				    sec_mask, mid)) {
-					status = 1;
-					break;
-				}
-
-				sec_number++;
-			}
-			if (mid == 0x6d) {
-				if (sec_number == 1 &&
-				    (addr == (rest_addr - 1))) {
-					rest_addr = 0x0fff;
-					sec_mask   = 0x1f000;
-				} else if (sec_number == 3 && (addr & 0x7ffe)) {
-					rest_addr = 0x3fff;
-					sec_mask   = 0x1c000;
-				}
-			}
-
-			if (qla2x00_program_flash_address(ha, addr, data,
-			    mid)) {
-				status = 1;
-				break;
-			}
-		}
-	} while (0);
-
-	qla2x00_flash_disable(ha);
-
-	return (status);
-}
