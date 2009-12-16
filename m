From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/5] mptfusion: block device when target is being removed by FW
Date: Wed, 16 Dec 2009 19:02:29 +0530
Message-ID: <20091216133221.GP31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58221 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932797AbZLPN74 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:59:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Add support to set the sdev state to SDEV_BLOCK during device removal
to stop IOs comming to the deleting driver immediately.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 1b7f550..c20bbe4 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1075,6 +1075,19 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	return 0;
 }
 
+static void
+mptsas_block_io_sdev(struct scsi_device *sdev, void *data)
+{
+	scsi_device_set_state(sdev, SDEV_BLOCK);
+}
+
+static void
+mptsas_block_io_starget(struct scsi_target *starget)
+{
+	if (starget)
+		starget_for_each_device(starget, NULL, mptsas_block_io_sdev);
+}
+
 /**
  * mptsas_target_reset_queue
  *
@@ -1098,10 +1111,11 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 	id = sas_event_data->TargetID;
 	channel = sas_event_data->Bus;
 
-	if (!(vtarget = mptsas_find_vtarget(ioc, channel, id)))
-		return;
-
-	vtarget->deleted = 1; /* block IO */
+	vtarget = mptsas_find_vtarget(ioc, channel, id);
+	if (vtarget) {
+		mptsas_block_io_starget(vtarget->starget);
+		vtarget->deleted = 1; /* block IO */
+	}
 
 	target_reset_list = kzalloc(sizeof(struct mptsas_target_reset_event),
 	    GFP_ATOMIC);
@@ -1868,7 +1882,8 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (ioc->sas_discovery_quiesce_io)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-//	scsi_print_command(SCpnt);
+	if (ioc->debug_level & MPT_DEBUG_SCSI)
+		scsi_print_command(SCpnt);
 
 	return mptscsih_qcmd(SCpnt,done);
 }
