From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptsas : reserving a channel for integrated raid
Date: Tue, 11 Jul 2006 17:49:34 -0400
Message-ID: <1152654574.3575.88.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D701F6489@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4839 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932143AbWGKVth (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 17:49:37 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D701F6489@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-07-11 at 15:42 -0600, Moore, Eric wrote:
> > Originally it was the outgoing phy that was identified in the channel,
> > but even that's no longer true.  Since the target ids are assigned per
> > HBA, they're unique enough without requiring additional channel
> > stuff ... how about killing the non zero channel in the sas transport
> > class and then you can simply use 1 for the raid virtual channel?
> > 
> 
> Correct, originally it was phy_id, then I changed it to port_id.
> 
> I'll work in it this afternoon, trying to getting something out later
> today.

Try this .. it works for aic94xx, but being away from my test set up I
can't actually plug in the mptsas card.  (Ignore the errors about unable
to find aic94xx files to patch ... )

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-07-11 14:23:36.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-07-11 14:32:07.000000000 -0500
@@ -1203,7 +1203,7 @@
 
 	if (identify->device_type == SAS_END_DEVICE &&
 	    rphy->scsi_target_id != -1) {
-		scsi_scan_target(&rphy->dev, parent->port_identifier,
+		scsi_scan_target(&rphy->dev, 0,
 				rphy->scsi_target_id, ~0, 0);
 	}
 
@@ -1305,15 +1305,13 @@
 
 	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
-		struct sas_port *parent = dev_to_sas_port(rphy->dev.parent);
-
 		if (rphy->identify.device_type != SAS_END_DEVICE ||
 		    rphy->scsi_target_id == -1)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel == parent->port_identifier) &&
+		if ((channel == SCAN_WILD_CARD || channel == 0) &&
 		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
-			scsi_scan_target(&rphy->dev, parent->port_identifier,
+			scsi_scan_target(&rphy->dev, 0,
 					 rphy->scsi_target_id, lun, 1);
 		}
 	}
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_init.c	2006-07-11 14:36:50.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c	2006-07-11 14:38:03.000000000 -0500
@@ -569,7 +569,6 @@
 	SHOST_TO_SAS_HA(shost) = &asd_ha->sas_ha;
 	asd_ha->sas_ha.core.shost = shost;
 	shost->transportt = aic94xx_transport_template;
-	shost->max_channel = ASD_MAX_PHYS - 1;
 	shost->max_id = ~0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
Index: BUILD-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptbase.h	2006-07-11 14:48:49.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptbase.h	2006-07-11 14:48:57.000000000 -0500
@@ -634,7 +634,6 @@
 	u16			 handle;
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
-	int			 num_ports;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
Index: BUILD-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- BUILD-2.6.orig/drivers/message/fusion/mptsas.c	2006-07-11 14:38:26.000000000 -0500
+++ BUILD-2.6/drivers/message/fusion/mptsas.c	2006-07-11 14:50:11.000000000 -0500
@@ -67,6 +67,11 @@
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptsas"
 
+/*
+ * Reserved channel for integrated raid
+ */
+#define MPTSAS_RAID_CHANNEL	1
+
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
@@ -644,16 +649,13 @@
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
 
+	sas_read_port_mode_page(sdev);
+
+ out:
 	return mptscsih_slave_configure(sdev);
 }
 
@@ -682,10 +684,7 @@
 
 	hd->Targets[target_id] = vtarget;
 
-	/*
-	 * RAID volumes placed beyond the last expected port.
-	 */
-	if (starget->channel == hd->ioc->num_ports)
+	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(starget->dev.parent);
@@ -736,7 +735,7 @@
 	if (!starget->hostdata)
 		return;
 
-	if (starget->channel == hd->ioc->num_ports)
+	if (starget->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(starget->dev.parent);
@@ -776,10 +775,7 @@
 	starget = scsi_target(sdev);
 	vdev->vtarget = starget->hostdata;
 
-	/*
-	 * RAID volumes placed beyond the last expected port.
-	 */
-	if (sdev->channel == hd->ioc->num_ports)
+	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
@@ -1652,18 +1648,14 @@
 
 			for (i = 0; i < port_info->num_phys; i++)
 				if (port_info->phy_info[i].identify.sas_address ==
-				    identify.sas_address) {
-					sas_port_mark_backlink(port);
+				    identify.sas_address)
 					goto out;
-				}
 
 		} else if (scsi_is_sas_rphy(parent)) {
 			struct sas_rphy *parent_rphy = dev_to_rphy(parent);
 			if (identify.sas_address ==
-			    parent_rphy->identify.sas_address) {
-				sas_port_mark_backlink(port);
+			    parent_rphy->identify.sas_address)
 				goto out;
-			}
 		}
 
 		switch (identify.device_type) {
@@ -1732,7 +1724,6 @@
 		hba = NULL;
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-	ioc->num_ports = port_info->num_phys;
 
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
@@ -1981,7 +1972,7 @@
 	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
 		goto out;
 	for (i=0; i<ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
-		scsi_add_device(ioc->sh, ioc->num_ports,
+		scsi_add_device(ioc->sh, MPTSAS_RAID_CHANNEL,
 		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
 	}
  out:
@@ -2287,35 +2278,26 @@
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


