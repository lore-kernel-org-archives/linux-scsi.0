From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] - mpt fusion - bug fix's for raid components adding/deleting
Date: Tue, 25 Apr 2006 17:38:20 -0600
Message-ID: <20060425233820.GA9424@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34548 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932172AbWDYXje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:39:34 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k3PNXZNI027889
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:33:35 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k3PNdXur010827
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:39:33 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch handles case where raid hidden components
are not being removed when power turned off to device
attached to expander, as well as the case of
exposing raid components when power is turned back on
to devices attached to an expander.  (This is a repost
of this patch, with  mptsas_is_end_device declared
further up in the code.)

This patch contains some other miscellaneous bug fix's.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-04-21 10:47:41.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-04-25 09:22:08.000000000 -0600
@@ -5736,11 +5736,13 @@
 	return rc;
 }
 
+# define EVENT_DESCR_STR_SZ		100
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 static void
 EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 {
-	char *ds;
+	char *ds = NULL;
 
 	switch(event) {
 	case MPI_EVENT_NONE:
@@ -5777,9 +5779,9 @@
 		if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LIP)
 			ds = "Loop State(LIP) Change";
 		else if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LPE)
-			ds = "Loop State(LPE) Change";			/* ??? */
+			ds = "Loop State(LPE) Change";		/* ??? */
 		else
-			ds = "Loop State(LPB) Change";			/* ??? */
+			ds = "Loop State(LPB) Change";		/* ??? */
 		break;
 	case MPI_EVENT_LOGOUT:
 		ds = "Logout";
@@ -5841,27 +5843,32 @@
 		break;
 	case MPI_EVENT_SAS_DEVICE_STATUS_CHANGE:
 	{
-		char buf[50];
 		u8 id = (u8)(evData0);
 		u8 ReasonCode = (u8)(evData0 >> 16);
 		switch (ReasonCode) {
 		case MPI_EVENT_SAS_DEV_STAT_RC_ADDED:
-			sprintf(buf,"SAS Device Status Change: Added: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Added: id=%d", id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING:
-			sprintf(buf,"SAS Device Status Change: Deleted: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Deleted: id=%d", id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_SMART_DATA:
-			sprintf(buf,"SAS Device Status Change: SMART Data: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: SMART Data: id=%d",
+			    id);
 			break;
 		case MPI_EVENT_SAS_DEV_STAT_RC_NO_PERSIST_ADDED:
-			sprintf(buf,"SAS Device Status Change: No Persistancy Added: id=%d", id);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: No Persistancy "
+			    "Added: id=%d", id);
 			break;
 		default:
-			sprintf(buf,"SAS Device Status Change: Unknown: id=%d", id);
-		break;
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "SAS Device Status Change: Unknown: id=%d", id);
+			break;
 		}
-		ds = buf;
 		break;
 	}
 	case MPI_EVENT_ON_BUS_TIMER_EXPIRED:
@@ -5878,41 +5885,46 @@
 		break;
 	case MPI_EVENT_SAS_PHY_LINK_STATUS:
 	{
-		char buf[50];
 		u8 LinkRates = (u8)(evData0 >> 8);
 		u8 PhyNumber = (u8)(evData0);
 		LinkRates = (LinkRates & MPI_EVENT_SAS_PLS_LR_CURRENT_MASK) >>
 			MPI_EVENT_SAS_PLS_LR_CURRENT_SHIFT;
 		switch (LinkRates) {
 		case MPI_EVENT_SAS_PLS_LR_RATE_UNKNOWN:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate Unknown",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_PHY_DISABLED:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Phy Disabled",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_FAILED_SPEED_NEGOTIATION:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Failed Speed Nego",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_SATA_OOB_COMPLETE:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Sata OOB Completed",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_1_5:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate 1.5 Gbps",PhyNumber);
 			break;
 		case MPI_EVENT_SAS_PLS_LR_RATE_3_0:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d:"
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d:"
 			   " Rate 3.0 Gpbs",PhyNumber);
 			break;
 		default:
-			sprintf(buf,"SAS PHY Link Status: Phy=%d", PhyNumber);
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			   "SAS PHY Link Status: Phy=%d", PhyNumber);
 			break;
 		}
-		ds = buf;
 		break;
 	}
 	case MPI_EVENT_SAS_DISCOVERY_ERROR:
@@ -5921,9 +5933,8 @@
 	case MPI_EVENT_IR_RESYNC_UPDATE:
 	{
 		u8 resync_complete = (u8)(evData0 >> 16);
-		char buf[40];
-		sprintf(buf,"IR Resync Update: Complete = %d:",resync_complete);
-		ds = buf;
+		snprintf(evStr, EVENT_DESCR_STR_SZ,
+		    "IR Resync Update: Complete = %d:",resync_complete);
 		break;
 	}
 	case MPI_EVENT_IR2:
@@ -5976,7 +5987,8 @@
 		ds = "Unknown";
 		break;
 	}
-	strcpy(evStr,ds);
+	if (ds)
+		strncpy(evStr, ds, EVENT_DESCR_STR_SZ);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -5998,7 +6010,7 @@
 	int ii;
 	int r = 0;
 	int handlers = 0;
-	char evStr[100];
+	char evStr[EVENT_DESCR_STR_SZ];
 	u8 event;
 
 	/*
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-04-21 10:47:41.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-04-21 10:53:19.000000000 -0600
@@ -91,6 +91,7 @@
 	MPTSAS_DEL_DEVICE,
 	MPTSAS_ADD_RAID,
 	MPTSAS_DEL_RAID,
+	MPTSAS_IGNORE_EVENT,
 };
 
 struct mptsas_hotplug_event {
@@ -298,6 +299,26 @@
 	return rc;
 }
 
+/*
+ * Returns true if there is a scsi end device
+ */
+static inline int
+mptsas_is_end_device(struct mptsas_devinfo * attached)
+{
+	if ((attached->handle) &&
+	    (attached->device_info &
+	    MPI_SAS_DEVICE_INFO_END_DEVICE) &&
+	    ((attached->device_info &
+	    MPI_SAS_DEVICE_INFO_SSP_TARGET) |
+	    (attached->device_info &
+	    MPI_SAS_DEVICE_INFO_STP_TARGET) |
+	    (attached->device_info &
+	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)))
+		return 1;
+	else
+		return 0;
+}
+
 static int
 mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		u32 form, u32 form_specific)
@@ -872,7 +893,11 @@
 	SasDevicePage0_t *buffer;
 	dma_addr_t dma_handle;
 	__le64 sas_address;
-	int error;
+	int error=0;
+
+	if (ioc->sas_discovery_runtime &&
+		mptsas_is_end_device(device_info))
+			goto out;
 
 	hdr.PageVersion = MPI_SASDEVICE0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
@@ -1009,7 +1034,11 @@
 	CONFIGPARMS cfg;
 	SasExpanderPage1_t *buffer;
 	dma_addr_t dma_handle;
-	int error;
+	int error=0;
+
+	if (ioc->sas_discovery_runtime &&
+		mptsas_is_end_device(&phy_info->attached))
+			goto out;
 
 	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
@@ -1068,26 +1097,6 @@
 	return error;
 }
 
-/*
- * Returns true if there is a scsi end device
- */
-static inline int
-mptsas_is_end_device(struct mptsas_devinfo * attached)
-{
-	if ((attached->handle) &&
-	    (attached->device_info &
-	    MPI_SAS_DEVICE_INFO_END_DEVICE) &&
-	    ((attached->device_info &
-	    MPI_SAS_DEVICE_INFO_SSP_TARGET) |
-	    (attached->device_info &
-	    MPI_SAS_DEVICE_INFO_STP_TARGET) |
-	    (attached->device_info &
-	    MPI_SAS_DEVICE_INFO_SATA_DEVICE)))
-		return 1;
-	else
-		return 0;
-}
-
 static void
 mptsas_parse_device_info(struct sas_identify *identify,
 		struct mptsas_devinfo *device_info)
@@ -1737,6 +1746,9 @@
 		break;
 	case MPTSAS_ADD_DEVICE:
 
+		if (ev->phys_disk_num_valid)
+			mpt_findImVolumes(ioc);
+
 		/*
 		 * Refresh sas device pg0 data
 		 */
@@ -1868,6 +1880,9 @@
 		scsi_device_put(sdev);
 		mpt_findImVolumes(ioc);
 		break;
+	case MPTSAS_IGNORE_EVENT:
+	default:
+		break;
 	}
 
 	kfree(ev);
@@ -1940,7 +1955,8 @@
 		EVENT_DATA_RAID *raid_event_data)
 {
 	struct mptsas_hotplug_event *ev;
-	RAID_VOL0_STATUS * volumeStatus;
+	int status = le32_to_cpu(raid_event_data->SettingsStatus);
+	int state = (status >> 8) & 0xff;
 
 	if (ioc->bus_type != SAS)
 		return;
@@ -1955,6 +1971,7 @@
 	INIT_WORK(&ev->work, mptsas_hotplug_work, ev);
 	ev->ioc = ioc;
 	ev->id = raid_event_data->VolumeID;
+	ev->event_type = MPTSAS_IGNORE_EVENT;
 
 	switch (raid_event_data->ReasonCode) {
 	case MPI_EVENT_RAID_RC_PHYSDISK_DELETED:
@@ -1966,6 +1983,25 @@
 		ev->phys_disk_num = raid_event_data->PhysDiskNum;
 		ev->event_type = MPTSAS_DEL_DEVICE;
 		break;
+	case MPI_EVENT_RAID_RC_PHYSDISK_STATUS_CHANGED:
+		switch (state) {
+		case MPI_PD_STATE_ONLINE:
+			ioc->raid_data.isRaid = 1;
+			ev->phys_disk_num_valid = 1;
+			ev->phys_disk_num = raid_event_data->PhysDiskNum;
+			ev->event_type = MPTSAS_ADD_DEVICE;
+			break;
+		case MPI_PD_STATE_MISSING:
+		case MPI_PD_STATE_NOT_COMPATIBLE:
+		case MPI_PD_STATE_OFFLINE_AT_HOST_REQUEST:
+		case MPI_PD_STATE_FAILED_AT_HOST_REQUEST:
+		case MPI_PD_STATE_OFFLINE_FOR_ANOTHER_REASON:
+			ev->event_type = MPTSAS_DEL_DEVICE;
+			break;
+		default:
+			break;
+		}
+		break;
 	case MPI_EVENT_RAID_RC_VOLUME_DELETED:
 		ev->event_type = MPTSAS_DEL_RAID;
 		break;
@@ -1973,11 +2009,18 @@
 		ev->event_type = MPTSAS_ADD_RAID;
 		break;
 	case MPI_EVENT_RAID_RC_VOLUME_STATUS_CHANGED:
-		volumeStatus = (RAID_VOL0_STATUS *) &
-		    raid_event_data->SettingsStatus;
-		ev->event_type = (volumeStatus->State ==
-		    MPI_RAIDVOL0_STATUS_STATE_FAILED) ?
-		    MPTSAS_DEL_RAID : MPTSAS_ADD_RAID;
+		switch (state) {
+		case MPI_RAIDVOL0_STATUS_STATE_FAILED:
+		case MPI_RAIDVOL0_STATUS_STATE_MISSING:
+			ev->event_type = MPTSAS_DEL_RAID;
+			break;
+		case MPI_RAIDVOL0_STATUS_STATE_OPTIMAL:
+		case MPI_RAIDVOL0_STATUS_STATE_DEGRADED:
+			ev->event_type = MPTSAS_ADD_RAID;
+			break;
+		default:
+			break;
+		}
 		break;
 	default:
 		break;
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-04-21 10:47:41.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-04-21 10:53:19.000000000 -0600
@@ -877,7 +877,7 @@
 	struct scsi_cmnd *sc;
 
 	dsprintk((KERN_INFO MYNAM ": search_running target %d lun %d max %d\n",
-			vdevice->target_id, vdevice->lun, max));
+			vdevice->vtarget->target_id, vdevice->lun, max));
 
 	for (ii=0; ii < max; ii++) {
 		if ((sc = hd->ScsiLookup[ii]) != NULL) {
 
