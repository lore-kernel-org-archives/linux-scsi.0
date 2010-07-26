From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/03] mptfusion: Block Error handling for deleting devices or Device in DMD
Date: Mon, 26 Jul 2010 18:56:21 +0530
Message-ID: <20100726132606.GB23066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42057 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167Ab0GZODu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 10:03:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Issue description:
In multipath topology, when device deletion is in transient state,
multipath driver can call blk_flush_queue() as part of path failure.
Before device get deleted from OS, Device may go OFFLINE as part of error
handling kicked off triggered from multipathing driver. Above condition hits
more frequently if device missing delay timer (which is LSI specific firmware
parameter) is non zero value.

root cause of this issue is Error handling thread is getting kicked off for
device which is not really present(in transient state of deleting).

This patch has solution for this issue. driver is now using eh_timed_out
callback. See below.

mptsas_transport_template->eh_timed_out = mptsas_eh_timed_out

Using mptsas_eh_timed_out function, driver can decide weather vdevice is
under Device missing delay or deleting state.

for either of those cases, there is BLK_EH_RESET_TIMER return to scsi mid
and error handling thread will not be kicked off for that particular scsi
command.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 0d149c8..7f31973 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -396,6 +396,8 @@ typedef struct _VirtTarget {
 	u8			 raidVolume;	/* set, if RAID Volume */
 	u8			 type;		/* byte 0 of Inquiry data */
 	u8			 deleted;	/* target in process of being removed */
+	u8			 inDMD;		/* currently in the device
+						   removal delay timer */
 	u32			 num_luns;
 } VirtTarget;
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f705a23..235113a 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -57,6 +57,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_sas.h>
+#include <scsi/scsi_transport.h>
 #include <scsi/scsi_dbg.h>
 
 #include "mptbase.h"
@@ -1912,6 +1913,48 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	return mptscsih_qcmd(SCpnt,done);
 }
 
+/**
+ *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
+ *		if the device under question is currently in the
+ *		device removal delay.
+ *	@sc: scsi command that the midlayer is about to time out
+ *
+ **/
+static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
+{
+	MPT_SCSI_HOST *hd;
+	MPT_ADAPTER   *ioc;
+	VirtDevice    *vdevice;
+	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
+
+	hd = shost_priv(sc->device->host);
+	if (hd == NULL) {
+		printk(KERN_ERR MYNAM ": %s: Can't locate host! (sc=%p)\n",
+		    __func__, sc);
+		goto done;
+	}
+
+	ioc = hd->ioc;
+	if (ioc->bus_type != SAS) {
+		printk(KERN_ERR MYNAM ": %s: Wrong bus type (sc=%p)\n",
+		    __func__, sc);
+		goto done;
+	}
+
+	vdevice = sc->device->hostdata;
+	if (vdevice && vdevice->vtarget && (vdevice->vtarget->inDMD
+		|| vdevice->vtarget->deleted)) {
+		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT ": %s: target removed "
+		    "or in device removal delay (sc=%p)\n",
+		    ioc->name, __func__, sc));
+		rc = BLK_EH_RESET_TIMER;
+		goto done;
+	}
+
+done:
+	return rc;
+}
+
 
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
@@ -2984,6 +3027,7 @@ static int mptsas_probe_one_phy(struct device *dev,
 	struct sas_phy *phy;
 	struct sas_port *port;
 	int error = 0;
+	VirtTarget *vtarget;
 
 	if (!dev) {
 		error = -ENODEV;
@@ -3206,6 +3250,16 @@ static int mptsas_probe_one_phy(struct device *dev,
 					rphy_to_expander_device(rphy));
 	}
 
+	/* If the device exists,verify it wasn't previously flagged
+	as a missing device.  If so, clear it */
+	vtarget = mptsas_find_vtarget(ioc,
+	    phy_info->attached.channel,
+	    phy_info->attached.id);
+	if (vtarget && vtarget->inDMD) {
+		printk(KERN_INFO "Device returned, unsetting inDMD\n");
+		vtarget->inDMD = 0;
+	}
+
  out:
 	return error;
 }
@@ -3659,9 +3713,42 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 		    MPI_SAS_IOUNIT0_RATE_FAILED_SPEED_NEGOTIATION)
 			phy_info->phy->negotiated_linkrate =
 			    SAS_LINK_RATE_FAILED;
-		else
+		else {
 			phy_info->phy->negotiated_linkrate =
 			    SAS_LINK_RATE_UNKNOWN;
+			if (ioc->device_missing_delay &&
+			    mptsas_is_end_device(&phy_info->attached)) {
+				struct scsi_device		*sdev;
+				VirtDevice			*vdevice;
+				u8	channel, id;
+				id = phy_info->attached.id;
+				channel = phy_info->attached.channel;
+				devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"Link down for fw_id %d:fw_channel %d\n",
+				    ioc->name, phy_info->attached.id,
+				    phy_info->attached.channel));
+
+				shost_for_each_device(sdev, ioc->sh) {
+					vdevice = sdev->hostdata;
+					if ((vdevice == NULL) ||
+						(vdevice->vtarget == NULL))
+						continue;
+					if ((vdevice->vtarget->tflags &
+					    MPT_TARGET_FLAGS_RAID_COMPONENT ||
+					    vdevice->vtarget->raidVolume))
+						continue;
+					if (vdevice->vtarget->id == id &&
+						vdevice->vtarget->channel ==
+						channel)
+						devtprintk(ioc,
+						printk(MYIOC_s_DEBUG_FMT
+						"SDEV OUTSTANDING CMDS"
+						"%d\n", ioc->name,
+						sdev->device_busy));
+				}
+
+			}
+		}
 	}
  out:
 	mptsas_free_fw_event(ioc, fw_event);
@@ -4906,12 +4993,47 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 	{
 		EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data =
 		    (EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *)reply->Data;
+		u16	ioc_stat;
+		ioc_stat = le16_to_cpu(reply->IOCStatus);
 
 		if (sas_event_data->ReasonCode ==
 		    MPI_EVENT_SAS_DEV_STAT_RC_NOT_RESPONDING) {
 			mptsas_target_reset_queue(ioc, sas_event_data);
 			return 0;
 		}
+		if (sas_event_data->ReasonCode ==
+			MPI_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+			ioc->device_missing_delay &&
+			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
+			VirtTarget *vtarget = NULL;
+			u8		id, channel;
+			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
+
+			id = sas_event_data->TargetID;
+			channel = sas_event_data->Bus;
+
+			vtarget = mptsas_find_vtarget(ioc, channel, id);
+			if (vtarget) {
+				devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "LogInfo (0x%x) available for "
+				   "INTERNAL_DEVICE_RESET"
+				   "fw_id %d fw_channel %d\n", ioc->name,
+				   log_info, id, channel));
+				if (vtarget->raidVolume) {
+					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"Skipping Raid Volume for inDMD\n",
+					ioc->name));
+				} else {
+					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+					"Setting device flag inDMD\n",
+					ioc->name));
+					vtarget->inDMD = 1;
+				}
+
+			}
+
+		}
+
 		break;
 	}
 	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
@@ -5244,6 +5366,7 @@ mptsas_init(void)
 	    sas_attach_transport(&mptsas_transport_functions);
 	if (!mptsas_transport_template)
 		return -ENODEV;
+	mptsas_transport_template->eh_timed_out = mptsas_eh_timed_out;
 
 	mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSAS_DRIVER);
 	mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete, MPTSAS_DRIVER);
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index dceb67a..59b8f53 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -664,6 +664,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		u32	 log_info;
 
 		status = le16_to_cpu(pScsiReply->IOCStatus) & MPI_IOCSTATUS_MASK;
+
 		scsi_state = pScsiReply->SCSIState;
 		scsi_status = pScsiReply->SCSIStatus;
 		xfer_cnt = le32_to_cpu(pScsiReply->TransferCount);
@@ -738,15 +739,36 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		case MPI_IOCSTATUS_SCSI_IOC_TERMINATED:		/* 0x004B */
 			if ( ioc->bus_type == SAS ) {
-				u16 ioc_status = le16_to_cpu(pScsiReply->IOCStatus);
-				if (ioc_status & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
-					if ((log_info & SAS_LOGINFO_MASK)
-					    == SAS_LOGINFO_NEXUS_LOSS) {
-						sc->result =
-							(DID_TRANSPORT_DISRUPTED
-							<< 16);
-						break;
-					}
+				u16 ioc_status =
+				    le16_to_cpu(pScsiReply->IOCStatus);
+				if ((ioc_status &
+					MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
+					&&
+					((log_info & SAS_LOGINFO_MASK) ==
+					SAS_LOGINFO_NEXUS_LOSS)) {
+						VirtDevice *vdevice =
+						sc->device->hostdata;
+
+					    /* flag the device as being in
+					     * device removal delay so we can
+					     * notify the midlayer to hold off
+					     * on timeout eh */
+						if (vdevice && vdevice->
+							vtarget &&
+							vdevice->vtarget->
+							raidVolume)
+							printk(KERN_INFO
+							"Skipping Raid Volume"
+							"for inDMD\n");
+						else if (vdevice &&
+							vdevice->vtarget)
+							vdevice->vtarget->
+								inDMD = 1;
+
+					    sc->result =
+						    (DID_TRANSPORT_DISRUPTED
+						    << 16);
+					    break;
 				}
 			} else if (ioc->bus_type == FC) {
 				/*
