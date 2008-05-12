From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 2/5] [ARM] rpc: acornscsi: fixup abort/reset methods, fix build errors
Date: Mon, 12 May 2008 18:02:13 +0100
Message-ID: <git-1210611733-8fdb3936a9ea1b925c5d8e961026d547835b4cfc@dyn-67.arm.linux.org.uk>
References: <git-1210611733-c1d6fd45bee4baae1053913f93912b1a88d2706f@dyn-67.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39302 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYELROG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:14:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

Revive the AcornSCSI driver, update it for the replacement command
abort and host reset methods, and fix the build errors in
acornscsi-io.S.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/Kconfig        |    2 +-
 drivers/scsi/arm/acornscsi-io.S |    6 ++++++
 drivers/scsi/arm/acornscsi.c    |   38 +++++++++-----------------------------
 3 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index 7236143..a8587f1 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -3,7 +3,7 @@
 #
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
-	depends on ARCH_ACORN && SCSI && BROKEN
+	depends on ARCH_ACORN && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Acorn SCSI card (aka30). If you have an
diff --git a/drivers/scsi/arm/acornscsi-io.S b/drivers/scsi/arm/acornscsi-io.S
index 3c5d4f8..5cebe31 100644
--- a/drivers/scsi/arm/acornscsi-io.S
+++ b/drivers/scsi/arm/acornscsi-io.S
@@ -10,6 +10,12 @@
 #include <asm/assembler.h>
 #include <asm/hardware.h>
 
+#if defined(__APCS_32__)
+#define LOADREGS(t,r,l...)	ldm##t	r, l
+#elif defined(__APCS_26__)
+#define LOADREGS(t,r,l...)	ldm##t	r, l##^
+#endif
+
 @ Purpose: transfer a block of data from the acorn scsi card to memory
 @ Proto  : void acornscsi_in(unsigned int addr_start, char *buffer, int length)
 @ Returns: nothing
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 8e53f02..fa58d02 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2731,9 +2731,7 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 //#if (DEBUG & DEBUG_ABORT)
 		printk("success\n");
 //#endif
-		SCpnt->result = DID_ABORT << 16;
-		SCpnt->scsi_done(SCpnt);
-		result = SCSI_ABORT_SUCCESS;
+		result = SUCCESS;
 		break;
 
 	/*
@@ -2745,7 +2743,7 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 //#if (DEBUG & DEBUG_ABORT)
 		printk("snooze\n");
 //#endif
-		result = SCSI_ABORT_SNOOZE;
+		result = FAILED;
 		break;
 
 	/*
@@ -2755,11 +2753,7 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 	default:
 	case res_not_running:
 		acornscsi_dumplog(host, SCpnt->device->id);
-#if (DEBUG & DEBUG_ABORT)
-		result = SCSI_ABORT_SNOOZE;
-#else
-		result = SCSI_ABORT_NOT_RUNNING;
-#endif
+		result = FAILED;
 //#if (DEBUG & DEBUG_ABORT)
 		printk("not running\n");
 //#endif
@@ -2770,13 +2764,12 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 }
 
 /*
- * Prototype: int acornscsi_reset(struct scsi_cmnd *SCpnt, unsigned int reset_flags)
+ * Prototype: int acornscsi_reset(struct scsi_cmnd *SCpnt)
  * Purpose  : reset a command on this host/reset this host
  * Params   : SCpnt  - command causing reset
- *	      result - what type of reset to perform
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_reset(struct scsi_cmnd *SCpnt, unsigned int reset_flags)
+int acornscsi_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
 	struct scsi_cmnd *SCptr;
@@ -2798,28 +2791,16 @@ int acornscsi_reset(struct scsi_cmnd *SCpnt, unsigned int reset_flags)
 
     acornscsi_dma_stop(host);
 
-    SCptr = host->SCpnt;
-
     /*
      * do hard reset.  This resets all devices on this host, and so we
      * must set the reset status on all commands.
      */
     acornscsi_resetcard(host);
 
-    /*
-     * report reset on commands current connected/disconnected
-     */
-    acornscsi_reportstatus(&host->SCpnt, &SCptr, DID_RESET);
-
     while ((SCptr = queue_remove(&host->queues.disconnected)) != NULL)
-	acornscsi_reportstatus(&SCptr, &SCpnt, DID_RESET);
-
-    if (SCpnt) {
-	SCpnt->result = DID_RESET << 16;
-	SCpnt->scsi_done(SCpnt);
-    }
+	;
 
-    return SCSI_RESET_BUS_RESET | SCSI_RESET_HOST_RESET | SCSI_RESET_SUCCESS;
+    return SUCCESS;
 }
 
 /*==============================================================================================
@@ -2976,9 +2957,8 @@ static struct scsi_host_template acornscsi_template = {
 	.name			= "AcornSCSI",
 	.info			= acornscsi_info,
 	.queuecommand		= acornscsi_queuecmd,
-#warning fixme
-	.abort			= acornscsi_abort,
-	.reset			= acornscsi_reset,
+	.eh_abort_handler	= acornscsi_abort,
+	.eh_bus_reset_handler	= acornscsi_bus_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
