From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] mptsas- trying to add raid support
Date: Wed, 4 Jan 2006 17:55:32 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153948@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22710 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751009AbWAEAzl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2006 19:55:41 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org

Christoph - I'm trying to add support in the mptsas driver to
report raid volumes to the block layer.  I'm making the ioc->num_ports
as
the virtual channel for raid volumes. For a 1068, this
is equal to 8, and for 1064, this is equal to 4.  You will need
the scsi_transport_sas.c patch I posted earlier today for the proper
mapping fix. 

The problem I'm facing is the scsi_scan_target() call at the end 
of the probe routine doesn't call the slave_alloc entry point, 
neither does the queue command entry point get called.

What am I missing? 
Rather does anyone know what is failing in scsi_scan.c.

Eric Moore


diff -uarN b/drivers/fusion/mptbase.h a/drivers/fusion/mptbase.h
--- b/drivers/fusion/mptbase.h	2005-12-28 13:57:42.000000000 -0700
+++ a/drivers/fusion/mptbase.h	2006-01-04 16:43:23.000000000 -0700
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.05"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.05"
+#define MPT_LINUX_VERSION_COMMON	"3.03.06"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.06"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -609,6 +609,7 @@
 	int			 InternalCtx;
 	spinlock_t		 initializing_hba_lock;
 	int 	 		 initializing_hba_lock_flag;
+	int			 num_ports; /* maximum number of sas
ports */
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
diff -uarN b/drivers/fusion/mptsas.c a/drivers/fusion/mptsas.c
--- b/drivers/fusion/mptsas.c	2005-12-28 13:57:42.000000000 -0700
+++ a/drivers/fusion/mptsas.c	2006-01-04 17:48:15.000000000 -0700
@@ -256,6 +256,17 @@
 		hd->Targets[sdev->id] = vtarget;
 	}
 
+	/* raid support */
+	if (sdev->channel == hd->ioc->num_ports) {
+		vdev->target_id = sdev->id;
+		vdev->bus_id = 0;
+		vdev->lun = 0;
+		goto out;
+	} else if (sdev->channel > hd->ioc->num_ports) {
+		kfree(vdev);
+		return -ENODEV;
+	}
+
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
 		for (i = 0; i < p->num_phys; i++) {
@@ -1020,6 +1031,9 @@
 		(*index)++;
 	}
 
+	/* maximum number of ports for this ioc */
+	ioc->num_ports = port_info->num_phys;
+
 	return 0;
 
  out_free_port_info:
@@ -1324,6 +1338,16 @@
 
 	mptsas_scan_sas_topology(ioc);
 
+	/* report raid volumes on channel equal to the max ports*/
+	if (!ioc->raid_data.pIocPg2)
+		return 0;
+	for (ii=0;ii<ioc->raid_data.pIocPg2->NumActiveVolumes;ii++){
+		scsi_scan_target(&sh->shost_gendev,
+			ioc->num_ports,
+			ioc->raid_data.pIocPg2->RaidVolume[ii].VolumeID,
+			~0, 0);
+	}
+
 	return 0;
 
 out_mptsas_probe:
