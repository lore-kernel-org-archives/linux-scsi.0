From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Sat, 2 Oct 2004 10:23:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002082337.GA13746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45981 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267353AbUJBIXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2004 04:23:41 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

In addition the code to free target structures in mptscsih_remove is
removed as the scsi layer guarantees to call ->slave_destory on
every life scsi_device before returning from scsi_remove_host.


--- 1.50/drivers/message/fusion/mptscsih.c	2004-09-29 01:58:39 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-10-01 12:45:04 +02:00
@@ -1374,7 +1374,7 @@
 
 	hd = (MPT_SCSI_HOST *)host->hostdata;
 	if (hd != NULL) {
-		int sz1, sz3, sztarget=0;
+		int sz1, sz3;
 
 		mptscsih_shutdown(&pdev->dev);
 
@@ -1387,28 +1387,9 @@
 		}
 
 		if (hd->Targets != NULL) {
-			int max, ii;
-
-			/*
-			 * Free any target structures that were allocated.
-			 */
-			if (hd->is_spi) {
-				max = MPT_MAX_SCSI_DEVICES;
-			} else {
-				max = MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;
-			}
-			for (ii=0; ii < max; ii++) {
-				if (hd->Targets[ii]) {
-					kfree(hd->Targets[ii]);
-					hd->Targets[ii] = NULL;
-					sztarget += sizeof(VirtDevice);
-				}
-			}
-
 			/*
 			 * Free pointer array.
 			 */
-			sz3 = max * sizeof(void *);
 			kfree(hd->Targets);
 			hd->Targets = NULL;
 		}
@@ -2767,39 +2738,52 @@
 mptscsih_slave_alloc(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
-	MPT_SCSI_HOST		*hd;
-	VirtDevice		*vdev;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtDevice		*vdev = hd->Targets[device->id];
 
-	hd = (MPT_SCSI_HOST *)host->hostdata;
+	if (vdev)
+		goto out;
 
-	if (hd == NULL)
-		return -ENODEV;
-
-	if ((vdev = hd->Targets[device->id]) == NULL) {
-		if ((vdev = kmalloc(sizeof(VirtDevice), GFP_ATOMIC)) == NULL) {
-			printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%d) FAILED!\n",
-			hd->ioc->name, (int)sizeof(VirtDevice));
-			return -ENOMEM;
-		} else {
-			memset(vdev, 0, sizeof(VirtDevice));
-			vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
-			vdev->ioc_id = hd->ioc->id;
-			vdev->target_id = device->id;
-			vdev->bus_id = device->channel;
-			vdev->raidVolume = 0;
-			hd->Targets[device->id] = vdev;
-			if (hd->is_spi) {
-				if (hd->ioc->spi_data.isRaid & (1 << device->id)) {
-					vdev->raidVolume = 1;
-					ddvtprintk((KERN_INFO
-					    "RAID Volume @ id %d\n", device->id));
-				}
-			} else {
-				vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
-			}
+	vdev = kmalloc(sizeof(VirtDevice), GFP_KERNEL);
+	if (!vdev) {
+		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+				hd->ioc->name, sizeof(VirtDevice));
+		return -ENOMEM;
+	}
+
+	memset(vdev, 0, sizeof(VirtDevice));
+	vdev->tflags = MPT_TARGET_FLAGS_Q_YES;
+	vdev->ioc_id = hd->ioc->id;
+	vdev->target_id = device->id;
+	vdev->bus_id = device->channel;
+	vdev->raidVolume = 0;
+	hd->Targets[device->id] = vdev;
+	if (hd->is_spi) {
+		if (hd->ioc->spi_data.isRaid & (1 << device->id)) {
+			vdev->raidVolume = 1;
+			ddvtprintk((KERN_INFO
+			    "RAID Volume @ id %d\n", device->id));
 		}
+	} else {
+		vdev->tflags |= MPT_TARGET_FLAGS_VALID_INQUIRY;
 	}
+
+ out:
 	vdev->num_luns++;
+	return 0;
+}
+
+static int mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)
+{
+	int i;
+
+	if (!hd->ioc->spi_data.isRaid || !hd->ioc->spi_data.pIocPg3)
+		return 0;
+
+	for (i = 0; i < hd->ioc->spi_data.pIocPg3->NumPhysDisks; i++) {
+		if (id == hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID)
+			return 1;
+	}
 
 	return 0;
 }
@@ -2812,59 +2796,33 @@
 mptscsih_slave_destroy(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
-	MPT_SCSI_HOST		*hd;
-	VirtDevice		*vdev;
-	int 			raid_volume=0;
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtDevice		*vdev =  hd->Targets[device->id];
+	uint			target = device->id;
+	uint			lun = device->lun;
 
-	hd = (MPT_SCSI_HOST *)host->hostdata;
+	mptscsih_search_running_cmds(hd, target, lun);
 
-	if (hd == NULL)
+	vdev->luns[0] &= ~(1 << lun);
+	if (--vdev->num_luns)
 		return;
 
-	mptscsih_search_running_cmds(hd, device->id, device->lun);
-
-	/* Free memory and reset all flags for this target
-	 */
-	if ((vdev = hd->Targets[device->id]) != NULL) {
-		vdev->num_luns--;
-
-		if (vdev->luns[0] & (1 << device->lun))
-			vdev->luns[0] &= ~(1 << device->lun);
+	kfree(hd->Targets[target]);
+	hd->Targets[target] = NULL;
 
-		/* Free device structure only if number of luns is 0.
-		 */
-		if (vdev->num_luns == 0) {
-			kfree(hd->Targets[device->id]);
-			hd->Targets[device->id] = NULL;
-
-			if (!hd->is_spi)
-				return;
-
-			if((hd->ioc->spi_data.isRaid) && (hd->ioc->spi_data.pIocPg3)) {
-			int i;
-				for(i=0;i<hd->ioc->spi_data.pIocPg3->NumPhysDisks &&
-					raid_volume==0;i++)
-
-					if(device->id ==
-					  hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID) {
-						raid_volume=1;
-						hd->ioc->spi_data.forceDv |=
-						  MPT_SCSICFG_RELOAD_IOC_PG3;
-					}
-			}
-
-			if(!raid_volume){
-				hd->ioc->spi_data.dvStatus[device->id] =
+	if (hd->is_spi) {
+		if (mptscsih_is_raid_volume(hd, target)) {
+			hd->ioc->spi_data.forceDv |= MPT_SCSICFG_RELOAD_IOC_PG3;
+		} else {
+			hd->ioc->spi_data.dvStatus[target] =
 				MPT_SCSICFG_NEGOTIATE;
 
-				if (hd->negoNvram == 0)
-					hd->ioc->spi_data.dvStatus[device->id]
-					|= MPT_SCSICFG_DV_NOT_DONE;
+			if (!hd->negoNvram) {
+				hd->ioc->spi_data.dvStatus[target] |=
+					MPT_SCSICFG_DV_NOT_DONE;
 			}
 		}
 	}
-
-	return;
 }
 
 static void
