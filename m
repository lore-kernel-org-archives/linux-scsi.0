From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other places into prep_fn()
Date: Thu, 31 Mar 2005 18:08:30 +0900 (KST)
Message-ID: <20050331090647.94FFEC1E@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:44075 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261250AbVCaJIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:08:35 -0500
Received: by wproxy.gmail.com with SMTP id 36so296979wri
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 01:08:35 -0800 (PST)
In-Reply-To: <20050331090647.FEDC3964@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

08_scsi_move_preps_to_prep_fn.patch

	Move request preparations scattered in scsi_request_fn() and
	scsi_dispatch_cmd() into scsi_prep_fn().

	* CDB_SIZE check in scsi_dispatch_cmd()
	* SCSI-2 LUN preparation in scsi_dispatch_cmd()
	* scsi_init_cmd_errh() in scsi_request_fn()

	No invalid request reaches scsi_request_fn() anymore.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi.c     |   30 ------------------------------
 scsi_lib.c |   25 +++++++++++++++++++------
 2 files changed, 19 insertions(+), 36 deletions(-)

Index: scsi-export/drivers/scsi/scsi.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi.c	2005-03-31 18:06:21.000000000 +0900
+++ scsi-export/drivers/scsi/scsi.c	2005-03-31 18:06:22.000000000 +0900
@@ -79,15 +79,6 @@
 #define MIN_RESET_PERIOD (15*HZ)
 
 /*
- * Macro to determine the size of SCSI command. This macro takes vendor
- * unique commands into account. SCSI commands in groups 6 and 7 are
- * vendor unique and we will depend upon the command length being
- * supplied correctly in cmd_len.
- */
-#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
-				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
-
-/*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
@@ -566,14 +557,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		goto out;
 	}
 
-	/* 
-	 * If SCSI-2 or lower, store the LUN value in cmnd.
-	 */
-	if (cmd->device->scsi_level <= SCSI_2) {
-		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
-			       (cmd->device->lun << 5 & 0xe0);
-	}
-
 	/*
 	 * We will wait MIN_RESET_DELAY clock ticks after the last reset so
 	 * we can avoid the drive not being ready.
@@ -614,19 +597,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 
 	atomic_inc(&cmd->device->iorequest_cnt);
 
-	/*
-	 * Before we queue this command, check if the command
-	 * length exceeds what the host adapter can handle.
-	 */
-	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
-		SCSI_LOG_MLQUEUE(3,
-				printk("queuecommand : command too long.\n"));
-		cmd->result = (DID_ABORT << 16);
-
-		scsi_done(cmd);
-		goto out;
-	}
-
 	spin_lock_irqsave(host->host_lock, flags);
 	scsi_cmd_get_serial(host, cmd); 
 
Index: scsi-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_lib.c	2005-03-31 18:06:21.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_lib.c	2005-03-31 18:06:22.000000000 +0900
@@ -28,6 +28,14 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+/*
+ * Macro to determine the size of SCSI command. This macro takes vendor
+ * unique commands into account. SCSI commands in groups 6 and 7 are
+ * vendor unique and we will depend upon the command length being
+ * supplied correctly in cmd_len.
+ */
+#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
+				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
 
 #define SG_MEMPOOL_NR		(sizeof(scsi_sg_pools)/sizeof(struct scsi_host_sg_pool))
 #define SG_MEMPOOL_SIZE		32
@@ -1140,6 +1148,17 @@ static int scsi_prep_fn(struct request_q
 			goto kill;
 	}
 
+	/* Check command length. */
+	if (CDB_SIZE(cmd) > sdev->host->max_cmd_len)
+		goto kill;
+
+	scsi_init_cmd_errh(cmd);
+
+	/* If SCSI-2 or lower, store the LUN value in cmnd. */
+	if (cmd->device->scsi_level <= SCSI_2)
+		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
+			(cmd->device->lun << 5 & 0xe0);
+
 	/*
 	 * The request is now prepped, no need to come back here
 	 */
@@ -1316,12 +1335,6 @@ static void scsi_request_fn(struct reque
 		}
 
 		/*
-		 * Finally, initialize any error handling parameters, and set up
-		 * the timers for timeouts.
-		 */
-		scsi_init_cmd_errh(cmd);
-
-		/*
 		 * Dispatch the command to the low-level driver.
 		 */
 		rtn = scsi_dispatch_cmd(cmd);

