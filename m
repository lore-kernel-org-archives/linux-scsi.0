From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH]DC395: cleanup of module code
Date: Thu, 29 May 2003 12:50:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305291250.30694.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:55940 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S262135AbTE2Khd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 06:37:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

Hi,

this is a major cleanup of module related code in the dc395 driver.

	Regards
		Oliver


You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1191, 2003-05-28 12:05:53+02:00, oliver@vermuden.neukum.org
  - major cleanup of the module code


 dc395x.c |  708 +++++++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 420 insertions(+), 288 deletions(-)


diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Wed May 28 12:08:44 2003
+++ b/drivers/scsi/dc395x.c	Wed May 28 12:08:44 2003
@@ -47,6 +47,7 @@
  ************************************************************************
  */
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/blk.h>
@@ -209,16 +210,6 @@
 #define PCI_DEVICE_ID_TEKRAM_TRMS1040           0x0391	/* Device ID    */
 #endif
 
-static struct pci_device_id dc395x_pci_tbl[] __devinitdata = {
-	{
-		.vendor		= PCI_VENDOR_ID_TEKRAM,
-		.device		= PCI_DEVICE_ID_TEKRAM_TRMS1040,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	 },
-	{}			/* Terminating entry */
-};
-MODULE_DEVICE_TABLE(pci, dc395x_pci_tbl);
 
 
 #define DC395x_LOCK_IO(dev)   spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
@@ -546,7 +537,6 @@
 				      struct DeviceCtlBlk *pDCB);
 void DC395x_initDCB(struct AdapterCtlBlk *pACB,
 		    struct DeviceCtlBlk **ppDCB, u8 target, u8 lun);
-int DC395x_shutdown(struct Scsi_Host *host);
 static void DC395x_remove_dev(struct AdapterCtlBlk *pACB,
 			      struct DeviceCtlBlk *pDCB);
 
@@ -613,116 +603,203 @@
 static u16 dc395x_clock_speed[] = { 200, 133, 100, 80, 67, 58, 50, 40 };
 /* real period:48ns,72ns,100ns,124ns,148ns,172ns,200ns,248ns */
 
+
+
+/*---------------------------------------------------------------------------
+                                Configuration
+  ---------------------------------------------------------------------------*/
+
+/*
+ * Command line parameters are stored in a structure below.
+ * These are the index's into the strcuture for the various
+ * command line options.
+ */
+#define CFG_ADAPTER_ID		0
+#define CFG_MAX_SPEED		1
+#define CFG_DEV_MODE		2
+#define CFG_ADAPTER_MODE	3
+#define CFG_TAGS		4
+#define CFG_RESET_DELAY		5
+
+#define CFG_NUM			6	/* number of configuration items */
+
+
 /*
- * Override defaults on cmdline:
- * dc395x_trm = AdaptID, MaxSpeed (Index), DevMode (Bitmapped), AdaptMode (Bitmapped), Tags (log2-1), DelayReset
+ * Value used to indicate that a command line override
+ * hasn't been used to modify the value.
  */
-int dc395x_trm[] = { -2, -2, -2, -2, -2, -2 };
+#define CFG_PARAM_UNSET -1
+
 
-#if defined(MODULE)
-MODULE_PARM(dc395x_trm, "1-6i");
-MODULE_PARM_DESC(dc395x_trm,
-		 "Host SCSI ID, Speed (0=20MHz), Device Flags, Adapter Flags, Max Tags (log2(tags)-1), DelayReset (s)");
+/*
+ * Hold command line parameters.
+ */
+struct dc395x_config_data {
+	int value;		/* value of this setting */
+	int min;		/* minimum value */
+	int max;		/* maximum value */
+	int def;		/* default value */
+	int safe;		/* safe value */
+};
+struct dc395x_config_data __initdata cfg_data[] = {
+	{ /* adapter id */
+		CFG_PARAM_UNSET,
+		0,
+		15,
+		7,
+		7
+	},
+	{ /* max speed */
+		CFG_PARAM_UNSET,
+		  0,
+		  7,
+		  1,	/* 13.3Mhz */
+		  4,	/*  6.7Hmz */
+	},
+	{ /* dev mode */
+		CFG_PARAM_UNSET,
+		0,
+		0x3f,
+		NTC_DO_PARITY_CHK | NTC_DO_DISCONNECT | NTC_DO_SYNC_NEGO |
+			NTC_DO_WIDE_NEGO | NTC_DO_TAG_QUEUEING |
+			NTC_DO_SEND_START,
+		NTC_DO_PARITY_CHK | NTC_DO_SEND_START
+	},
+	{ /* adapter mode */
+		CFG_PARAM_UNSET,
+		0,
+		0x2f,
+#ifdef CONFIG_SCSI_MULTI_LUN
+			NAC_SCANLUN |
 #endif
+		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET
+			/*| NAC_ACTIVE_NEG*/,
+		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET | 0x08
+	},
+	{ /* tags */
+		CFG_PARAM_UNSET,
+		0,
+		5,
+		3,	/* 16 tags (??) */
+		2,
+	},
+	{ /* reset delay */
+		CFG_PARAM_UNSET,
+		0,
+		180,
+		1,	/* 1 second */
+		10,	/* 10 seconds */
+	}
+};
 
-MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
-MODULE_DESCRIPTION
-    ("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
-MODULE_SUPPORTED_DEVICE("sd,sr,sg,st");
 
-MODULE_LICENSE("GPL");
+/*
+ * Safe settings. If set to zero the the BIOS/default values with command line
+ * overrides will be used. If set to 1 then safe and slow settings will be used.
+ */
+static int dc395x_safe = 0;
+module_param_named(safe, dc395x_safe, bool, 0);
+MODULE_PARM_DESC(safe, "Use safe and slow settings only. Default: false");
 
-/* Delaying after a reset */
-static char __initdata DC395x_interpd[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
 
-/* Convert EEprom value to seconds */
-static void __init DC395x_interpret_delay(struct NvRamType *eeprom)
-{
-	/*printk (DC395X_NAME, "Debug: Delay: %i\n", eeprom->NvramDelayTime); */
-	eeprom->NvramDelayTime = DC395x_interpd[eeprom->NvramDelayTime];
-}
+module_param_named(adapter_id, cfg_data[CFG_ADAPTER_ID].value, int, 0);
+MODULE_PARM_DESC(adapter_id, "Adapter SCSI ID. Default 7 (0-15)");
 
-/* seconds to EEProm value */
-static int __init DC395x_uninterpret_delay(int delay)
-{
-	u8 idx = 0;
-	while (idx < 7 && DC395x_interpd[idx] < delay)
-		idx++;
-	return idx;
-}
+module_param_named(max_speed, cfg_data[CFG_MAX_SPEED].value, int, 0);
+MODULE_PARM_DESC(max_speed, "Maximum bus speed. Default 1 (0-7) Speeds: 0=20, 1=13.3, 2=10, 3=8, 4=6.7, 5=5.8, 6=5, 7=4 Mhz");
 
+module_param_named(dev_mode, cfg_data[CFG_DEV_MODE].value, int, 0);
+MODULE_PARM_DESC(dev_mode, "Device mode.");
 
-/* Handle "-1" case */
-static void __init DC395x_check_for_safe_settings(void)
+module_param_named(adapter_mode, cfg_data[CFG_ADAPTER_MODE].value, int, 0);
+MODULE_PARM_DESC(adapter_mode, "Adapter mode.");
+
+module_param_named(tags, cfg_data[CFG_TAGS].value, int, 0);
+MODULE_PARM_DESC(tags, "Number of tags (1<<x). Default 3 (0-5)");
+
+module_param_named(reset_delay, cfg_data[CFG_RESET_DELAY].value, int, 0);
+MODULE_PARM_DESC(reset_delay, "Reset delay in seconds. Default 1 (0-180)");
+
+
+/**
+ * set_safe_settings - if the safe parameter is set then
+ * set all values to the safe and slow values.
+ **/
+static
+void __init set_safe_settings(void)
 {
-	if (dc395x_trm[0] == -1 || dc395x_trm[0] > 15) {	/* modules-2.0.0 passes -1 as string */
-		dc395x_trm[0] = 7;
-		dc395x_trm[1] = 4;
-		dc395x_trm[2] = 0x09;
-		dc395x_trm[3] = 0x0f;
-		dc395x_trm[4] = 2;
-		dc395x_trm[5] = 10;
-		dprintkl(KERN_INFO, "Using safe settings.\n");
+	if (dc395x_safe)
+	{
+		int i;
+
+		dprintkl(KERN_INFO, "Using sage settings.\n");
+		for (i = 0; i < CFG_NUM; i++)
+		{
+			cfg_data[i].value = cfg_data[i].safe;
+		}
 	}
 }
 
-/* Defaults, to be overriden by (a) BIOS and (b) Cmnd line (kernel/module) args */
-int __initdata dc395x_def[] = { 7, 1 /* 13.3MHz */ ,
-	NTC_DO_PARITY_CHK | NTC_DO_DISCONNECT | NTC_DO_SYNC_NEGO |
-	    NTC_DO_WIDE_NEGO | NTC_DO_TAG_QUEUEING | NTC_DO_SEND_START,
-	NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET
-	    /* | NAC_ACTIVE_NEG */
-#ifdef CONFIG_SCSI_MULTI_LUN
-	    | NAC_SCANLUN
-#endif
-	    , 3 /* 16 Tags per LUN */ , 1	/* s delay after Reset */
-};
 
-/* Copy defaults over set values where missing */
-static void __init DC395x_fill_with_defaults(void)
+/**
+ * fix_settings - reset any boot parmeters which are out of range
+ * back to the default values.
+ **/
+static
+void __init fix_settings(void)
 {
 	int i;
+
 	dprintkdbg(DBG_PARSE, "setup %08x %08x %08x %08x %08x %08x\n",
-		    dc395x_trm[0], dc395x_trm[1], dc395x_trm[2],
-		    dc395x_trm[3], dc395x_trm[4], dc395x_trm[5]);
-	for (i = 0; i < 6; i++) {
-		if (dc395x_trm[i] < 0 || dc395x_trm[i] > 255)
-			dc395x_trm[i] = dc395x_def[i];
-	}
-	/* Sanity checks */
-	if (dc395x_trm[0] > 15)
-		dc395x_trm[0] = 7;
-	if (dc395x_trm[1] > 7)
-		dc395x_trm[1] = 4;
-	if (dc395x_trm[4] > 5)
-		dc395x_trm[4] = 4;
-	if (dc395x_trm[5] > 180)
-		dc395x_trm[5] = 180;
+		    cfg_data[CFG_ADAPTER_ID].value,
+		    cfg_data[CFG_MAX_SPEED].value,
+		    cfg_data[CFG_DEV_MODE].value,
+		    cfg_data[CFG_ADAPTER_MODE].value,
+		    cfg_data[CFG_TAGS].value,
+		    cfg_data[CFG_RESET_DELAY].value);
+	for (i = 0; i < CFG_NUM; i++)
+	{
+		if (cfg_data[i].value < cfg_data[i].min ||
+			cfg_data[i].value > cfg_data[i].max)
+		{
+			cfg_data[i].value = cfg_data[i].def;
+		}
+	}
 }
 
 
-/* Read the parameters from the command line */
-#if !defined(MODULE)
-static int DC395x_trm_setup(char *str)
-{
-	int i;
-	int im;
-	int ints[8];
-	(void) get_options(str, ARRAY_SIZE(ints), ints);
-	im = ints[0];
-	if (im > 6) {
-		dprintkl(KERN_NOTICE, "ignore extra params!\n");
-		im = 6;
-	}
-	for (i = 0; i < im; i++)
-		dc395x_trm[i] = ints[i + 1];
 
-	return 1;
+/*
+ * Mapping from the eeprom value (index into this array) to the
+ * the number of actual seconds that the delay should be for.
+ */
+static
+char __initdata eeprom_index_to_delay_map[] = { 1, 3, 5, 10, 16, 30, 60, 120 };
+
+
+/**
+ * eeprom_index_to_delay - Take the eeprom delay setting and convert it
+ * into a number of seconds.
+ */
+static void __init eeprom_index_to_delay(struct NvRamType *eeprom)
+{
+	eeprom->NvramDelayTime = eeprom_index_to_delay_map[eeprom->NvramDelayTime];
 }
 
-__setup(DC395X_NAME "=", DC395x_trm_setup);
 
-#endif				/* !MODULE */
+/**
+ * delay_to_eeprom_index - Take a delay in seconds and return the closest
+ * eeprom index which will delay for at least that amount of seconds.
+ */
+static int __init delay_to_eeprom_index(int delay)
+{
+	u8 idx = 0;
+	while (idx < 7 && eeprom_index_to_delay_map[idx] < delay) {
+		idx++;
+	}
+	return idx;
+}
+
 
 /* Overrride BIOS values with the set ones */
 static void __init DC395x_EEprom_Override(struct NvRamType *eeprom)
@@ -730,21 +807,32 @@
 	u8 id;
 
 	/* Adapter Settings */
-	if (dc395x_trm[0] != -2)
-		eeprom->NvramScsiId = (u8) dc395x_trm[0];	/* Adapter ID */
-	if (dc395x_trm[3] != -2)
-		eeprom->NvramChannelCfg = (u8) dc395x_trm[3];
-	if (dc395x_trm[5] != -2)
-		eeprom->NvramDelayTime = DC395x_uninterpret_delay(dc395x_trm[5]);	/* Reset delay */
-	if (dc395x_trm[4] != -2)
-		eeprom->NvramMaxTag = (u8) dc395x_trm[4];	/* Tagged Cmds */
+	if (cfg_data[CFG_ADAPTER_ID].value != CFG_PARAM_UNSET) {
+		eeprom->NvramScsiId =
+		    (u8)cfg_data[CFG_ADAPTER_ID].value;
+	}
+	if (cfg_data[CFG_ADAPTER_MODE].value != CFG_PARAM_UNSET) {
+		eeprom->NvramChannelCfg =
+		    (u8)cfg_data[CFG_ADAPTER_MODE].value;
+	}
+	if (cfg_data[CFG_RESET_DELAY].value != CFG_PARAM_UNSET) {
+		eeprom->NvramDelayTime =
+		    delay_to_eeprom_index(cfg_data[CFG_RESET_DELAY].value);
+	}
+	if (cfg_data[CFG_TAGS].value != CFG_PARAM_UNSET) {
+		eeprom->NvramMaxTag = (u8)cfg_data[CFG_TAGS].value;
+	}
 
 	/* Device Settings */
 	for (id = 0; id < DC395x_MAX_SCSI_ID; id++) {
-		if (dc395x_trm[2] != -2)
-			eeprom->NvramTarget[id].NvmTarCfg0 = (u8) dc395x_trm[2];	/* Cfg0 */
-		if (dc395x_trm[1] != -2)
-			eeprom->NvramTarget[id].NvmTarPeriod = (u8) dc395x_trm[1];	/* Speed */
+		if (cfg_data[CFG_DEV_MODE].value != CFG_PARAM_UNSET) {
+			eeprom->NvramTarget[id].NvmTarCfg0 =
+			    (u8)cfg_data[CFG_DEV_MODE].value;
+		}
+		if (cfg_data[CFG_MAX_SPEED].value != CFG_PARAM_UNSET) {
+			eeprom->NvramTarget[id].NvmTarPeriod =
+			    (u8)cfg_data[CFG_MAX_SPEED].value;
+		}
 	}
 }
 
@@ -1346,7 +1434,7 @@
 #if debug_enabled(DBG_RECURSION)
 	if (dbg_in_driver++ > NORM_REC_LVL) {
 		dprintkl(KERN_DEBUG,
-			": %i queue_command () recursion? (pid=%li)\n",
+			"%i queue_command () recursion? (pid=%li)\n",
 			dbg_in_driver, cmd->pid);
 	}
 #endif
@@ -1928,7 +2016,7 @@
 	struct ScsiReqBlk *pSRB;
 	dprintkl(KERN_DEBUG, "Chip forgot to produce SelTO IRQ!\n");
 	if (!pACB->pActiveDCB || !pACB->pActiveDCB->pActiveSRB) {
-		dprintkl(KERN_DEBUG, " ... but no cmd pending? Oops!\n");
+		dprintkl(KERN_DEBUG, "... but no cmd pending? Oops!\n");
 		return;
 	}
 	DC395x_LOCK_IO(pACB->pScsiHost);
@@ -4160,6 +4248,7 @@
 {
 	struct DeviceCtlBlk *pPrevDCB = pACB->pLinkDCB;
 
+	dprintkdbg(DBG_0, "remove_dev\n");
 	if (pDCB->GoingSRBCnt > 1) {
 		dprintkdbg(DBG_DCB, "Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCnt %i\n",
 			  pDCB->TargetID, pDCB->TargetLUN, (int) pDCB,
@@ -4982,6 +5071,7 @@
 
 
 /* Free SG tables */
+static
 void DC395x_free_SG_tables(struct AdapterCtlBlk *pACB, int SRBIdx)
 {
 	int srbidx;
@@ -5497,10 +5587,10 @@
 		cksum += *w_eeprom;
 	if (cksum != 0x1234) {
 		/*
-		 * Checksum is wrong. 
+		 * Checksum is wrong.
 		 * Load a set of defaults into the eeprom buffer
 		 */
-		dprintkl(KERN_WARNING, 
+		dprintkl(KERN_WARNING,
 		       "EEProm checksum error: using default values and options.\n");
 		eeprom->NvramSubVendorID[0] = (u8) PCI_VENDOR_ID_TEKRAM;
 		eeprom->NvramSubVendorID[1] =
@@ -5529,8 +5619,8 @@
 			*d_eeprom = 0x00;
 
 		/* Now load defaults (maybe set by boot/module params) */
-		DC395x_check_for_safe_settings();
-		DC395x_fill_with_defaults();
+		set_safe_settings();
+		fix_settings();
 		DC395x_EEprom_Override(eeprom);
 
 		eeprom->NvramCheckSum = 0x00;
@@ -5540,16 +5630,16 @@
 
 		*w_eeprom = 0x1234 - cksum;
 		TRM_S1040_write_all(eeprom, io_port);
-		eeprom->NvramDelayTime = dc395x_trm[5];
+		eeprom->NvramDelayTime = cfg_data[CFG_RESET_DELAY].value;
 	} else {
-		DC395x_check_for_safe_settings();
-		DC395x_interpret_delay(eeprom);
+		set_safe_settings();
+		eeprom_index_to_delay(eeprom);
 		DC395x_EEprom_Override(eeprom);
 	}
 }
 
 
-/* 
+/*
  * adapter - print connection and terminiation config
  *
  * @param pACB - adapter control block
@@ -5586,6 +5676,29 @@
 }
 
 
+/**
+ * DC395x_print_eeprom_settings - output the eeprom settings
+ * to the kernel log so people can see what they were.
+ *
+ * @index: Adapter number
+ **/
+static void __init
+DC395x_print_eeprom_settings(u16 index)
+{
+	dprintkl(KERN_INFO, "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), DevMode=0x%02x\n",
+	       dc395x_trm_eepromBuf[index].NvramScsiId,
+	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarPeriod,
+	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarPeriod] / 10,
+	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarPeriod] % 10,
+	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarCfg0);
+	dprintkl(KERN_INFO, "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
+	       dc395x_trm_eepromBuf[index].NvramChannelCfg,
+	       dc395x_trm_eepromBuf[index].NvramMaxTag,
+	       1 << dc395x_trm_eepromBuf[index].NvramMaxTag,
+	       dc395x_trm_eepromBuf[index].NvramDelayTime);
+}
+
+
 /*
  *********************************************************************
  *			DC395x_detect
@@ -5610,119 +5723,44 @@
 	 */
 	DC395x_check_eeprom(&dc395x_trm_eepromBuf[index], (u16) io_port);
 
-	/*$$$$$$$$$$$  MEMORY ALLOCATE FOR ADAPTER CONTROL BLOCK $$$$$$$$$$$$ */
+	/*
+	 *$$$$$$$$$$$  MEMORY ALLOCATE FOR ADAPTER CONTROL BLOCK $$$$$$$$$$$$
+	 */
 	host = scsi_register(host_template, sizeof(struct AdapterCtlBlk));
 	if (!host) {
 		dprintkl(KERN_INFO, "pSH scsi_register ERROR\n");
 		return 0;
 	}
-	dprintkl(KERN_INFO,
-	       "Used settings: AdapterID=%02i, Speed=%i(%02i.%01iMHz), DevMode=0x%02x\n",
-	       dc395x_trm_eepromBuf[index].NvramScsiId,
-	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarPeriod,
-	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].
-				  NvramTarget[0].NvmTarPeriod] / 10,
-	       dc395x_clock_speed[dc395x_trm_eepromBuf[index].
-				  NvramTarget[0].NvmTarPeriod] % 10,
-	       dc395x_trm_eepromBuf[index].NvramTarget[0].NvmTarCfg0);
-	dprintkl(KERN_INFO,
-	       "               AdaptMode=0x%02x, Tags=%i(%02i), DelayReset=%is\n",
-	       dc395x_trm_eepromBuf[index].NvramChannelCfg,
-	       dc395x_trm_eepromBuf[index].NvramMaxTag,
-	       1 << dc395x_trm_eepromBuf[index].NvramMaxTag,
-	       dc395x_trm_eepromBuf[index].NvramDelayTime);
+	DC395x_print_eeprom_settings(index);
 
 	pACB = (struct AdapterCtlBlk *) host->hostdata;
-	/*DC395x_ACB_INITLOCK(pACB); */
-	/*DC395x_ACB_LOCK(pACB,acb_flags); */
-	/*$$$$$$$$ INITIAL ADAPTER CONTROL BLOCK $$$$$$$$$$$$ */
+
 	if (DC395x_initACB(host, io_port, irq, index)) {
 		scsi_unregister(host);
-		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
 		return 0;
 	}
 	DC395x_print_config(pACB);
-	/*$$$$$$$$$$$$$$$$$ INITIAL ADAPTER $$$$$$$$$$$$$$$$$ */
+
+       /*
+        *$$$$$$$$$$$$$$$$$ INITIAL ADAPTER $$$$$$$$$$$$$$$$$
+        */
 	if (!DC395x_initAdapter(host, io_port, irq, index)) {
 		if (!DC395x_pACB_start) {
 			DC395x_pACB_start = pACB;
-			DC395x_pACB_current = pACB;
-			pACB->pNextACB = NULL;
 		} else {
 			DC395x_pACB_current->pNextACB = pACB;
-			DC395x_pACB_current = pACB;
-			pACB->pNextACB = NULL;
 		}
-		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
-		return host;
+		DC395x_pACB_current = pACB;
+		pACB->pNextACB = NULL;
+
 	} else {
-		dprintkl(KERN_INFO,
-		       "DC395x_initAdapter initial ERROR\n");
+		dprintkl(KERN_INFO, "DC395x_initAdapter initial ERROR\n");
 		scsi_unregister(host);
-		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
-		return 0;
+		host = NULL;
 	}
+	return host;
 }
 
-
-/*
- * DC395x_detect
- *
- * Detect TRM-S1040 cards, acquire resources and initialise the card.
- * Argument is a pointer to the host driver's scsi_hosts entry.
- *
- * Returns the number of adapters found.
- *
- * This function is called during system initialization and must not
- * call SCSI mid-level functions including scsi_malloc() and
- * scsi_free().
- */
-static int __init DC395x_detect(Scsi_Host_Template * host_template)
-{
-	struct pci_dev *pdev = NULL;
-	unsigned int io_port;
-	u8 irq;
-	DC395x_pACB_start = NULL;
-
-	/* without PCI we cannot do anything */
-	if (pci_present() == 0) {
-		dprintkl(KERN_INFO, "PCI not present\n");
-		return 0;
-	}
-	dprintkl(KERN_INFO, "%s %s\n", DC395X_BANNER, DC395X_VERSION);
-
-	while ((pdev =
-		pci_find_device(PCI_VENDOR_ID_TEKRAM,
-				PCI_DEVICE_ID_TEKRAM_TRMS1040, pdev))) {
-		struct Scsi_Host *scsi_host;
-		if (pci_enable_device(pdev))
-			continue;
-
-		io_port =
-		    pci_resource_start(pdev, 0) & PCI_BASE_ADDRESS_IO_MASK;
-		irq = pdev->irq;
-		dprintkdbg(DBG_0, "IO_PORT=%04x,IRQ=%x\n", (unsigned int) io_port, irq);
-		if ((scsi_host =
-		     DC395x_init(host_template, io_port, irq,
-				 DC395x_adapterCnt))) {
-			pci_set_master(pdev);
-			((struct AdapterCtlBlk *) (scsi_host->hostdata))->
-			    pdev = pdev;
-			/*DC395x_set_pci_cfg(pdev); */
-			DC395x_adapterCnt++;
-		}
-	}
-
-	if (DC395x_adapterCnt) {
-		host_template->proc_name = DC395X_NAME;
-	}
-	dprintkl(KERN_INFO, "%s: %i adapters found\n",
-	       DC395X_BANNER, DC395x_adapterCnt);
-
-	return DC395x_adapterCnt;
-}
-
-
 /*
  * Functions: DC395x_inquiry(), DC395x_inquiry_done()
  *
@@ -6014,130 +6052,224 @@
 }
 
 
-/*
- * Function : int DC395x_shutdown (struct Scsi_Host *host)
- *  Purpose : does a clean (we hope) shutdown of the SCSI chip.
- *		Use prior to dumping core, unloading the driver, etc.
- *  Returns : 0 on success
- */
-int DC395x_shutdown(struct Scsi_Host *host)
+/**
+ * DC395x_chip_shutdown - cleanly shut down the scsi controller chip,
+ * stopping all operations and disablig interrupt generation on the
+ * card.
+ *
+ * @acb: The scsi adapter control block of the adapter to shut down.
+ **/
+static
+void DC395x_chip_shutdown(struct AdapterCtlBlk *pACB)
 {
-	struct AdapterCtlBlk *pACB;
-	pACB = (struct AdapterCtlBlk *) (host->hostdata);
-
-	/* pACB->soft_reset(host); */
-
 	/* disable interrupt */
 	DC395x_write8(TRM_S1040_DMA_INTEN, 0);
 	DC395x_write8(TRM_S1040_SCSI_INTEN, 0);
+
+	/* remove timers */
 	if (timer_pending(&pACB->Waiting_Timer))
 		del_timer(&pACB->Waiting_Timer);
 	if (timer_pending(&pACB->SelTO_Timer))
 		del_timer(&pACB->SelTO_Timer);
 
-	if (1 || pACB->Config & HCC_SCSI_RESET)
+	/* reset the scsi bus */
+	if (pACB->Config & HCC_SCSI_RESET)
 		DC395x_ResetSCSIBus(pACB);
 
+	/* clear any pending interupt state */
 	DC395x_read8(TRM_S1040_SCSI_INTSTATUS);
+
+	/* release chip resources */
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	DC395x_free_tracebufs(pACB, DC395x_MAX_SRB_CNT);
 #endif
 	DC395x_free_SG_tables(pACB, DC395x_MAX_SRB_CNT);
-	return 0;
 }
 
 
-/*
- * Free all DCBs
- */
-void DC395x_freeDCBs(struct Scsi_Host *host)
+/**
+ * DC395x_free_DCBs - Free all of the DCBs.
+ *
+ * @pACB: Adapter to remove the DCBs for.
+ **/
+static
+void DC395x_free_DCBs(struct AdapterCtlBlk* pACB)
 {
-	struct DeviceCtlBlk *pDCB;
-	struct DeviceCtlBlk *nDCB;
-	struct AdapterCtlBlk *pACB =
-	    (struct AdapterCtlBlk *) (host->hostdata);
+	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *dcb_next;
 
 	dprintkdbg(DBG_DCB, "Free %i DCBs\n", pACB->DCBCnt);
-	pDCB = pACB->pLinkDCB;
-	if (pDCB) {
-		do {
-			nDCB = pDCB->pNextDCB;
-			dprintkdbg(DBG_DCB, "Free DCB (ID %i, LUN %i): %p\n",
-				  pDCB->TargetID, pDCB->TargetLUN, pDCB);
-			DC395x_remove_dev(pACB, pDCB);	/* includes a dc395x_kfree(pDCB); */
-			printk(".");
-			pDCB = nDCB;
-		} while (pDCB && pACB->pLinkDCB);
+
+	for (dcb = pACB->pLinkDCB; dcb != NULL; dcb = dcb_next)
+	{
+		dcb_next = dcb->pNextDCB;
+		dprintkdbg(DBG_DCB, "Free DCB (ID %i, LUN %i): %p\n",
+				dcb->TargetID, dcb->TargetLUN, dcb);
+		/*
+		 * Free the DCB. This removes the entry from the
+		 * pLinkDCB list and decrements the count in DCBCnt
+		 */
+		DC395x_remove_dev(pACB, dcb);
+
 	}
 }
 
-
-/*
- * Release method
+/**
+ * DC395x_release - shutdown device and release resources that were
+ * allocate for it. Called once for each card as it is shutdown.
  *
- * Called when we are to shutdown the controller and release all of
- * it's resources.
- */
-static int DC395x_release(struct Scsi_Host *host)
+ * @host: The adapter instance to shutdown.
+ **/
+static
+void DC395x_release(struct Scsi_Host *host)
 {
-	struct AdapterCtlBlk *pACB =
-	    (struct AdapterCtlBlk *) (host->hostdata);
+	struct AdapterCtlBlk *pACB = (struct AdapterCtlBlk *) (host->hostdata);
 	unsigned long flags;
 
-	dprintkl(KERN_DEBUG, "release");
+	dprintkl(KERN_DEBUG, "DC395x release\n");
 
 	DC395x_LOCK_IO(pACB->pScsiHost);
-	DC395x_shutdown(host);
-	DC395x_freeDCBs(host);
+	DC395x_chip_shutdown(pACB);
+	DC395x_free_DCBs(pACB);
 
 	if (host->irq != NO_IRQ) {
-		/*
-		 * Find the IRQ to release. XXX Why didn't we just store the
-		 * appropriate IRQ details when we request_irq it?
-		 */
-		int irq_count;
-		for (irq_count = 0, pACB = DC395x_pACB_start;
-		     pACB;
-		     pACB = pACB->pNextACB) {
-			if (pACB->IRQLevel == host->irq)
-				++irq_count;
-		}
-		if (irq_count == 1)
-			free_irq(host->irq, DC395x_pACB_start);
+		free_irq(host->irq, DC395x_pACB_start);
 	}
 	release_region(host->io_port, host->n_io_port);
 
 	DC395x_UNLOCK_IO(pACB->pScsiHost);
-
-	return 1;
 }
 
 
 /*
  * SCSI host template
  */
-static Scsi_Host_Template driver_template = {
-	.proc_name = DC395X_NAME,
-	.proc_info = DC395x_proc_info,
-	.name = DC395X_BANNER " " DC395X_VERSION,
-	.detect = DC395x_detect,
-	.release = DC395x_release,
-	.queuecommand = DC395x_queue_command,
-	.bios_param = DC395x_bios_param,
-	.slave_alloc = DC395x_slave_alloc,
-	.slave_destroy = DC395x_slave_destroy,
-	.can_queue = DC395x_MAX_CAN_QUEUE,
-	.this_id = 7,
-	.sg_tablesize = DC395x_MAX_SG_TABLESIZE,
-	.cmd_per_lun = DC395x_MAX_CMD_PER_LUN,
-	.eh_abort_handler = DC395x_eh_abort,
-	.eh_bus_reset_handler = DC395x_eh_bus_reset,
-	.unchecked_isa_dma = 0,
-	.use_clustering = DISABLE_CLUSTERING,
+static Scsi_Host_Template dc395x_driver_template = {
+	.module                 = THIS_MODULE,
+	.proc_name              = DC395X_NAME,
+	.proc_info              = DC395x_proc_info,
+	.name                   = DC395X_BANNER " " DC395X_VERSION,
+	.queuecommand           = DC395x_queue_command,
+	.bios_param             = DC395x_bios_param,
+	.slave_alloc            = DC395x_slave_alloc,
+	.slave_destroy          = DC395x_slave_destroy,
+	.can_queue              = DC395x_MAX_CAN_QUEUE,
+	.this_id                = 7,
+	.sg_tablesize           = DC395x_MAX_SG_TABLESIZE,
+	.cmd_per_lun            = DC395x_MAX_CMD_PER_LUN,
+	.eh_abort_handler       = DC395x_eh_abort,
+	.eh_bus_reset_handler   = DC395x_eh_bus_reset,
+	.unchecked_isa_dma      = 0,
+	.use_clustering         = DISABLE_CLUSTERING,
 };
+
+/*
+ * Called to initialise a single instance of the adaptor
+ */
+
+static
+int __devinit dc395x_init_one(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	unsigned int io_port;
+	u8 irq;
+	struct Scsi_Host *scsi_host;
+	static int banner_done = 0;
+
+	dprintkdbg(DBG_0, "Init one instance of the dc395x\n");
+	if (!banner_done)
+	{
+		dprintkl(KERN_INFO, "%s %s\n", DC395X_BANNER, DC395X_VERSION);
+		banner_done = 1;
+	}
+
+	if (pci_enable_device(pdev))
+	{
+		dprintkl(KERN_INFO, "PCI Enable device failed.\n");
+		return -ENODEV;
+	}
+
+	dprintkdbg(DBG_0, "Get resources...\n");
+	io_port = pci_resource_start(pdev, 0) & PCI_BASE_ADDRESS_IO_MASK;
+	irq = pdev->irq;
+	dprintkdbg(DBG_0, "IO_PORT=%04x,IRQ=%x\n", (unsigned int) io_port, irq);
+
+	scsi_host = DC395x_init(&dc395x_driver_template, io_port, irq, DC395x_adapterCnt);
+	if (!scsi_host)
+	{
+		dprintkdbg(DBG_0, "DC395x_init failed\n");
+		return -ENOMEM;
+	}
+
+	pci_set_master(pdev);
+
+	/* store pci devices in out host data object. */
+	((struct AdapterCtlBlk *)(scsi_host->hostdata))->pdev = pdev;
+
+	/* increment adaptor count */
+	DC395x_adapterCnt++;
+
+	/* store ptr to scsi host in the PCI device structure */
+	pci_set_drvdata(pdev, scsi_host);
+
+	/* get the scsi mid level to scan for new devices on the bus */
+	scsi_add_host(scsi_host, &pdev->dev);
+
+	return 0;
+}
+
+
 /*
- * The following code deals with registering the above scsi host
- * template with the higher level scsi code and results in the detect
- * method from the template being called during initialisation.
+ * Called to remove a single instance of the adaptor
  */
-#include "scsi_module.c"
+static void __devexit dc395x_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	dprintkdbg(DBG_0, "Removing instance\n");
+	scsi_remove_host(host);
+	DC395x_release(host);
+	pci_set_drvdata(pdev, NULL);
+}
+
+/*
+ * Table which identifies the PCI devices which
+ * are handled by this device driver.
+ */
+static struct pci_device_id dc395x_pci_table[] __devinitdata = {
+	{
+		.vendor		= PCI_VENDOR_ID_TEKRAM,
+		.device		= PCI_DEVICE_ID_TEKRAM_TRMS1040,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+	 },
+	{}			/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, dc395x_pci_table);
+
+/*
+ * PCI driver operations.
+ * Tells the PCI sub system what can be done with the card.
+ */
+static struct pci_driver dc395x_driver = {
+	.name           = DC395X_NAME,
+	.id_table       = dc395x_pci_table,
+	.probe          = dc395x_init_one,
+	.remove         = __devexit_p(dc395x_remove_one),
+};
+
+static int __init dc395x_module_init(void)
+{
+	return pci_module_init(&dc395x_driver);
+}
+
+static void __exit dc395x_module_exit(void)
+{
+	pci_unregister_driver(&dc395x_driver);
+}
+
+module_init(dc395x_module_init);
+module_exit(dc395x_module_exit);
+
+MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
+MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
+MODULE_LICENSE("GPL");

===================================================================


This BitKeeper patch contains the following changesets:
1.1191
## Wrapped with gzip_uu ##


begin 664 bkpatch13502
M'XL(`*R*U#X``\5;<7?:.!+_VWP*;7KI04J(#3:0I'27`$UY32`'I'N];9^?
ML47BB[%9VZ3);OK=;V8D&T-,DNZ[>]?>UD8:C4:CF=_,2+Y7[#+BX9$2>.XM
M#PNOV(<@BH\4>)\O'>Y7?+Z\6<XK07@%?:,@@+Z#ZV#.#\2``WZW",*X:A2@
M^\**[6L&K=&1HE5J:4M\O^!'RJAW>GG6'A4*K1;K7%O^%1_SF+5:A3@(;RW/
MB7ZQXFLO\"MQ:/G1G,=6Q0[F#RGI0U55J_#7T!HUU:@_:'55;SS8FJ-IEJYQ
M1ZWJS;I>$'+]DK.`=5;`H]K0-+6NUQ^,PT:C6>@RK:)IAQI3:P>J<5!M,JUZ
MI!I'1NV-"B\JV\Z:O='8OEHX8?_=M70*-MMG<^O?0<ALCUO^<L&"&8NO.9L'
MSM+CS`X<7OC(C,/FH5ZX6.FUL/^#?PH%U5(+[Y(U!MP/?%[!G?9<?WE'^G-"
M[(L.(CMR#QR[=FC<56RA2[U:KVI:0VT\Z,U:X_!AQ@]KJC4#;>I3G3>G3^CN
M*;9&M:FIJJ'7'@S-J.ED.[GD:$?_(]$+"S3B'Y<<C<NH'3[4FFJS0<95W[0L
M_266I5=5ME]M-O^/UD6Z'[+]\!O]#ZSE(G\;_H+9]?5#IA5>N;[MP=+96]JS
M`R'`P@JM>>7Z7:%;U:I,4PM=@ZC[=<U@5:WP!?X>[/WHG$^)PY[YTPG\F7NU
M#*W8#7R@_B_.O7=`JRFP/9AE/K=\AX$N.",E\!ATS:R0LPB,@#O,]9D%[^'2
MCI?0.N5>\*V"8R?7/.)$B1OI^@Z_^WL$SSB@!AAB+VG(#+8=6VZMT`V6$8ZU
ML_,&"UQCA$P/"J\</L/&SOM3L]UM7TQZ([/?511UK>>\_4]S?-'K08>VUM'M
M?3+/A]V>HE1S65%?;:UKTCX=*XJ^UC;JC7L38';6_JPH!J@KVSFX/%<4I:X<
M[#%_.9_R$(W9SNX7<V,^CQ@I^DNA6]<:K(JVU(0'K/Z3Y2TY6T:@75`6:,ZU
MK1C5:,6@ZW7=@.F'+C@'#+NV(O_O,>P`]]/!8+[N[%ZJ%[A68#9P8[1<>*SK
MX*(]:I^;EP-8&MO72+!JE>E(:C!=E2;Q(?"<=1E6=B&V2!@#$ZYHBH6;CA5;
M[,^"`OLO)#E64$'T*IS=C5C$X]CUKY`)$<Y=7Y#!BSM?SB5YVFW=R6[K+J<;
MEB:ZX<5:>O%&=V3-I!#XMNK\?OS$"DP3)(GIU9Z)MM^^LA:N[$\&K"S'6H`F
MF.O0/,J&7LO0I.(_FH'_-NB?@O*]+(?#0EBTX'S[:,94\6B(AU;&%6BU2NW\
M^@\QBC&=&EF]TO@P%XWI#`Z_1:/@3XNGWM5F^!Q,.F9WB"3]R6>S\^$C>V"R
MK=L?=X:#0:\S6;6-/P\ZYJ!W.F0/,#@9_6N_VY.M"2'XE/F/R]YEKS\X7:,=
M]P9=<SQICR;/3+\BS"PNT?Y+%EB%!;YR9V`;#-;QOG]JCCOCOGE^>3;IFV>7
M`Q*JW8'6]@!^@I3@!W6F'19$^^FDVAWU/_7&*!/^'O7:B"#:J6RX&/[:&PT'
M@BT!!K(\V!.][<X$!J-:]@[*?YTE=*AW:C.C@]BZBIY>.YE>3=A-7=`7?_ZY
M)`95RQE>(2`X^I%GW3]CSDWQ$$S!C\%GI`UKJFA49:L0[CNZ&>!+$_"E6Z_5
M")'@T9`H,T:7E'`055A_AC\0T/[@H8@?^-])?S@^6//NB'USX^LU?$)V"4QB
MM^<!1!)`9OEJR-`74(`C(PACJ0#KHR3(`9+;C'!&P`0-;3'UN"!R!I-PT?0!
M&YTB=I:SE&4V#0*OS-32<0&"SN59#Q5[#C%EW)'4.U`0;1,H\+W["NN*I1^Q
MF>5%?*>$*JU!0H*/)JN#2O4:_,J11WJ*Z3KE%9"MQ]2O%=)H&=>X1<XLEYVV
M=#XT3M;OIM*Q!BNJ^YI1$O+I!FN"8$8U7S!`0),0<$.N-**_0*P,CYUS&1JF
MRT@@ZTHN#>5JE-@8FZ,CIK:J:IEI+033,JNVP')9K=4L,[T%2%IF1LNHP*]Z
MRRBS1DMG`+BX)%C+%B4#UIH(11M+27*0%ZQDQ6&GRV]=FQ)B7A&:-`S*&@P`
MI?I3>YPC0C;=^8%]EJ*T,S!+LGS)FQZ!96-:3*5>,)T8N3-(DR>!4=K;MW>E
MU?;5</N$5>7.3^!E$GAMB)')WEX@S1J?G5$&$B'UE9BV850`AU(N3*0)T)`'
M^K*9NO`^<T6-0RZ>)E%,Y$$$1W(@LP!])+PEV?,:+(@^!*84F0JW`>0@(EUY
M/'D1>TMH0TWRQKK!(*Z!/,4,1)4@"@"`(\2YN!9%<18A_+KQBA][HX'9'[P?
M$DIARA995QG`_N+C\A4%4_NB2ZC(7/8V28_AQYLWP)[X*^G>N'(W@#[;1HD:
M$'X'>>M0=6GP;&ID^\TJH)S4\,R]RRI7Q"[+OT>@C5&_LG;Y=NW:UU27!,L8
MK2O$:A4Y3"W[)E'P>E39KMKLK%*K();.1/[<!-\T"OT&5-::3JD9>PYN\Z@>
M@5\>T2:L/#7=<W191\WK?^Q!N-W/[#89$YC8X_U^N[;?D.RSAX=\RWBW3FG=
MO=B*L!H@(T([:J@Z;DRW(6HA>A@R]3BW%@NTZ%D8S,D4.%_@JV!:I$(V*6-=
M+(5#Z[XDS0;'XY!5W6=!66QY:>Y#-9RP+T20Z#I80CDUI2(XFU@4[&LKS%8;
M0@B39C?C0."1.;<6HOR`.H!!T(+(A%%+J\,O>-;Q'=;V?0V*<EF!QTRL&YY=
ML!11UF0(-K`&2*0`#F+D0SJP,FM-P#";(&5])7?BHBRV!K<C:SZY7T#B+NA*
M!=A7\;K_;G`+\-A%^HD[QZW=KH_\(5^/<;<QSX2'(38='K5$*6(\,,HR3I1B
M/0)\4D?(XV7HD\IL+XAX%*_4*PX\)-A0^BA8H(^`"7C<BF)9T<^#I1]OTQ^B
MKU1?KHA%4>E"#^EKV832\TZDH0I,[J'%0L-;R,)>OWY":T#T%:@$)T:NZMR]
M>7.,[J+(A4++<>$[`EL#4G6(&PV=_&;=JW-AC?W4VCQC$+.L[=;8CMR^PUH2
M<HK+9NEIMD*\K=-G8.YE`N#)I<^]SNSJ>2$RS+>(\1@E7R9%QLZE$/E;_P)(
MSA,K`^XODP=RZ(D%&GFLBPRK8P&LNHXG1@V]`?:A/)Y[(TAMG7]=@(D57O$8
M;/1K97"+OV"#5%)._A9MS")Q_[$TFW'UKXISP4,W<)X0:',BF<YH-7&*+)\P
M>F?79;\O^9*;20E;+`'.V,LP<@/_9U9<N$YKUW-+D&&5@<%A32,&XKF9H75[
M)Y>GD*)5*A4H@&+F!\R>.VS!?0<@_6<V#!;13R)7Z^M:O8HL)`=G>E7LGIR:
M$$%V0CZ'`AK`XC:A/:0,1X:JKF&H%$;E$W2PQSK7W+Z)H/""$/DM#/RK"M'5
M)%TM1]I?VZ-!?W!:1L(:EH=`6,/22E$>)[`BO<PF7U@3&88N9]#%#%OCQS.^
M(W@90@B]_I00^5%-QC#B8U2%3/2$)`->FTU636-/MT,Y-RDC\?!,)@MIZF(9
M9R-STDGIALA7;W@(P,6\`%+Q`'8X6."UB84!BT,4$EG'/?O&0X[Q!4?^0B(?
ML:2<$X$\F^EFHW?A*2F+2ZTN(AY%H2UU`G=2R=-9^]W6KEIURZ(*;^VZ1?Q9
MV54U]_S#'Z4R%%:WYU!GMM0[Z+@CLU?D'8BL5>)P+N4Y6<Y^(RG0,=-X\@,#
MI&>KZX[]B`%$>_M&'#'\]A=Y?F4'F*K]3SCOYG%^.1L$5[3LW%W<N(:B7<SL
M3QD2IJLHV4;:/O`&*IJA,?JQ[5M%XQ\8)(+5:H#&WK[]\5'/#DBQI"12(DB*
MC+HFP`>?M8("G@Y(^+?5'\;.>^?#T6?6/CL;=MJ3'GL_'#&93^`I]&0T/&,G
MT/>198;]#=D<$/]#*B<-<6"J/.F1PAL1?^JU.HB#HYJB+#7J.D8+?!I"8'CJ
MT",7CW60_),57RZB/^A/^NVS5.Y'%*O!)#2$MBH^Z90,GW5"U;K10"6EBVAW
M3DP(<R&'?+;%\">"*S[WWRT&_"Z&-^@87)Z='8M%&(>"45W-"2;27"5W!+`$
MYO#=A9*L-QH-1R*@`;-Z53(3<>,ZB.)T-FS&>)?DP=@I!C68<0AEOJHU6`/J
M?A4*C,,-5+>OW84972]C)_CF`YK3!;>'I1]@.K71>0X@%997<1AX'@B)H\IT
M_!,'HAS%,Z!@P<4%HJ@_'#>RIIY[A44"#\/E(F97W)<D+/"3BM2V0B<%?<N>
M'N'=K)@RN3&14[,IXD]R^9YT0HA)I<TY"<E;:%+52:5W8N_$NV%[N)UX[*1"
M[66@PBC.?T%?82++8#'X5$B7!$!&%MNG9U42R;,Q(3Z>ZM)]'F1VPE3$O3A[
MS3YT.IE[$CR5474R%."">Q#2V9!,A80&48&X,+H[0GHM(QQ6;)SV!84(EJ'-
M$RDA/\`S*=50Z;94-<0]1M8*9B'G9K=S@O'\/;R+[11JQN9T>W`5JY`,FD_4
M(@F3@X+\/4BGR=7_'DOU;QA25%*L)!9'S,E>.?;T>'N7Z8-+XBFT6M?P@PC@
MU0#UDK[H'`AHI!^#_YZY_@V(=<RP]2?I5TR0),SD"5'R4_1(W^\*--C(3:$5
M7)S4":^LV.^R7<@D\+9NURT=L=V%B#<*<=U_)P)=OUMFF9]`3;\IET/(QNR5
M>$J55\!;((D5^Q")-`R<Y3X](!)#DC4RSXUBX9[<AD%`*P;95.:[/O+L^#&-
M.E@!X"K))DM.9,)31+6A(X##$X%\W;`2P]QG*<8XXJ9`G%"(WI7%TI$#9H'(
M`XPPH$\+<,?<N,(ZT`)96N#;HHU;]C7!![,B(*"S:3E-A01K"C-J:O!$\T5H
M%/"2WH3[8*?(3Z+(TR`B!4[,%Q,X$S\$9'O(F4RW6:.C7Y5*$&4[SF"]FM];
M8D7DMO\._\4B@*Y3U&9#@`T]MU120LQ$KS)ZU-5#5<ATB(BAY`(BN=YQVKGR
M5-F!7'0\D.K7-;5.08AHW/!W*2V\E5DV7(+^PIB&:II&MWX:9@AXH*]!S-<:
M21J?JM&<\/G"PQV7"8[X>,J,DV;ZDJ$BO[K:_--BDP_]L2EN2,"O*I!QV'3;
MLDE'4O[3'+3/5W2N/PMRZ3"#D?U(_)C?.M.3]F``:<<._)4MGWJC<7\XP,%4
M.R>E<\Y,:[4U#IBZ022NC?)%6_4C=>19X*/D-KG4F?X5N</!#(/[K>2R'P=`
MP29$W*(H/$?HM`?BVPD<@$?0INLPMCF@0?-?F3%D"#QR_^#;V(WQ%.?DK#?N
M_XLXVG/'A#3#]);^=A'.N^9%;X2?2>`0?FU:TR",3<C7'<Q>-H8D_9(6@K8I
M+M56]%G:M!_IE[Z-)PG<,2'9,9VYE?!6J3>"S?26$3@W1O&,L/TQ+LKLG%V.
M(4FE8P7T"DC8&JNOVP3:T3=6E!.Z^,$:P_LLCZ^`*YL-!6%!?+8EL4L<SR+B
MT@FMG6:;9N"G*+:P720!6()_R\DA$<.D*XK9.A$@-^[G'EXDX7FN'[E7/GUF
M!^@;F/B-\[$XY@U_7X7G#$YB7F2*#%7)G"%/L90*30?$$J?#7W*/>OJX#*39
M7+U8FKS7PW3KIPS')'3G9>"[$=NENF_=?\L;SDOA=UU(C8X4O\CL#M3#?31F
MJ:4B*K/TU,P7G3[KT9`D),XL%S8\O9V4Z?Q^;S#L]CXEL^5HY11RSC2$5BH)
M`[D?F.:`=`F!@&42#V^4(14%06#5XY[9[G8A&QV;_2&XT?@CL@A_Q^%`2_A^
MG+\I0_-B.)JT=E7]KMP?_:.U2^<@K)BUCE)B'F4T#<H<E-065OZ%MEE\G8_^
MY346::R1D1QREG3O4\;K^L\*G9E/ZCU'[5`/)VI'%2(FS"WT9K&[QS+[ID]-
M4<ER(_$S4KJ]I;71_5@P_3>W(8/!E*JX+>X74[DSL;\$.29ZI]B&9$K7E\E;
MXO<R?T/^C_2"]R1KDL:B:,(2A41T196'%BE-<?7%+'),%N^$MRB3-)Z5EA/V
M5]GB9PXXX?%;[HFY+)]2-I]_2[4D2L"T2B)^EN,0SY4NRNRU,,!4Y7*'U/1H
M`Y#SD%)0C4X.UK!3%BC/XB8P$8>S]#2TC3-&F)S?K3!4IL/;4)3`,3])E.YX
MM:'.4KYOC7`>40$*L:65DG:D$*0NN0_*1J*:-.?O(-8Y\H!(A)P)P9&X%70=
M,"]WYLJB8F4<\AL%RM#!0$24=-CT7MPX2PL2SKMV69@;2J1"L9&2@=^^KB(6
MN8[X>A4<LW(+U7`0*DJ+(.M3;]`=XF6;.>E]'+7/,7)5!-^$!&"SW^FM2,S)
MZ'RL0:%-M-%R*CD*ZO;@,Y`F79+31A>CCP^_TY>2;,+#N>M;=/\L:B[Q?:[\
M1D?.3ND+!HCRH[62.0O-DWI)99EC%/&A.O>\U1:`9"RZ!PR:BV-S]*LI:!MC
M$GU;2+6</%')U;R89`UB95Z]D=H^RI-=1XB=]F^N1R;34YYELI%U((WTR15-
MZE_FHOC(PTKE`GTAD'/E+$CEUU44.\0W+G^F((&R9?O78XLT_G57S_JY'(I-
M*];(<^F'_,K%6"!9Y7/.3OU8VE+Z,29-\'A.,A!I3NW+R8?AJ+C3J9Q5V(>E
M!49WP'HANFH'OPT]8!^7$.U/K=`+9K.=4L8.QYU1_V(":4QQASY_)!Q**F!I
M`@C.$WZ#E09XR3ZY":1E>"LB*:.CA(#L@BIX>-,,%D%^RZ/,E&=@^(-QK[AS
=>G&&S>G_Q<V6]VZM9E77#%O3"O\!*QB"ZUDW````
`
end

