From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi: Remove CONFIG_SCSI_MULTI_LUN
Date: Wed, 20 Feb 2013 14:47:14 +0100
Message-ID: <1361368034-54444-5-git-send-email-hare@suse.de>
References: <1361368034-54444-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935413Ab3BTNrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2013 08:47:20 -0500
In-Reply-To: <1361368034-54444-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

Obsolete now; either use 'max_lun' if the host supports only a
limited number of LUNs or BLIST_NOLUN if the target has problems
addressing more than one LUN.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig     |   14 --------------
 drivers/scsi/dc395x.c    |    9 +--------
 drivers/scsi/ncr53c8xx.h |    4 ----
 drivers/scsi/scsi_scan.c |    4 ----
 4 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 142f632..9f43fd4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -197,20 +197,6 @@ config SCSI_ENCLOSURE
 	  it has an enclosure device.  Selecting this option will just allow
 	  certain enclosure conditions to be reported and is not required.
 
-config SCSI_MULTI_LUN
-	bool "Probe all LUNs on each SCSI device"
-	depends on SCSI
-	help
-	  Some devices support more than one LUN (Logical Unit Number) in order
-	  to allow access to several media, e.g. CD jukebox, USB card reader,
-	  mobile phone in mass storage mode. This option forces the kernel to
-	  probe for all LUNs by default. This setting can be overriden by
-	  max_luns boot/module parameter. Note that this option does not affect
-	  devices conforming to SCSI-3 or higher as they can explicitely report
-	  their number of LUNs. It is safe to say Y here unless you have one of
-	  those rare devices which reacts in an unexpected way when probed for
-	  multiple LUNs.
-
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
 	depends on SCSI
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 9acdb9c..733f11f 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -517,9 +517,7 @@ static struct ParameterData cfg_data[] = {
 		CFG_PARAM_UNSET,
 		0,
 		0x2f,
-#ifdef CONFIG_SCSI_MULTI_LUN
-			NAC_SCANLUN |
-#endif
+		NAC_SCANLUN |
 		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET
 			/*| NAC_ACTIVE_NEG*/,
 		NAC_GT2DRIVES | NAC_GREATER_1G | NAC_POWERON_SCSI_RESET | 0x08
@@ -4432,15 +4430,10 @@ static void adapter_init_scsi_host(struct Scsi_Host *host)
 	if (host->max_id - 1 == eeprom->scsi_id)
 		host->max_id--;
 
-#ifdef CONFIG_SCSI_MULTI_LUN
 	if (eeprom->channel_cfg & NAC_SCANLUN)
 		host->max_lun = 8;
 	else
 		host->max_lun = 1;
-#else
-	host->max_lun = 1;
-#endif
-
 }
 
 
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 0e008da..02901c5 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -264,11 +264,7 @@
 #define SCSI_NCR_SG_TABLESIZE	(SCSI_NCR_MAX_SCATTER)
 #define SCSI_NCR_TIMER_INTERVAL	(HZ)
 
-#if 1 /* defined CONFIG_SCSI_MULTI_LUN */
 #define SCSI_NCR_MAX_LUN	(16)
-#else
-#define SCSI_NCR_MAX_LUN	(1)
-#endif
 
 /*
  *  IO functions definition for big/little endian CPU support.
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 28446bc..e9b916f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -81,11 +81,7 @@ static const char *scsi_null_device_strs = "nullnullnullnull";
 
 #define MAX_SCSI_LUNS	512
 
-#ifdef CONFIG_SCSI_MULTI_LUN
 static u64 max_scsi_luns = MAX_SCSI_LUNS;
-#else
-static u64 max_scsi_luns = 1;
-#endif
 
 module_param_named(max_luns, max_scsi_luns, ullong, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
-- 
1.7.4.2

