From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] fusion - adding raid support in mptsas
Date: Fri, 13 Jan 2006 16:25:20 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7E9@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12470 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423099AbWAMXZa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:25:30 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

The SAS RAID volumes are reported beyond the expected number of phys.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/mptbase.h
a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-01-13 13:51:07.000000000
-0700
+++ a/drivers/message/fusion/mptbase.h	2006-01-13 15:10:43.000000000
-0700
@@ -630,6 +630,7 @@
 	struct list_head	 sas_topology;
 	struct mutex		 sas_topology_mutex;
 	MPT_SAS_MGMT		 sas_mgmt;
+	int			 num_ports;
 
 	struct list_head	 fc_rports;
 	spinlock_t		 fc_rport_lock; /* list and ri flags */
diff -uarN b/drivers/message/fusion/mptsas.c
a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-01-13 11:39:21.000000000
-0700
+++ a/drivers/message/fusion/mptsas.c	2006-01-13 15:24:35.000000000
-0700
@@ -274,6 +274,16 @@
 		hd->Targets[sdev->id] = vtarget;
 	}
 
+	/*
+	  RAID volumes placed beyond the last expected port.
+	*/
+	if (sdev->channel == hd->ioc->num_ports) {
+		vdev->target_id = sdev->id;
+		vdev->bus_id = 0;
+		vdev->lun = 0;
+		goto out;
+	}
+
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
 	mutex_lock(&hd->ioc->sas_topology_mutex);
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
@@ -284,6 +294,7 @@
 					p->phy_info[i].attached.id;
 				vdev->bus_id =
p->phy_info[i].attached.channel;
 				vdev->lun = sdev->lun;
+
mutex_unlock(&hd->ioc->sas_topology_mutex);
 				goto out;
 			}
 		}
@@ -295,7 +306,6 @@
 	return -ENODEV;
 
  out:
-	mutex_unlock(&hd->ioc->sas_topology_mutex);
 	vtarget->ioc_id = vdev->ioc_id;
 	vtarget->target_id = vdev->target_id;
 	vtarget->bus_id = vdev->bus_id;
@@ -1051,6 +1061,7 @@
 	if (error)
 		goto out_free_port_info;
 
+	ioc->num_ports = port_info->num_phys;
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_add_tail(&port_info->list, &ioc->sas_topology);
 	mutex_unlock(&ioc->sas_topology_mutex);
@@ -1585,6 +1596,20 @@
 
 	mptsas_scan_sas_topology(ioc);
 
+	/*
+	  Reporting RAID volumes.
+	*/
+	if (!ioc->raid_data.pIocPg2)
+		return 0;
+	if (!ioc->raid_data.pIocPg2->NumActiveVolumes)
+		return 0;
+	for (ii=0;ii<ioc->raid_data.pIocPg2->NumActiveVolumes;ii++) {
+		scsi_add_device(sh,
+			ioc->num_ports,
+			ioc->raid_data.pIocPg2->RaidVolume[ii].VolumeID,
+			0);
+	}
+
 	return 0;
 
 out_mptsas_probe:
