From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 2/9] mptfusion: sas enclosures with smart drive
Date: Tue, 11 Jul 2006 17:22:22 -0600
Message-ID: <20060711232222.GB12249@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62929 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932248AbWGKXfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:35:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Adding support for sas enclosures with smart drives.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-11 12:00:50.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 12:10:21.000000000 -0600
@@ -363,6 +363,7 @@ typedef struct _VirtDevice {
 #define MPT_TARGET_FLAGS_VALID_56	0x10
 #define MPT_TARGET_FLAGS_SAF_TE_ISSUED	0x20
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x40
+#define MPT_TARGET_FLAGS_LED_ON		0x80
 
 /*
  *	/proc/mpt interface
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-07-11 12:44:08.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-07-11 12:43:45.000000000 -0600
@@ -482,6 +482,34 @@ nextSGEset:
 	return SUCCESS;
 } /* mptscsih_AddSGE() */
 
+static void
+mptscsih_issue_sep_command(MPT_ADAPTER *ioc, VirtTarget *vtarget,
+    U32 SlotStatus)
+{
+	MPT_FRAME_HDR *mf;
+	SEPRequest_t 	 *SEPMsg;
+
+	if (ioc->bus_type == FC)
+		return;
+
+	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
+		    ioc->name,__FUNCTION__));
+		return;
+	}
+
+	SEPMsg = (SEPRequest_t *)mf;
+	SEPMsg->Function = MPI_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
+	SEPMsg->Bus = vtarget->bus_id;
+	SEPMsg->TargetID = vtarget->target_id;
+	SEPMsg->Action = MPI_SEP_REQ_ACTION_WRITE_STATUS;
+	SEPMsg->SlotStatus = SlotStatus;
+	devtverboseprintk((MYIOC_s_WARN_FMT
+	    "Sending SEP cmd=%x id=%d bus=%d\n",
+	    ioc->name, SlotStatus, SEPMsg->TargetID, SEPMsg->Bus));
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_io_done - Main SCSI IO callback routine registered to
@@ -505,6 +533,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
 	u16		 req_idx, req_idx_MR;
+	VirtDevice	 *vdev;
+	VirtTarget	 *vtarget;
 
 	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
 
@@ -625,6 +655,16 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
+
+			vdev = sc->device->hostdata;
+			if (!vdev)
+				break;
+			vtarget = vdev->vtarget;
+			if (vtarget->tflags & MPT_TARGET_FLAGS_LED_ON) {
+				mptscsih_issue_sep_command(ioc, vtarget,
+				    MPI_SEP_REQ_SLOTSTATUS_UNCONFIGURED);
+				vtarget->tflags &= ~MPT_TARGET_FLAGS_LED_ON;
+			}
 			break;
 
 		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
@@ -2386,6 +2426,13 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
 
 				ioc->eventContext++;
+				if (hd->ioc->pcidev->vendor ==
+				    PCI_VENDOR_ID_IBM) {
+					mptscsih_issue_sep_command(hd->ioc,
+					    vdev->vtarget, MPI_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
+					vdev->vtarget->tflags |=
+					    MPT_TARGET_FLAGS_LED_ON;
+				}
 			}
 		}
 	} else {
