From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove scsi_assign_lock usage
Date: Mon, 31 Oct 2005 20:03:48 +0100
Message-ID: <20051031190348.GA16590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59808 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932340AbVJaTDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 14:03:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

just take the internal lock in queuecommand instead.  also switch
the only direct use of the internal lock to the wrappers used elsewhere.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-10-04 20:07:32.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-10-31 10:25:42.000000000 +0100
@@ -476,26 +476,20 @@
 {
 	struct	 ahc_softc *ahc;
 	struct	 ahc_linux_device *dev = scsi_transport_device_data(cmd->device);
+	int rtn = SCSI_MLQUEUE_HOST_BUSY;
+	unsigned long flags;
 
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
-	/*
-	 * Save the callback on completion function.
-	 */
-	cmd->scsi_done = scsi_done;
-
-	/*
-	 * Close the race of a command that was in the process of
-	 * being queued to us just as our simq was frozen.  Let
-	 * DV commands through so long as we are only frozen to
-	 * perform DV.
-	 */
-	if (ahc->platform_data->qfrozen != 0)
-		return SCSI_MLQUEUE_HOST_BUSY;
-
-	cmd->result = CAM_REQ_INPROG << 16;
+	ahc_lock(ahc, &flags);
+	if (ahc->platform_data->qfrozen == 0) {
+		cmd->scsi_done = scsi_done;
+		cmd->result = CAM_REQ_INPROG << 16;
+		rtn = ahc_linux_run_command(ahc, dev, cmd);
+	}
+	ahc_unlock(ahc, &flags);
 
-	return ahc_linux_run_command(ahc, dev, cmd);
+	return rtn;
 }
 
 static inline struct scsi_target **
@@ -1079,7 +1073,6 @@
 
 	*((struct ahc_softc **)host->hostdata) = ahc;
 	ahc_lock(ahc, &s);
-	scsi_assign_lock(host, &ahc->platform_data->spin_lock);
 	ahc->platform_data->host = host;
 	host->can_queue = AHC_MAX_QUEUE;
 	host->cmd_per_lun = 2;
@@ -2111,6 +2104,7 @@
 	int    paused;
 	int    wait;
 	int    disconnected;
+	unsigned long flags;
 
 	pending_scb = NULL;
 	paused = FALSE;
@@ -2127,7 +2121,7 @@
 		printf(" 0x%x", cmd->cmnd[cdb_byte]);
 	printf("\n");
 
-	spin_lock_irq(&ahc->platform_data->spin_lock);
+	ahc_lock(ahc, &flags);
 
 	/*
 	 * First determine if we currently own this command.
@@ -2367,7 +2361,8 @@
 		int ret;
 
 		ahc->platform_data->flags |= AHC_UP_EH_SEMAPHORE;
-		spin_unlock_irq(&ahc->platform_data->spin_lock);
+		ahc_unlock(ahc, &flags);
+
 		init_timer(&timer);
 		timer.data = (u_long)ahc;
 		timer.expires = jiffies + (5 * HZ);
@@ -2381,10 +2376,8 @@
 			printf("Timer Expired\n");
 			retval = FAILED;
 		}
-		spin_lock_irq(&ahc->platform_data->spin_lock);
-	}
-
-	spin_unlock_irq(&ahc->platform_data->spin_lock);
+	} else
+		ahc_unlock(ahc, &flags);
 	return (retval);
 }
 
