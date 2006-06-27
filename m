From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 1/2] mptsas: wide port support
Date: Tue, 27 Jun 2006 14:42:12 -0600
Message-ID: <20060627204211.GA25908@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8371 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030358AbWF0Uw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 16:52:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

- (forgot sign off)

* Wide port support added - using James Bottomley's new SAS wide port API.
(There is a known problem in sas transport layer reported yesterday to
James. The Kobject dev.bus_ids for end devices are not unique across
expanders. I have added a work around in this patch, where I asigning
an unique port identifier for every port within the host - this solves
the problem, but I expect a fix from James in the sas transport).

* Adding target_alloc and target_destroy entry points, and moving code over
from the slave entry points.

* The renaming of some mptscsih_xxx functions declared in mptsas.c,
to mptsas_xxx.

* Target Reset moved from slave_destroy to hotplug work thread
handling (with regard to device removal). Also inhibit IO to end device
while device is being broken down . Talked to James Smart about this
at Linux Expo (with questions of how the fc transport handles this).

* Cleaning up the kzalloc's, and kfree's


Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/Makefile a/drivers/message/fusion/Makefile
--- b/drivers/message/fusion/Makefile	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/Makefile	2006-06-27 12:22:03.000000000 -0600
@@ -33,6 +33,11 @@
 #  For mptfc:
 #CFLAGS_mptfc.o += -DMPT_DEBUG_FC
 
+#  For mptsas:
+#CFLAGS_mptsas.o += -DMPT_DEBUG_SAS
+#CFLAGS_mptsas.o += -DMPT_DEBUG_SAS_WIDE
+
+
 #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-} LSI_LOGIC
 
 obj-$(CONFIG_FUSION_SPI)	+= mptbase.o mptscsih.o mptspi.o
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-06-27 12:17:25.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-06-27 12:22:45.000000000 -0600
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.10"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.10"
+#define MPT_LINUX_VERSION_COMMON	"3.04.00"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.00"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -342,6 +342,7 @@
 	u8			 negoFlags;	/* bit field, see above */
 	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
+	u8			 deleted;	/* target in process of being removed */
 	u32			 num_luns;
 	u32			 luns[8];		/* Max LUNs is 256 */
 } VirtTarget;
@@ -633,7 +634,7 @@
 	int			 sas_index; /* index refrencing */
 	MPT_SAS_MGMT		 sas_mgmt;
 	int			 num_ports;
-	struct work_struct	 mptscsih_persistTask;
+	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
@@ -642,6 +643,7 @@
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
+	u8		port_serial_number;
 } MPT_ADAPTER;
 
 /*
@@ -893,6 +895,13 @@
 #define DBG_DUMP_REQUEST_FRAME_HDR(mfp)
 #endif
 
+// debug sas wide ports
+#ifdef MPT_DEBUG_SAS_WIDE
+#define dsaswideprintk(x) printk x
+#else
+#define dsaswideprintk(x)
+#endif
+
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-06-17 19:49:35.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-06-27 12:25:28.000000000 -0600
@@ -50,11 +50,14 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/delay.h>	/* for mdelay */
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_sas.h>
+#include <scsi/scsi_dbg.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -137,23 +140,37 @@
 	u32	device_info;	/* bitfield detailed info about this device */
 };
 
+/*
+ * Specific details on ports, wide/narrow
+ */
+struct mptsas_portinfo_details{
+	u8	port_id; 	/* port number provided to transport */
+	u16	num_phys;	/* number of phys belong to this port */
+	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
+	struct sas_rphy *rphy;	/* transport layer rphy object */
+	struct sas_port *port;	/* transport layer port object */
+	struct scsi_target *starget;
+	struct mptsas_portinfo *port_info;
+};
+
 struct mptsas_phyinfo {
 	u8	phy_id; 		/* phy index */
-	u8	port_id; 		/* port number this phy is part of */
+	u8	port_id; 		/* firmware port identifier */
 	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
 	u8	hw_link_rate; 		/* hardware max/min phys link rate */
 	u8	programmed_link_rate;	/* programmed max/min phy link rate */
+	u8	sas_port_add_phy;	/* flag to request sas_port_add_phy*/
 	struct mptsas_devinfo identify;	/* point to phy device info */
 	struct mptsas_devinfo attached;	/* point to attached device info */
-	struct sas_phy *phy;
-	struct sas_rphy *rphy;
-	struct scsi_target *starget;
+	struct sas_phy *phy;		/* transport layer phy object */
+	struct mptsas_portinfo *portinfo;
+	struct mptsas_portinfo_details * port_details;
 };
 
 struct mptsas_portinfo {
 	struct list_head list;
 	u16		handle;		/* unique id to address this */
-	u8		num_phys;	/* number of phys */
+	u16		num_phys;	/* number of phys */
 	struct mptsas_phyinfo *phy_info;
 };
 
@@ -169,7 +186,7 @@
 	u8	sep_channel;		/* SEP channel logical channel id */
 };
 
-#ifdef SASDEBUG
+#ifdef MPT_DEBUG_SAS
 static void mptsas_print_phy_data(MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
 {
 	printk("---- IO UNIT PAGE 0 ------------\n");
@@ -305,7 +322,7 @@
 static inline int
 mptsas_is_end_device(struct mptsas_devinfo * attached)
 {
-	if ((attached->handle) &&
+	if ((attached->sas_address) &&
 	    (attached->device_info &
 	    MPI_SAS_DEVICE_INFO_END_DEVICE) &&
 	    ((attached->device_info &
@@ -319,6 +336,253 @@
 		return 0;
 }
 
+/* no mutex */
+void
+mptsas_port_delete(struct mptsas_portinfo_details * port_details)
+{
+	struct mptsas_portinfo *port_info;
+	struct mptsas_phyinfo *phy_info;
+	u8	i;
+
+	if (!port_details)
+		return;
+
+	port_info = port_details->port_info;
+	phy_info = port_info->phy_info;
+
+	dsaswideprintk((KERN_DEBUG "%s: [%p]: port=%02d num_phys=%02d "
+	    	"bitmask=0x%016llX\n",
+		__FUNCTION__, port_details, port_details->port_id,
+		port_details->num_phys, port_details->phy_bitmask));
+
+	for (i = 0; i < port_info->num_phys; i++, phy_info++) {
+		if(phy_info->port_details != port_details)
+			continue;
+		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
+		phy_info->port_details = NULL;
+	}
+	kfree(port_details);
+}
+
+static inline struct sas_rphy *
+mptsas_get_rphy(struct mptsas_phyinfo *phy_info)
+{
+	if (phy_info->port_details)
+		return phy_info->port_details->rphy;
+	else
+		return NULL;
+}
+
+static inline void
+mptsas_set_rphy(struct mptsas_phyinfo *phy_info, struct sas_rphy *rphy)
+{
+	if (phy_info->port_details) {
+		phy_info->port_details->rphy = rphy;
+		dsaswideprintk((KERN_DEBUG "sas_rphy_add: rphy=%p\n", rphy));
+	}
+
+#ifdef MPT_DEBUG_SAS_WIDE
+	if (rphy) {
+		dev_printk(KERN_DEBUG, &rphy->dev, "add:");
+		printk("rphy=%p release=%p\n",
+			rphy, rphy->dev.release);
+	}
+#endif
+}
+
+static inline struct sas_port *
+mptsas_get_port(struct mptsas_phyinfo *phy_info)
+{
+	if (phy_info->port_details)
+		return phy_info->port_details->port;
+	else
+		return NULL;
+}
+
+static inline void
+mptsas_set_port(struct mptsas_phyinfo *phy_info, struct sas_port *port)
+{
+	if (phy_info->port_details)
+		phy_info->port_details->port = port;
+
+#ifdef MPT_DEBUG_SAS_WIDE
+	if (port) {
+		dev_printk(KERN_DEBUG, &port->dev, "add: ");
+		printk("port=%p release=%p\n",
+			port, port->dev.release);
+	}
+#endif
+}
+
+static inline struct scsi_target *
+mptsas_get_starget(struct mptsas_phyinfo *phy_info)
+{
+	if (phy_info->port_details)
+		return phy_info->port_details->starget;
+	else
+		return NULL;
+}
+
+static inline void
+mptsas_set_starget(struct mptsas_phyinfo *phy_info, struct scsi_target *
+starget)
+{
+	if (phy_info->port_details)
+		phy_info->port_details->starget = starget;
+}
+
+
+/*
+ * mptsas_setup_wide_ports
+ *
+ * Updates for new and existing narrow/wide port configuration
+ * in the sas_topology
+ */
+void
+mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
+{
+	struct mptsas_portinfo_details * port_details;
+	struct mptsas_phyinfo *phy_info, *phy_info_cmp;
+	u64	sas_address;
+	int	i, j;
+
+	mutex_lock(&ioc->sas_topology_mutex);
+
+	phy_info = port_info->phy_info;
+	for (i = 0 ; i < port_info->num_phys ; i++, phy_info++) {
+		if (phy_info->attached.handle)
+			continue;
+		port_details = phy_info->port_details;
+		if (!port_details)
+			continue;
+		if (port_details->num_phys < 2)
+			continue;
+		/*
+		 * Removing a phy from a port, letting the last
+		 * phy be removed by firmware events.
+		 */
+		dsaswideprintk((KERN_DEBUG
+			"%s: [%p]: port=%d deleting phy = %d\n",
+			__FUNCTION__, port_details,
+			port_details->port_id, i));
+		port_details->num_phys--;
+		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
+		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
+		sas_port_delete_phy(port_details->port, phy_info->phy);
+		phy_info->port_details = NULL;
+	}
+
+	/*
+	 * Populate and refresh the tree
+	 */
+	phy_info = port_info->phy_info;
+	for (i = 0 ; i < port_info->num_phys ; i++, phy_info++) {
+		sas_address = phy_info->attached.sas_address;
+		dsaswideprintk((KERN_DEBUG "phy_id=%d sas_address=0x%018llX\n",
+			i, sas_address));
+		if (!sas_address)
+			continue;
+		port_details = phy_info->port_details;
+		/*
+		 * Forming a port
+		 */
+		if (!port_details) {
+			port_details = kzalloc(sizeof(*port_details),
+				GFP_KERNEL);
+			if (!port_details)
+				goto out;
+			port_details->num_phys = 1;
+			port_details->port_info = port_info;
+			port_details->port_id = ioc->port_serial_number++;
+			if (phy_info->phy_id < 64 )
+				port_details->phy_bitmask |=
+				    (1 << phy_info->phy_id);
+			phy_info->sas_port_add_phy=1;
+			dsaswideprintk((KERN_DEBUG "\t\tForming port\n\t\t"
+				"phy_id=%d sas_address=0x%018llX\n",
+				i, sas_address));
+			phy_info->port_details = port_details;
+		}
+
+		if (i == port_info->num_phys - 1)
+			continue;
+		phy_info_cmp = &port_info->phy_info[i + 1];
+		for (j = i + 1 ; j < port_info->num_phys ; j++,
+		    phy_info_cmp++) {
+			if (!phy_info_cmp->attached.sas_address)
+				continue;
+			if (sas_address != phy_info_cmp->attached.sas_address)
+				continue;
+			if (phy_info_cmp->port_details == port_details )
+				continue;
+			dsaswideprintk((KERN_DEBUG
+				"\t\tphy_id=%d sas_address=0x%018llX\n",
+				j, phy_info_cmp->attached.sas_address));
+			if (phy_info_cmp->port_details) {
+				port_details->rphy =
+				    mptsas_get_rphy(phy_info_cmp);
+				port_details->port =
+				    mptsas_get_port(phy_info_cmp);
+				port_details->starget =
+				    mptsas_get_starget(phy_info_cmp);
+				port_details->port_id =
+					phy_info_cmp->port_details->port_id;
+				port_details->num_phys =
+					phy_info_cmp->port_details->num_phys;
+//				port_info->port_serial_number--;
+				ioc->port_serial_number--;
+				if (!phy_info_cmp->port_details->num_phys)
+					kfree(phy_info_cmp->port_details);
+			} else
+				phy_info_cmp->sas_port_add_phy=1;
+			/*
+			 * Adding a phy to a port
+			 */
+			phy_info_cmp->port_details = port_details;
+			if (phy_info_cmp->phy_id < 64 )
+				port_details->phy_bitmask |=
+				(1 << phy_info_cmp->phy_id);
+			port_details->num_phys++;
+		}
+	}
+
+ out:
+
+#ifdef MPT_DEBUG_SAS_WIDE
+	for (i = 0; i < port_info->num_phys; i++) {
+		port_details = port_info->phy_info[i].port_details;
+		if (!port_details)
+			continue;
+		dsaswideprintk((KERN_DEBUG
+			"%s: [%p]: phy_id=%02d port_id=%02d num_phys=%02d "
+		    	"bitmask=0x%016llX\n",
+			__FUNCTION__,
+			port_details, i, port_details->port_id,
+			port_details->num_phys, port_details->phy_bitmask));
+		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
+			port_details->port, port_details->rphy));
+	}
+	dsaswideprintk((KERN_DEBUG"\n"));
+#endif
+	mutex_unlock(&ioc->sas_topology_mutex);
+}
+
+static void
+mptsas_target_reset(MPT_ADAPTER *ioc, VirtTarget * vtarget)
+{
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+
+	if (mptscsih_TMHandler(hd,
+	     MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+	     vtarget->bus_id, vtarget->target_id, 0, 0, 5) < 0) {
+		hd->tmPending = 0;
+		hd->tmState = TM_STATE_NONE;
+		printk(MYIOC_s_WARN_FMT
+	       "Error processing TaskMgmt id=%d TARGET_RESET\n",
+			ioc->name, vtarget->target_id);
+	}
+}
+
 static int
 mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		u32 form, u32 form_specific)
@@ -400,11 +664,105 @@
 	return mptscsih_slave_configure(sdev);
 }
 
-/*
- * This is pretty ugly.  We will be able to seriously clean it up
- * once the DV code in mptscsih goes away and we can properly
- * implement ->target_alloc.
- */
+static int
+mptsas_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(&starget->dev);
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	VirtTarget		*vtarget;
+	u32			target_id;
+	u32			channel;
+	struct sas_rphy		*rphy;
+	struct mptsas_portinfo	*p;
+	int 			 i;
+
+	vtarget = kzalloc(sizeof(VirtTarget), GFP_KERNEL);
+	if (!vtarget)
+		return -ENOMEM;
+
+	vtarget->starget = starget;
+	vtarget->ioc_id = hd->ioc->id;
+	vtarget->tflags = MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;
+
+	target_id = starget->id;
+	channel = 0;
+
+	hd->Targets[target_id] = vtarget;
+
+	/*
+	 * RAID volumes placed beyond the last expected port.
+	 */
+	if (starget->channel == hd->ioc->num_ports)
+		goto out;
+
+	rphy = dev_to_rphy(starget->dev.parent);
+	mutex_lock(&hd->ioc->sas_topology_mutex);
+	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
+		for (i = 0; i < p->num_phys; i++) {
+			if (p->phy_info[i].attached.sas_address !=
+					rphy->identify.sas_address)
+				continue;
+			target_id = p->phy_info[i].attached.id;
+			channel = p->phy_info[i].attached.channel;
+			mptsas_set_starget(&p->phy_info[i], starget);
+
+			/*
+			 * Exposing hidden raid components
+			 */
+			if (mptscsih_is_phys_disk(hd->ioc, target_id)) {
+				target_id = mptscsih_raid_id_to_num(hd,
+						target_id);
+				vtarget->tflags |=
+				    MPT_TARGET_FLAGS_RAID_COMPONENT;
+			}
+			mutex_unlock(&hd->ioc->sas_topology_mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&hd->ioc->sas_topology_mutex);
+
+	kfree(vtarget);
+	return -ENXIO;
+
+ out:
+	vtarget->target_id = target_id;
+	vtarget->bus_id = channel;
+	starget->hostdata = vtarget;
+	return 0;
+}
+
+static void
+mptsas_target_destroy(struct scsi_target *starget)
+{
+	struct Scsi_Host *host = dev_to_shost(&starget->dev);
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	struct sas_rphy		*rphy;
+	struct mptsas_portinfo	*p;
+	int 			 i;
+
+	if (!starget->hostdata)
+		return;
+
+	if (starget->channel == hd->ioc->num_ports)
+		goto out;
+
+	rphy = dev_to_rphy(starget->dev.parent);
+	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
+		for (i = 0; i < p->num_phys; i++) {
+			if (p->phy_info[i].attached.sas_address !=
+					rphy->identify.sas_address)
+				continue;
+			mptsas_set_starget(&p->phy_info[i], NULL);
+			goto out;
+		}
+	}
+
+ out:
+	kfree(starget->hostdata);
+	starget->hostdata = NULL;
+}
+
+
 static int
 mptsas_slave_alloc(struct scsi_device *sdev)
 {
@@ -412,61 +770,41 @@
 	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
-	VirtTarget		*vtarget;
 	VirtDevice		*vdev;
 	struct scsi_target 	*starget;
-	u32			target_id;
-	int i;
+	int 			i;
 
 	vdev = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
 	if (!vdev) {
-		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",
+		printk(MYIOC_s_ERR_FMT "slave_alloc kzalloc(%zd) FAILED!\n",
 				hd->ioc->name, sizeof(VirtDevice));
 		return -ENOMEM;
 	}
-	sdev->hostdata = vdev;
 	starget = scsi_target(sdev);
-	vtarget = starget->hostdata;
-	vtarget->ioc_id = hd->ioc->id;
-	vdev->vtarget = vtarget;
-	if (vtarget->num_luns == 0) {
-		vtarget->tflags = MPT_TARGET_FLAGS_Q_YES|MPT_TARGET_FLAGS_VALID_INQUIRY;
-		hd->Targets[sdev->id] = vtarget;
-	}
+	vdev->vtarget = starget->hostdata;
 
 	/*
-	  RAID volumes placed beyond the last expected port.
-	*/
-	if (sdev->channel == hd->ioc->num_ports) {
-		target_id = sdev->id;
-		vtarget->bus_id = 0;
-		vdev->lun = 0;
+	 * RAID volumes placed beyond the last expected port.
+	 */
+	if (sdev->channel == hd->ioc->num_ports)
 		goto out;
-	}
 
 	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
 	mutex_lock(&hd->ioc->sas_topology_mutex);
 	list_for_each_entry(p, &hd->ioc->sas_topology, list) {
 		for (i = 0; i < p->num_phys; i++) {
-			if (p->phy_info[i].attached.sas_address ==
-					rphy->identify.sas_address) {
-				target_id = p->phy_info[i].attached.id;
-				vtarget->bus_id = p->phy_info[i].attached.channel;
-				vdev->lun = sdev->lun;
-				p->phy_info[i].starget = sdev->sdev_target;
-				/*
-				 * Exposing hidden disk (RAID)
-				 */
-				if (mptscsih_is_phys_disk(hd->ioc, target_id)) {
-					target_id = mptscsih_raid_id_to_num(hd,
-							target_id);
-					vdev->vtarget->tflags |=
-					    MPT_TARGET_FLAGS_RAID_COMPONENT;
-					sdev->no_uld_attach = 1;
-				}
-				mutex_unlock(&hd->ioc->sas_topology_mutex);
-				goto out;
-			}
+			if (p->phy_info[i].attached.sas_address !=
+					rphy->identify.sas_address)
+				continue;
+			vdev->lun = sdev->lun;
+			/*
+			 * Exposing hidden raid components
+			 */
+			if (mptscsih_is_phys_disk(hd->ioc,
+					p->phy_info[i].attached.id))
+				sdev->no_uld_attach = 1;
+			mutex_unlock(&hd->ioc->sas_topology_mutex);
+			goto out;
 		}
 	}
 	mutex_unlock(&hd->ioc->sas_topology_mutex);
@@ -475,57 +813,39 @@
 	return -ENXIO;
 
  out:
-	vtarget->target_id = target_id;
-	vtarget->num_luns++;
+	vdev->vtarget->num_luns++;
+	sdev->hostdata = vdev;
 	return 0;
 }
 
-static void
-mptsas_slave_destroy(struct scsi_device *sdev)
+static int
+mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
-	struct Scsi_Host *host = sdev->host;
-	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)host->hostdata;
-	VirtDevice *vdev;
-
-	/*
-	 * Issue target reset to flush firmware outstanding commands.
-	 */
-	vdev = sdev->hostdata;
-	if (vdev->configured_lun){
-		if (mptscsih_TMHandler(hd,
-		     MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-		     vdev->vtarget->bus_id,
-		     vdev->vtarget->target_id,
-		     0, 0, 5 /* 5 second timeout */)
-		     < 0){
+	VirtDevice	*vdev = SCpnt->device->hostdata;
 
-			/* The TM request failed!
-			 * Fatal error case.
-			 */
-			printk(MYIOC_s_WARN_FMT
-		       "Error processing TaskMgmt id=%d TARGET_RESET\n",
-				hd->ioc->name,
-				vdev->vtarget->target_id);
-
-			hd->tmPending = 0;
-			hd->tmState = TM_STATE_NONE;
-		}
+//	scsi_print_command(SCpnt);
+	if (vdev->vtarget->deleted) {
+		SCpnt->result = DID_NO_CONNECT << 16;
+		done(SCpnt);
+		return 0;
 	}
-	mptscsih_slave_destroy(sdev);
+
+	return mptscsih_qcmd(SCpnt,done);
 }
 
+
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptscsih_qcmd,
-	.target_alloc			= mptscsih_target_alloc,
+	.queuecommand			= mptsas_qcmd,
+	.target_alloc			= mptsas_target_alloc,
 	.slave_alloc			= mptsas_slave_alloc,
 	.slave_configure		= mptsas_slave_configure,
-	.target_destroy			= mptscsih_target_destroy,
-	.slave_destroy			= mptsas_slave_destroy,
+	.target_destroy			= mptsas_target_destroy,
+	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
@@ -795,7 +1115,7 @@
 
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,
-		sizeof(struct mptsas_phyinfo),GFP_KERNEL);
+		sizeof(*port_info->phy_info),GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
 		goto out_free_consistent;
@@ -811,6 +1131,7 @@
 		    buffer->PhyData[i].Port;
 		port_info->phy_info[i].negotiated_link_rate =
 		    buffer->PhyData[i].NegotiatedLinkRate;
+		port_info->phy_info[i].portinfo = port_info;
 	}
 
  out_free_consistent:
@@ -968,7 +1289,7 @@
 	CONFIGPARMS cfg;
 	SasExpanderPage0_t *buffer;
 	dma_addr_t dma_handle;
-	int error;
+	int i, error;
 
 	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
@@ -1013,12 +1334,15 @@
 	port_info->num_phys = buffer->NumPhys;
 	port_info->handle = le16_to_cpu(buffer->DevHandle);
 	port_info->phy_info = kcalloc(port_info->num_phys,
-		sizeof(struct mptsas_phyinfo),GFP_KERNEL);
+		sizeof(*port_info->phy_info),GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
 		goto out_free_consistent;
 	}
 
+	for (i = 0; i < port_info->num_phys; i++)
+		port_info->phy_info[i].portinfo = port_info;
+
  out_free_consistent:
 	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
 			    buffer, dma_handle);
@@ -1161,19 +1485,23 @@
 {
 	MPT_ADAPTER *ioc;
 	struct sas_phy *phy;
-	int error;
+	struct sas_port *port;
+	int error = 0;
 
-	if (!dev)
-		return -ENODEV;
+	if (!dev) {
+		error = -ENODEV;
+		goto out;
+	}
 
 	if (!phy_info->phy) {
 		phy = sas_phy_alloc(dev, index);
-		if (!phy)
-			return -ENOMEM;
+		if (!phy) {
+			error = -ENOMEM;
+			goto out;
+		}
 	} else
 		phy = phy_info->phy;
 
-	phy->port_identifier = phy_info->port_id;
 	mptsas_parse_device_info(&phy->identify, &phy_info->identify);
 
 	/*
@@ -1265,19 +1593,50 @@
 		error = sas_phy_add(phy);
 		if (error) {
 			sas_phy_free(phy);
-			return error;
+			goto out;
 		}
 		phy_info->phy = phy;
 	}
 
-	if ((phy_info->attached.handle) &&
-	    (!phy_info->rphy)) {
+	if (!phy_info->attached.handle ||
+			!phy_info->port_details)
+		goto out;
+
+	port = mptsas_get_port(phy_info);
+	ioc = phy_to_ioc(phy_info->phy);
+
+	if (phy_info->sas_port_add_phy) {
+
+		if (!port) {
+			port = sas_port_alloc(dev,
+			    phy_info->port_details->port_id);
+			dsaswideprintk((KERN_DEBUG
+			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
+			    port, dev, phy_info->port_details->port_id));
+			if (!port) {
+				error = -ENOMEM;
+				goto out;
+			}
+			error = sas_port_add(port);
+			if (error) {
+				dfailprintk((MYIOC_s_ERR_FMT
+					"%s: exit at line=%d\n", ioc->name,
+					__FUNCTION__, __LINE__));
+				goto out;
+			}
+			mptsas_set_port(phy_info, port);
+		}
+		dsaswideprintk((KERN_DEBUG "sas_port_add_phy: phy_id=%d\n",
+		    phy_info->phy_id));
+		sas_port_add_phy(port, phy_info->phy);
+		phy_info->sas_port_add_phy = 0;
+	}
+
+	if (!mptsas_get_rphy(phy_info) && port && !port->rphy) {
 
 		struct sas_rphy *rphy;
 		struct sas_identify identify;
 
-		ioc = phy_to_ioc(phy_info->phy);
-
 		/*
 		 * Let the hotplug_work thread handle processing
 		 * the adding/removing of devices that occur
@@ -1285,36 +1644,42 @@
 		 */
 		if (ioc->sas_discovery_runtime &&
 			mptsas_is_end_device(&phy_info->attached))
-			return 0;
+				goto out;
 
 		mptsas_parse_device_info(&identify, &phy_info->attached);
 		switch (identify.device_type) {
 		case SAS_END_DEVICE:
-			rphy = sas_end_device_alloc(phy);
+			rphy = sas_end_device_alloc(port);
 			break;
 		case SAS_EDGE_EXPANDER_DEVICE:
 		case SAS_FANOUT_EXPANDER_DEVICE:
-			rphy = sas_expander_alloc(phy, identify.device_type);
+			rphy = sas_expander_alloc(port, identify.device_type);
 			break;
 		default:
 			rphy = NULL;
 			break;
 		}
-		if (!rphy)
-			return 0; /* non-fatal: an rphy can be added later */
+		if (!rphy) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+				__FUNCTION__, __LINE__));
+			goto out;
+		}
 
 		rphy->identify = identify;
-
 		error = sas_rphy_add(rphy);
 		if (error) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+				__FUNCTION__, __LINE__));
 			sas_rphy_free(rphy);
-			return error;
+			goto out;
 		}
-
-		phy_info->rphy = rphy;
+		mptsas_set_rphy(phy_info, rphy);
 	}
 
-	return 0;
+ out:
+	return error;
 }
 
 static int
@@ -1342,8 +1707,7 @@
 		for (i = 0; i < hba->num_phys; i++)
 			port_info->phy_info[i].negotiated_link_rate =
 				hba->phy_info[i].negotiated_link_rate;
-		if (hba->phy_info)
-			kfree(hba->phy_info);
+		kfree(hba->phy_info);
 		kfree(hba);
 		hba = NULL;
 	}
@@ -1362,24 +1726,24 @@
 		    port_info->phy_info[i].phy_id;
 		handle = port_info->phy_info[i].identify.handle;
 
-		if (port_info->phy_info[i].attached.handle) {
+		if (port_info->phy_info[i].attached.handle)
 			mptsas_sas_device_pg0(ioc,
 				&port_info->phy_info[i].attached,
 				(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
 				 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
 				port_info->phy_info[i].attached.handle);
-		}
+	}
+
+	mptsas_setup_wide_ports(ioc, port_info);
 
+	for (i = 0; i < port_info->num_phys; i++, ioc->sas_index++)
 		mptsas_probe_one_phy(&ioc->sh->shost_gendev,
 		    &port_info->phy_info[i], ioc->sas_index, 1);
-		ioc->sas_index++;
-	}
 
 	return 0;
 
  out_free_port_info:
-	if (hba)
-		kfree(hba);
+	kfree(hba);
  out:
 	return error;
 }
@@ -1388,6 +1752,8 @@
 mptsas_probe_expander_phys(MPT_ADAPTER *ioc, u32 *handle)
 {
 	struct mptsas_portinfo *port_info, *p, *ex;
+	struct device *parent;
+	struct sas_rphy *rphy;
 	int error = -ENOMEM, i, j;
 
 	ex = kzalloc(sizeof(*port_info), GFP_KERNEL);
@@ -1409,16 +1775,13 @@
 		list_add_tail(&port_info->list, &ioc->sas_topology);
 	} else {
 		port_info->handle = ex->handle;
-		if (ex->phy_info)
-			kfree(ex->phy_info);
+		kfree(ex->phy_info);
 		kfree(ex);
 		ex = NULL;
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
 
 	for (i = 0; i < port_info->num_phys; i++) {
-		struct device *parent;
-
 		mptsas_sas_expander_pg1(ioc, &port_info->phy_info[i],
 			(MPI_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM <<
 			 MPI_SAS_EXPAND_PGAD_FORM_SHIFT), (i << 16) + *handle);
@@ -1442,34 +1805,34 @@
 			port_info->phy_info[i].attached.phy_id =
 			    port_info->phy_info[i].phy_id;
 		}
+	}
 
-		/*
-		 * If we find a parent port handle this expander is
-		 * attached to another expander, else it hangs of the
-		 * HBA phys.
-		 */
-		parent = &ioc->sh->shost_gendev;
+	parent = &ioc->sh->shost_gendev;
+	for (i = 0; i < port_info->num_phys; i++) {
 		mutex_lock(&ioc->sas_topology_mutex);
 		list_for_each_entry(p, &ioc->sas_topology, list) {
 			for (j = 0; j < p->num_phys; j++) {
-				if (port_info->phy_info[i].identify.handle ==
+				if (port_info->phy_info[i].identify.handle !=
 						p->phy_info[j].attached.handle)
-					parent = &p->phy_info[j].rphy->dev;
+					continue;
+				rphy = mptsas_get_rphy(&p->phy_info[j]);
+				parent = &rphy->dev;
 			}
 		}
 		mutex_unlock(&ioc->sas_topology_mutex);
+	}
+
+	mptsas_setup_wide_ports(ioc, port_info);
 
+	for (i = 0; i < port_info->num_phys; i++, ioc->sas_index++)
 		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
 		    ioc->sas_index, 0);
-		ioc->sas_index++;
-	}
 
 	return 0;
 
  out_free_port_info:
 	if (ex) {
-		if (ex->phy_info)
-			kfree(ex->phy_info);
+		kfree(ex->phy_info);
 		kfree(ex);
 	}
  out:
@@ -1488,7 +1851,12 @@
 {
 	struct mptsas_portinfo buffer;
 	struct mptsas_portinfo *port_info, *n, *parent;
+	struct mptsas_phyinfo *phy_info;
+	struct scsi_target * starget;
+	VirtTarget * vtarget;
+	struct sas_port * port;
 	int i;
+	u64	expander_sas_address;
 
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry_safe(port_info, n, &ioc->sas_topology, list) {
@@ -1503,6 +1871,25 @@
 		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), port_info->handle)) {
 
 			/*
+			 * Issue target reset to all child end devices
+			 * then mark them deleted to prevent further
+			 * IO going to them.
+			 */
+			phy_info = port_info->phy_info;
+			for (i = 0; i < port_info->num_phys; i++, phy_info++) {
+				starget = mptsas_get_starget(phy_info);
+				if (!starget)
+					continue;
+				vtarget = starget->hostdata;
+				if(vtarget->deleted)
+					continue;
+				vtarget->deleted = 1;
+				mptsas_target_reset(ioc, vtarget);
+				sas_port_delete(mptsas_get_port(phy_info));
+				mptsas_port_delete(phy_info->port_details);
+			}
+
+			/*
 			 * Obtain the port_info instance to the parent port
 			 */
 			parent = mptsas_find_portinfo_by_handle(ioc,
@@ -1511,34 +1898,43 @@
 			if (!parent)
 				goto next_port;
 
+			expander_sas_address =
+				port_info->phy_info[0].identify.sas_address;
+
 			/*
 			 * Delete rphys in the parent that point
 			 * to this expander.  The transport layer will
 			 * cleanup all the children.
 			 */
-			for (i = 0; i < parent->num_phys; i++) {
-				if ((!parent->phy_info[i].rphy) ||
-				    (parent->phy_info[i].attached.sas_address !=
-				   port_info->phy_info[i].identify.sas_address))
+			phy_info = parent->phy_info;
+			for (i = 0; i < parent->num_phys; i++, phy_info++) {
+				port = mptsas_get_port(phy_info);
+				if (!port)
+					continue;
+				if (phy_info->attached.sas_address !=
+					expander_sas_address)
 					continue;
-				sas_rphy_delete(parent->phy_info[i].rphy);
-				memset(&parent->phy_info[i].attached, 0,
-				    sizeof(struct mptsas_devinfo));
-				parent->phy_info[i].rphy = NULL;
-				parent->phy_info[i].starget = NULL;
+#ifdef MPT_DEBUG_SAS_WIDE
+				dev_printk(KERN_DEBUG, &port->dev, "delete\n");
+#endif
+				sas_port_delete(port);
+				mptsas_port_delete(phy_info->port_details);
 			}
  next_port:
+
+			phy_info = port_info->phy_info;
+			for (i = 0; i < port_info->num_phys; i++, phy_info++)
+				mptsas_port_delete(phy_info->port_details);
+
 			list_del(&port_info->list);
-			if (port_info->phy_info)
-				kfree(port_info->phy_info);
+			kfree(port_info->phy_info);
 			kfree(port_info);
 		}
 		/*
 		* Free this memory allocated from inside
 		* mptsas_sas_expander_pg0
 		*/
-		if (buffer.phy_info)
-			kfree(buffer.phy_info);
+		kfree(buffer.phy_info);
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
 }
@@ -1574,60 +1970,59 @@
 /*
  * Work queue thread to handle Runtime discovery
  * Mere purpose is the hot add/delete of expanders
+ *(Mutex UNLOCKED)
  */
 static void
-mptscsih_discovery_work(void * arg)
+__mptsas_discovery_work(MPT_ADAPTER *ioc)
 {
-	struct mptsas_discovery_event *ev = arg;
-	MPT_ADAPTER *ioc = ev->ioc;
 	u32 handle = 0xFFFF;
 
-	mutex_lock(&ioc->sas_discovery_mutex);
 	ioc->sas_discovery_runtime=1;
 	mptsas_delete_expander_phys(ioc);
 	mptsas_probe_hba_phys(ioc);
 	while (!mptsas_probe_expander_phys(ioc, &handle))
 		;
-	kfree(ev);
 	ioc->sas_discovery_runtime=0;
+}
+
+/*
+ * Work queue thread to handle Runtime discovery
+ * Mere purpose is the hot add/delete of expanders
+ *(Mutex LOCKED)
+ */
+static void
+mptsas_discovery_work(void * arg)
+{
+	struct mptsas_discovery_event *ev = arg;
+	MPT_ADAPTER *ioc = ev->ioc;
+
+	mutex_lock(&ioc->sas_discovery_mutex);
+	__mptsas_discovery_work(ioc);
 	mutex_unlock(&ioc->sas_discovery_mutex);
+	kfree(ev);
 }
 
 static struct mptsas_phyinfo *
-mptsas_find_phyinfo_by_parent(MPT_ADAPTER *ioc, u16 parent_handle, u8 phy_id)
+mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
 {
 	struct mptsas_portinfo *port_info;
-	struct mptsas_devinfo device_info;
 	struct mptsas_phyinfo *phy_info = NULL;
-	int i, error;
-
-	/*
-	 * Retrieve the parent sas_address
-	 */
-	error = mptsas_sas_device_pg0(ioc, &device_info,
-		(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
-		 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
-		parent_handle);
-	if (error)
-		return NULL;
+	int i;
 
-	/*
-	 * The phy_info structures are never deallocated during lifetime of
-	 * a host, so the code below is safe without additional refcounting.
-	 */
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry(port_info, &ioc->sas_topology, list) {
 		for (i = 0; i < port_info->num_phys; i++) {
-			if (port_info->phy_info[i].identify.sas_address ==
-			    device_info.sas_address &&
-			    port_info->phy_info[i].phy_id == phy_id) {
-				phy_info = &port_info->phy_info[i];
-				break;
-			}
+			if (port_info->phy_info[i].attached.sas_address
+			    != sas_address)
+				continue;
+			if (!mptsas_is_end_device(
+				&port_info->phy_info[i].attached))
+				continue;
+			phy_info = &port_info->phy_info[i];
+			break;
 		}
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-
 	return phy_info;
 }
 
@@ -1638,21 +2033,19 @@
 	struct mptsas_phyinfo *phy_info = NULL;
 	int i;
 
-	/*
-	 * The phy_info structures are never deallocated during lifetime of
-	 * a host, so the code below is safe without additional refcounting.
-	 */
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry(port_info, &ioc->sas_topology, list) {
-		for (i = 0; i < port_info->num_phys; i++)
-			if (mptsas_is_end_device(&port_info->phy_info[i].attached))
-				if (port_info->phy_info[i].attached.id == id) {
-					phy_info = &port_info->phy_info[i];
-					break;
-				}
+		for (i = 0; i < port_info->num_phys; i++) {
+			if (port_info->phy_info[i].attached.id != id)
+				continue;
+			if (!mptsas_is_end_device(
+				&port_info->phy_info[i].attached))
+				continue;
+			phy_info = &port_info->phy_info[i];
+			break;
+		}
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-
 	return phy_info;
 }
 
@@ -1660,7 +2053,7 @@
  * Work queue thread to clear the persitency table
  */
 static void
-mptscsih_sas_persist_clear_table(void * arg)
+mptsas_persist_clear_table(void * arg)
 {
 	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
 
@@ -1681,7 +2074,6 @@
 			mptsas_reprobe_lun);
 }
 
-
 /*
  * Work queue thread to handle SAS hotplug events
  */
@@ -1692,14 +2084,17 @@
 	MPT_ADAPTER *ioc = ev->ioc;
 	struct mptsas_phyinfo *phy_info;
 	struct sas_rphy *rphy;
+	struct sas_port *port;
 	struct scsi_device *sdev;
+	struct scsi_target * starget;
 	struct sas_identify identify;
 	char *ds = NULL;
 	struct mptsas_devinfo sas_device;
 	VirtTarget *vtarget;
+	VirtDevice *vdevice;
 
-	mutex_lock(&ioc->sas_discovery_mutex);
 
+	mutex_lock(&ioc->sas_discovery_mutex);
 	switch (ev->event_type) {
 	case MPTSAS_DEL_DEVICE:
 
@@ -1708,24 +2103,50 @@
 		/*
 		 * Sanity checks, for non-existing phys and remote rphys.
 		 */
-		if (!phy_info)
+		if (!phy_info || !phy_info->port_details) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
 			break;
-		if (!phy_info->rphy)
+		}
+		rphy = mptsas_get_rphy(phy_info);
+		if (!rphy) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
+			break;
+		}
+		port = mptsas_get_port(phy_info);
+		if (!port) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
 			break;
-		if (phy_info->starget) {
-			vtarget = phy_info->starget->hostdata;
+		}
+
+		starget = mptsas_get_starget(phy_info);
+		if (starget) {
+			vtarget = starget->hostdata;
 
-			if (!vtarget)
+			if (!vtarget) {
+				dfailprintk((MYIOC_s_ERR_FMT
+					"%s: exit at line=%d\n", ioc->name,
+					__FUNCTION__, __LINE__));
 				break;
+			}
+
 			/*
 			 * Handling  RAID components
 			 */
 			if (ev->phys_disk_num_valid) {
 				vtarget->target_id = ev->phys_disk_num;
 				vtarget->tflags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
-				mptsas_reprobe_target(vtarget->starget, 1);
+				mptsas_reprobe_target(starget, 1);
 				break;
 			}
+
+			vtarget->deleted = 1;
+			mptsas_target_reset(ioc, vtarget);
 		}
 
 		if (phy_info->attached.device_info & MPI_SAS_DEVICE_INFO_SSP_TARGET)
@@ -1739,10 +2160,11 @@
 		       "removing %s device, channel %d, id %d, phy %d\n",
 		       ioc->name, ds, ev->channel, ev->id, phy_info->phy_id);
 
-		sas_rphy_delete(phy_info->rphy);
-		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
-		phy_info->rphy = NULL;
-		phy_info->starget = NULL;
+#ifdef MPT_DEBUG_SAS_WIDE
+		dev_printk(KERN_DEBUG, &port->dev, "delete\n");
+#endif
+		sas_port_delete(port);
+		mptsas_port_delete(phy_info->port_details);
 		break;
 	case MPTSAS_ADD_DEVICE:
 
@@ -1754,59 +2176,60 @@
 		 */
 		if (mptsas_sas_device_pg0(ioc, &sas_device,
 		    (MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID <<
-		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT), ev->id))
+		     MPI_SAS_DEVICE_PGAD_FORM_SHIFT), ev->id)) {
+				dfailprintk((MYIOC_s_ERR_FMT
+					"%s: exit at line=%d\n", ioc->name,
+					__FUNCTION__, __LINE__));
 			break;
+		}
 
-		phy_info = mptsas_find_phyinfo_by_parent(ioc,
-				sas_device.handle_parent, sas_device.phy_id);
+		ssleep(2);
+		__mptsas_discovery_work(ioc);
 
-		if (!phy_info) {
-			u32 handle = 0xFFFF;
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+				sas_device.sas_address);
 
-			/*
-			* Its possible when an expander has been hot added
-			* containing attached devices, the sas firmware
-			* may send a RC_ADDED event prior to the
-			* DISCOVERY STOP event. If that occurs, our
-			* view of the topology in the driver in respect to this
-			* expander might of not been setup, and we hit this
-			* condition.
-			* Therefore, this code kicks off discovery to
-			* refresh the data.
-			* Then again, we check whether the parent phy has
-			* been created.
-			*/
-			ioc->sas_discovery_runtime=1;
-			mptsas_delete_expander_phys(ioc);
-			mptsas_probe_hba_phys(ioc);
-			while (!mptsas_probe_expander_phys(ioc, &handle))
-				;
-			ioc->sas_discovery_runtime=0;
-
-			phy_info = mptsas_find_phyinfo_by_parent(ioc,
-				sas_device.handle_parent, sas_device.phy_id);
-			if (!phy_info)
-				break;
+		if (!phy_info || !phy_info->port_details) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
+			break;
 		}
 
-		if (phy_info->starget) {
-			vtarget = phy_info->starget->hostdata;
+		starget = mptsas_get_starget(phy_info);
+		if (starget) {
+			vtarget = starget->hostdata;
 
-			if (!vtarget)
+			if (!vtarget) {
+				dfailprintk((MYIOC_s_ERR_FMT
+					"%s: exit at line=%d\n", ioc->name,
+				       	__FUNCTION__, __LINE__));
 				break;
+			}
 			/*
 			 * Handling  RAID components
 			 */
 			if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 				vtarget->tflags &= ~MPT_TARGET_FLAGS_RAID_COMPONENT;
 				vtarget->target_id = ev->id;
-				mptsas_reprobe_target(phy_info->starget, 0);
+				mptsas_reprobe_target(starget, 0);
 			}
 			break;
 		}
 
-		if (phy_info->rphy)
+		if (mptsas_get_rphy(phy_info)) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
 			break;
+		}
+		port = mptsas_get_port(phy_info);
+		if (!port) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
+			break;
+		}
 
 		memcpy(&phy_info->attached, &sas_device,
 		    sizeof(struct mptsas_devinfo));
@@ -1823,28 +2246,23 @@
 		       ioc->name, ds, ev->channel, ev->id, ev->phy_id);
 
 		mptsas_parse_device_info(&identify, &phy_info->attached);
-		switch (identify.device_type) {
-		case SAS_END_DEVICE:
-			rphy = sas_end_device_alloc(phy_info->phy);
-			break;
-		case SAS_EDGE_EXPANDER_DEVICE:
-		case SAS_FANOUT_EXPANDER_DEVICE:
-			rphy = sas_expander_alloc(phy_info->phy, identify.device_type);
-			break;
-		default:
-			rphy = NULL;
-			break;
-		}
-		if (!rphy)
+		rphy = sas_end_device_alloc(port);
+		if (!rphy) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
 			break; /* non-fatal: an rphy can be added later */
+		}
 
 		rphy->identify = identify;
 		if (sas_rphy_add(rphy)) {
+			dfailprintk((MYIOC_s_ERR_FMT
+				"%s: exit at line=%d\n", ioc->name,
+			       	__FUNCTION__, __LINE__));
 			sas_rphy_free(rphy);
 			break;
 		}
-
-		phy_info->rphy = rphy;
+		mptsas_set_rphy(phy_info, rphy);
 		break;
 	case MPTSAS_ADD_RAID:
 		sdev = scsi_device_lookup(
@@ -1876,6 +2294,9 @@
 		printk(MYIOC_s_INFO_FMT
 		       "removing raid volume, channel %d, id %d\n",
 		       ioc->name, ioc->num_ports, ev->id);
+		vdevice = sdev->hostdata;
+		vdevice->vtarget->deleted = 1;
+		mptsas_target_reset(ioc, vdevice->vtarget);
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
 		mpt_findImVolumes(ioc);
@@ -1885,12 +2306,13 @@
 		break;
 	}
 
-	kfree(ev);
 	mutex_unlock(&ioc->sas_discovery_mutex);
+	kfree(ev);
+
 }
 
 static void
-mptscsih_send_sas_event(MPT_ADAPTER *ioc,
+mptsas_send_sas_event(MPT_ADAPTER *ioc,
 		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data)
 {
 	struct mptsas_hotplug_event *ev;
@@ -1906,7 +2328,7 @@
 	switch (sas_event_data->ReasonCode) {
 	case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
 	case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
-		ev = kmalloc(sizeof(*ev), GFP_ATOMIC);
+		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
 			printk(KERN_WARNING "mptsas: lost hotplug event\n");
 			break;
@@ -1936,10 +2358,9 @@
 	/*
 	 * Persistent table is full.
 	 */
-		INIT_WORK(&ioc->mptscsih_persistTask,
-		    mptscsih_sas_persist_clear_table,
-		    (void *)ioc);
-		schedule_work(&ioc->mptscsih_persistTask);
+		INIT_WORK(&ioc->sas_persist_task,
+		    mptsas_persist_clear_table, (void *)ioc);
+		schedule_work(&ioc->sas_persist_task);
 		break;
 	case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
 	/* TODO */
@@ -1951,7 +2372,7 @@
 }
 
 static void
-mptscsih_send_raid_event(MPT_ADAPTER *ioc,
+mptsas_send_raid_event(MPT_ADAPTER *ioc,
 		EVENT_DATA_RAID *raid_event_data)
 {
 	struct mptsas_hotplug_event *ev;
@@ -1961,13 +2382,12 @@
 	if (ioc->bus_type != SAS)
 		return;
 
-	ev = kmalloc(sizeof(*ev), GFP_ATOMIC);
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev) {
 		printk(KERN_WARNING "mptsas: lost hotplug event\n");
 		return;
 	}
 
-	memset(ev,0,sizeof(struct mptsas_hotplug_event));
 	INIT_WORK(&ev->work, mptsas_hotplug_work, ev);
 	ev->ioc = ioc;
 	ev->id = raid_event_data->VolumeID;
@@ -2029,7 +2449,7 @@
 }
 
 static void
-mptscsih_send_discovery(MPT_ADAPTER *ioc,
+mptsas_send_discovery_event(MPT_ADAPTER *ioc,
 	EVENT_DATA_SAS_DISCOVERY *discovery_data)
 {
 	struct mptsas_discovery_event *ev;
@@ -2044,11 +2464,10 @@
 	if (discovery_data->DiscoveryStatus)
 		return;
 
-	ev = kmalloc(sizeof(*ev), GFP_ATOMIC);
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev)
 		return;
-	memset(ev,0,sizeof(struct mptsas_discovery_event));
-	INIT_WORK(&ev->work, mptscsih_discovery_work, ev);
+	INIT_WORK(&ev->work, mptsas_discovery_work, ev);
 	ev->ioc = ioc;
 	schedule_work(&ev->work);
 };
@@ -2076,21 +2495,21 @@
 
 	switch (event) {
 	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
-		mptscsih_send_sas_event(ioc,
+		mptsas_send_sas_event(ioc,
 			(EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)reply->Data);
 		break;
 	case MPI_EVENT_INTEGRATED_RAID:
-		mptscsih_send_raid_event(ioc,
+		mptsas_send_raid_event(ioc,
 			(EVENT_DATA_RAID *)reply->Data);
 		break;
 	case MPI_EVENT_PERSISTENT_TABLE_FULL:
-		INIT_WORK(&ioc->mptscsih_persistTask,
-		    mptscsih_sas_persist_clear_table,
+		INIT_WORK(&ioc->sas_persist_task,
+		    mptsas_persist_clear_table,
 		    (void *)ioc);
-		schedule_work(&ioc->mptscsih_persistTask);
+		schedule_work(&ioc->sas_persist_task);
 		break;
 	 case MPI_EVENT_SAS_DISCOVERY:
-		mptscsih_send_discovery(ioc,
+		mptsas_send_discovery_event(ioc,
 			(EVENT_DATA_SAS_DISCOVERY *)reply->Data);
 		break;
 	default:
@@ -2309,7 +2728,7 @@
 
 	return 0;
 
-out_mptsas_probe:
+ out_mptsas_probe:
 
 	mptscsih_remove(pdev);
 	return error;
@@ -2319,6 +2738,7 @@
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	struct mptsas_portinfo *p, *n;
+	int i;
 
 	ioc->sas_discovery_ignore_events=1;
 	sas_remove_host(ioc->sh);
@@ -2326,8 +2746,9 @@
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry_safe(p, n, &ioc->sas_topology, list) {
 		list_del(&p->list);
-		if (p->phy_info)
-			kfree(p->phy_info);
+		for (i = 0 ; i < p->num_phys ; i++)
+			mptsas_port_delete(p->phy_info[i].port_details);
+		kfree(p->phy_info);
 		kfree(p);
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
