From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] remove MULTI_LUN config option
Date: Tue, 2 Sep 2003 12:11:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902021145.GC1941@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:14997 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263480AbTIBCMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2003 22:12:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

We already have a module_param to limit how many LUNs we scan, so I
think we can remove the config option. It means one less config option
to worry about.

Anton

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1407  -> 1.1408 
#	drivers/scsi/ibmmca.c	1.22    -> 1.23   
#	drivers/scsi/dc395x.c	1.20    -> 1.21   
#	drivers/scsi/sym53c8xx_defs.h	1.9     -> 1.10   
#	drivers/scsi/scsi_scan.c	1.103   -> 1.104  
#	drivers/scsi/Kconfig	1.25    -> 1.26   
#	drivers/scsi/sym53c8xx_2/sym53c8xx.h	1.9     -> 1.10   
#	drivers/scsi/tmscsim.c	1.24    -> 1.25   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/02	anton@samba.org	1.1408
# remove CONFIG_SCSI_MULTI_LUN
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/Kconfig	Tue Sep  2 10:20:06 2003
@@ -139,18 +139,6 @@
 comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
 	depends on SCSI
 
-config SCSI_MULTI_LUN
-	bool "Probe all LUNs on each SCSI device"
-	depends on SCSI
-	help
-	  If you have a SCSI device that supports more than one LUN (Logical
-	  Unit Number), e.g. a CD jukebox, and only one LUN is detected, you
-	  can say Y here to force the SCSI driver to probe for multiple LUNs.
-	  A SCSI device with multiple LUNs acts logically like multiple SCSI
-	  devices. The vast majority of SCSI devices have only one LUN, and
-	  so most people can say N here and should in fact do so, because it
-	  is safer.
-
 config SCSI_REPORT_LUNS
 	bool "Build with SCSI REPORT LUNS support"
 	depends on SCSI
diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/dc395x.c	Tue Sep  2 10:20:06 2003
@@ -633,9 +633,7 @@
 		CFG_PARAM_UNSET,
 		0,
 		0x2f,
-#ifdef CONFIG_SCSI_MULTI_LUN
 			NAC_SCANLUN |
-#endif
 		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET
 			/*| NAC_ACTIVE_NEG*/,
 		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET | 0x08
@@ -4922,14 +4920,10 @@
 	host->max_id = 16;
 	if (host->max_id - 1 == eeprom->scsi_id)
 		host->max_id--;
-#ifdef	CONFIG_SCSI_MULTI_LUN
 	if (eeprom->channel_cfg & NAC_SCANLUN)
 		host->max_lun = 8;
 	else
 		host->max_lun = 1;
-#else
-	host->max_lun = 1;
-#endif
 	/*
 	 ********************************
 	 */
diff -Nru a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/ibmmca.c	Tue Sep  2 10:20:06 2003
@@ -1192,9 +1192,7 @@
 	printk("\nIBM MCA SCSI: Scanning SCSI-devices.");
 #endif
 	for (id = 0; id < max_pun; id++)
-#ifdef CONFIG_SCSI_MULTI_LUN
 		for (lun = 0; lun < 8; lun++)
-#endif
 		{
 			probe_display(1);
 #ifdef IM_DEBUG_PROBE
@@ -1223,9 +1221,7 @@
 #endif
 	ldn = 0;
 	lun = 0;
-#ifdef CONFIG_SCSI_MULTI_LUN
 	for (lun = 0; lun < 8 && ldn < MAX_LOG_DEV; lun++)
-#endif
 		for (id = 0; id < max_pun && ldn < MAX_LOG_DEV; id++) {
 			probe_display(1);
 #ifdef IM_DEBUG_PROBE
@@ -1900,9 +1896,7 @@
 			immediate_assign(host_index, 0, 0, 0, REMOVE_LDN);
 			/* remap all ldns, as written in the pun/lun table */
 			lun = 0;
-#ifdef CONFIG_SCSI_MULTI_LUN
 			for (lun = 0; lun < 8; lun++)
-#endif
 				for (id = 0; id < max_pun; id++) {
 					if (get_ldn(host_index)[id][lun] <= MAX_LOG_DEV)
 						immediate_assign(host_index, id, lun, get_ldn(host_index)[id][lun], SET_LDN);
@@ -2396,11 +2390,7 @@
 	len += sprintf(buffer + len, "\n             IBM-SCSI-Subsystem-Linux-Driver, Version %s\n\n\n", IBMMCA_SCSI_DRIVER_VERSION);
 	len += sprintf(buffer + len, " SCSI Access-Statistics:\n");
 	len += sprintf(buffer + len, "               Device Scanning Order....: %s\n", (ibm_ansi_order) ? "IBM/ANSI" : "New Industry Standard");
-#ifdef CONFIG_SCSI_MULTI_LUN
 	len += sprintf(buffer + len, "               Multiple LUN probing.....: Yes\n");
-#else
-	len += sprintf(buffer + len, "               Multiple LUN probing.....: No\n");
-#endif
 	len += sprintf(buffer + len, "               This Hostnumber..........: %d\n", shpnt->host_no);
 	len += sprintf(buffer + len, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(host_index)));
 	len += sprintf(buffer + len, "               (Shared) IRQ.............: %d\n", IM_IRQ);
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/scsi_scan.c	Tue Sep  2 10:20:06 2003
@@ -68,11 +68,7 @@
 
 #define MAX_SCSI_LUNS	512
 
-#ifdef CONFIG_SCSI_MULTI_LUN
 static unsigned int max_scsi_luns = MAX_SCSI_LUNS;
-#else
-static unsigned int max_scsi_luns = 1;
-#endif
 
 module_param_named(max_luns, max_scsi_luns, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
diff -Nru a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h	Tue Sep  2 10:20:06 2003
@@ -189,11 +189,7 @@
 /*
  *  Max number of LUNs per target.
  */
-#if 1 /* defined CONFIG_SCSI_MULTI_LUN */
 #define	CONFIG_SCSI_SYM53C8XX_MAX_LUN	(16)
-#else
-#define	CONFIG_SCSI_SYM53C8XX_MAX_LUN	(1)
-#endif
 
 /*
  *  Driver setup structure.
diff -Nru a/drivers/scsi/sym53c8xx_defs.h b/drivers/scsi/sym53c8xx_defs.h
--- a/drivers/scsi/sym53c8xx_defs.h	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/sym53c8xx_defs.h	Tue Sep  2 10:20:06 2003
@@ -346,11 +346,7 @@
 #define SCSI_NCR_SG_TABLESIZE	(SCSI_NCR_MAX_SCATTER)
 #define SCSI_NCR_TIMER_INTERVAL	(HZ)
 
-#if 1 /* defined CONFIG_SCSI_MULTI_LUN */
 #define SCSI_NCR_MAX_LUN	(16)
-#else
-#define SCSI_NCR_MAX_LUN	(1)
-#endif
 
 #ifndef HOSTS_C
 
diff -Nru a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	Tue Sep  2 10:20:06 2003
+++ b/drivers/scsi/tmscsim.c	Tue Sep  2 10:20:06 2003
@@ -631,9 +631,7 @@
 		| SYNC_NEGO_ | TAG_QUEUEING_,
 		MORE2_DRV | GREATER_1G | RST_SCSI_BUS | ACTIVE_NEGATION
 		/* | NO_SEEK */
-# ifdef CONFIG_SCSI_MULTI_LUN
 		| LUN_CHECK
-# endif
 		, 3 /* 16 Tags per LUN */, 1 /* s delay after Reset */ };
 
 /* Copy defaults over set values where missing */
