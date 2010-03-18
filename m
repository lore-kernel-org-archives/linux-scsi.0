From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 07/12] mptfusion: sanity check for vdevice pointer is added
Date: Thu, 18 Mar 2010 19:22:45 +0530
Message-ID: <20100318135233.GH22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45923 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333Ab0CROXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:23:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added sanity checks before accessing vdevice and added vdevice->deleted
setting for mptfc.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index dc6b8f8..9f95201 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1329,6 +1329,8 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	if (ioc->sh) {
 		shost_for_each_device(sdev, ioc->sh) {
 			vdevice = sdev->hostdata;
+			if (vdevice == NULL || vdevice->vtarget == NULL)
+				continue;
 			if (vdevice->vtarget->tflags &
 			    MPT_TARGET_FLAGS_RAID_COMPONENT)
 				continue;
@@ -1450,6 +1452,8 @@ mptctl_gettargetinfo (unsigned long arg)
 			if (!maxWordsLeft)
 				continue;
 			vdevice = sdev->hostdata;
+			if (vdevice == NULL || vdevice->vtarget == NULL)
+				continue;
 			if (vdevice->vtarget->tflags &
 			    MPT_TARGET_FLAGS_RAID_COMPONENT)
 				continue;
@@ -1978,6 +1982,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 				struct scsi_target *starget = scsi_target(sdev);
 				VirtTarget *vtarget = starget->hostdata;
 
+				if (vtarget == NULL)
+					continue;
+
 				if ((pScsiReq->TargetID == vtarget->id) &&
 				    (pScsiReq->Bus == vtarget->channel) &&
 				    (vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 35dd8e9..de914f8 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -476,6 +476,7 @@ mptfc_register_dev(MPT_ADAPTER *ioc, int channel, FCDevicePage0_t *pg0)
 				if (vtarget) {
 					vtarget->id = pg0->CurrentTargetID;
 					vtarget->channel = pg0->CurrentBus;
+					vtarget->deleted = 0;
 				}
 			}
 			*((struct mptfc_rport_info **)rport->dd_data) = ri;
@@ -1086,6 +1087,8 @@ mptfc_setup_reset(struct work_struct *work)
 		container_of(work, MPT_ADAPTER, fc_setup_reset_work);
 	u64			pn;
 	struct mptfc_rport_info *ri;
+	struct scsi_target      *starget;
+	VirtTarget              *vtarget;
 
 	/* reset about to happen, delete (block) all rports */
 	list_for_each_entry(ri, &ioc->fc_rports, list) {
@@ -1093,6 +1096,12 @@ mptfc_setup_reset(struct work_struct *work)
 			ri->flags &= ~MPT_RPORT_INFO_FLAGS_REGISTERED;
 			fc_remote_port_delete(ri->rport);	/* won't sleep */
 			ri->rport = NULL;
+			starget = ri->starget;
+			if (starget) {
+				vtarget = starget->hostdata;
+				if (vtarget)
+					vtarget->deleted = 1;
+			}
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
@@ -1113,6 +1122,8 @@ mptfc_rescan_devices(struct work_struct *work)
 	int			ii;
 	u64			pn;
 	struct mptfc_rport_info *ri;
+	struct scsi_target      *starget;
+	VirtTarget              *vtarget;
 
 	/* start by tagging all ports as missing */
 	list_for_each_entry(ri, &ioc->fc_rports, list) {
@@ -1140,6 +1151,12 @@ mptfc_rescan_devices(struct work_struct *work)
 				       MPT_RPORT_INFO_FLAGS_MISSING);
 			fc_remote_port_delete(ri->rport);	/* won't sleep */
 			ri->rport = NULL;
+			starget = ri->starget;
+			if (starget) {
+				vtarget = starget->hostdata;
+				if (vtarget)
+					vtarget->deleted = 1;
+			}
 
 			pn = (u64)ri->pg0.WWPN.High << 32 |
 			     (u64)ri->pg0.WWPN.Low;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 04bae41..585d919 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2338,6 +2338,8 @@ mptscsih_slave_destroy(struct scsi_device *sdev)
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 	vdevice = sdev->hostdata;
+	if (!vdevice)
+		return;
 
 	mptscsih_search_running_cmds(hd, vdevice);
 	vtarget->num_luns--;
