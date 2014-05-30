From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] ncr53c8xx: remove ancient configuration macros
Date: Fri, 30 May 2014 10:10:00 +0200
Message-ID: <1401437400.6101.17.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It has not been possible to set CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO,
CONFIG_SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK, and
CONFIG_SCSI_NCR53C8XX_DISABLE_PARITY_CHECK through the configuration
system since v2.1.20. Remove these ancient macros.

To enable (or disable) the functionality they covered one should edit a
header file and set related preprocessor macros. Since this is actually
a documented feature those related macros remain available.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Note that the documentation still contains
    insmod ncr53c8xx

Besides insmod being outdated, the modules that use ncr53c8xx's code
appear to be NCR_Q720_mod.ko and zalon7xx.ko. So the documentation needs
probably to be updated to reflect this.

 Documentation/scsi/ncr53c8xx.txt |  5 -----
 drivers/scsi/ncr53c8xx.h         | 12 ------------
 2 files changed, 17 deletions(-)

diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index 49c7b723225b..df4a1b97e659 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -580,11 +580,6 @@ CONFIG_SCSI_NCR53C8XX_SYNC            (default answer: 5)
     This frequency can be changed later with the "setsync" control command.
     0 means "asynchronous data transfers".
 
-CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO (default answer: n)
-    Force synchronous negotiation for all SCSI-2 devices.
-    Some SCSI-2 devices do not report this feature in byte 7 of inquiry 
-    response but do support it properly (TAMARACK scanners for example).
-
 CONFIG_SCSI_NCR53C8XX_NO_DISCONNECT   (default and only reasonable answer: n)
     If you suspect a device of yours does not properly support disconnections,
     you can answer "y". Then, all SCSI devices will never disconnect the bus 
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index e34ec5a2ea5e..8043635982bc 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -148,29 +148,17 @@
 /*
  * Force synchronous negotiation for all targets
  */
-#ifdef CONFIG_SCSI_NCR53C8XX_FORCE_SYNC_NEGO
-#define SCSI_NCR_SETUP_FORCE_SYNC_NEGO	(1)
-#else
 #define SCSI_NCR_SETUP_FORCE_SYNC_NEGO	(0)
-#endif
 
 /*
  * Disable master parity checking (flawed hardwares need that)
  */
-#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_MPARITY_CHECK
-#define SCSI_NCR_SETUP_MASTER_PARITY	(0)
-#else
 #define SCSI_NCR_SETUP_MASTER_PARITY	(1)
-#endif
 
 /*
  * Disable scsi parity checking (flawed devices may need that)
  */
-#ifdef CONFIG_SCSI_NCR53C8XX_DISABLE_PARITY_CHECK
-#define SCSI_NCR_SETUP_SCSI_PARITY	(0)
-#else
 #define SCSI_NCR_SETUP_SCSI_PARITY	(1)
-#endif
 
 /*
  * Settle time after reset at boot-up
-- 
1.9.3

