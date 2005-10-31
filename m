From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic79xx: remove scsi_assign_lock usage
Date: Mon, 31 Oct 2005 20:05:01 +0100
Message-ID: <20051031190501.GB16590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:63136 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932482AbVJaTFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 14:05:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

just take the internal lock in queuecommand instead.  also switch
the only direct use of the internal lock to the wrappers used elsewhere.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-10-04 20:07:32.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-10-31 10:24:59.000000000 +0100
@@ -435,29 +435,20 @@
 {
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
+	int rtn = SCSI_MLQUEUE_HOST_BUSY;
+	unsigned long flags;
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	/*
-	 * Close the race of a command that was in the process of
-	 * being queued to us just as our simq was frozen.  Let
-	 * DV commands through so long as we are only frozen to
-	 * perform DV.
-	 */
-	if (ahd->platform_data->qfrozen != 0) {
-		printf("%s: queue frozen\n", ahd_name(ahd));
+	ahd_lock(ahd, &flags);
+	if (ahd->platform_data->qfrozen == 0) {
+		cmd->scsi_done = scsi_done;
+		cmd->result = CAM_REQ_INPROG << 16;
+		rtn = ahd_linux_run_command(ahd, dev, cmd);
 
-		return SCSI_MLQUEUE_HOST_BUSY;
 	}
-
-	/*
-	 * Save the callback on completion function.
-	 */
-	cmd->scsi_done = scsi_done;
-
-	cmd->result = CAM_REQ_INPROG << 16;
-
-	return ahd_linux_run_command(ahd, dev, cmd);
+	ahd_unlock(ahd, &flags);
+	return rtn;
 }
 
 static inline struct scsi_target **
@@ -1080,7 +1071,6 @@
 
 	*((struct ahd_softc **)host->hostdata) = ahd;
 	ahd_lock(ahd, &s);
-	scsi_assign_lock(host, &ahd->platform_data->spin_lock);
 	ahd->platform_data->host = host;
 	host->can_queue = AHD_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -2061,6 +2051,7 @@
 	int    wait;
 	int    disconnected;
 	ahd_mode_state saved_modes;
+	unsigned long flags;
 
 	pending_scb = NULL;
 	paused = FALSE;
@@ -2077,7 +2068,7 @@
 		printf(" 0x%x", cmd->cmnd[cdb_byte]);
 	printf("\n");
 
-	spin_lock_irq(&ahd->platform_data->spin_lock);
+	ahd_lock(ahd, &flags);
 
 	/*
 	 * First determine if we currently own this command.
@@ -2300,7 +2291,8 @@
 		int ret;
 
 		ahd->platform_data->flags |= AHD_SCB_UP_EH_SEM;
-		spin_unlock_irq(&ahd->platform_data->spin_lock);
+		ahd_unlock(ahd, &flags);
+
 		init_timer(&timer);
 		timer.data = (u_long)ahd;
 		timer.expires = jiffies + (5 * HZ);
@@ -2314,9 +2306,8 @@
 			printf("Timer Expired\n");
 			retval = FAILED;
 		}
-		spin_lock_irq(&ahd->platform_data->spin_lock);
 	}
-	spin_unlock_irq(&ahd->platform_data->spin_lock);
+		ahd_unlock(ahd, &flags);
 	return (retval);
 }
 
