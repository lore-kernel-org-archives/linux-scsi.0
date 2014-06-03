From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] scsi: Remove CONFIG_SCSI_MULTI_LUN
Date: Tue,  3 Jun 2014 10:58:52 +0200
Message-ID: <1401785937-43581-2-git-send-email-hare@suse.de>
References: <1401785937-43581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaFCI7B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 04:59:01 -0400
In-Reply-To: <1401785937-43581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Obsolete; either use 'max_lun' if the host supports only a
limited number of LUNs or BLIST_NOLUN if the target has
problems addressing more than one LUN.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Ewan Milne <emilne@redhat.com>
---
 Documentation/scsi/tmscsim.txt |  2 --
 drivers/scsi/Kconfig           | 14 --------------
 drivers/scsi/dc395x.c          |  9 +--------
 drivers/scsi/ncr53c8xx.h       |  4 ----
 drivers/scsi/scsi_scan.c       |  4 ----
 drivers/usb/storage/Kconfig    |  4 +---
 6 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
index 3303d21..0810132 100644
--- a/Documentation/scsi/tmscsim.txt
+++ b/Documentation/scsi/tmscsim.txt
@@ -317,8 +317,6 @@ Each of the parameters is a number, containing the described information:
     4	 0x10	   16	  Immediate return on BIOS seek command. (Not used)
  (*)5	 0x20	   32	  Check for LUNs >= 1.
   
-  The default for LUN Check depends on CONFIG_SCSI_MULTI_LUN.
-
 * TaggedCmnds is a number indicating the maximum number of Tagged Commands.
   It is the binary logarithm - 1 of the actual number. Max is 4 (32).
    Value  Number of Tagged Commands
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 02832d6..62c60cd 100644
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
-	  probe for all LUNs by default. This setting can be overridden by
-	  max_luns boot/module parameter. Note that this option does not affect
-	  devices conforming to SCSI-3 or higher as they can explicitly report
-	  their number of LUNs. It is safe to say Y here unless you have one of
-	  those rare devices which reacts in an unexpected way when probed for
-	  multiple LUNs.
-
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
 	depends on SCSI
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 83d9bf6..ad7bee0 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -519,9 +519,7 @@ static struct ParameterData cfg_data[] = {
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
@@ -4434,15 +4432,10 @@ static void adapter_init_scsi_host(struct Scsi_Host *host)
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
index e02b3aa..8564bdc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -81,11 +81,7 @@ static const char *scsi_null_device_strs = "nullnullnullnull";
 
 #define MAX_SCSI_LUNS	512
 
-#ifdef CONFIG_SCSI_MULTI_LUN
 static unsigned int max_scsi_luns = MAX_SCSI_LUNS;
-#else
-static unsigned int max_scsi_luns = 1;
-#endif
 
 module_param_named(max_luns, max_scsi_luns, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_luns,
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 13b5bfb..83e7d77 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -18,9 +18,7 @@ config USB_STORAGE
 
 	  This option depends on 'SCSI' support being enabled, but you
 	  probably also need 'SCSI device support: SCSI disk support'
-	  (BLK_DEV_SD) for most USB storage devices.  Some devices also
-	  will require 'Probe all LUNs on each SCSI device'
-	  (SCSI_MULTI_LUN).
+	  (BLK_DEV_SD) for most USB storage devices.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
-- 
1.7.12.4

