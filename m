From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] ncr53c8xx: remove remnants of immediate arbitration
Date: Fri, 30 May 2014 09:45:50 +0200
Message-ID: <1401435950.6101.6.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54550 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932332AbaE3Hpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2014 03:45:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

The code for immediate arbitration was removed from (what looks like a
predecessor of) the ncr53c8xx code in v2.6.0. Remove its remnants now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 Documentation/scsi/ncr53c8xx.txt | 52 ----------------------------------------
 drivers/scsi/ncr53c8xx.c         | 12 ----------
 drivers/scsi/ncr53c8xx.h         |  8 -------
 3 files changed, 72 deletions(-)

diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index 1d508dcbf859..49c7b723225b 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -52,12 +52,10 @@ Written by Gerard Roudier <groudier@free.fr>
              10.2.19 Check SCSI BUS 
              10.2.20 Exclude a host from being attached
              10.2.21 Suggest a default SCSI id for hosts
-             10.2.22 Enable use of IMMEDIATE ARBITRATION
       10.3 Advised boot setup commands
       10.4 PCI configuration fix-up boot option
       10.5 Serial NVRAM support boot option
       10.6 SCSI BUS checking boot option
-      10.7 IMMEDIATE ARBITRATION boot option
 11. Some constants and flags of the ncr53c8xx.h header file
 12. Installation
 13. Architecture dependent features
@@ -843,16 +841,6 @@ port address 0x1400.
     try to deduce the value previously set in the hardware and use value 
     7 if the hardware value is zero.
 
-10.2.22 Enable use of IMMEDIATE ARBITRATION
-        (only supported by the sym53c8xx driver. See 10.7 for more details)
-        iarb:0    do not use this feature.
-        iarb:#x   use this feature according to bit fields as follow:
-
-    bit 0 (1) : enable IARB each time the initiator has been reselected 
-                when it arbitrated for the SCSI BUS.
-    (#x >> 4) : maximum number of successive settings of IARB if the initiator 
-                win arbitration and it has other commands to send to a device.
-
 Boot fail safe
     safe:y	load the following assumed fail safe initial setup
 
@@ -876,7 +864,6 @@ Boot fail safe
   differential support		from BIOS settings	diff:1
   irq mode			from BIOS settings	irqm:1
   SCSI BUS check		do not attach on error	buschk:1
-  immediate arbitration		disabled		iarb:0
 
 10.3 Advised boot setup commands
 
@@ -1005,45 +992,6 @@ Unfortunately, the following common SCSI BUS problems are not detected:
 On the other hand, either bad cabling, broken devices, not conformant 
 devices, ... may cause a SCSI signal to be wrong when te driver reads it.
 
-10.7 IMMEDIATE ARBITRATION boot option
-
-This option is only supported by the SYM53C8XX driver (not by the NCR53C8XX).
-
-SYMBIOS 53C8XX chips are able to arbitrate for the SCSI BUS as soon as they 
-have detected an expected disconnection (BUS FREE PHASE). For this process 
-to be started, bit 1 of SCNTL1 IO register must be set when the chip is 
-connected to the SCSI BUS.
-
-When this feature has been enabled for the current connection, the chip has 
-every chance to win arbitration if only devices with lower priority are 
-competing for the SCSI BUS. By the way, when the chip is using SCSI id 7, 
-then it will for sure win the next SCSI BUS arbitration.
-
-Since, there is no way to know what devices are trying to arbitrate for the 
-BUS, using this feature can be extremely unfair. So, you are not advised
-to enable it, or at most enable this feature for the case the chip lost 
-the previous arbitration (boot option 'iarb:1').
-
-This feature has the following advantages:
-
-a) Allow the initiator with ID 7 to win arbitration when it wants so.
-b) Overlap at least 4 micro-seconds of arbitration time with the execution 
-   of SCRIPTS that deal with the end of the current connection and that 
-   starts the next job.
-
-Hmmm... But (a) may just prevent other devices from reselecting the initiator, 
-and delay data transfers or status/completions, and (b) may just waste 
-SCSI BUS bandwidth if the SCRIPTS execution lasts more than 4 micro-seconds.
-
-The use of IARB needs the SCSI_NCR_IARB_SUPPORT option to have been defined 
-at compile time and the 'iarb' boot option to have been set to a non zero 
-value at boot time. It is not that useful for real work, but can be used 
-to stress SCSI devices or for some applications that can gain advantage of 
-it. By the way, if you experience badnesses like 'unexpected disconnections', 
-'bad reselections', etc... when using IARB on heavy IO load, you should not 
-be surprised, because force-feeding anything and blocking its arse at the 
-same time cannot work for a long time. :-))
-
 
 11. Some constants and flags of the ncr53c8xx.h header file
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7d014b11df62..9661a2c9e13c 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -615,10 +615,6 @@ static struct ncr_driver_setup
 #define OPT_EXCLUDE		24
 #define OPT_HOST_ID		25
 
-#ifdef SCSI_NCR_IARB_SUPPORT
-#define OPT_IARB		26
-#endif
-
 #ifdef MODULE
 #define	ARG_SEP	' '
 #else
@@ -640,9 +636,6 @@ static char setup_token[] __initdata =
 	"recovery:"
 	"safe:"   "nvram:"
 	"excl:"   "hostid:"
-#ifdef SCSI_NCR_IARB_SUPPORT
-	"iarb:"
-#endif
 	;	/* DONNOT REMOVE THIS ';' */
 
 static int __init get_setup_token(char *p)
@@ -766,11 +759,6 @@ static int __init sym53c8xx__setup(char *str)
 		case OPT_HOST_ID:
 			driver_setup.host_id = val;
 			break;
-#ifdef SCSI_NCR_IARB_SUPPORT
-		case OPT_IARB:
-			driver_setup.iarb = val;
-			break;
-#endif
 		default:
 			printk("sym53c8xx_setup: unexpected boot option '%.*s' ignored\n", (int)(pc-cur+1), cur);
 			break;
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index 736a9df68d58..e34ec5a2ea5e 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -112,13 +112,6 @@
 #endif
 
 /*
- * Immediate arbitration
- */
-#if defined(CONFIG_SCSI_NCR53C8XX_IARB)
-#define SCSI_NCR_IARB_SUPPORT
-#endif
-
-/*
  * Sync transfer frequency at startup.
  * Allow from 5Mhz to 80Mhz default 20 Mhz.
  */
@@ -534,7 +527,6 @@ struct ncr_driver_setup {
 	u8	optimize;
 	u8	recovery;
 	u8	host_id;
-	u16	iarb;
 	u32	excludes[SCSI_NCR_MAX_EXCLUDES];
 	char	tag_ctrl[100];
 };
-- 
1.9.3

