From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: [PATCH] pm8001: support HDA (flashless) mode (take 3)
Date: Fri, 4 May 2012 07:33:25 -0400
Message-ID: <6C34E1B4-8631-4CB3-8A8A-B075968F65E6@xyratex.com>
References: <9D3C8933-99C4-45AD-A046-C393A2071F3A@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: multipart/mixed; boundary="Apple-Mail=_7B490D87-E67B-436F-9511-74A878E2589D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:46682 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754928Ab2EDLda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 07:33:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, Jack Wang <jack_wang@usish.com>, James Bottomley <JBottomley@parallels.com>, lindar_liu <lindar_liu@usish.com>, =?utf-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>, john_gong <john_gong@usish.com>


--Apple-Mail=_7B490D87-E67B-436F-9511-74A878E2589D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Third time IS the charm :-)

The pm8001 can be delivered as a standalone product with =
flash-programmed
firmware images, or without the flash present requiring the driver to =
upload
the images into the chip's RAM and then run. This is called flashless =
HDA mode.

We add support for this firmware upload in the enclosed patch. We try =
some
basic initialization checks of the Firmware, and if it appears dead, we =
make
the assumption the adapter must in-fact be halted in this HDA mode. The
Firmware images themselves have not been cleared for open-release by =
PMC, but
they are available in OpenSolaris <hint hint>. PMC's rationalization for =
not
wanting an open-release of the Firmware Images is that they do not want =
to
take support calls except from paying OEMs (such as Xyratex) that are =
embedding
PMC product into the motherboards and thus may have a tested combination =
of
Firmware and Hardware. Please respect this sentiment. Images are =
expected in:

/lib/firmware/aap1img.bin
/lib/firmware/ilaimg.bin
/lib/firmware/iopimg.bin
/lib/firmware/istrimg.bin

using the exact same naming convention as PMC and in OpenSolaris (and =
its
followon children) for these image files.

Take 2 of the patch, added manifests MAIN_HDA_FLAGS_FORCE_HDA and
MAIN_HDA_FLAGS_HDA_FW to check against the bit value of .hda_mode_flag
if the SEEPROM is forcing HDA flashless mode.

Take 3 of the patch, added hot-plug reset operations, dropped some
unnecessary but inert duplicated operations and dropped the firmware
images down one level into /lib/firmware/pm8001/ directory.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
Review-by: Jack Wang <jack_wang@usish.com>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: lindar_liu@usish.com
Cc: crystal_yu@usish.com
Cc: john_gong@usish.com

 drivers/scsi/pm8001/pm8001_hwi.c  |  582 =
+++++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |   40 ++
 drivers/scsi/pm8001/pm8001_init.c |   36 ++
 drivers/scsi/pm8001/pm8001_sas.h  |    3=20
 4 files changed, 616 insertions(+), 45 deletions(-)


--Apple-Mail=_7B490D87-E67B-436F-9511-74A878E2589D
Content-Disposition: attachment;
	filename=pm8001-hda-3.patch
Content-Type: application/octet-stream;
	name="pm8001-hda-3.patch"
Content-Transfer-Encoding: 7bit

The pm8001 can be delivered as a standalone product with flash-programmed
firmware images, or without the flash present requiring the driver to upload
the images into the chip's RAM and then run. This is called flashless HDA mode.

We add support for this firmware upload in the enclosed patch. We try some
basic initialization checks of the Firmware, and if it appears dead, we make
the assumption the adapter must in-fact be halted in this HDA mode. The
Firmware images themselves have not been cleared for open-release by PMC, but
they are available in OpenSolaris <hint hint>. PMC's rationalization for not
wanting an open-release of the Firmware Images is that they do not want to
take support calls except from paying OEMs (such as Xyratex) that are embedding
PMC product into the motherboards and thus may have a tested combination of
Firmware and Hardware. Please respect this sentiment. Images are expected in:

/lib/firmware/aap1img.bin
/lib/firmware/ilaimg.bin
/lib/firmware/iopimg.bin
/lib/firmware/istrimg.bin

using the exact same naming convention as PMC and in OpenSolaris (and its
followon children) for these image files.

Take 2 of the patch, added manifests MAIN_HDA_FLAGS_FORCE_HDA and
MAIN_HDA_FLAGS_HDA_FW to check against the bit value of .hda_mode_flag
if the SEEPROM is forcing HDA flashless mode.

Take 3 of the patch, added hot-plug reset operations, dropped some
unnecessary but inert duplicated operations and dropped the firmware
images into /lib/firmware/pm8001/ directory.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: lindar_liu@usish.com
Cc: crystal_yu@usish.com
Cc: john_gong@usish.com

 drivers/scsi/pm8001/pm8001_hwi.c  |  582 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |   40 ++
 drivers/scsi/pm8001/pm8001_init.c |   36 ++
 drivers/scsi/pm8001/pm8001_sas.h  |    3 
 4 files changed, 616 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 8477df4..2c30cb0 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -37,11 +37,13 @@
  * POSSIBILITY OF SUCH DAMAGES.
  *
  */
- #include <linux/slab.h>
- #include "pm8001_sas.h"
- #include "pm8001_hwi.h"
- #include "pm8001_chips.h"
- #include "pm8001_ctl.h"
+#include <linux/slab.h>
+#include "pm8001_sas.h"
+#include "pm8001_hwi.h"
+#include "pm8001_chips.h"
+#include "pm8001_ctl.h"
+
+#include <linux/firmware.h>
 
 /**
  * read_main_config_table - read the configure table and save it.
@@ -63,6 +65,9 @@ static void __devinit read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		pm8001_mr32(address, MAIN_OBQ_OFFSET);
 	pm8001_ha->main_cfg_tbl.hda_mode_flag	=
 		pm8001_mr32(address, MAIN_HDA_FLAGS_OFFSET);
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("MAIN_HDA_FLAGS = 0x%x\n",
+			pm8001_ha->main_cfg_tbl.hda_mode_flag));
 
 	/* read analog Setting offset from the configuration table */
 	pm8001_ha->main_cfg_tbl.anolog_setup_table_offset =
@@ -597,6 +602,479 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 		base_addr + pm8001_cr32(pm8001_ha, pcibar, offset + 0x20);
 }
 
+static void pm8001_hda_send_cmd(struct pm8001_hba_info *pm8001_ha,
+				u32 arg_array[], u32 num_args, u32 cmd)
+{
+	u32	reg;
+	u32	i;
+
+	for (i = 0; i < num_args; i++)
+		pm8001_cw32(pm8001_ha, 3, HDA_CMD_OFFSET+(i*4), arg_array[i]);
+
+	reg = pm8001_cr32(pm8001_ha, 3, HDA_CMD_OFFSET+28);
+	reg = (reg & HDA_SEQ_ID_BITS) >> 16;
+	if (reg == 0xff)
+		reg = 0;
+	reg++;
+	reg = ((HDA_C_PA << 24) | (reg << 16) |  cmd);
+	pm8001_cw32(pm8001_ha, 3, HDA_CMD_OFFSET+28, reg);
+}
+
+static u32 pm8001_hda_recv_rsp(struct pm8001_hba_info *pm8001_ha, u32 cmd)
+{
+	u32	rsp;
+	u32	i = 0;
+
+	do {
+		mdelay(10);
+		rsp = pm8001_cr32(pm8001_ha, 3, HDA_CMD_OFFSET+28);
+		rsp = rsp & HDA_CODE_BITS;
+
+		switch (cmd) {
+		case HDAC_CMD_EXEC:
+			if (rsp == HDA_RSP_EXEC)
+				return 1;
+			if (rsp == HDA_RSP_BAD_IMG)
+				return 0;
+			if (rsp == HDA_RSP_BAD_CMD)
+				return 0;
+			break;
+		}
+		i++;
+	} while (i < 200);
+
+	return 1;
+}
+
+static u32 pm8001_bar4_cpy(struct pm8001_hba_info *pm8001_ha,
+	u32 base, u32 offset, const unsigned char array[], u32 alen)
+{
+	u32	dbase;
+	u32	doffset;
+	u32	*larray;
+	u32	val;
+	u32	csize;
+	u32	wc;
+	u32	i = 0;
+	unsigned long flags;
+
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("alen = 0x%x\n", alen));
+
+	dbase = (base+offset) & MB3_SHIFT_MASK;
+	doffset = offset & MB3_OFFSET_MASK;
+	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	do {
+		if (-1 == pm8001_bar4_shift(pm8001_ha, dbase)) {
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			return 0;
+		}
+
+		if ((doffset+alen) > SIZE_64KB)
+			csize = SIZE_64KB - doffset;
+		else
+			csize = alen;
+
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR dbase = 0x%x\n", dbase));
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR doffset = 0x%x\n", doffset));
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR size = 0x%x\n", csize));
+
+		wc = ((csize % 4) > 0) ? ((csize / 4) + 1) : (csize / 4);
+		larray = (u32 *)array;
+		for (i = 0; i < wc; i++) {
+			val = larray[i];
+			pm8001_cw32(pm8001_ha, 2, (doffset + (i*4)), val);
+		}
+
+		alen -= csize;
+		dbase += SIZE_64KB;
+		doffset = 0;
+		array = array + csize;
+	} while (alen != 0);
+
+	if (-1 == pm8001_bar4_shift(pm8001_ha, 0x0)) {
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+
+	return 1;
+}
+
+static u32 pm8001_bar4_cpy_big(struct pm8001_hba_info *pm8001_ha,
+	u32 base, u32 offset, const unsigned char array[], u32 alen)
+{
+	u32	dbase;
+	u32	doffset;
+	u32	*larray;
+	u32	val;
+	u32	csize;
+	u32	wc;
+	u32	i = 0;
+	u8 *local_buffer = NULL;
+	unsigned long flags;
+
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("alen = 0x%x\n", alen));
+
+	dbase = (base+offset) & MB3_SHIFT_MASK;
+	doffset = offset & MB3_OFFSET_MASK;
+	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	do {
+		if (-1 == pm8001_bar4_shift(pm8001_ha, dbase)) {
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			return 0;
+		}
+
+		if ((doffset+alen) > SIZE_64KB)
+			csize = SIZE_64KB - doffset;
+		else
+			csize = alen;
+
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR dbase = 0x%x\n", dbase));
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR doffset = 0x%x\n", doffset));
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("ILA STR size = 0x%x\n", csize));
+
+		wc = ((csize % 4) > 0) ? ((csize / 4) + 1) : (csize / 4);
+		local_buffer = kmalloc(csize, GFP_KERNEL);
+		if (local_buffer != NULL)
+			memcpy(local_buffer, array, csize);
+		larray = (u32 *)local_buffer;
+		for (i = 0; i < wc; i++) {
+			val = larray[i];
+			pm8001_cw32(pm8001_ha, 2, (doffset + (i*4)), val);
+		}
+		kfree(local_buffer);
+		alen -= csize;
+		dbase += SIZE_64KB;
+		doffset = 0;
+		array = array + csize;
+	} while (alen != 0);
+
+	if (-1 == pm8001_bar4_shift(pm8001_ha, 0x0)) {
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+
+	return 1;
+}
+
+
+static int pm8001_ishdar_idle(struct pm8001_hba_info *pm8001_ha)
+{
+	u32     hdaw;
+	u32     pcilogic;
+
+	pcilogic = get_pci_bar_index(0x24);
+
+	hdaw = pm8001_cr32(pm8001_ha, pcilogic, HDA_RSP_OFFSET+28);
+	if ((((hdaw & HDA_PA_BITS) >> 24) == HDA_R_PA)
+	 && ((hdaw & HDA_CODE_BITS) == HDA_RSP_IDLE))
+		return 1;
+
+	return 0;
+}
+
+static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha);
+
+/* Catch-22, this is called before chip initialization, values may change */
+static int __devinit pm8001_chip_in_hda_mode(struct pm8001_hba_info *pm8001_ha)
+{
+	/* check the firmware status */
+	if (-1 == check_fw_ready(pm8001_ha)) {
+		/* Must be sick, must be in HDA mode? */
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("Firmware is not ready, in HDA mode?\n"));
+		return -EBUSY;
+	}
+	if (!pm8001_ha->main_cfg_tbl_addr)
+		init_pci_device_addresses(pm8001_ha);
+	if (!pm8001_ha->main_cfg_tbl_addr)
+		return 0;
+	if (mpi_uninit_check(pm8001_ha) != 0) {
+		/* Must be sick, must be in HDA mode? */
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("MPI state not ready, in HDA mode?\n"));
+		return 1;
+	}
+	/* SEEPROM configuration bits */
+	if (!pm8001_ha->main_cfg_tbl.hda_mode_flag)
+		read_main_config_table(pm8001_ha);
+	return pm8001_ha->main_cfg_tbl.hda_mode_flag
+	 & (MAIN_HDA_FLAGS_FORCE_HDA|MAIN_HDA_FLAGS_HDA_FW);
+}
+
+static int
+pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha, u32 signature);
+
+static int pm8001_chip_hda_mode(struct pm8001_hba_info *pm8001_ha)
+{
+	int	i = 0;
+	u32	arga[6];
+	u32	reg;
+	u32	aap1_offset;
+	u32	fw_offset;
+	u32	pad1;
+	u32	pad2;
+	u8 *istr_buffer = NULL;
+	u32 istr_length = 0;
+	u8 *ila_buffer = NULL;
+	u32 ila_length = 0;
+	u32 aap1_length = 0;
+	u32 iop_length = 0;
+	u8 firmware_released = true;
+
+	/*get initial string image*/
+	if (request_firmware(&pm8001_ha->fw_image, "pm8001/istrimg.bin",
+			pm8001_ha->dev) != 0) {
+		pm8001_printk("Can not get istrimg.bin\n");
+		goto err_out_hda;
+	}
+	istr_length = pm8001_ha->fw_image->size;
+	pm8001_printk("Get istrimg.bin, length is %x\n", istr_length);
+	istr_buffer = kmalloc(pm8001_ha->fw_image->size, GFP_KERNEL);
+	if (istr_buffer == NULL) {
+		release_firmware(pm8001_ha->fw_image);
+		goto err_out_hda;
+	}
+
+	memcpy(istr_buffer, pm8001_ha->fw_image->data,
+		pm8001_ha->fw_image->size);
+	release_firmware(pm8001_ha->fw_image);
+
+	/*Get ILA image*/
+	if (request_firmware(&pm8001_ha->fw_image, "pm8001/ilaimg.bin",
+			pm8001_ha->dev) != 0) {
+		pm8001_printk("Can not get ilaimg.bin\n");
+		goto err_out_hda;
+	}
+
+	ila_length = pm8001_ha->fw_image->size;
+	pm8001_printk("Get ilaimg.bin, length is %x\n", ila_length);
+	ila_buffer = kmalloc(pm8001_ha->fw_image->size, GFP_KERNEL);
+	if (ila_buffer == NULL) {
+		release_firmware(pm8001_ha->fw_image);
+		goto err_out_hda;
+	}
+
+	memcpy(ila_buffer, pm8001_ha->fw_image->data,
+		pm8001_ha->fw_image->size);
+	release_firmware(pm8001_ha->fw_image);
+
+	/*get aap1 image*/
+	if (request_firmware(&pm8001_ha->fw_image, "pm8001/aap1img.bin",
+			pm8001_ha->dev) != 0) {
+		pm8001_printk("Can not get aap1img.bin\n");
+		goto err_out_hda;
+	}
+	aap1_length = pm8001_ha->fw_image->size;
+	pm8001_printk("Get aap1img.bin, length is %x\n", aap1_length);
+
+	firmware_released = false;
+
+	/* Try soft reset until it goes into HDA mode */
+	i = 0;
+	do {
+		if (pm8001_ishdar_idle(pm8001_ha))
+			break;
+		pm8001_chip_soft_rst(pm8001_ha, SPC_HDASOFT_RESET_SIGNATURE);
+		mdelay(10);
+		i++;
+	} while (i < 2);
+	if ((i != 2) && !pm8001_ishdar_idle(pm8001_ha)) {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("SPC_HDASOFT_RESET: failed!\n"));
+		goto err_out_hda;
+	}
+
+	/* HDA Mode - Clear ODMR and ODCR */
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+
+	/* Step 1: Poll HDA_RSP_IDLE - HDA mode */
+	i = 0;
+	do {
+		mdelay(10);
+		if (pm8001_ishdar_idle(pm8001_ha))
+			break;
+		i++;
+	} while (i < 200);
+	if (i == 200) {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("HDA Mode: Timeout!\n")); /* 2 sec */
+		goto err_out_hda;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("HDA Mode!\n"));
+
+	/* Step 2: Push the init string to 0x0047E000 & data compare */
+	pm8001_printk("istrimage length is %x\n", istr_length);
+	if (!pm8001_bar4_cpy(pm8001_ha, GSM_HDA_ILA_STR_BASE,
+			GSM_ILA_STR_OFFSET, istr_buffer, istr_length))
+		goto err_out_hda;
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("ILA Str cpy done!\n"));
+
+	/* Tell FW ISTR is ready */
+	reg = (ILA_HDA_ISTR_IMG_DONE << 24) | istr_length;
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_3, reg);
+
+	/* Step 3: Write the HDA mode SoftReset signature */
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_0,
+		SPC_HDASOFT_RESET_SIGNATURE);
+
+	/* Step 4: Push the ILA image to 0x00400000 */
+	arga[1] = ila_length;
+	if (!pm8001_bar4_cpy(pm8001_ha, GSM_HDA_ILA_BASE, GSM_HDA_ILA_OFFSET,
+			ila_buffer, ila_length))
+		goto err_out_hda;
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("ILA  cpy done!\n"));
+
+	/* Step 5: Tell boot ROM to authenticate ILA and execute it */
+	arga[0] = 0;
+	pm8001_hda_send_cmd(pm8001_ha, arga, 2, HDAC_CMD_EXEC);
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("CMD EXEC sent!\n"));
+
+	/*
+	 * Step 6: Checking response status from boot ROM,
+	 *         HDAR_EXEC (good), HDAR_BAD_CMD and HDAR_BAD_IMG
+	 */
+	if (!pm8001_hda_recv_rsp(pm8001_ha, HDAC_CMD_EXEC))
+		goto err_out_hda;
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("CMD EXEC rsp ok!\n"));
+
+	/* Step 7: Poll ILAHDA_AAP1IMGGET/Offset in MSGU Scratchpad 0 */
+	/* Check MSGU Scratchpad 1 [1,0] == 00 */
+	i = 0;
+	do {
+		mdelay(10);
+		reg = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
+		aap1_offset = reg & ~SCRATCH_PAD0_STATE_MASK;
+		reg = reg >> 24;
+		if (reg == ILA_HDA_AAP1_IMG_GET)
+			break;
+		i++;
+	} while (i < 200);
+	if (i == 200) {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("APP1_IMG_GET Poll timeout !\n"));
+		reg = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("scratch pad 1 = 0x%x\n", reg));
+		reg = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("scratch pad 2 = 0x%x\n", reg));
+
+		goto err_out_hda;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("APP1 img get ok!\n"));
+
+	/* Step 8: Copy AAP1 image, update the Host Scratchpad 3 */
+	reg = (ILA_HDA_AAP1_IMG_DONE << 24) | aap1_length;
+	if (!pm8001_bar4_cpy_big(pm8001_ha, GSM_HDA_ILA_BASE, aap1_offset,
+			pm8001_ha->fw_image->data, aap1_length)) {
+		release_firmware(pm8001_ha->fw_image);
+		firmware_released = true;
+		goto err_out_hda;
+	} else {
+		release_firmware(pm8001_ha->fw_image);
+		firmware_released = true;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("APP1  cpy done!\n"));
+
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_3, reg);
+
+
+	/*Get IOP image*/
+	if (request_firmware(&pm8001_ha->fw_image, "pm8001/iopimg.bin",
+			pm8001_ha->dev) != 0) {
+		pm8001_printk("Can not get istrimg.bin\n");
+		goto err_out_hda;
+	} else {
+		iop_length = pm8001_ha->fw_image->size;
+		pm8001_printk("Get iopimg.bin, length is %x\n", iop_length);
+		firmware_released = false;
+	}
+
+	/* Step 9: Poll ILAHDA_IOPIMGGET/Offset in MSGU Scratchpad 0 */
+	i = 0;
+	do {
+		mdelay(10);
+		reg = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
+		fw_offset = reg & ~SCRATCH_PAD0_STATE_MASK;
+		reg = reg >> 24;
+		if (reg == ILA_HDA_IOP_IMG_GET)
+			break;
+		i++;
+	} while (i < 200);
+	if (i == 200) {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("IOP_IMG_GET Poll timeout !\n"));
+
+		goto err_out_hda;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("IOP img get ok!\n"));
+
+	/* Step 10: Copy IOP image, update the Host Scratchpad 3 */
+	reg = (ILA_HDA_IOP_IMG_DONE << 24) | iop_length;
+	if (!pm8001_bar4_cpy_big(pm8001_ha, GSM_HDA_ILA_BASE, fw_offset,
+			pm8001_ha->fw_image->data, iop_length)) {
+		release_firmware(pm8001_ha->fw_image);
+		firmware_released = true;
+		goto err_out_hda;
+	} else {
+		release_firmware(pm8001_ha->fw_image);
+		firmware_released = true;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("IOP  cpy done!\n"));
+
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_3, reg);
+
+	/* Clear the signature */
+	pm8001_cw32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_0, 0);
+
+	/* step 11: wait for the FW and IOP to get ready - 1 sec timeout */
+	/* Wait for the SPC Configuration Table to be ready */
+	i = 0;
+	do {
+		mdelay(10);
+		pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
+		if (pad1 & SCRATCH_PAD1_RDY) {
+			pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
+			if (pad2 & SCRATCH_PAD2_RDY)
+				break;
+		}
+		i++;
+	} while (i < 200);
+
+	if (i == 200) {
+		PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("PAD 1 & 2 not Rdy !\n"));
+
+		goto err_out_hda;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("HDA Mode Complete!\n"));
+
+	kfree(istr_buffer);
+	kfree(ila_buffer);
+	if (firmware_released == false)
+		release_firmware(pm8001_ha->fw_image);
+
+	return 1;
+
+err_out_hda:
+	kfree(istr_buffer);
+	kfree(ila_buffer);
+	if (firmware_released == false)
+		release_firmware(pm8001_ha->fw_image);
+
+	return 0;
+}
+
 /**
  * pm8001_chip_init - the main init function that initialize whole PM8001 chip.
  * @pm8001_ha: our hba card information
@@ -604,7 +1082,8 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
 static int __devinit pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
 	/* check the firmware status */
-	if (-1 == check_fw_ready(pm8001_ha)) {
+	if ((pm8001_ha->rst_signature != SPC_HDASOFT_RESET_SIGNATURE)
+	 && (-1 == check_fw_ready(pm8001_ha))) {
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Firmware is not ready!\n"));
 		return -EBUSY;
@@ -704,40 +1183,60 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
 		PM8001_INIT_DBG(pm8001_ha,
 			pm8001_printk("Firmware is ready for reset .\n"));
 	} else {
-		unsigned long flags;
-		/* Trigger NMI twice via RB6 */
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
-		if (-1 == pm8001_bar4_shift(pm8001_ha, RB6_ACCESS_REG)) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("Shift Bar4 to 0x%x failed\n",
-					RB6_ACCESS_REG));
-			return -1;
-		}
-		pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET,
-			RB6_MAGIC_NUMBER_RST);
-		pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET, RB6_MAGIC_NUMBER_RST);
-		/* wait for 100 ms */
-		mdelay(100);
-		regVal = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2) &
-			SCRATCH_PAD2_FWRDY_RST;
-		if (regVal != SCRATCH_PAD2_FWRDY_RST) {
-			regVal1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-			regVal2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("TIMEOUT:MSGU_SCRATCH_PAD1"
-				"=0x%x, MSGU_SCRATCH_PAD2=0x%x\n",
-				regVal1, regVal2));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD0 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0)));
-			PM8001_FAIL_DBG(pm8001_ha,
-				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
-				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));
+		if (pm8001_ishdar_idle(pm8001_ha)) {
+			/*
+			 *	For customers wants to do soft reset even the
+			 * chip is already in HDA mode
+			 *
+			 * Do not need to trigger RB6 twice
+			 */
+			;
+		} else {
+			unsigned long flags;
+			/* Trigger NMI twice via RB6 */
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			if (-1 == pm8001_bar4_shift(pm8001_ha,
+					RB6_ACCESS_REG)) {
+				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("Shift Bar4 to 0x%x "
+						"failed\n",
+						RB6_ACCESS_REG));
+				return -1;
+			}
+			pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET,
+				RB6_MAGIC_NUMBER_RST);
+			pm8001_cw32(pm8001_ha, 2, SPC_RB6_OFFSET,
+				RB6_MAGIC_NUMBER_RST);
+			/* wait for 100 ms */
+			mdelay(100);
+			regVal = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2) &
+				SCRATCH_PAD2_FWRDY_RST;
+			if (regVal != SCRATCH_PAD2_FWRDY_RST) {
+				regVal1 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_SCRATCH_PAD_1);
+				regVal2 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_SCRATCH_PAD_2);
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("TIMEOUT:"
+						"MSGU_SCRATCH_PAD1=0x%x, "
+						"MSGU_SCRATCH_PAD2=0x%x\n",
+						regVal1, regVal2));
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("SCRATCH_PAD0 "
+						"value = 0x%x\n",
+						pm8001_cr32(pm8001_ha, 0,
+							MSGU_SCRATCH_PAD_0)));
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("SCRATCH_PAD3 "
+						"value = 0x%x\n",
+						pm8001_cr32(pm8001_ha, 0,
+							MSGU_SCRATCH_PAD_3)));
+				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				return -1;
+			}
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-			return -1;
 		}
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	}
 	return 0;
 }
@@ -1009,7 +1508,10 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha, u32 signature)
 	pm8001_cw32(pm8001_ha, 2, SPC_REG_RESET, regVal);
 
 	/* step 14: delay 10 usec - Normal Mode */
-	udelay(10);
+	if (signature == SPC_SOFT_RESET_SIGNATURE)
+		udelay(10);
+	else
+		mdelay(200);
 	/* check Soft Reset Normal mode or Soft Reset HDA mode */
 	if (signature == SPC_SOFT_RESET_SIGNATURE) {
 		/* step 15 (Normal Mode): wait until scratch pad1 register
@@ -4683,6 +5185,8 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 
 const struct pm8001_dispatch pm8001_8001_dispatch = {
 	.name			= "pmc8001",
+	.chip_in_hda_mode	= pm8001_chip_in_hda_mode,
+	.chip_hda_mode		= pm8001_chip_hda_mode,
 	.chip_init		= pm8001_chip_init,
 	.chip_soft_rst		= pm8001_chip_soft_rst,
 	.chip_rst		= pm8001_hw_chip_rst,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 1a4611e..8fd2f2e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -855,6 +855,16 @@ struct set_dev_state_resp {
 #define MSIX_INTERRUPT_DISABLE		0x1
 #define MSIX_INTERRUPT_ENABLE		0x0
 
+/* ILA codes in MSGU Scratchpad 0 */
+#define ILA_HDA_IOP_IMG_GET              0x10
+#define ILA_HDA_AAP1_IMG_GET             0x11
+#define ILA_HDA_AAP2_IMG_GET             0x12
+#define ILA_HDA_EXITGOOD                 0x1F
+#define ILA_HDA_IOP_IMG_DONE             0x80
+#define ILA_HDA_AAP1_IMG_DONE            0x81
+#define ILA_HDA_ISTR_IMG_DONE            0x83
+
+#define SCRATCH_PAD0_STATE_MASK		0xFF000000
 
 /* state definition for Scratch Pad1 register */
 #define SCRATCH_PAD1_POR		0x00  /* power on reset state */
@@ -918,6 +928,9 @@ struct set_dev_state_resp {
 #define MAIN_FATAL_ERROR_RDUMP1_OFFSET	0x7C/* DWORD 0x1F */
 #define MAIN_FATAL_ERROR_RDUMP1_LENGTH	0x80/* DWORD 0x20 */
 #define MAIN_HDA_FLAGS_OFFSET		0x84/* DWORD 0x21 */
+# define MAIN_HDA_FLAGS_BOOTSTRAP_MASK	0x00000003
+# define MAIN_HDA_FLAGS_FORCE_HDA	0x00000004
+# define MAIN_HDA_FLAGS_HDA_FW		0x00000008
 #define MAIN_ANALOG_SETUP_OFFSET	0x88/* DWORD 0x22 */
 
 /* Gereral Status Table offset - byte offset */
@@ -952,8 +965,10 @@ struct set_dev_state_resp {
 #define PCIE_ERROR_INTERRUPT_ENABLE	0x003048
 #define PCIE_ERROR_INTERRUPT		0x00304C
 /* signature definition for host scratch pad0 register */
-#define SPC_SOFT_RESET_SIGNATURE	0x252acbcd
 /* Signature for Soft Reset */
+#define SPC_SOFT_RESET_SIGNATURE	0x252acbcd
+/* Signature for HDA Soft Reset without PCIe resetting */
+#define SPC_HDASOFT_RESET_SIGNATURE	0xa5aa27d7
 
 /* SPC Reset register - BAR4(0x20), BAR2(win) (need dynamic mapping) */
 #define SPC_REG_RESET			0x000000/* reset register */
@@ -987,6 +1002,14 @@ struct set_dev_state_resp {
 #define MBIC_AAP1_ADDR_BASE		0x060000
 #define MBIC_IOP_ADDR_BASE		0x070000
 #define GSM_ADDR_BASE			0x0700000
+#define GSM_HDA_ILA_STR_BASE            0x470000
+#define GSM_ILA_STR_OFFSET              0xE000
+#define GSM_HDA_ILA_BASE                0x400000
+#define GSM_HDA_ILA_OFFSET              0x0
+#define SIZE_64KB                       0x00010000
+#define MB3_SHIFT_MASK                  0xFFFF0000
+#define MB3_OFFSET_MASK                 0x0000FFFF
+
 /* Dynamic map through Bar4 - 0x00700000 */
 #define GSM_CONFIG_RESET		0x00000000
 #define RAM_ECC_DB_ERR			0x00000018
@@ -998,10 +1021,23 @@ struct set_dev_state_resp {
 #define GSM_WRITE_DATA_PARITY_CHECK	0x00000048
 
 #define RB6_ACCESS_REG			0x6A0000
-#define HDAC_EXEC_CMD			0x0002
+#define HDA_CMD_OFFSET			0xfec0
+#define HDA_RSP_OFFSET			0xfee0
+#define HDAC_CMD_BUF_INFO		0x0001
+#define HDAC_CMD_EXEC			0x0002
+#define HDAC_CMD_RESET			0x0003
 #define HDA_C_PA			0xcb
+#define HDA_R_PA			0xdb
+#define HDA_PA_BITS			0xff000000
 #define HDA_SEQ_ID_BITS			0x00ff0000
+#define HDA_CODE_BITS			0x0000ffff
 #define HDA_GSM_OFFSET_BITS		0x00FFFFFF
+#define HDA_RSP_BUF_INFO		0x8001
+#define HDA_RSP_IDLE			0x8002
+#define HDA_RSP_BAD_IMG			0x8003
+#define HDA_RSP_BAD_CMD			0x8004
+#define HDA_RSP_INTL_ERR		0x8005
+#define HDA_RSP_EXEC			0x8006
 #define MBIC_AAP1_ADDR_BASE		0x060000
 #define MBIC_IOP_ADDR_BASE		0x070000
 #define GSM_ADDR_BASE			0x0700000
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 36efaa7..c3f4cf6 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_chips.h"
+#include "pm8001_hwi.h"
 
 static struct scsi_transport_template *pm8001_stt;
 
@@ -669,8 +670,35 @@ static int __devinit pm8001_pci_probe(struct pci_dev *pdev,
 		rc = -ENOMEM;
 		goto err_out_free;
 	}
+	/*
+	 * Make sure we have at least a sane region 0
+	 *
+	 * We do this here because a failure in pm8001_pci_alloc
+	 * is just interpreted as a memory allocation failure.
+	 */
+	if (pm8001_ha->io_mem[0].memvirtaddr == NULL
+	 || pm8001_ha->io_mem[0].memsize < (1 << 15)) {
+		printk(KERN_ERR "BAR0 access bad: %p,%x\n",
+			pm8001_ha->io_mem[0].memvirtaddr,
+			pm8001_ha->io_mem[0].memsize);
+		rc = -ENXIO;
+		goto err_out_free;
+	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+
+	/* HDA SEEPROM Force HDA Mode */
+	if (PM8001_CHIP_DISP->chip_in_hda_mode(pm8001_ha)) {
+		pm8001_ha->rst_signature = SPC_HDASOFT_RESET_SIGNATURE;
+		rc = PM8001_CHIP_DISP->chip_hda_mode(pm8001_ha);
+		if (!rc) {
+			rc = -EBUSY;
+			goto err_out_ha_free;
+		}
+	} else {
+		pm8001_ha->rst_signature = SPC_SOFT_RESET_SIGNATURE;
+		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha,
+			SPC_SOFT_RESET_SIGNATURE);
+	}
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_ha_free;
@@ -719,7 +747,7 @@ static void __devexit pm8001_pci_remove(struct pci_dev *pdev)
 	list_del(&pm8001_ha->list);
 	scsi_remove_host(pm8001_ha->shost);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, pm8001_ha->rst_signature);
 
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
@@ -763,7 +791,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -ENODEV;
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha);
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, pm8001_ha->rst_signature);
 #ifdef PM8001_USE_MSIX
 	for (i = 0; i < pm8001_ha->number_of_intr; i++)
 		synchronize_irq(pm8001_ha->msix_entries[i].vector);
@@ -819,7 +847,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	if (rc)
 		goto err_out_disable;
 
-	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, 0x252acbcd);
+	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha, pm8001_ha->rst_signature);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 1100820..4b7f2e0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -130,6 +130,8 @@ struct pm8001_ioctl_payload {
 
 struct pm8001_dispatch {
 	char *name;
+	int (*chip_in_hda_mode)(struct pm8001_hba_info *pm8001_ha);
+	int (*chip_hda_mode)(struct pm8001_hba_info *pm8001_ha);
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);
 	int (*chip_soft_rst)(struct pm8001_hba_info *pm8001_ha, u32 signature);
 	void (*chip_rst)(struct pm8001_hba_info *pm8001_ha);
@@ -384,6 +386,7 @@ struct pm8001_hba_info {
 	u32			logging_level;
 	u32			fw_status;
 	const struct firmware 	*fw_image;
+	u32			rst_signature;
 };
 
 struct pm8001_work {

--Apple-Mail=_7B490D87-E67B-436F-9511-74A878E2589D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



--Apple-Mail=_7B490D87-E67B-436F-9511-74A878E2589D--
