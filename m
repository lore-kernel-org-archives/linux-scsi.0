From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptsas : reserving a channel for integrated raid
Date: Tue, 11 Jul 2006 10:25:43 -0600
Message-ID: <20060711162543.GA11553@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51860 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750885AbWGKQic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 12:38:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Recent changes in the sas transport layer have taken
ownership of port_id(channel) assignments. Previously
this was owned by the scsi lld, and mptsas code was written
to reserve the channel beyond the last port id for integrated
raid.  With this change in the transport layer, any non-raid devices
that land on the reserved channel will not be detected due to
improper firmware h:c:t:l mapping calculation.

This patch moves the reserved channel to -1. This can be
easily changed to some other value in the future release
since its a hash define.

Its higly doubtfull the transport layer would ever
use up all the port ids, and wrap back around to zero since
this is int.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-10 11:30:13.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 10:18:35.000000000 -0600
@@ -634,7 +634,6 @@ typedef struct _MPT_ADAPTER
 	u16			 handle;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
-	int			 num_ports;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-07-10 11:30:13.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-07-11 10:29:33.000000000 -0600
@@ -67,6 +67,11 @@
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptsas"
 
+/*
+ * Reserved channel for integrated raid
+ */
+#define MPTSAS_RAID_CHANNEL	-1
+
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
@@ -644,16 +649,13 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
 static int
 mptsas_slave_configure(struct scsi_device *sdev)
 {
-	struct Scsi_Host	*host = sdev->host;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 
-	/*
-	 * RAID volumes placed beyond the last expected port.
-	 * Ignore sending sas mode pages in that case..
-	 */
-	if (sdev->channel < hd->ioc->num_ports)
-		sas_read_port_mode_page(sdev);
+	if (sdev->channel == MPTSAS_RAID_CHANNEL)
+		goto out;
+
+	sas_read_port_mode_page(sdev);
 
+ out:
 	return mptscsih_slave_configure(sdev);
 }
 
@@ -682,10 +684,7 @@ mptsas_target_alloc(struct scsi_target *
 
 	hd->Targets[target_id] = vtarget;
 
-	/*
-	 * RAID volumes placed beyond the last expected port.
-	 */
-	if (starget->channel == hd->ioc->num_ports)
+	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(starget->dev.parent);
@@ -736,7 +735,7 @@ mptsas_target_destroy(struct scsi_target
 	if (!starget->hostdata)
 		return;
 
-	if (starget->channel == hd->ioc->num_ports)
+	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(starget->dev.parent);
@@ -776,10 +775,7 @@ mptsas_slave_alloc(struct scsi_device *s
 	starget = scsi_target(sdev);
 	vdev->vtarget = starget->hostdata;
 
-	/*
-	 * RAID volumes placed beyond the last expected port.
-	 */
-	if (sdev->channel == hd->ioc->num_ports)
+	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
@@ -1728,7 +1724,6 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 		hba = NULL;
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-	ioc->num_ports = port_info->num_phys;
 
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
@@ -1977,7 +1972,7 @@ mptsas_scan_sas_topology(MPT_ADAPTER *io
 	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
 		goto out;
 	for (i=0; i<ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
-		scsi_add_device(ioc->sh, ioc->num_ports,
+		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
 		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
 	}
  out:
@@ -2283,35 +2278,26 @@ mptsas_hotplug_work(void *arg)
 		mptsas_set_rphy(phy_info, rphy);
 		break;
 	case MPTSAS_ADD_RAID:
-		sdev = scsi_device_lookup(
-			ioc->sh,
-			ioc->num_ports,
-			ev->id,
-			0);
+		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
+		    ev->id, 0);
 		if (sdev) {
 			scsi_device_put(sdev);
 			break;
 		}
 		printk(MYIOC_s_INFO_FMT
 		       "attaching raid volume, channel %d, id %d\n",
-		       ioc->name, ioc->num_ports, ev->id);
-		scsi_add_device(ioc->sh,
-			ioc->num_ports,
-			ev->id,
-			0);
+		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
+		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL, ev->id, 0);
 		mpt_findImVolumes(ioc);
 		break;
 	case MPTSAS_DEL_RAID:
-		sdev = scsi_device_lookup(
-			ioc->sh,
-			ioc->num_ports,
-			ev->id,
-			0);
+		sdev = scsi_device_lookup(ioc->sh, MPTSAS_RAID_CHANNEL,
+	    	    ev->id, 0);
 		if (!sdev)
 			break;
 		printk(MYIOC_s_INFO_FMT
 		       "removing raid volume, channel %d, id %d\n",
-		       ioc->name, ioc->num_ports, ev->id);
+		       ioc->name, MPTSAS_RAID_CHANNEL, ev->id);
 		vdevice = sdev->hostdata;
 		vdevice->vtarget->deleted = 1;
 		mptsas_target_reset(ioc, vdevice->vtarget);
