From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Thu, 16 Feb 2006 18:36:13 -0800
Message-ID: <20060217023613.GA30583@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:4587 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751263AbWBQCgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 21:36:16 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1H2aF2S024465
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 21:36:15 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1H2cnM7191748
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 19:38:49 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k1H2aEDo025712
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 19:36:15 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tarte@us.ibm.com, Robert <Robert_Tarte@adaptec.com>, Jeff Garzik <jgarzik@redhat.com>

This patch addresses the issue of the aic94xx driver not working on
non-x86 or on systems where the card bios had been disabled.
http://bugzilla.kernel.org/show_bug.cgi?id=6042

Rob Tarte, Jeff Ding, and I coordinated on the fix for the OCM issue.

The patch has been run on a Powermac G5, a PPC64, and IA64 based system.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 This purpose of this patch is to allow the aic94xx driver to load and
 function on archs that do not allow the cards bios to run. This patch
 contains a forward port of code changes made to the adp94xx driver
 that inits the ocm if the bios did not. The patch also provides default
 parameters for flash values if the flash data cannot be read.

 Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/aic94xx/aic94xx_hwi.c     |    6 -
 drivers/scsi/aic94xx/aic94xx_reg.h     |   13 ++
 drivers/scsi/aic94xx/aic94xx_reg_def.h |   13 ++
 drivers/scsi/aic94xx/aic94xx_sds.c     |  187 +++++++++++++++++++++++++++++++--
 drivers/scsi/aic94xx/aic94xx_seq.c     |    6 -
 5 files changed, 215 insertions(+), 10 deletions(-)

Index: sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-02-11 00:51:10.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-02-16 09:54:38.000000000 -0800
@@ -413,10 +413,14 @@ static int asd_init_escbs(struct asd_ha_
  */
 int asd_chip_hardrst(struct asd_ha_struct *asd_ha)
 {
+	int i;
 	int count = 100;
 	u32 reg;
 
-	asd_write_reg_dword(asd_ha, COMBIST, HARDRST);
+	for (i = 0 ; i < 4 ; i++) {
+		asd_write_reg_dword(asd_ha, COMBIST, HARDRST);
+	}
+
 	do {
 		udelay(1);
 		reg = asd_read_reg_dword(asd_ha, CHIMINT);
Index: sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg.h
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_reg.h	2006-02-11 00:51:10.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg.h	2006-02-11 00:57:45.000000000 -0800
@@ -89,6 +89,19 @@ ASD_READ_OCM(u8, byte, b);
 ASD_READ_OCM(u16,word, w);
 ASD_READ_OCM(u32,dword,l);
 
+#define ASD_WRITE_OCM(type, ord, S)                                    \
+static inline void asd_write_ocm_##ord (struct asd_ha_struct *asd_ha,  \
+					 u32 offs, type val)          \
+{                                                                     \
+	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[1];   \
+	write##S (val, io_handle->addr + (unsigned long) offs);       \
+	return;                                                       \
+}
+
+ASD_WRITE_OCM(u8, byte, b);
+ASD_WRITE_OCM(u16,word, w);
+ASD_WRITE_OCM(u32,dword,l);
+
 #define ASD_DDBSITE_READ(type, ord)                                        \
 static inline type asd_ddbsite_read_##ord (struct asd_ha_struct *asd_ha,   \
 					   u16 ddb_site_no,                \
Index: sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg_def.h
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_reg_def.h	2006-02-11 00:51:10.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_reg_def.h	2006-02-11 00:57:45.000000000 -0800
@@ -1796,6 +1796,8 @@
 
 #define PCIC_FLASH_MBAR	0xB8
 
+#define PCIC_INTRPT_STAT 0xD4
+
 #define PCIC_TP_CTRL	0xFC
 
 /*
@@ -1805,6 +1807,7 @@
 
 #define	EXSICNFGR	(EXSI_REG_BASE_ADR + 0x00)
 
+#define		OCMINITIALIZED		0x80000000
 #define		ASIEN			0x00400000
 #define		HCMODE			0x00200000
 #define		PCIDEF			0x00100000
@@ -1959,6 +1962,16 @@
 #define XSRAM_SIZE                        0x100000
 
 /*
+ * NVRAM Registers, Address Range: (0x00000 - 0x3FFFF).
+ */
+#define		NVRAM_REG_BASE_ADR	0xBF800000
+#define		NVRAM_MAX_BASE_ADR	0x003FFFFF
+
+/* OCM base address */
+#define		OCM_BASE_ADDR		0xA0000000
+#define		OCM_MAX_SIZE		0x20000
+
+/*
  * Sequencers (Central and Link) Scratch RAM page definitions.
  */
 
Index: sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_sds.c
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_sds.c	2006-02-11 00:21:30.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_sds.c	2006-02-16 10:07:03.000000000 -0800
@@ -51,6 +51,60 @@ struct asd_ocm_dir {
 	struct asd_ocm_dir_ent entry[15];
 } __attribute__ ((packed));
 
+#define	OCM_DE_OCM_DIR			0x00
+#define	OCM_DE_WIN_DRVR			0x01
+#define	OCM_DE_BIOS_CHIM		0x02
+#define	OCM_DE_RAID_ENGN		0x03
+#define	OCM_DE_BIOS_INTL		0x04
+#define	OCM_DE_BIOS_CHIM_OSM		0x05
+#define	OCM_DE_BIOS_CHIM_DYNAMIC	0x06
+#define	OCM_DE_ADDC2C_RES0		0x07
+#define	OCM_DE_ADDC2C_RES1		0x08
+#define	OCM_DE_ADDC2C_RES2		0x09
+#define	OCM_DE_ADDC2C_RES3		0x0A
+
+#define OCM_INIT_DIR_ENTRIES	5
+/***************************************************************************
+*  OCM dircetory default
+***************************************************************************/
+static struct asd_ocm_dir OCMDirInit =
+{
+	.sig = {0x4D, 0x4F},	/* signature */
+	.num_de = OCM_INIT_DIR_ENTRIES,	/* no. of directory entries */
+};
+
+/***************************************************************************
+*  OCM dircetory Entries default
+***************************************************************************/
+static struct asd_ocm_dir_ent OCMDirEntriesInit[OCM_INIT_DIR_ENTRIES] =
+{
+	{
+		.type = (OCM_DE_ADDC2C_RES0),	/* Entry type  */
+		.offs = {128},			/* Offset */
+		.size = {0, 4},			/* size */
+	},
+	{
+		.type = (OCM_DE_ADDC2C_RES1),	/* Entry type  */
+		.offs = {128, 4},		/* Offset */
+		.size = {0, 4},			/* size */
+	},
+	{
+		.type = (OCM_DE_ADDC2C_RES2),	/* Entry type  */
+		.offs = {128, 8},		/* Offset */
+		.size = {0, 4},			/* size */
+	},
+	{
+		.type = (OCM_DE_ADDC2C_RES3),	/* Entry type  */
+		.offs = {128, 12},		/* Offset */
+		.size = {0, 4},			/* size */
+	},
+	{
+		.type = (OCM_DE_WIN_DRVR),	/* Entry type  */
+		.offs = {128, 16},		/* Offset */
+		.size = {128, 235, 1},		/* size */
+	},
+};
+
 struct asd_bios_chim_struct {
 	char sig[4];
 	u8   major;          /* 1 */
@@ -92,11 +146,12 @@ static int asd_read_ocm_seg(struct asd_h
 static int asd_read_ocm_dir(struct asd_ha_struct *asd_ha,
 			    struct asd_ocm_dir *dir, u32 offs)
 {
-	int err = asd_read_ocm_seg(asd_ha, (void *)dir, offs, sizeof(*dir));
+	int err = asd_read_ocm_seg(asd_ha, dir, offs, sizeof(*dir));
 	if (err) {
 		ASD_DPRINTK("couldn't read ocm segment\n");
 		return err;
 	}
+
 	if (dir->sig[0] != 'M' || dir->sig[1] != 'O') {
 		ASD_DPRINTK("no valid dir signature(%c%c) at start of OCM\n",
 			    dir->sig[0], dir->sig[1]);
@@ -111,6 +166,28 @@ static int asd_read_ocm_dir(struct asd_h
 	return 0;
 }
 
+/**
+ * asd_write_ocm_seg - write an on chip memory (OCM) segment
+ * @asd_ha: pointer to the host adapter structure
+ * @buffer: where to read the write data
+ * @offs: offset into OCM to write to
+ * @size: how many bytes to write
+ *
+ * Return the number of bytes not written. Return 0 on success.
+ */
+static void asd_write_ocm_seg(struct asd_ha_struct *asd_ha, void *buffer,
+			    u32 offs, int size)
+{
+	u8 *p = buffer;
+	if (unlikely(asd_ha->iospace))
+		asd_write_reg_string(asd_ha, buffer, offs+OCM_BASE_ADDR, size);
+	else {
+		for ( ; size > 0; size--, offs++, p++)
+			asd_write_ocm_byte(asd_ha, offs, *p);
+	}
+	return;
+}
+
 #define THREE_TO_NUM(X) ((X)[0] | ((X)[1] << 8) | ((X)[2] << 16))
 
 static int asd_find_dir_entry(struct asd_ocm_dir *dir, u8 type,
@@ -208,6 +285,67 @@ out:
 	return err;
 }
 
+static void
+asd_hwi_initialize_ocm_dir (struct asd_ha_struct *asd_ha)
+{
+	int i;
+
+	/* Zero OCM */
+	for (i = 0; i < OCM_MAX_SIZE; i += 4)
+		asd_write_ocm_dword(asd_ha, i, 0);
+
+	/* Write Dir */
+	asd_write_ocm_seg(asd_ha, &OCMDirInit, 0,
+			  sizeof(struct asd_ocm_dir));
+
+	/* Write Dir Entries */
+	for (i = 0; i < OCM_INIT_DIR_ENTRIES; i++)
+		asd_write_ocm_seg(asd_ha, &OCMDirEntriesInit[i],
+				  sizeof(struct asd_ocm_dir) +
+				  (i * sizeof(struct asd_ocm_dir_ent))
+				  , sizeof(struct asd_ocm_dir_ent));
+
+}
+
+static int
+asd_hwi_check_ocm_access (struct asd_ha_struct *asd_ha)
+{
+	struct pci_dev *pcidev = asd_ha->pcidev;
+	u32 reg;
+	int err = 0;
+	u32 v;
+
+	/* check if OCM has been initialized by BIOS */
+	reg = asd_read_reg_dword(asd_ha, EXSICNFGR);
+
+	if (!(reg & OCMINITIALIZED)) {
+		err = pci_read_config_dword(pcidev, PCIC_INTRPT_STAT, &v);
+		if (err) {
+			asd_printk("couldn't access PCIC_INTRPT_STAT of %s\n",
+					pci_name(pcidev));
+			goto out;
+		}
+
+		printk(KERN_INFO "OCM is not initialized by BIOS,"
+		       "reinitialize it and ignore it, current IntrptStatus"
+		       "is 0x%x\n", v);
+
+		if (v)
+			err = pci_write_config_dword(pcidev,
+						     PCIC_INTRPT_STAT, v);
+		if (err) {
+			asd_printk("couldn't write PCIC_INTRPT_STAT of %s\n",
+					pci_name(pcidev));
+			goto out;
+		}
+
+		asd_hwi_initialize_ocm_dir(asd_ha);
+
+	}
+out:
+	return err;
+}
+
 /**
  * asd_read_ocm - read on chip memory (OCM)
  * @asd_ha: pointer to the host adapter structure
@@ -217,6 +355,9 @@ int asd_read_ocm(struct asd_ha_struct *a
 	int err;
 	struct asd_ocm_dir *dir;
 
+	if (asd_hwi_check_ocm_access(asd_ha))
+		return -1;
+
 	dir = kmalloc(sizeof(*dir), GFP_KERNEL);
 	if (!dir) {
 		asd_printk("no memory for ocm dir\n");
@@ -606,9 +747,9 @@ static int asd_validate_ms(struct asd_ma
 	ms->size = le16_to_cpu((__force __le16) ms->size);
 
 	if (asd_calc_flash_chksum((u16 *)ms, ms->size/2)) {
-		ASD_DPRINTK("failed manuf sector checksum\n");
-		return -EINVAL;
+		asd_printk("failed manuf sector checksum\n");
 	}
+
 	return 0;
 }
 
@@ -683,11 +824,29 @@ static int asd_ms_get_phy_params(struct 
 	int en_phys = 0;
 	int rep_phys = 0;
 	struct asd_manuf_phy_param *phy_param;
+	struct asd_manuf_phy_param dflt_phy_param;
 
 	phy_param = asd_find_ll_by_id(manuf_sec, 'P', 'M');
 	if (!phy_param) {
 		ASD_DPRINTK("ms: no phy parameters found\n");
-		return -ENOENT;
+		ASD_DPRINTK("ms: Creating default phy parameters\n");
+		dflt_phy_param.sig[0] = 'P';
+		dflt_phy_param.sig[1] = 'M';
+		dflt_phy_param.maj = 0;
+		dflt_phy_param.min = 2;
+		dflt_phy_param.num_phy_desc = 8;
+		dflt_phy_param.phy_desc_size = sizeof(struct asd_manuf_phy_desc);
+		for (i =0; i < ASD_MAX_PHYS; i++) {
+			dflt_phy_param.phy_desc[i].state = 0;
+			dflt_phy_param.phy_desc[i].phy_id = i;
+			dflt_phy_param.phy_desc[i].phy_control_0 = 0xf6;
+			dflt_phy_param.phy_desc[i].phy_control_1 = 0x10;
+			dflt_phy_param.phy_desc[i].phy_control_2 = 0x43;
+			dflt_phy_param.phy_desc[i].phy_control_3 = 0xeb;
+		}
+
+		phy_param = &dflt_phy_param;
+
 	}
 
 	if (phy_param->maj != 0) {
@@ -736,7 +895,7 @@ static int asd_ms_get_connector_map(stru
 	cm = asd_find_ll_by_id(manuf_sec, 'M', 'C');
 	if (!cm) {
 		ASD_DPRINTK("ms: no connector map found\n");
-		return -ENOENT;
+		return 0;
 	}
 
 	if (cm->maj != 0) {
@@ -872,15 +1031,29 @@ static int asd_process_ctrla_phy_setting
 static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
-	int err;
+	int err, i;
 	u32 offs, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
+	struct asd_ctrla_phy_settings dflt_ps;
 
 	err = asd_find_flash_de(flash_dir, FLASH_DE_CTRL_A_USER, &offs, &size);
 	if (err) {
 		ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
-		goto out;
+		ASD_DPRINTK("Creating default CTRL-A user settings section\n");
+
+		dflt_ps.id0 = 'h';
+		dflt_ps.num_phys = 8;
+		for (i =0; i < ASD_MAX_PHYS; i++) {
+			memcpy(dflt_ps.phy_ent[i].sas_addr,
+			       asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
+			dflt_ps.phy_ent[i].sas_link_rates = 0x98;
+			dflt_ps.phy_ent[i].flags = 0x0;
+			dflt_ps.phy_ent[i].sata_link_rates = 0x0;
+		}
+
+		size = sizeof(struct asd_ctrla_phy_settings);
+		ps = &dflt_ps;
 	}
 
 	if (size == 0)
Index: sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_seq.c
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_seq.c	2006-02-11 00:21:30.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_seq.c	2006-02-16 09:54:38.000000000 -0800
@@ -757,8 +757,10 @@ static void asd_init_lseq_mdp(struct asd
 	asd_write_reg_word(asd_ha, LmSEQ_RESP_LEN(lseq), 0);
 	asd_write_reg_word(asd_ha, LmSEQ_FIRST_INV_SCB_SITE(lseq),
 			   (u16)last_scb_site_no+1);
-	asd_write_reg_dword(asd_ha, LmSEQ_INTEN_SAVE(lseq),
-			    (u32) LmM0INTEN_MASK);
+	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
+			    (u16) LmM0INTEN_MASK & 0xFFFF0000 >> 16);
+	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
+			    (u16) LmM0INTEN_MASK & 0xFFFF);
 	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_FRM_LEN(lseq), 0);
 	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_PROTOCOL(lseq), 0);
 	asd_write_reg_byte(asd_ha, LmSEQ_RESP_STATUS(lseq), 0);


