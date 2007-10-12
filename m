From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] aic94xx: update BIOS image from user space.
Date: Thu, 11 Oct 2007 19:01:58 -0700
Message-ID: <1192154518.6403.2.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:44138 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbXJLCCU (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 22:02:20 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id EEF5A20DF79
	for <Linux-scsi@vger.kernel.org>; Thu, 11 Oct 2007 19:02:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

 1. Create a file "update_bios" in sysfs to allow user to
    update bios from user space.

 2. The BIOS image file can be downloaded from web site 
    "http://www.adaptec.com/en-US/downloads/bios_fw/bios_fw_ver?productId=SAS-48300&dn=Adaptec+Serial+Attached+SCSI+48300"
    and copy the BIOS image into /lib/firmware folder.

 3. The aic994xx will accept "update bios_file" and "verify bios_file"
    commands to perform update and verify BIOS image .

    For example:

     Type "echo "update asc483c01.ufi" > /sys/devices/.../update_bios"
          to update BIOS image from /lib/firmware/as483c01.ufi file
          into HBA's flash memory.

     Type "echo "verify asc483c01.ufi" > /sys/devices/.../update_bios"
          to verify BIOS image between /lib/firmware/asc48c01.ufi file
          and HBA's flash memory.

 4. Type "cat  /sys/devices/.../update_bios" to view the status or
    result of updating BIOS.




Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

diff -urN a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-10-10 17:13:55.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-10-11 18:38:58.000000000 -0700
@@ -72,6 +72,7 @@
 	u8     manuf;
 	u8     dev_id;
 	u8     sec_prot;
+	u8     method;
 
 	u32    dir_offs;
 };
@@ -216,6 +217,8 @@
 	struct dma_pool  *scb_pool;
 
 	struct asd_seq_data  seq; /* sequencer related */
+	u32    bios_status;
+	const struct firmware *bios_image;
 };
 
 /* ---------- Common macros ---------- */
diff -urN a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-10 17:13:29.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	2007-10-11 19:31:03.000000000 -0700
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/firmware.h>
 
 #include <scsi/scsi_host.h>
 
@@ -36,6 +37,7 @@
 #include "aic94xx_reg.h"
 #include "aic94xx_hwi.h"
 #include "aic94xx_seq.h"
+#include "aic94xx_sds.h"
 
 /* The format is "version.release.patchlevel" */
 #define ASD_DRIVER_VERSION "1.0.3"
@@ -313,6 +315,180 @@
 }
 static DEVICE_ATTR(pcba_sn, S_IRUGO, asd_show_dev_pcba_sn, NULL);
 
+#define FLASH_CMD_NONE      0x00
+#define FLASH_CMD_UPDATE    0x01
+#define FLASH_CMD_VERIFY    0x02
+
+struct flash_command {
+     u8      command[8];
+     int     code;
+};
+
+static struct flash_command flash_command_table[] =
+{
+     {"verify",      FLASH_CMD_VERIFY},
+     {"update",      FLASH_CMD_UPDATE},
+     {"",            FLASH_CMD_NONE}      /* Last entry should be NULL. */
+};
+
+
+struct error_bios{     char    *reason;     int     err_code;
+};
+
+static struct error_bios flash_error_table[] =
+{
+     {"Failed to open bios image file",      FAIL_OPEN_BIOS_FILE},
+     {"PCI ID mismatch",                     FAIL_CHECK_PCI_ID},
+     {"Checksum mismatch",                   FAIL_CHECK_SUM},
+     {"Unknown Error",                       FAIL_UNKNOWN},
+     {"Failed to verify.",                   FAIL_VERIFY},
+     {"Failed to reset flash chip.",         FAIL_RESET_FLASH},
+     {"Failed to find flash chip type.",     FAIL_FIND_FLASH_ID},
+     {"Failed to erash flash chip.",         FAIL_ERASE_FLASH},
+     {"Failed to program flash chip.",       FAIL_WRITE_FLASH},
+     {"Flash in progress",                   FLASH_IN_PROGRESS},
+     {"Image file size Error",               FAIL_FILE_SIZE},
+     {"Input parameter error",               FAIL_PARAMETERS},
+     {"Out of memory",                       FAIL_OUT_MEMORY},
+     {"OK", 0}	/* Last entry err_code = 0. */
+};
+
+static ssize_t asd_store_update_bios(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct asd_ha_struct *asd_ha = dev_to_asd_ha(dev);
+	char *cmd_ptr, *filename_ptr;
+	struct bios_file_header header, *hdr_ptr;
+	int res, i;
+	u32 csum = 0;
+	int flash_command = FLASH_CMD_NONE;
+	int err = 0;
+
+
+	cmd_ptr = kzalloc(count*2, GFP_KERNEL);
+
+	if (!cmd_ptr) {
+		err = FAIL_OUT_MEMORY;
+		goto out;
+	}
+
+	filename_ptr = cmd_ptr + count;
+	res = sscanf(buf, "%s %s", cmd_ptr, filename_ptr);
+	if (res != 2) {
+		err = FAIL_PARAMETERS;
+		goto out1;
+	}
+
+	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
+		if (!memcmp(flash_command_table[i].command,
+				 cmd_ptr, strlen(cmd_ptr))) {
+			flash_command = flash_command_table[i].code;
+			break;
+		}
+	}
+	if (flash_command == FLASH_CMD_NONE) {
+		err = FAIL_PARAMETERS;
+		goto out1;
+	}
+
+	if (asd_ha->bios_status == FLASH_IN_PROGRESS) {
+		err = FLASH_IN_PROGRESS;
+		goto out1;
+	}
+	err = request_firmware(&asd_ha->bios_image,
+				   filename_ptr,
+				   &asd_ha->pcidev->dev);
+	if (err) {
+		asd_printk("Failed to load bios image file %s, error %d\n",
+			   filename_ptr, err);
+		err = FAIL_OPEN_BIOS_FILE;
+		goto out1;
+	}
+
+	hdr_ptr = (struct bios_file_header *)asd_ha->bios_image->data;
+
+	if ((hdr_ptr->contrl_id.vendor != asd_ha->pcidev->vendor ||
+		hdr_ptr->contrl_id.device != asd_ha->pcidev->device) &&
+		(hdr_ptr->contrl_id.sub_vendor != asd_ha->pcidev->vendor ||
+		hdr_ptr->contrl_id.sub_device != asd_ha->pcidev->device)) {
+
+		ASD_DPRINTK("The PCI vendor or device id does not match\n");
+		ASD_DPRINTK("vendor=%x dev=%x sub_vendor=%x sub_dev=%x"
+		" pci vendor=%x pci dev=%x\n",
+		hdr_ptr->contrl_id.vendor,
+		hdr_ptr->contrl_id.device,
+		hdr_ptr->contrl_id.sub_vendor,
+		hdr_ptr->contrl_id.sub_device,
+		asd_ha->pcidev->vendor,
+		asd_ha->pcidev->device);
+		err = FAIL_CHECK_PCI_ID;
+		goto out2;
+	}
+
+	if (hdr_ptr->filelen != asd_ha->bios_image->size) {
+		err = FAIL_FILE_SIZE;
+		goto out2;
+	}
+
+	/* calculate checksum */
+	for (i = 0; i < hdr_ptr->filelen; i++)
+		csum += asd_ha->bios_image->data[i];
+
+	if ((csum & 0x0000ffff) != hdr_ptr->checksum) {
+		ASD_DPRINTK("BIOS file checksum mismatch\n");
+		err = FAIL_CHECK_SUM;
+		goto out2;
+	}
+	if (flash_command == FLASH_CMD_UPDATE) {
+		asd_ha->bios_status = FLASH_IN_PROGRESS;
+		err = asd_write_flash_seg(asd_ha,
+			&asd_ha->bios_image->data[sizeof(*hdr_ptr)],
+			0, hdr_ptr->filelen-sizeof(*hdr_ptr));
+		if (!err)
+			err = asd_verify_flash_seg(asd_ha,
+				&asd_ha->bios_image->data[sizeof(*hdr_ptr)],
+				0, hdr_ptr->filelen-sizeof(*hdr_ptr));
+	} else {
+		asd_ha->bios_status = FLASH_IN_PROGRESS;
+		err = asd_verify_flash_seg(asd_ha,
+			&asd_ha->bios_image->data[sizeof(header)],
+			0, hdr_ptr->filelen-sizeof(header));
+	}
+
+out2:
+	release_firmware(asd_ha->bios_image);
+out1:
+	kfree(cmd_ptr);
+out:
+	asd_ha->bios_status = err;
+
+	if (!err)
+		return count;
+	else
+		return -err;
+}
+
+static ssize_t asd_show_update_bios(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	int i;
+	struct asd_ha_struct *asd_ha = dev_to_asd_ha(dev);
+	for (i = 0; flash_error_table[i].err_code != 0; i++) {
+		if (flash_error_table[i].err_code == asd_ha->bios_status)
+			break;
+	}
+	if (asd_ha->bios_status != FLASH_IN_PROGRESS)
+		asd_ha->bios_status = FLASH_OK;
+
+	return snprintf(buf, PAGE_SIZE, "status=%x %s\n",
+			flash_error_table[i].err_code,
+			flash_error_table[i].reason);
+}
+
+static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUGO,
+	asd_show_update_bios, asd_store_update_bios);
+
 static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
 {
 	int err;
@@ -328,8 +504,13 @@
 	err = device_create_file(&asd_ha->pcidev->dev, &dev_attr_pcba_sn);
 	if (err)
 		goto err_biosb;
+	err = device_create_file(&asd_ha->pcidev->dev, &dev_attr_update_bios);
+	if (err)
+		goto err_update_bios;
 
 	return 0;
+err_update_bios:
+	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_pcba_sn);
 
 err_biosb:
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_bios_build);
@@ -343,6 +524,7 @@
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_revision);
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_bios_build);
 	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_pcba_sn);
+	device_remove_file(&asd_ha->pcidev->dev, &dev_attr_update_bios);
 }
 
 /* The first entry, 0, is used for dynamic ids, the rest for devices
@@ -589,6 +771,7 @@
 	asd_ha->sas_ha.dev = &asd_ha->pcidev->dev;
 	asd_ha->sas_ha.lldd_ha = asd_ha;
 
+	asd_ha->bios_status = FLASH_OK;
 	asd_ha->name = asd_dev->name;
 	asd_printk("found %s, device %s\n", asd_ha->name, pci_name(dev));
 
diff -urN a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
--- a/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-10 17:13:43.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c	2007-10-11 18:38:09.000000000 -0700
@@ -30,6 +30,7 @@
 
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
+#include "aic94xx_sds.h"
 
 /* ---------- OCM stuff ---------- */
 
@@ -1083,3 +1084,432 @@
 	kfree(flash_dir);
 	return err;
 }
+
+/**
+ * asd_verify_flash_seg - verify data with flash memory
+ * @asd_ha: pointer to the host adapter structure
+ * @src: pointer to the source data to be verified
+ * @dest_offset: offset from flash memory
+ * @bytes_to_verify: total bytes to verify
+ */
+int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
+		void *src, u32 dest_offset, u32 bytes_to_verify)
+{
+	u8 *src_buf;
+	u8 flash_char;
+	int err;
+	u32 nv_offset, reg, i;
+
+
+	reg = asd_ha->hw_prof.flash.bar;
+	src_buf = NULL;
+
+	err = FLASH_OK;
+	nv_offset = dest_offset;
+	src_buf = (u8 *)src;
+	for (i = 0; i < bytes_to_verify; i++) {
+
+		flash_char = asd_read_reg_byte(asd_ha, reg + nv_offset + i);
+		if (flash_char != src_buf[i]) {
+			err = FAIL_VERIFY;
+			break;
+		}
+	}
+	return err;
+}
+
+/**
+ * asd_write_flash_seg - write data into flash memory
+ * @asd_ha: pointer to the host adapter structure
+ * @src: pointer to the source data to be written
+ * @dest_offset: offset from flash memory
+ * @bytes_to_write: total bytes to write
+ */
+int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
+		void *src, u32 dest_offset, u32 bytes_to_write)
+{
+	u8 *src_buf;
+	u32 nv_offset, reg, i;
+	int err;
+
+
+	reg = asd_ha->hw_prof.flash.bar;
+	src_buf = NULL;
+
+	err = asd_check_flash_type(asd_ha);
+	if (err) {
+		ASD_DPRINTK("couldn't find the type of flash. err=%d\n", err);
+		return err;
+	}
+
+	nv_offset = dest_offset;
+	err = asd_erase_nv_sector(asd_ha, nv_offset, bytes_to_write);
+	if (err) {
+		ASD_DPRINTK("Erase failed at offset:0x%x\n",
+			nv_offset);
+		return err;
+	}
+
+	err = asd_reset_flash(asd_ha);
+	if (err) {
+		ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+		return err;
+	}
+
+	src_buf = (u8 *)src;
+	for (i = 0; i < bytes_to_write; i++) {
+		/* Setup program command sequence */
+		switch (asd_ha->hw_prof.flash.method) {
+
+		case FLASH_METHOD_A:
+		{
+			asd_write_reg_byte(asd_ha,
+					(reg + 0xAAA), 0xAA);
+			asd_write_reg_byte(asd_ha,
+					(reg + 0x555), 0x55);
+			asd_write_reg_byte(asd_ha,
+					(reg + 0xAAA), 0xA0);
+			asd_write_reg_byte(asd_ha,
+					(reg + nv_offset + i),
+					(*(src_buf + i)));
+			break;
+		}
+		case FLASH_METHOD_B:
+		{
+			asd_write_reg_byte(asd_ha,
+					(reg + 0x555), 0xAA);
+			asd_write_reg_byte(asd_ha,
+					(reg + 0x2AA), 0x55);
+			asd_write_reg_byte(asd_ha,
+					(reg + 0x555), 0xA0);
+			asd_write_reg_byte(asd_ha,
+					(reg + nv_offset + i),
+					(*(src_buf + i)));
+			break;
+		}
+		default:
+			break;
+		}
+		if (asd_chk_write_status(asd_ha,
+				(nv_offset + i), 0) != 0) {
+			ASD_DPRINTK("aicx: Write failed at offset:0x%x\n",
+				reg + nv_offset + i);
+			return FAIL_WRITE_FLASH;
+		}
+	}
+
+	err = asd_reset_flash(asd_ha);
+	if (err) {
+		ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+		return err;
+	}
+	return 0;
+}
+
+int asd_chk_write_status(struct asd_ha_struct *asd_ha,
+	 u32 sector_addr, u8 erase_flag)
+{
+	u32 reg;
+	u32 loop_cnt;
+	u8  nv_data1, nv_data2;
+	u8  toggle_bit1;
+
+	/*
+	 * Read from DQ2 requires sector address
+	 * while it's dont care for DQ6
+	 */
+	reg = asd_ha->hw_prof.flash.bar;
+
+	for (loop_cnt = 0; loop_cnt < 50000; loop_cnt++) {
+		nv_data1 = asd_read_reg_byte(asd_ha, reg);
+		nv_data2 = asd_read_reg_byte(asd_ha, reg);
+
+		toggle_bit1 = ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
+				 ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
+
+		if (toggle_bit1 == 0) {
+			return 0;
+		} else {
+			if (nv_data2 & FLASH_STATUS_BIT_MASK_DQ5) {
+				nv_data1 = asd_read_reg_byte(asd_ha,
+								reg);
+				nv_data2 = asd_read_reg_byte(asd_ha,
+								reg);
+				toggle_bit1 =
+				((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
+				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
+
+				if (toggle_bit1 == 0)
+					return 0;
+			}
+		}
+
+		/*
+		 * ERASE is a sector-by-sector operation and requires
+		 * more time to finish while WRITE is byte-byte-byte
+		 * operation and takes lesser time to finish.
+		 *
+		 * For some strange reason a reduced ERASE delay gives different
+		 * behaviour across different spirit boards. Hence we set
+		 * a optimum balance of 50mus for ERASE which works well
+		 * across all boards.
+		 */
+		if (erase_flag) {
+			udelay(FLASH_STATUS_ERASE_DELAY_COUNT);
+		} else {
+			udelay(FLASH_STATUS_WRITE_DELAY_COUNT);
+		}
+	}
+	return -1;
+}
+
+/**
+ * asd_hwi_erase_nv_sector - Erase the flash memory sectors.
+ * @asd_ha: pointer to the host adapter structure
+ * @flash_addr: pointer to offset from flash memory
+ * @size: total bytes to erase.
+ */
+int asd_erase_nv_sector(struct asd_ha_struct *asd_ha, u32 flash_addr, u32 size)
+{
+	u32 reg;
+	u32 sector_addr;
+
+	reg = asd_ha->hw_prof.flash.bar;
+
+	/* sector staring address */
+	sector_addr = flash_addr & FLASH_SECTOR_SIZE_MASK;
+
+	/*
+	 * Erasing an flash sector needs to be done in six consecutive
+	 * write cyles.
+	 */
+	while (sector_addr < flash_addr+size) {
+		switch (asd_ha->hw_prof.flash.method) {
+
+		case FLASH_METHOD_A:
+			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0xAA);
+			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x55);
+			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0x80);
+			asd_write_reg_byte(asd_ha, (reg + 0xAAA), 0xAA);
+			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x55);
+			asd_write_reg_byte(asd_ha, (reg + sector_addr), 0x30);
+			break;
+
+		case FLASH_METHOD_B:
+			asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
+			asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
+			asd_write_reg_byte(asd_ha, (reg + 0x555), 0x80);
+			asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
+			asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
+			asd_write_reg_byte(asd_ha, (reg + sector_addr), 0x30);
+			break;
+
+		default:
+			break;
+		}
+
+		if (asd_chk_write_status(asd_ha, sector_addr, 1) != 0)
+			return FAIL_ERASE_FLASH;
+
+		sector_addr += FLASH_SECTOR_SIZE;
+	}
+
+	return 0;
+}
+
+int asd_check_flash_type(struct asd_ha_struct *asd_ha)
+{
+	u8 manuf_id;
+	u8 dev_id;
+	u8 sec_prot;
+	u32 inc;
+	u32 reg;
+	int err;
+
+	/* get Flash memory base address */
+	reg = asd_ha->hw_prof.flash.bar;
+
+
+	/* Determine flash info */
+	err = asd_reset_flash(asd_ha);
+	if (err) {
+		ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+		return err;
+	}
+
+	asd_ha->hw_prof.flash.method = FLASH_METHOD_UNKNOWN;
+	asd_ha->hw_prof.flash.manuf = FLASH_MANUF_ID_UNKNOWN;
+	asd_ha->hw_prof.flash.dev_id = FLASH_DEV_ID_UNKNOWN;
+
+	/* Get flash info. This would most likely be AMD Am29LV family flash.
+	 * First try the sequence for word mode.  It is the same as for
+	 * 008B (byte mode only), 160B (word mode) and 800D (word mode).
+	 */
+	inc = asd_ha->hw_prof.flash.wide ? 2 : 1;
+	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0xAA);
+	asd_write_reg_byte(asd_ha, reg + 0x555, 0x55);
+	asd_write_reg_byte(asd_ha, reg + 0xAAA, 0x90);
+	manuf_id = asd_read_reg_byte(asd_ha, reg);
+	dev_id = asd_read_reg_byte(asd_ha, reg + inc);
+	sec_prot = asd_read_reg_byte(asd_ha, reg + inc + inc);
+	/* Get out of autoselect mode. */
+	err = asd_reset_flash(asd_ha);
+	if (err) {
+		ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+		return err;
+	}
+	ASD_DPRINTK("Flash MethodA manuf_id(0x%x) dev_id(0x%x) "
+		"sec_prot(0x%x)\n", manuf_id, dev_id, sec_prot);
+	err = asd_reset_flash(asd_ha);
+	if (err != 0)
+		return err;
+
+	switch (manuf_id) {
+
+	case FLASH_MANUF_ID_AMD:
+
+		switch (sec_prot) {
+
+		case FLASH_DEV_ID_AM29LV800DT:
+		case FLASH_DEV_ID_AM29LV640MT:
+		case FLASH_DEV_ID_AM29F800B:
+			asd_ha->hw_prof.flash.method = FLASH_METHOD_A;
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case FLASH_MANUF_ID_ST:
+
+		switch (sec_prot) {
+
+		case FLASH_DEV_ID_STM29W800DT:
+		case FLASH_DEV_ID_STM29LV640:
+			asd_ha->hw_prof.flash.method = FLASH_METHOD_A;
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case FLASH_MANUF_ID_FUJITSU:
+
+		switch (sec_prot) {
+
+		case FLASH_DEV_ID_MBM29LV800TE:
+		case FLASH_DEV_ID_MBM29DL800TA:
+			asd_ha->hw_prof.flash.method = FLASH_METHOD_A;
+			break;
+
+		}
+		break;
+
+	case FLASH_MANUF_ID_MACRONIX:
+
+		switch (sec_prot) {
+
+		case FLASH_DEV_ID_MX29LV800BT:
+			asd_ha->hw_prof.flash.method = FLASH_METHOD_A;
+			break;
+		}
+		break;
+	}
+
+	if (asd_ha->hw_prof.flash.method == FLASH_METHOD_UNKNOWN) {
+
+		err = asd_reset_flash(asd_ha);
+		if (err) {
+			ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+			return err;
+		}
+
+		/* Issue Unlock sequence for AM29LV008BT */
+		asd_write_reg_byte(asd_ha, (reg + 0x555), 0xAA);
+		asd_write_reg_byte(asd_ha, (reg + 0x2AA), 0x55);
+		asd_write_reg_byte(asd_ha, (reg + 0x555), 0x90);
+		manuf_id = asd_read_reg_byte(asd_ha, reg);
+		dev_id = asd_read_reg_byte(asd_ha, reg + inc);
+		sec_prot = asd_read_reg_byte(asd_ha, reg + inc + inc);
+
+		ASD_DPRINTK("Flash MethodB manuf_id(0x%x) dev_id(0x%x) sec_prot"
+			"(0x%x)\n", manuf_id, dev_id, sec_prot);
+
+		err = asd_reset_flash(asd_ha);
+		if (err != 0) {
+			ASD_DPRINTK("couldn't reset flash. err=%d\n", err);
+			return err;
+		}
+
+		switch (manuf_id) {
+		case FLASH_MANUF_ID_AMD:
+
+			switch (dev_id) {
+
+			case FLASH_DEV_ID_AM29LV008BT:
+				asd_ha->hw_prof.flash.method = FLASH_METHOD_B;
+				break;
+			default:
+				break;
+			}
+			break;
+
+		case FLASH_MANUF_ID_ST:
+
+			switch (dev_id) {
+
+			case FLASH_DEV_ID_STM29008:
+				asd_ha->hw_prof.flash.method = FLASH_METHOD_B;
+				break;
+			default:
+				break;
+			}
+			break;
+
+		case FLASH_MANUF_ID_FUJITSU:
+
+			switch (dev_id) {
+
+			case FLASH_DEV_ID_MBM29LV008TA:
+				asd_ha->hw_prof.flash.method = FLASH_METHOD_B;
+				break;
+
+			}
+			break;
+
+		case FLASH_MANUF_ID_INTEL:
+
+			switch (dev_id) {
+
+			case FLASH_DEV_ID_I28LV00TAT:
+				asd_ha->hw_prof.flash.method = FLASH_METHOD_B;
+				break;
+
+			}
+			break;
+
+		case FLASH_MANUF_ID_MACRONIX:
+
+			switch (dev_id) {
+
+			case FLASH_DEV_ID_I28LV00TAT:
+				asd_ha->hw_prof.flash.method = FLASH_METHOD_B;
+				break;
+
+			}
+			break;
+
+		default:
+			return FAIL_FIND_FLASH_ID;
+		}
+	}
+
+	if (asd_ha->hw_prof.flash.method == FLASH_METHOD_UNKNOWN)
+	      return FAIL_FIND_FLASH_ID;
+
+
+	asd_ha->hw_prof.flash.manuf = manuf_id;
+	asd_ha->hw_prof.flash.dev_id = dev_id;
+	asd_ha->hw_prof.flash.sec_prot = sec_prot;
+	return 0;
+}
diff -urN a/drivers/scsi/aic94xx/aic94xx_sds.h b/drivers/scsi/aic94xx/aic94xx_sds.h
--- a/drivers/scsi/aic94xx/aic94xx_sds.h	1969-12-31 16:00:00.000000000 -0800
+++ b/drivers/scsi/aic94xx/aic94xx_sds.h	2007-10-11 18:38:06.000000000 -0700
@@ -0,0 +1,167 @@
+/*
+ * Aic94xx SAS/SATA driver hardware interface header file.
+ *
+ * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+ * Copyright (C) 2005 Gilbert Wu <gilbert_wu@adaptec.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This file is part of the aic94xx driver.
+ *
+ * The aic94xx driver is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * The aic94xx driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the aic94xx driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+#ifndef _AIC94XX_SDS_H_
+#define _AIC94XX_SDS_H_
+
+enum {
+	FLASH_METHOD_UNKNOWN,
+	FLASH_METHOD_A,
+	FLASH_METHOD_B
+};
+
+#define FLASH_MANUF_ID_AMD              0x01
+#define FLASH_MANUF_ID_ST               0x20
+#define FLASH_MANUF_ID_FUJITSU          0x04
+#define FLASH_MANUF_ID_MACRONIX         0xC2
+#define FLASH_MANUF_ID_INTEL            0x89
+#define FLASH_MANUF_ID_UNKNOWN          0xFF
+
+#define FLASH_DEV_ID_AM29LV008BT        0x3E
+#define FLASH_DEV_ID_AM29LV800DT        0xDA
+#define FLASH_DEV_ID_STM29W800DT        0xD7
+#define FLASH_DEV_ID_STM29LV640         0xDE
+#define FLASH_DEV_ID_STM29008           0xEA
+#define FLASH_DEV_ID_MBM29LV800TE       0xDA
+#define FLASH_DEV_ID_MBM29DL800TA       0x4A
+#define FLASH_DEV_ID_MBM29LV008TA       0x3E
+#define FLASH_DEV_ID_AM29LV640MT        0x7E
+#define FLASH_DEV_ID_AM29F800B          0xD6
+#define FLASH_DEV_ID_MX29LV800BT        0xDA
+#define FLASH_DEV_ID_MX29LV008CT        0xDA
+#define FLASH_DEV_ID_I28LV00TAT         0x3E
+#define FLASH_DEV_ID_UNKNOWN            0xFF
+/* status bit mask values */
+#define FLASH_STATUS_BIT_MASK_DQ6       0x40
+#define FLASH_STATUS_BIT_MASK_DQ5       0x20
+#define FLASH_STATUS_BIT_MASK_DQ2       0x04
+
+/* minimum value in micro seconds needed for checking status */
+#define FLASH_STATUS_ERASE_DELAY_COUNT  50
+#define FLASH_STATUS_WRITE_DELAY_COUNT  25
+
+#define FLASH_SECTOR_SIZE               0x010000
+#define FLASH_SECTOR_SIZE_MASK          0xffff0000
+
+
+
+#define FLASH_OK                        0x000000
+#define FAIL_OPEN_BIOS_FILE             0x000100
+#define FAIL_CHECK_PCI_ID               0x000200
+#define FAIL_CHECK_SUM                  0x000300
+#define FAIL_UNKNOWN                    0x000400
+#define FAIL_VERIFY                     0x000500
+#define FAIL_RESET_FLASH                0x000600
+#define FAIL_FIND_FLASH_ID              0x000700
+#define FAIL_ERASE_FLASH                0x000800
+#define FAIL_WRITE_FLASH                0x000900
+#define FAIL_FILE_SIZE                  0x000a00
+#define FAIL_PARAMETERS                 0x000b00
+#define FAIL_OUT_MEMORY                 0x000c00
+#define FLASH_IN_PROGRESS               0x001000
+
+
+struct controller_id
+{
+    u32 vendor;
+    /* PCI Vendor ID */
+
+    u32 device;
+    /* PCI Device ID */
+
+    u32 sub_vendor;
+    /* PCI Subvendor ID */
+
+    u32 sub_device;
+    /* PCI Subdevice ID */
+
+};
+struct image_info
+{
+	u32 ImageId;
+	/*Identifies the image(e.g 0=Footbridge image,1=Drawbridge image)*/
+
+	u32 ImageOffset;
+	/*Offset of the image from the beginning of the file*/
+
+	u32 ImageLength;
+	/*length of the image*/
+
+	u32 ImageChecksum;
+	/*Image checksum*/
+
+	u32 ImageVersion;
+	/*Version of the image, could be build number*/
+};
+
+struct bios_file_header
+{
+	u8 signature[32];
+	/* Signature/Cookie to identify the file*/
+	/* The signature above is only 25 characters long.  */
+
+	u32 checksum;
+	/*Entire file checksum with this field zero*/
+
+	u32 antidote;
+	/*Entire file checksum antidote with this field 0xFFFFFFFF*/
+
+	struct controller_id contrl_id;
+	/*Controller id to identify the controller whose images are*/
+	/*stored in the file.  */
+
+	u32 filelen;
+	/*Length of the entire file*/
+
+	u32 chunk_num;
+	/*The chunk/part number of this DOS file in case the Image */
+	/*is stored in parts in multiple DOS files across floppies*/
+
+	u32 total_chunks;
+	/*Total number of chunks/parts in which the image file is stored*/
+
+	u32 num_images;
+	/*Number of images in the file,e.g Footbridge image, Drawbridge image*/
+
+	u32 build_num;
+	/*Build number of the process that generated this image*/
+
+	struct image_info image_header;
+};
+
+int asd_verify_flash_seg(struct asd_ha_struct *asd_ha,
+		void *src, u32 dest_offset, u32 bytes_to_verify);
+int asd_write_flash_seg(struct asd_ha_struct *asd_ha,
+		void *src, u32 dest_offset, u32 bytes_to_write);
+int asd_chk_write_status(struct asd_ha_struct *asd_ha,
+		u32 sector_addr, u8 erase_flag);
+int asd_check_flash_type(struct asd_ha_struct *asd_ha);
+int asd_erase_nv_sector(struct asd_ha_struct *asd_ha,
+		u32 flash_addr, u32 size);
+#endif
+
+
+
+

