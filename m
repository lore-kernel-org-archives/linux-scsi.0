From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas- trying to add raid support
Date: Thu, 5 Jan 2006 18:48:56 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153DB9@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39647 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932162AbWAFBtQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 20:49:16 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org, "Pope, Steve" <Steve.Pope@lsil.com>

Eric Moore wrote: 

> Christoph - I'm trying to add support in the mptsas driver to
> report raid volumes to the block layer.  I'm making the ioc->num_ports
> as
> the virtual channel for raid volumes. For a 1068, this
> is equal to 8, and for 1064, this is equal to 4.  You will need
> the scsi_transport_sas.c patch I posted earlier today for the proper
> mapping fix. 
> 
> The problem I'm facing is the scsi_scan_target() call at the end 
> of the probe routine doesn't call the slave_alloc entry point, 
> neither does the queue command entry point get called.
> 
> What am I missing? 
> Rather does anyone know what is failing in scsi_scan.c.
> 

Christoph - Ok, I figured out what is going wrong with calling
scsi_scan_target.  It fails in scsi_alloc_target because 
shost->transportt->target_parent is getting called in the sas
transport layer at the function sas_target_parent. This function
in the sas transport layer is not knowing about RAID volumes 
because RAID volumes don't exist as a scsi device directly
attached to a single phy.  The RAID volume is spanning several
devices over a number of phys, and assigned a separate unique 
target ID, not the same as one of the phys.

Thus I came up with a crude hack that creates imaginary phys so
the raid volumes can reside.  Id rather see the sas transport
layer handle raid volumes, or the alternative - completely let
the mptsas driver work independent of the sas transport layer.  


Here is my patch location on ftp: 
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/raid.patch

Apply my patch to 2.6.15-git1, as well as the previous patch I posted
this week:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113641201200858&w=2



diff -uarN b/drivers/fusion/mptbase.h a/drivers/fusion/mptbase.h
--- b/drivers/fusion/mptbase.h	2006-01-05 18:19:11.000000000 -0700
+++ a/drivers/fusion/mptbase.h	2006-01-05 18:21:24.000000000 -0700
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.05"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.05"
+#define MPT_LINUX_VERSION_COMMON	"3.03.06"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.06"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -611,6 +611,7 @@
 	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
 	struct net_device	*netdev;
+	int			 num_ports;
 	struct list_head	 sas_topology;
 	MPT_SAS_MGMT		 sas_mgmt;
 } MPT_ADAPTER;
diff -uarN b/drivers/fusion/mptsas.c a/drivers/fusion/mptsas.c
--- b/drivers/fusion/mptsas.c	2006-01-05 18:19:11.000000000 -0700
+++ a/drivers/fusion/mptsas.c	2006-01-05 18:24:10.000000000 -0700
@@ -85,6 +85,7 @@
 static int	mptsasInternalCtx = -1; /* Used only for internal
commands */
 static int	mptsasMgmtCtx = -1;
 
+#define RAID_WILDCARD_HANDLE ~0
 
 /*
  * SAS topology structures
@@ -796,6 +797,61 @@
 	return error;
 }
 
+static int
+mptsas_sas_raid_vol_pg1(MPT_ADAPTER *ioc, u64 * sas_address,
+		u32 form)
+{
+	ConfigPageHeader_t hdr;
+	CONFIGPARMS cfg;
+	RaidVolumePage1_t *buffer;
+	dma_addr_t dma_handle;
+	int error;
+
+	hdr.PageVersion = 0;
+	hdr.PageLength = 0;
+	hdr.PageNumber = 1;
+	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
+	cfg.cfghdr.hdr = &hdr;
+	cfg.physAddr = -1;
+	cfg.pageAddr = form;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
+	cfg.dir = 0;
+	cfg.timeout = 10;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out;
+
+	if (!hdr.PageLength) {
+		error = -ENXIO;
+		goto out;
+	}
+
+	buffer = pci_alloc_consistent(ioc->pcidev,
+	    hdr.PageLength * 4, &dma_handle);
+
+	if (!buffer) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	cfg.physAddr = dma_handle;
+	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+
+	error = mpt_config(ioc, &cfg);
+	if (error)
+		goto out_free_consistent;
+
+	memcpy(sas_address, &buffer->WWID, sizeof(__le64));
+
+ out_free_consistent:
+	pci_free_consistent(ioc->pcidev, hdr.PageLength * 4,
+			    buffer, dma_handle);
+ out:
+	return error;
+}
+
+
 static void
 mptsas_parse_device_info(struct sas_identify *identify,
 		struct mptsas_devinfo *device_info)
@@ -994,6 +1050,7 @@
 	if (error)
 		goto out_free_port_info;
 
+	ioc->num_ports=port_info->num_phys;
 	list_add_tail(&port_info->list, &ioc->sas_topology);
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
@@ -1100,6 +1157,83 @@
 	return error;
 }
 
+/* this creates imaginary phys whereas to hang the RAID volumes.
+ * they are placed on a port that is greater than the maximum
+ * number of ports found on the directed attached hba
+ */
+static int
+mptsas_probe_raid_phys(MPT_ADAPTER *ioc, int *index)
+{
+	struct mptsas_portinfo *port_info = NULL;
+	u64 sas_address=0;
+	int i,ii;
+
+	if(!ioc->raid_data.pIocPg2)
+		return 0;
+	if(!ioc->raid_data.pIocPg2->NumActiveVolumes)
+		return 0;
+
+	port_info = kmalloc(sizeof(*port_info), GFP_KERNEL);
+	if (!port_info)
+		goto out;
+	memset(port_info, 0, sizeof(*port_info));
+
+	port_info->handle = RAID_WILDCARD_HANDLE;
+	port_info->num_phys = ioc->raid_data.pIocPg2->NumActiveVolumes;
+	port_info->phy_info = kcalloc(port_info->num_phys,
+		sizeof(struct mptsas_phyinfo),GFP_KERNEL);
+	if (!port_info->phy_info)
+		goto out;
+	memset(port_info->phy_info, 0, sizeof(*port_info->phy_info));
+	list_add_tail(&port_info->list, &ioc->sas_topology);
+
+	for(i=0,ii=ioc->num_ports;i<port_info->num_phys;i++,ii++) {
+
+		mptsas_sas_raid_vol_pg1(ioc, &sas_address,
+			(ioc->raid_data.pIocPg2->RaidVolume[i].VolumeBus
<< 8) +
+			ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID);
+
+		port_info->phy_info[i].phy_id = ii;
+		port_info->phy_info[i].port_id = ioc->num_ports;
+		port_info->phy_info[i].negotiated_link_rate =
+		    MPI_SAS_IOUNIT0_RATE_UNKNOWN;
+		/* identify */
+		port_info->phy_info[i].identify.phy_id = ii;
+		port_info->phy_info[i].identify.port_id =
ioc->num_ports;
+		port_info->phy_info[i].identify.handle =
RAID_WILDCARD_HANDLE;
+		port_info->phy_info[i].identify.device_info =
+			MPI_SAS_DEVICE_INFO_SSP_INITIATOR +
+			MPI_SAS_DEVICE_INFO_END_DEVICE;
+		/* attached */
+		port_info->phy_info[i].attached.phy_id = ii;
+		port_info->phy_info[i].attached.port_id =
ioc->num_ports;
+		port_info->phy_info[i].attached.handle =
RAID_WILDCARD_HANDLE;
+		port_info->phy_info[i].attached.target =
+		    ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID;
+		port_info->phy_info[i].attached.sas_address =
sas_address;
+		port_info->phy_info[i].attached.device_info =
+			MPI_SAS_DEVICE_INFO_SSP_TARGET +
+			MPI_SAS_DEVICE_INFO_END_DEVICE;
+	}
+
+	for(i=0;i<port_info->num_phys;i++) {
+		 mptsas_probe_one_phy(&ioc->sh->shost_gendev,
+		     &port_info->phy_info[i], *index, 1);
+		(*index)++;
+	}
+
+	return 0;
+
+out:
+	if (port_info) {
+		if (port_info->phy_info)
+			kfree(port_info->phy_info);
+		kfree(port_info);
+	}
+
+	return 0;
+}
+
 static void
 mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 {
@@ -1107,6 +1241,7 @@
 	int index = 0;
 
 	mptsas_probe_hba_phys(ioc, &index);
+	mptsas_probe_raid_phys(ioc, &index);
 	while (!mptsas_probe_expander_phys(ioc, &handle, &index))
 		;
 }  
