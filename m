From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym2 2.1.18i
Date: Fri, 12 Mar 2004 19:39:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040312193923.GX2148@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42923 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262465AbUCLTjZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 14:39:25 -0500
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 1B1sV9-000617-JN
	for linux-scsi@vger.kernel.org; Fri, 12 Mar 2004 19:39:23 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 - Correct a typo "mvram" -> "nvram".
 - Re-do the PQS/PDS support which I'd #if 0 out.  Should even work on
   multiple-domain boxes now ;-)
 - Move all the nvram definitions to sym_nvram.h (from Gerard's 2.1.19-pre3)
 - hcb_p -> struct sym_hcb *
 - sdev_p -> struct sym_device *
 - Delete a lot of unused macros from sym_misc.h
 - Move READ_BARRIER and WRITE_BARRIER definitions to sym_glue.h
 - SYM_CONF_NVRAM_WRITE_SUPPORT (from Gerard's 2.1.19-pre3).  Not enabled
   yet.
 - Fix some -W warnings (some courtesy of Adrian Bunk).

diff -urpNX dontdiff linus-2.6/Documentation/scsi/sym53c8xx_2.txt parisc-2.6/Documentation/scsi/sym53c8xx_2.txt
--- linus-2.6/Documentation/scsi/sym53c8xx_2.txt	Fri Mar 12 11:41:32 2004
+++ parisc-2.6/Documentation/scsi/sym53c8xx_2.txt	Thu Mar 11 09:05:46 2004
@@ -567,7 +567,7 @@ characters and digits are allowed.
         nvram:n     do not look for serial NVRAM
         nvram:y     test controllers for onboard serial NVRAM
         (alternate binary form)
-        mvram=<bits options>
+        nvram=<bits options>
         0x01   look for NVRAM  (equivalent to nvram=y)
         0x02   ignore NVRAM "Synchronous negotiation" parameters for all devices
         0x04   ignore NVRAM "Wide negotiation"  parameter for all devices
@@ -661,7 +661,7 @@ optimized parameters value.
 The 'nvram' boot option can be entered in hexadecimal form in order 
 to ignore some options configured in the NVRAM, as follow:
 
-mvram=<bits options>
+nvram=<bits options>
       0x01   look for NVRAM  (equivalent to nvram=y)
       0x02   ignore NVRAM "Synchronous negotiation" parameters for all devices
       0x04   ignore NVRAM "Wide negotiation"  parameter for all devices
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Fri Mar 12 11:42:18 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Thu Mar 11 09:06:01 2004
@@ -70,13 +70,6 @@
 #define	SYM_CONF_DMA_ADDRESSING_MODE CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
 
 /*
- *  NCR PQS/PDS special device support.
- */
-#if 1
-#define SYM_CONF_PQS_PDS_SUPPORT
-#endif
-
-/*
  *  NVRAM support.
  */
 #if 1
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Fri Mar 12 11:42:18 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h	Thu Mar 11 09:06:01 2004
@@ -127,135 +127,6 @@ struct sym_pci_chip {
 };
 
 /*
- *	Symbios NVRAM data format
- */
-#define SYMBIOS_NVRAM_SIZE 368
-#define SYMBIOS_NVRAM_ADDRESS 0x100
-
-struct Symbios_nvram {
-/* Header 6 bytes */
-	u_short type;		/* 0x0000 */
-	u_short byte_count;	/* excluding header/trailer */
-	u_short checksum;
-
-/* Controller set up 20 bytes */
-	u_char	v_major;	/* 0x00 */
-	u_char	v_minor;	/* 0x30 */
-	u32	boot_crc;
-	u_short	flags;
-#define SYMBIOS_SCAM_ENABLE	(1)
-#define SYMBIOS_PARITY_ENABLE	(1<<1)
-#define SYMBIOS_VERBOSE_MSGS	(1<<2)
-#define SYMBIOS_CHS_MAPPING	(1<<3)
-#define SYMBIOS_NO_NVRAM	(1<<3)	/* ??? */
-	u_short	flags1;
-#define SYMBIOS_SCAN_HI_LO	(1)
-	u_short	term_state;
-#define SYMBIOS_TERM_CANT_PROGRAM	(0)
-#define SYMBIOS_TERM_ENABLED		(1)
-#define SYMBIOS_TERM_DISABLED		(2)
-	u_short	rmvbl_flags;
-#define SYMBIOS_RMVBL_NO_SUPPORT	(0)
-#define SYMBIOS_RMVBL_BOOT_DEVICE	(1)
-#define SYMBIOS_RMVBL_MEDIA_INSTALLED	(2)
-	u_char	host_id;
-	u_char	num_hba;	/* 0x04 */
-	u_char	num_devices;	/* 0x10 */
-	u_char	max_scam_devices;	/* 0x04 */
-	u_char	num_valid_scam_devices;	/* 0x00 */
-	u_char	flags2;
-#define SYMBIOS_AVOID_BUS_RESET		(1<<2)
-
-/* Boot order 14 bytes * 4 */
-	struct Symbios_host{
-		u_short	type;		/* 4:8xx / 0:nok */
-		u_short	device_id;	/* PCI device id */
-		u_short	vendor_id;	/* PCI vendor id */
-		u_char	bus_nr;		/* PCI bus number */
-		u_char	device_fn;	/* PCI device/function number << 3*/
-		u_short	word8;
-		u_short	flags;
-#define	SYMBIOS_INIT_SCAN_AT_BOOT	(1)
-		u_short	io_port;	/* PCI io_port address */
-	} host[4];
-
-/* Targets 8 bytes * 16 */
-	struct Symbios_target {
-		u_char	flags;
-#define SYMBIOS_DISCONNECT_ENABLE	(1)
-#define SYMBIOS_SCAN_AT_BOOT_TIME	(1<<1)
-#define SYMBIOS_SCAN_LUNS		(1<<2)
-#define SYMBIOS_QUEUE_TAGS_ENABLED	(1<<3)
-		u_char	rsvd;
-		u_char	bus_width;	/* 0x08/0x10 */
-		u_char	sync_offset;
-		u_short	sync_period;	/* 4*period factor */
-		u_short	timeout;
-	} target[16];
-/* Scam table 8 bytes * 4 */
-	struct Symbios_scam {
-		u_short	id;
-		u_short	method;
-#define SYMBIOS_SCAM_DEFAULT_METHOD	(0)
-#define SYMBIOS_SCAM_DONT_ASSIGN	(1)
-#define SYMBIOS_SCAM_SET_SPECIFIC_ID	(2)
-#define SYMBIOS_SCAM_USE_ORDER_GIVEN	(3)
-		u_short status;
-#define SYMBIOS_SCAM_UNKNOWN		(0)
-#define SYMBIOS_SCAM_DEVICE_NOT_FOUND	(1)
-#define SYMBIOS_SCAM_ID_NOT_SET		(2)
-#define SYMBIOS_SCAM_ID_VALID		(3)
-		u_char	target_id;
-		u_char	rsvd;
-	} scam[4];
-
-	u_char	spare_devices[15*8];
-	u_char	trailer[6];		/* 0xfe 0xfe 0x00 0x00 0x00 0x00 */
-};
-typedef struct Symbios_nvram	Symbios_nvram;
-typedef struct Symbios_host	Symbios_host;
-typedef struct Symbios_target	Symbios_target;
-typedef struct Symbios_scam	Symbios_scam;
-
-/*
- *	Tekram NvRAM data format.
- */
-#define TEKRAM_NVRAM_SIZE 64
-#define TEKRAM_93C46_NVRAM_ADDRESS 0
-#define TEKRAM_24C16_NVRAM_ADDRESS 0x40
-
-struct Tekram_nvram {
-	struct Tekram_target {
-		u_char	flags;
-#define	TEKRAM_PARITY_CHECK		(1)
-#define TEKRAM_SYNC_NEGO		(1<<1)
-#define TEKRAM_DISCONNECT_ENABLE	(1<<2)
-#define	TEKRAM_START_CMD		(1<<3)
-#define TEKRAM_TAGGED_COMMANDS		(1<<4)
-#define TEKRAM_WIDE_NEGO		(1<<5)
-		u_char	sync_index;
-		u_short	word2;
-	} target[16];
-	u_char	host_id;
-	u_char	flags;
-#define TEKRAM_MORE_THAN_2_DRIVES	(1)
-#define TEKRAM_DRIVES_SUP_1GB		(1<<1)
-#define	TEKRAM_RESET_ON_POWER_ON	(1<<2)
-#define TEKRAM_ACTIVE_NEGATION		(1<<3)
-#define TEKRAM_IMMEDIATE_SEEK		(1<<4)
-#define	TEKRAM_SCAN_LUNS		(1<<5)
-#define	TEKRAM_REMOVABLE_FLAGS		(3<<6)	/* 0: disable; */
-						/* 1: boot device; 2:all */
-	u_char	boot_delay_index;
-	u_char	max_tags_index;
-	u_short	flags1;
-#define TEKRAM_F2_F6_ENABLED		(1)
-	u_short	spare[29];
-};
-typedef struct Tekram_nvram	Tekram_nvram;
-typedef struct Tekram_target	Tekram_target;
-
-/*
  *	SYM53C8XX IO register data structure.
  */
 struct sym_reg {
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	Fri Mar 12 11:42:18 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	Thu Mar 11 09:06:01 2004
@@ -135,7 +135,7 @@ static struct sym_fwz_ofs sym_fw2z_ofs =
  *  Patch routine for firmware #1.
  */
 static void
-sym_fw1_patch(hcb_p np)
+sym_fw1_patch(struct sym_hcb *np)
 {
 	struct sym_fw1a_scr *scripta0;
 	struct sym_fw1b_scr *scriptb0;
@@ -176,7 +176,7 @@ sym_fw1_patch(hcb_p np)
  *  Patch routine for firmware #2.
  */
 static void
-sym_fw2_patch(hcb_p np)
+sym_fw2_patch(struct sym_hcb *np)
 {
 	struct sym_fw2a_scr *scripta0;
 	struct sym_fw2b_scr *scriptb0;
@@ -282,7 +282,7 @@ sym_fw_fill_data (u32 *in, u32 *out)
  *  To be done for all firmwares.
  */
 static void 
-sym_fw_setup_bus_addresses(hcb_p np, struct sym_fw *fw)
+sym_fw_setup_bus_addresses(struct sym_hcb *np, struct sym_fw *fw)
 {
 	u32 *pa;
 	u_short *po;
@@ -319,7 +319,7 @@ sym_fw_setup_bus_addresses(hcb_p np, str
  *  Setup routine for firmware #1.
  */
 static void 
-sym_fw1_setup(hcb_p np, struct sym_fw *fw)
+sym_fw1_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw1a_scr *scripta0;
 	struct sym_fw1b_scr *scriptb0;
@@ -343,7 +343,7 @@ sym_fw1_setup(hcb_p np, struct sym_fw *f
  *  Setup routine for firmware #2.
  */
 static void 
-sym_fw2_setup(hcb_p np, struct sym_fw *fw)
+sym_fw2_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw2a_scr *scripta0;
 	struct sym_fw2b_scr *scriptb0;
@@ -389,7 +389,7 @@ sym_find_firmware(struct sym_pci_chip *c
 /*
  *  Bind a script to physical addresses.
  */
-void sym_fw_bind_script (hcb_p np, u32 *start, int len)
+void sym_fw_bind_script(struct sym_hcb *np, u32 *start, int len)
 {
 	u32 opcode, new, old, tmp1, tmp2;
 	u32 *end, *cur;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Mar 12 11:42:18 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Mar 11 09:06:01 2004
@@ -57,7 +57,9 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
+
 #include "sym_glue.h"
+#include "sym_nvram.h"
 
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
@@ -532,7 +534,7 @@ static int sym_queue_command(struct sym_
 /*
  *  Setup buffers and pointers that address the CDB.
  */
-static int __inline sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *ccb, struct sym_ccb *cp)
+static inline int sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *ccb, struct sym_ccb *cp)
 {
 	u32	cmd_ba;
 	int	cmd_len;
@@ -1281,7 +1283,7 @@ static int is_keyword(char *ptr, int len
 {
 	int verb_len = strlen(verb);
 
-	if (len >= strlen(verb) && !memcmp(verb, ptr, verb_len))
+	if (len >= verb_len && !memcmp(verb, ptr, verb_len))
 		return verb_len;
 	else
 		return 0;
@@ -1938,7 +1940,7 @@ int __init sym53c8xx_setup(char *str)
 	char *cur = str;
 	char *pc, *pv;
 	unsigned long val;
-	int i,  c;
+	unsigned int i,  c;
 	int xi = 0;
 
 	while (cur != NULL && (pc = strchr(cur, ':')) != NULL) {
@@ -2171,6 +2173,55 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	return 0;
 }
 
+/*
+ * The NCR PQS and PDS cards are constructed as a DEC bridge
+ * behind which sits a proprietary NCR memory controller and
+ * either four or two 53c875s as separate devices.  We can tell
+ * if an 875 is part of a PQS/PDS or not since if it is, it will
+ * be on the same bus as the memory controller.  In its usual
+ * mode of operation, the 875s are slaved to the memory
+ * controller for all transfers.  To operate with the Linux
+ * driver, the memory controller is disabled and the 875s
+ * freed to function independently.  The only wrinkle is that
+ * the preset SCSI ID (which may be zero) must be read in from
+ * a special configuration space register of the 875.
+ */
+void sym_config_pqs(struct pci_dev *pdev, struct sym_device *sym_dev)
+{
+	int slot;
+
+	for (slot = 0; slot < 256; slot++) {
+		u8 tmp;
+		struct pci_dev *memc = pci_get_slot(pdev->bus, slot);
+
+		if (!memc || memc->vendor != 0x101a || memc->device == 0x0009) {
+			pci_dev_put(memc);
+			continue;
+		}
+
+		/*
+		 * We set these bits in the memory controller once per 875.
+		 * This isn't a problem in practice.
+		 */
+
+		/* bit 1: allow individual 875 configuration */
+		pci_read_config_byte(memc, 0x44, &tmp);
+		tmp |= 0x2;
+		pci_write_config_byte(memc, 0x44, tmp);
+
+		/* bit 2: drive individual 875 interrupts to the bus */
+		pci_read_config_byte(memc, 0x45, &tmp);
+		tmp |= 0x4;
+		pci_write_config_byte(memc, 0x45, tmp);
+
+		pci_read_config_byte(pdev, 0x84, &tmp);
+		sym_dev->host_id = tmp;
+
+		pci_dev_put(memc);
+
+		break;
+	}
+}
 
 /*
  *  Called before unloading the module.
@@ -2221,79 +2272,6 @@ static struct scsi_host_template sym2_te
 #endif
 };
 
-#ifdef _SYM_CONF_PQS_PDS_SUPPORT
-#if 0
-/*
- *  Detect all NCR PQS/PDS boards and keep track of their bus nr.
- *
- *  The NCR PQS or PDS card is constructed as a DEC bridge
- *  behind which sit a proprietary NCR memory controller and
- *  four or two 53c875s as separate devices.  In its usual mode
- *  of operation, the 875s are slaved to the memory controller
- *  for all transfers.  We can tell if an 875 is part of a
- *  PQS/PDS or not since if it is, it will be on the same bus
- *  as the memory controller.  To operate with the Linux
- *  driver, the memory controller is disabled and the 875s
- *  freed to function independently.  The only wrinkle is that
- *  the preset SCSI ID (which may be zero) must be read in from
- *  a special configuration space register of the 875
- */
-#ifndef SYM_CONF_MAX_PQS_BUS
-#define SYM_CONF_MAX_PQS_BUS 16
-#endif
-static int pqs_bus[SYM_CONF_MAX_PQS_BUS] __initdata = { 0 };
-
-static void __init sym_detect_pqs_pds(void)
-{
-	short index;
-	struct pci_dev *dev = NULL;
-
-	for(index=0; index < SYM_CONF_MAX_PQS_BUS; index++) {
-		u_char tmp;
-
-		dev = pci_find_device(0x101a, 0x0009, dev);
-		if (dev == NULL) {
-			pqs_bus[index] = -1;
-			break;
-		}
-		printf_info(NAME53C8XX ": NCR PQS/PDS memory controller detected on bus %d\n", dev->bus->number);
-		pci_read_config_byte(dev, 0x44, &tmp);
-		/* bit 1: allow individual 875 configuration */
-		tmp |= 0x2;
-		pci_write_config_byte(dev, 0x44, tmp);
-		pci_read_config_byte(dev, 0x45, &tmp);
-		/* bit 2: drive individual 875 interrupts to the bus */
-		tmp |= 0x4;
-		pci_write_config_byte(dev, 0x45, tmp);
-
-		pqs_bus[index] = dev->bus->number;
-	}
-}
-#endif
-
-static int pqs_probe()
-{
-}
-
-static void pqs_remove()
-{
-}
-
-static struct pci_device_id pqs_id_table[] __devinitdata = {
-	{ 0x101a, 0x0009, },
-	{ 0, }
-};
-
-MODULE_DEVICE_TABLE(pci, pqs_id_table);
-
-static struct pci_driver pqs_driver = {
-	.name		= NAME53C8XX " (PQS)",
-	.id_table	= pqs_id_table,
-	.probe		= pqs_probe,
-	.remove		= __devexit_p(pqs_remove),
-};
-#endif /* PQS */
-
 static int attach_count;
 
 static int __devinit sym2_probe(struct pci_dev *pdev,
@@ -2318,6 +2296,8 @@ static int __devinit sym2_probe(struct p
 	if (sym53c8xx_pci_init(pdev, &sym_dev))
 		goto free;
 
+	sym_config_pqs(pdev, &sym_dev);
+
 	sym_get_nvram(&sym_dev, &nvram);
 
 	instance = sym_attach(&sym2_template, attach_count, &sym_dev);
@@ -2406,9 +2386,6 @@ static struct pci_driver sym2_driver = {
 
 static int __init sym2_init(void)
 {
-#ifdef _SYM_CONF_PQS_PDS_SUPPORT
-	pci_register_driver(&pqs_driver);
-#endif
 	pci_register_driver(&sym2_driver);
 	return 0;
 }
@@ -2416,9 +2393,6 @@ static int __init sym2_init(void)
 static void __exit sym2_exit(void)
 {
 	pci_unregister_driver(&sym2_driver);
-#ifdef _SYM_CONF_PQS_PDS_SUPPORT
-	pci_unregister_driver(&pqs_driver);
-#endif
 }
 
 module_init(sym2_init);
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Fri Mar 12 11:42:18 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	Thu Mar 11 09:06:01 2004
@@ -77,9 +77,9 @@
 /*
  *  General driver includes.
  */
-#include "sym_misc.h"
 #include "sym_conf.h"
 #include "sym_defs.h"
+#include "sym_misc.h"
 
 /*
  * Configuration addendum for Linux.
@@ -113,6 +113,26 @@
 #define sym_mdelay(ms)	mdelay(ms)
 
 /*
+ *  A 'read barrier' flushes any data that have been prefetched 
+ *  by the processor due to out of order execution. Such a barrier 
+ *  must notably be inserted prior to looking at data that have 
+ *  been DMAed, assuming that program does memory READs in proper 
+ *  order and that the device ensured proper ordering of WRITEs.
+ *
+ *  A 'write barrier' prevents any previous WRITEs to pass further 
+ *  WRITEs. Such barriers must be inserted each time another agent 
+ *  relies on ordering of WRITEs.
+ *
+ *  Note that, due to posting of PCI memory writes, we also must 
+ *  insert dummy PCI read transactions when some ordering involving 
+ *  both directions over the PCI does matter. PCI transactions are 
+ *  fully ordered in each direction.
+ */
+
+#define MEMORY_READ_BARRIER()	rmb()
+#define MEMORY_WRITE_BARRIER()	wmb()
+
+/*
  *  Let the compiler know about driver data structure names.
  */
 typedef struct sym_tcb *tcb_p;
@@ -413,6 +433,8 @@ struct sym_slot {
 	char	inst_name[16];
 };
 
+struct sym_nvram;
+
 struct sym_device {
 	struct pci_dev *pdev;
 	struct sym_slot  s;
@@ -420,12 +442,7 @@ struct sym_device {
 	struct sym_nvram *nvram;
 	u_short device_id;
 	u_char host_id;
-#ifdef	SYM_CONF_PQS_PDS_SUPPORT
-	u_char pqs_pds;
-#endif
 };
-
-typedef struct sym_device *sdev_p;
 
 /*
  *  The driver definitions (sym_hipd.h) must know about a 
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Fri Mar 12 11:42:20 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	Thu Mar 11 09:06:01 2004
@@ -50,13 +50,10 @@
  * SUCH DAMAGE.
  */
 
-#define SYM_DRIVER_NAME	"sym-2.1.18f"
+#define SYM_DRIVER_NAME	"sym-2.1.18i"
 
-#ifdef __FreeBSD__
-#include <dev/sym/sym_glue.h>
-#else
 #include "sym_glue.h"
-#endif
+#include "sym_nvram.h"
 
 #if 0
 #define SYM_DEBUG_GENERIC_SUPPORT
@@ -616,8 +613,7 @@ sym_getsync(hcb_p np, u_char dt, u_char 
 	if (dt) {
 		fak = (kpc - 1) / (div_10M[div] << 1) + 1 - 2;
 		/* ret = ((2+fak)*div_10M[div])/np->clock_khz; */
-	}
-	else {
+	} else {
 		fak = (kpc - 1) / div_10M[div] + 1 - 4;
 		/* ret = ((4+fak)*div_10M[div])/np->clock_khz; */
 	}
@@ -625,8 +621,10 @@ sym_getsync(hcb_p np, u_char dt, u_char 
 	/*
 	 *  Check against our hardware limits, or bugs :).
 	 */
-	if (fak < 0)	{fak = 0; ret = -1;}
-	if (fak > 2)	{fak = 2; ret = -1;}
+	if (fak > 2) {
+		fak = 2;
+		ret = -1;
+	}
 
 	/*
 	 *  Compute and return sync parameters.
@@ -1054,8 +1052,9 @@ static int sym_prepare_setting(hcb_p np,
 		sym_nvram_setup_target (np, i, nvram);
 
 		/*
-		 *  For now, guess PPR/DT support from the period 
-		 *  and BUS width.
+		 * Some single-ended devices may crash on receiving a
+		 * PPR negotiation attempt.  Only try PPR if we're in
+		 * LVD mode.
 		 */
 		if (np->features & FE_ULTRA3) {
 			tp->tinfo.user.options |= PPR_OPT_DT;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Fri Mar 12 11:42:20 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	Thu Mar 11 09:06:02 2004
@@ -171,6 +171,15 @@
 #define	SYM_CONF_MIN_ASYNC (40)
 
 /*
+ *  Shortest memory chunk is (1<<SYM_MEM_SHIFT), currently 16.
+ *  Actual allocations happen as SYM_MEM_CLUSTER_SIZE sized.
+ *  (1 PAGE at a time is just fine).
+ */
+#define SYM_MEM_SHIFT	4
+#define SYM_MEM_CLUSTER_SIZE	(1UL << SYM_MEM_CLUSTER_SHIFT)
+#define SYM_MEM_CLUSTER_MASK	(SYM_MEM_CLUSTER_SIZE-1)
+
+/*
  *  Number of entries in the START and DONE queues.
  *
  *  We limit to 1 PAGE in order to succeed allocation of 
@@ -196,21 +205,6 @@
 #define MAX_QUEUE	SYM_CONF_MAX_QUEUE
 
 /*
- *  Union of supported NVRAM formats.
- */
-struct sym_nvram {
-	int type;
-#define	SYM_SYMBIOS_NVRAM	(1)
-#define	SYM_TEKRAM_NVRAM	(2)
-#if SYM_CONF_NVRAM_SUPPORT
-	union {
-		Symbios_nvram Symbios;
-		Tekram_nvram Tekram;
-	} data;
-#endif
-};
-
-/*
  *  Common definitions for both bus space based and legacy IO methods.
  */
 #define INB(r)		INB_OFF(offsetof(struct sym_reg,r))
@@ -1114,23 +1108,6 @@ struct sym_hcb {
 
 #define HCB_BA(np, lbl)	(np->hcb_ba + offsetof(struct sym_hcb, lbl))
 
-/*
- *  NVRAM reading (sym_nvram.c).
- */
-#if SYM_CONF_NVRAM_SUPPORT
-void sym_nvram_setup_host (hcb_p np, struct sym_nvram *nvram);
-void sym_nvram_setup_target (hcb_p np, int target, struct sym_nvram *nvp);
-int sym_read_nvram (sdev_p np, struct sym_nvram *nvp);
-#else
-static inline void sym_nvram_setup_host(hcb_p np, struct sym_nvram *nvram) { }
-static inline void sym_nvram_setup_target(hcb_p np, struct sym_nvram *nvram) { }
-static inline int sym_read_nvram(sdev_p np, struct sym_nvram *nvp)
-{
-	nvp->type = 0;
-	return 0;
-}
-#endif
-
 
 /*
  *  FIRMWARES (sym_fw.c)
@@ -1257,8 +1234,8 @@ bad:
  *  Set up data pointers used by SCRIPTS.
  *  Called from O/S specific code.
  */
-static void __inline 
-sym_setup_data_pointers(hcb_p np, ccb_p cp, int dir)
+static inline void sym_setup_data_pointers(struct sym_hcb *np,
+		struct sym_ccb *cp, int dir)
 {
 	u32 lastp, goalp;
 
@@ -1321,15 +1298,6 @@ sym_setup_data_pointers(hcb_p np, ccb_p 
 /*
  *  MEMORY ALLOCATOR.
  */
-
-/*
- *  Shortest memory chunk is (1<<SYM_MEM_SHIFT), currently 16.
- *  Actual allocations happen as SYM_MEM_CLUSTER_SIZE sized.
- *  (1 PAGE at a time is just fine).
- */
-#define SYM_MEM_SHIFT	4
-#define SYM_MEM_CLUSTER_SIZE	(1UL << SYM_MEM_CLUSTER_SHIFT)
-#define SYM_MEM_CLUSTER_MASK	(SYM_MEM_CLUSTER_SIZE-1)
 
 /*
  *  Link between free memory chunks of a given size.
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Fri Mar 12 11:42:20 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c	Thu Mar 11 09:06:02 2004
@@ -315,7 +315,7 @@ __sym_sniff_inquiry(hcb_p np, u_char tn,
 	 */
 	inq_byte56 = tp->inq_byte56;
 	if (inq_version >= 4 && inq_len > 56)
-		tp->inq_byte56 = inq_data[56];
+		inq_byte56 = inq_data[56];
 #if 0
 printf("XXXXXX [%d] inq_version=%x inq_byte7=%x inq_byte56=%x XXXXX\n",
 	inq_len, inq_version, inq_byte7, inq_byte56);
@@ -328,6 +328,7 @@ printf("XXXXXX [%d] inq_version=%x inq_b
 	    tp->inq_byte56  != inq_byte56) {
 		tp->inq_version = inq_version;
 		tp->inq_byte7   = inq_byte7;
+		tp->inq_byte56  = inq_byte56;
 		return 1;
 	}
 	return 0;
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h	Fri Mar 12 11:42:20 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h	Thu Mar 11 09:06:02 2004
@@ -54,41 +54,6 @@
 #define SYM_MISC_H
 
 /*
- *  A 'read barrier' flushes any data that have been prefetched 
- *  by the processor due to out of order execution. Such a barrier 
- *  must notably be inserted prior to looking at data that have 
- *  been DMAed, assuming that program does memory READs in proper 
- *  order and that the device ensured proper ordering of WRITEs.
- *
- *  A 'write barrier' prevents any previous WRITEs to pass further 
- *  WRITEs. Such barriers must be inserted each time another agent 
- *  relies on ordering of WRITEs.
- *
- *  Note that, due to posting of PCI memory writes, we also must 
- *  insert dummy PCI read transactions when some ordering involving 
- *  both directions over the PCI does matter. PCI transactions are 
- *  fully ordered in each direction.
- *
- *  IA32 processors insert implicit barriers when the processor 
- *  accesses unchacheable either for reading or writing, and 
- *  donnot reorder WRITEs. As a result, some 'read barriers' can 
- *  be avoided (following access to uncacheable), and 'write 
- *  barriers' should be useless (preventing compiler optimizations 
- *  should be enough).
- */
-
-#define __READ_BARRIER()	rmb()
-#define __WRITE_BARRIER()	wmb()
-
-#ifndef MEMORY_READ_BARRIER
-#define MEMORY_READ_BARRIER()	__READ_BARRIER()
-#endif
-#ifndef MEMORY_WRITE_BARRIER
-#define MEMORY_WRITE_BARRIER()	__WRITE_BARRIER()
-#endif
-
-
-/*
  *  A la VMS/CAM-3 queue management.
  */
 typedef struct sym_quehead {
@@ -222,48 +187,11 @@ static __inline struct sym_quehead *sym_
 #define sym_is_bit(p, n)	(((u32 *)(p))[(n)>>5] &   (1<<((n)&0x1f)))
 
 /*
- *  Portable but silly implemented byte order primitives.
- */
-#if	BYTE_ORDER == BIG_ENDIAN
-
-#define __revb16(x) (	(((u16)(x) & (u16)0x00ffU) << 8) | \
-			(((u16)(x) & (u16)0xff00U) >> 8) 	)
-#define __revb32(x) (	(((u32)(x) & 0x000000ffU) << 24) | \
-			(((u32)(x) & 0x0000ff00U) <<  8) | \
-			(((u32)(x) & 0x00ff0000U) >>  8) | \
-			(((u32)(x) & 0xff000000U) >> 24)	)
-
-#define __htole16(v)	__revb16(v)
-#define __htole32(v)	__revb32(v)
-#define __le16toh(v)	__htole16(v)
-#define __le32toh(v)	__htole32(v)
-
-static __inline u16	_htole16(u16 v) { return __htole16(v); }
-static __inline u32	_htole32(u32 v) { return __htole32(v); }
-#define _le16toh	_htole16
-#define _le32toh	_htole32
-
-#else	/* LITTLE ENDIAN */
-
-#define __htole16(v)	(v)
-#define __htole32(v)	(v)
-#define __le16toh(v)	(v)
-#define __le32toh(v)	(v)
-
-#define _htole16(v)	(v)
-#define _htole32(v)	(v)
-#define _le16toh(v)	(v)
-#define _le32toh(v)	(v)
-
-#endif	/* BYTE_ORDER */
-
-/*
  * The below round up/down macros are to be used with a constant 
  * as argument (sizeof(...) for example), for the compiler to 
  * optimize the whole thing.
  */
 #define _U_(a,m)	(a)<=(1<<m)?m:
-#define _D_(a,m)	(a)<(1<<(m+1))?m:
 
 /*
  * Round up logarithm to base 2 of a 16 bit constant.
@@ -273,24 +201,5 @@ static __inline u32	_htole32(u32 v) { re
  _U_(a, 0)_U_(a, 1)_U_(a, 2)_U_(a, 3)_U_(a, 4)_U_(a, 5)_U_(a, 6)_U_(a, 7) \
  _U_(a, 8)_U_(a, 9)_U_(a,10)_U_(a,11)_U_(a,12)_U_(a,13)_U_(a,14)_U_(a,15) \
  16)
-
-/*
- * Round down logarithm to base 2 of a 16 bit constant.
- */
-#define _LGRD16_(a) \
-( \
- _D_(a, 0)_D_(a, 1)_D_(a, 2)_D_(a, 3)_D_(a, 4)_D_(a, 5)_D_(a, 6)_D_(a, 7) \
- _D_(a, 8)_D_(a, 9)_D_(a,10)_D_(a,11)_D_(a,12)_D_(a,13)_D_(a,14)_D_(a,15) \
- 16)
-
-/*
- * Round up a 16 bit constant to the nearest power of 2.
- */
-#define _SZRU16_(a) ((a)==0?0:(1<<_LGRU16_(a)))
-
-/*
- * Round down a 16 bit constant to the nearest power of 2.
- */
-#define _SZRD16_(a) ((a)==0?0:(1<<_LGRD16_(a)))
 
 #endif /* SYM_MISC_H */
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	Fri Mar 12 11:42:20 2004
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.c	Thu Mar 11 09:06:02 2004
@@ -50,11 +50,8 @@
  * SUCH DAMAGE.
  */
 
-#ifdef __FreeBSD__
-#include <dev/sym/sym_glue.h>
-#else
 #include "sym_glue.h"
-#endif
+#include "sym_nvram.h"
 
 /*
  *  Some poor and bogus sync table that refers to Tekram NVRAM layout.
@@ -246,8 +243,8 @@ static void sym_display_Tekram_nvram(str
 	}
 }
 #else
-static void sym_display_Symbios_nvram(struct sym_device *np, Symbios_nvram *nvram) { }
-static void sym_display_Tekram_nvram(struct sym_device *np, Tekram_nvram *nvram) { }
+static void sym_display_Symbios_nvram(struct sym_device *np, Symbios_nvram *nvram) { (void)np; (void)nvram; }
+static void sym_display_Tekram_nvram(struct sym_device *np, Tekram_nvram *nvram) { (void)np; (void)nvram; }
 #endif	/* SYM_CONF_DEBUG_NVRAM */
 
 
@@ -382,6 +379,61 @@ static void S24C16_read_byte(struct sym_
 
 	S24C16_write_ack(np, ack_data, gpreg, gpcntl);
 }
+
+#if SYM_CONF_NVRAM_WRITE_SUPPORT
+/*
+ *  Write 'len' bytes starting at 'offset'.
+ */
+static int sym_write_S24C16_nvram(struct sym_device *np, int offset,
+		u_char *data, int len)
+{
+	u_char	gpcntl, gpreg;
+	u_char	old_gpcntl, old_gpreg;
+	u_char	ack_data;
+	int	x;
+
+	/* save current state of GPCNTL and GPREG */
+	old_gpreg	= INB (nc_gpreg);
+	old_gpcntl	= INB (nc_gpcntl);
+	gpcntl		= old_gpcntl & 0x1c;
+
+	/* set up GPREG & GPCNTL to set GPIO0 and GPIO1 in to known state */
+	OUTB (nc_gpreg,  old_gpreg);
+	OUTB (nc_gpcntl, gpcntl);
+
+	/* this is to set NVRAM into a known state with GPIO0/1 both low */
+	gpreg = old_gpreg;
+	S24C16_set_bit(np, 0, &gpreg, CLR_CLK);
+	S24C16_set_bit(np, 0, &gpreg, CLR_BIT);
+		
+	/* now set NVRAM inactive with GPIO0/1 both high */
+	S24C16_stop(np, &gpreg);
+
+	/* NVRAM has to be written in segments of 16 bytes */
+	for (x = 0; x < len ; x += 16) {
+		do {
+			S24C16_start(np, &gpreg);
+			S24C16_write_byte(np, &ack_data,
+					  0xa0 | (((offset+x) >> 7) & 0x0e),
+					  &gpreg, &gpcntl);
+		} while (ack_data & 0x01);
+
+		S24C16_write_byte(np, &ack_data, (offset+x) & 0xff, 
+				  &gpreg, &gpcntl);
+
+		for (y = 0; y < 16; y++)
+			S24C16_write_byte(np, &ack_data, data[x+y], 
+					  &gpreg, &gpcntl);
+		S24C16_stop(np, &gpreg);
+	}
+
+	/* return GPIO0/1 to original states after having accessed NVRAM */
+	OUTB (nc_gpcntl, old_gpcntl);
+	OUTB (nc_gpreg,  old_gpreg);
+
+	return 0;
+}
+#endif /* SYM_CONF_NVRAM_WRITE_SUPPORT */
 
 /*
  *  Read 'len' bytes starting at 'offset'.
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h
--- linus-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	Wed Dec 31 17:00:00 1969
+++ parisc-2.6/drivers/scsi/sym53c8xx_2/sym_nvram.h	Fri Oct 17 07:32:00 2003
@@ -0,0 +1,216 @@
+/*
+ * Device driver for the SYMBIOS/LSILOGIC 53C8XX and 53C1010 family 
+ * of PCI-SCSI IO processors.
+ *
+ * Copyright (C) 1999-2001  Gerard Roudier <groudier@free.fr>
+ *
+ * This driver is derived from the Linux sym53c8xx driver.
+ * Copyright (C) 1998-2000  Gerard Roudier
+ *
+ * The sym53c8xx driver is derived from the ncr53c8xx driver that had been 
+ * a port of the FreeBSD ncr driver to Linux-1.2.13.
+ *
+ * The original ncr driver has been written for 386bsd and FreeBSD by
+ *         Wolfgang Stanglmeier        <wolf@cologne.de>
+ *         Stefan Esser                <se@mi.Uni-Koeln.de>
+ * Copyright (C) 1994  Wolfgang Stanglmeier
+ *
+ * Other major contributions:
+ *
+ * NVRAM detection and reading.
+ * Copyright (C) 1997 Richard Waltham <dormouse@farsrobt.demon.co.uk>
+ *
+ *-----------------------------------------------------------------------------
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Where this Software is combined with software released under the terms of 
+ * the GNU Public License ("GPL") and the terms of the GPL would require the 
+ * combined work to also be released under the terms of the GPL, the terms
+ * and conditions of this License will apply in addition to those of the
+ * GPL with the exception of any terms or conditions of this License that
+ * conflict with, or are expressly prohibited by, the GPL.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
+ * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef SYM_NVRAM_H
+#define SYM_NVRAM_H
+
+#include "sym_conf.h"
+
+/*
+ *	Symbios NVRAM data format
+ */
+#define SYMBIOS_NVRAM_SIZE 368
+#define SYMBIOS_NVRAM_ADDRESS 0x100
+
+struct Symbios_nvram {
+/* Header 6 bytes */
+	u_short type;		/* 0x0000 */
+	u_short byte_count;	/* excluding header/trailer */
+	u_short checksum;
+
+/* Controller set up 20 bytes */
+	u_char	v_major;	/* 0x00 */
+	u_char	v_minor;	/* 0x30 */
+	u32	boot_crc;
+	u_short	flags;
+#define SYMBIOS_SCAM_ENABLE	(1)
+#define SYMBIOS_PARITY_ENABLE	(1<<1)
+#define SYMBIOS_VERBOSE_MSGS	(1<<2)
+#define SYMBIOS_CHS_MAPPING	(1<<3)
+#define SYMBIOS_NO_NVRAM	(1<<3)	/* ??? */
+	u_short	flags1;
+#define SYMBIOS_SCAN_HI_LO	(1)
+	u_short	term_state;
+#define SYMBIOS_TERM_CANT_PROGRAM	(0)
+#define SYMBIOS_TERM_ENABLED		(1)
+#define SYMBIOS_TERM_DISABLED		(2)
+	u_short	rmvbl_flags;
+#define SYMBIOS_RMVBL_NO_SUPPORT	(0)
+#define SYMBIOS_RMVBL_BOOT_DEVICE	(1)
+#define SYMBIOS_RMVBL_MEDIA_INSTALLED	(2)
+	u_char	host_id;
+	u_char	num_hba;	/* 0x04 */
+	u_char	num_devices;	/* 0x10 */
+	u_char	max_scam_devices;	/* 0x04 */
+	u_char	num_valid_scam_devices;	/* 0x00 */
+	u_char	flags2;
+#define SYMBIOS_AVOID_BUS_RESET		(1<<2)
+
+/* Boot order 14 bytes * 4 */
+	struct Symbios_host{
+		u_short	type;		/* 4:8xx / 0:nok */
+		u_short	device_id;	/* PCI device id */
+		u_short	vendor_id;	/* PCI vendor id */
+		u_char	bus_nr;		/* PCI bus number */
+		u_char	device_fn;	/* PCI device/function number << 3*/
+		u_short	word8;
+		u_short	flags;
+#define	SYMBIOS_INIT_SCAN_AT_BOOT	(1)
+		u_short	io_port;	/* PCI io_port address */
+	} host[4];
+
+/* Targets 8 bytes * 16 */
+	struct Symbios_target {
+		u_char	flags;
+#define SYMBIOS_DISCONNECT_ENABLE	(1)
+#define SYMBIOS_SCAN_AT_BOOT_TIME	(1<<1)
+#define SYMBIOS_SCAN_LUNS		(1<<2)
+#define SYMBIOS_QUEUE_TAGS_ENABLED	(1<<3)
+		u_char	rsvd;
+		u_char	bus_width;	/* 0x08/0x10 */
+		u_char	sync_offset;
+		u_short	sync_period;	/* 4*period factor */
+		u_short	timeout;
+	} target[16];
+/* Scam table 8 bytes * 4 */
+	struct Symbios_scam {
+		u_short	id;
+		u_short	method;
+#define SYMBIOS_SCAM_DEFAULT_METHOD	(0)
+#define SYMBIOS_SCAM_DONT_ASSIGN	(1)
+#define SYMBIOS_SCAM_SET_SPECIFIC_ID	(2)
+#define SYMBIOS_SCAM_USE_ORDER_GIVEN	(3)
+		u_short status;
+#define SYMBIOS_SCAM_UNKNOWN		(0)
+#define SYMBIOS_SCAM_DEVICE_NOT_FOUND	(1)
+#define SYMBIOS_SCAM_ID_NOT_SET		(2)
+#define SYMBIOS_SCAM_ID_VALID		(3)
+		u_char	target_id;
+		u_char	rsvd;
+	} scam[4];
+
+	u_char	spare_devices[15*8];
+	u_char	trailer[6];		/* 0xfe 0xfe 0x00 0x00 0x00 0x00 */
+};
+typedef struct Symbios_nvram	Symbios_nvram;
+typedef struct Symbios_host	Symbios_host;
+typedef struct Symbios_target	Symbios_target;
+typedef struct Symbios_scam	Symbios_scam;
+
+/*
+ *	Tekram NvRAM data format.
+ */
+#define TEKRAM_NVRAM_SIZE 64
+#define TEKRAM_93C46_NVRAM_ADDRESS 0
+#define TEKRAM_24C16_NVRAM_ADDRESS 0x40
+
+struct Tekram_nvram {
+	struct Tekram_target {
+		u_char	flags;
+#define	TEKRAM_PARITY_CHECK		(1)
+#define TEKRAM_SYNC_NEGO		(1<<1)
+#define TEKRAM_DISCONNECT_ENABLE	(1<<2)
+#define	TEKRAM_START_CMD		(1<<3)
+#define TEKRAM_TAGGED_COMMANDS		(1<<4)
+#define TEKRAM_WIDE_NEGO		(1<<5)
+		u_char	sync_index;
+		u_short	word2;
+	} target[16];
+	u_char	host_id;
+	u_char	flags;
+#define TEKRAM_MORE_THAN_2_DRIVES	(1)
+#define TEKRAM_DRIVES_SUP_1GB		(1<<1)
+#define	TEKRAM_RESET_ON_POWER_ON	(1<<2)
+#define TEKRAM_ACTIVE_NEGATION		(1<<3)
+#define TEKRAM_IMMEDIATE_SEEK		(1<<4)
+#define	TEKRAM_SCAN_LUNS		(1<<5)
+#define	TEKRAM_REMOVABLE_FLAGS		(3<<6)	/* 0: disable; */
+						/* 1: boot device; 2:all */
+	u_char	boot_delay_index;
+	u_char	max_tags_index;
+	u_short	flags1;
+#define TEKRAM_F2_F6_ENABLED		(1)
+	u_short	spare[29];
+};
+typedef struct Tekram_nvram	Tekram_nvram;
+typedef struct Tekram_target	Tekram_target;
+
+/*
+ *  Union of supported NVRAM formats.
+ */
+struct sym_nvram {
+	int type;
+#define	SYM_SYMBIOS_NVRAM	(1)
+#define	SYM_TEKRAM_NVRAM	(2)
+#if SYM_CONF_NVRAM_SUPPORT
+	union {
+		Symbios_nvram Symbios;
+		Tekram_nvram Tekram;
+	} data;
+#endif
+};
+
+#if SYM_CONF_NVRAM_SUPPORT
+void sym_nvram_setup_host (struct sym_hcb *np, struct sym_nvram *nvram);
+void sym_nvram_setup_target (struct sym_hcb *np, int target, struct sym_nvram *nvp);
+int sym_read_nvram (struct sym_device *np, struct sym_nvram *nvp);
+#else
+static inline void sym_nvram_setup_host(struct sym_hcb *np, struct sym_nvram *nvram) { }
+static inline void sym_nvram_setup_target(struct sym_hcb *np, struct sym_nvram *nvram) { }
+static inline int sym_read_nvram(struct sym_device *np, struct sym_nvram *nvp)
+{
+	nvp->type = 0;
+	return 0;
+}
+#endif
+
+#endif /* SYM_NVRAM_H */

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
