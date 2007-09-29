From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/6] mpt fusion: fix up fusion prints using the sdev_printk, dev_printk, and shost_printk API
Date: Sat, 29 Sep 2007 10:17:21 -0600
Message-ID: <20070929161721.GA4371@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42035 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbXI2QRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:17:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Cleaning up prints that use the xxx_printk API, in that the fusion preamble "mptbase: iocX" follows the info provided by the print API.
The way its currently coded, the [H:C:T] print in sdev_printk will be inbetween "mptbase" and "iocX", instead of before.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-09-28 18:04:14.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-09-28 16:58:56.000000000 -0600
@@ -186,6 +186,7 @@
  * MPT drivers.  NOTE: Users of these macro defs must
  * themselves define their own MYNAM.
  */
+#define MYIOC_s_FMT			MYNAM ": %s: "
 #define MYIOC_s_DEBUG_FMT		KERN_DEBUG MYNAM ": %s: "
 #define MYIOC_s_INFO_FMT		KERN_INFO MYNAM ": %s: "
 #define MYIOC_s_NOTE_FMT		KERN_NOTICE MYNAM ": %s: "
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-28 18:04:14.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-28 17:06:04.000000000 -0600
@@ -318,8 +318,8 @@ mptsas_set_rphy(MPT_ADAPTER *ioc, struct
 	}
 
 	if (rphy) {
-		dsaswideprintk(ioc, dev_printk(MYIOC_s_DEBUG_FMT,
-		    &rphy->dev, "add:", ioc->name));
+		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
+		    &rphy->dev, MYIOC_s_FMT "add:", ioc->name));
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rphy=%p release=%p\n",
 		    ioc->name, rphy, rphy->dev.release));
 	}
@@ -341,8 +341,8 @@ mptsas_set_port(MPT_ADAPTER *ioc, struct
 		phy_info->port_details->port = port;
 
 	if (port) {
-		dsaswideprintk(ioc, dev_printk(MYIOC_s_DEBUG_FMT,
-		    &port->dev, "add:", ioc->name));
+		dsaswideprintk(ioc, dev_printk(KERN_DEBUG,
+		    &port->dev, MYIOC_s_FMT "add:", ioc->name));
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "port=%p release=%p\n",
 		    ioc->name, port, port->dev.release));
 	}
@@ -2296,8 +2296,9 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 					expander_sas_address)
 					continue;
 				dsaswideprintk(ioc,
-				    dev_printk(MYIOC_s_DEBUG_FMT, &port->dev,
-				    "delete port (%d)\n", ioc->name, port->port_identifier));
+				    dev_printk(KERN_DEBUG, &port->dev,
+				    MYIOC_s_FMT "delete port (%d)\n", ioc->name,
+				    port->port_identifier));
 				sas_port_delete(port);
 				mptsas_port_delete(ioc, phy_info->port_details);
 			}
@@ -2681,7 +2682,7 @@ mptsas_hotplug_work(struct work_struct *
 		printk(MYIOC_s_INFO_FMT
 		       "removing %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
-		dev_printk(MYIOC_s_DEBUG_FMT, &port->dev,
+		dev_printk(KERN_DEBUG, &port->dev, MYIOC_s_FMT
 		    "delete port (%d)\n", ioc->name, port->port_identifier);
 		sas_port_delete(port);
 		mptsas_port_delete(ioc, phy_info->port_details);
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-09-28 18:04:14.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-28 17:05:10.000000000 -0600
@@ -992,7 +992,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 		scsi_dma_unmap(sc);
 		sc->result = DID_RESET << 16;
 		sc->host_scribble = NULL;
-		sdev_printk(MYIOC_s_INFO_FMT, sc->device,
+		sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
 		    "completing cmds: fw_channel %d, fw_id %d, sc=%p,"
 		    " mf = %p, idx=%x\n", ioc->name, channel, id, sc, mf, ii);
 		sc->scsi_done(sc);
@@ -1053,7 +1053,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
-			sdev_printk(MYIOC_s_INFO_FMT, sc->device, "completing cmds: fw_channel %d,"
+			sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT "completing cmds: fw_channel %d,"
 			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name, vdevice->vtarget->channel,
 			   vdevice->vtarget->id, sc, mf, ii);
 			sc->scsi_done(sc);
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-28 18:04:14.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-28 17:04:41.000000000 -0600
@@ -537,7 +537,7 @@ static int mptspi_read_spi_device_pg0(st
 
 	spi_dev_pg0 = dma_alloc_coherent(&ioc->pcidev->dev, size, &spi_dev_pg0_dma, GFP_KERNEL);
 	if (spi_dev_pg0 == NULL) {
-		starget_printk(MYIOC_s_ERR_FMT, starget,
+		starget_printk(KERN_ERR, starget, MYIOC_s_FMT
 		    "dma_alloc_coherent for parameters failed\n", ioc->name);
 		return -EINVAL;
 	}
@@ -558,7 +558,7 @@ static int mptspi_read_spi_device_pg0(st
 	cfg.pageAddr = starget->id;
 
 	if (mpt_config(ioc, &cfg)) {
-		starget_printk(MYIOC_s_ERR_FMT, starget, "mpt_config failed\n", ioc->name);
+		starget_printk(KERN_ERR, starget, MYIOC_s_FMT "mpt_config failed\n", ioc->name);
 		goto out_free;
 	}
 	err = 0;
@@ -681,7 +681,7 @@ static void mptspi_dv_device(struct _MPT
 	/* If this is a piece of a RAID, then quiesce first */
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) < 0) {
-		starget_printk(MYIOC_s_ERR_FMT, scsi_target(sdev),
+		starget_printk(KERN_ERR, scsi_target(sdev), MYIOC_s_FMT
 		    "Integrated RAID quiesce failed\n", ioc->name);
 		return;
 	}
@@ -692,7 +692,7 @@ static void mptspi_dv_device(struct _MPT
 
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 0, vtarget->channel, vtarget->id) < 0)
-		starget_printk(MYIOC_s_ERR_FMT, scsi_target(sdev),
+		starget_printk(KERN_ERR, scsi_target(sdev), MYIOC_s_FMT
 		    "Integrated RAID resume failed\n", ioc->name);
 
 	mptspi_read_parameters(sdev->sdev_target);
@@ -856,7 +856,7 @@ static int mptspi_write_spi_device_pg1(s
 
 	pg1 = dma_alloc_coherent(&ioc->pcidev->dev, size, &pg1_dma, GFP_KERNEL);
 	if (pg1 == NULL) {
-		starget_printk(MYIOC_s_ERR_FMT, starget,
+		starget_printk(KERN_ERR, starget, MYIOC_s_FMT
 		    "dma_alloc_coherent for parameters failed\n", ioc->name);
 		return -EINVAL;
 	}
@@ -886,7 +886,7 @@ static int mptspi_write_spi_device_pg1(s
 	mptspi_print_write_nego(hd, starget, le32_to_cpu(pg1->RequestedParameters));
 
 	if (mpt_config(ioc, &cfg)) {
-		starget_printk(MYIOC_s_ERR_FMT, starget,
+		starget_printk(KERN_ERR, starget, MYIOC_s_FMT
 		    "mpt_config failed\n", ioc->name);
 		goto out_free;
 	}
@@ -1104,11 +1104,11 @@ static void mpt_work_wrapper(struct work
 		if(vtarget->id != disk)
 			continue;
 
-		starget_printk(MYIOC_s_INFO_FMT, vtarget->starget,
+		starget_printk(KERN_INFO, vtarget->starget, MYIOC_s_FMT
 		    "Integrated RAID requests DV of new device\n", ioc->name);
 		mptspi_dv_device(hd, sdev);
 	}
-	shost_printk(MYIOC_s_INFO_FMT, shost,
+	shost_printk(KERN_INFO, shost, MYIOC_s_FMT
 	    "Integrated RAID detects new device %d\n", ioc->name, disk);
 	scsi_scan_target(&ioc->sh->shost_gendev, 1, disk, 0, 1);
 }
@@ -1120,7 +1120,7 @@ static void mpt_dv_raid(struct _MPT_SCSI
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	if (!wqw) {
-		shost_printk(MYIOC_s_ERR_FMT, ioc->sh,
+		shost_printk(KERN_ERR, ioc->sh, MYIOC_s_FMT
 		    "Failed to act on RAID event for physical disk %d\n",
 		    ioc->name, disk);
 		return;
