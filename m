From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: user scsi_device host private data
Date: Mon, 23 May 2005 17:14:22 +0200
Message-ID: <20050523151422.GA3668@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53918 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261888AbVEWPO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 11:14:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- ddc0c48133f130f8f4fcaeee05c8cff31209259d/drivers/scsi/aic7xxx/aic7xxx_osm.c  (mode:100644)
+++ uncommitted/drivers/scsi/aic7xxx/aic7xxx_osm.c  (mode:100644)
@@ -610,10 +610,8 @@
 static int
 ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 {
-	struct	 ahc_softc *ahc;
-	struct	 ahc_linux_device *dev;
-
-	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+	struct ahc_softc *ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+	struct ahc_linux_device *dev = cmd->device->hostdata;
 
 	/*
 	 * Save the callback on completion function.
@@ -629,10 +627,6 @@
 	if (ahc->platform_data->qfrozen != 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun);
-	BUG_ON(dev == NULL);
-
 	cmd->result = CAM_REQ_INPROG << 16;
 
 	return ahc_linux_run_command(ahc, dev, cmd);
@@ -707,6 +701,8 @@
 		if (dev == NULL)
 			goto out;
 	}
+
+	device->hostdata = dev;
 	retval = 0;
 
  out:
@@ -717,16 +713,12 @@
 static int
 ahc_linux_slave_configure(struct scsi_device *device)
 {
-	struct	ahc_softc *ahc;
-	struct	ahc_linux_device *dev;
-
-	ahc = *((struct ahc_softc **)device->host->hostdata);
+	struct ahc_softc *ahc = *((struct ahc_softc **)device->host->hostdata);
+	struct ahc_linux_device *dev = device->hostdata;
 
 	if (bootverbose)
 		printf("%s: Slave Configure %d\n", ahc_name(ahc), device->id);
 
-	dev = ahc_linux_get_device(ahc, device->channel, device->id,
-				   device->lun);
 	dev->scsi_device = device;
 	ahc_linux_device_queue_depth(ahc, dev);
 
@@ -740,16 +732,11 @@
 static void
 ahc_linux_slave_destroy(struct scsi_device *device)
 {
-	struct	ahc_softc *ahc;
-	struct	ahc_linux_device *dev;
+	struct ahc_softc *ahc = *((struct ahc_softc **)device->host->hostdata);
+	struct ahc_linux_device *dev = device->hostdata;
 
-	ahc = *((struct ahc_softc **)device->host->hostdata);
 	if (bootverbose)
 		printf("%s: Slave Destroy %d\n", ahc_name(ahc), device->id);
-	dev = ahc_linux_get_device(ahc, device->channel,
-				   device->id, device->lun);
-
-	BUG_ON(dev->active);
 
 	ahc_linux_free_device(ahc, dev);
 }
@@ -1401,6 +1388,7 @@
 				   devinfo->lun);
 	if (dev == NULL)
 		return;
+
 	was_queuing = dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED);
 	switch (alg) {
 	default:
@@ -2330,7 +2318,7 @@
 ahc_linux_queue_recovery_cmd(struct scsi_cmnd *cmd, scb_flag flag)
 {
 	struct ahc_softc *ahc;
-	struct ahc_linux_device *dev;
+	struct ahc_linux_device *dev = cmd->device->hostdata;
 	struct scb *pending_scb;
 	u_int  saved_scbptr;
 	u_int  active_scb_index;
@@ -2365,21 +2353,6 @@
 	 * at all, and the system wanted us to just abort the
 	 * command, return success.
 	 */
-	dev = ahc_linux_get_device(ahc, cmd->device->channel, cmd->device->id,
-				   cmd->device->lun);
-
-	if (dev == NULL) {
-		/*
-		 * No target device for this command exists,
-		 * so we must not still own the command.
-		 */
-		printf("%s:%d:%d:%d: Is not an active device\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
-		retval = SUCCESS;
-		goto no_cmd;
-	}
-
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
 	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
 				       cmd->device->channel + 'A',
