From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/4] Drivers: scsi: storvsc: Restructure error handling code on command completion
Date: Thu, 21 Feb 2013 12:04:52 -0800
Message-ID: <1361477093-17549-3-git-send-email-kys@microsoft.com>
References: <1361477060-17505-1-git-send-email-kys@microsoft.com>
 <1361477093-17549-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48824
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3BUTgR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2013 14:36:17 -0500
In-Reply-To: <1361477093-17549-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

In preparation for handling additional sense codes, restructure and cleanup
the error handling code in the command completion code path.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |  101 +++++++++++++++++++++++++------------------
 1 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2060509..16d5aac 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -761,6 +761,55 @@ cleanup:
 	return ret;
 }
 
+static void storvsc_handle_error(struct vmscsi_request *vm_srb,
+				struct scsi_cmnd *scmnd,
+				struct Scsi_Host *host,
+				u8 asc, u8 ascq)
+{
+	struct storvsc_scan_work *wrk;
+	void (*process_err_fn)(struct work_struct *work);
+	bool do_work = false;
+
+	switch (vm_srb->srb_status) {
+	case SRB_STATUS_ERROR:
+		/*
+		 * If there is an error; offline the device since all
+		 * error recovery strategies would have already been
+		 * deployed on the host side. However, if the command
+		 * were a pass-through command deal with it appropriately.
+		 */
+		switch (scmnd->cmnd[0]) {
+		case ATA_16:
+		case ATA_12:
+			set_host_byte(scmnd, DID_PASSTHROUGH);
+			break;
+		default:
+			set_host_byte(scmnd, DID_TARGET_FAILURE);
+		}
+		break;
+	case SRB_STATUS_INVALID_LUN:
+		do_work = true;
+		process_err_fn = storvsc_remove_lun;
+		break;
+	}
+	if (!do_work)
+		return;
+
+	/*
+	 * We need to schedule work to process this error; schedule it.
+	 */
+	wrk = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
+	if (!wrk) {
+		set_host_byte(scmnd, DID_TARGET_FAILURE);
+		return;
+	}
+
+	wrk->host = host;
+	wrk->lun = vm_srb->lun;
+	INIT_WORK(&wrk->work, process_err_fn);
+	schedule_work(&wrk->work);
+}
+
 
 static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 {
@@ -769,8 +818,13 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
-	struct storvsc_scan_work *wrk;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
+	struct Scsi_Host *host;
+	struct storvsc_device *stor_dev;
+	struct hv_device *dev = host_dev->dev;
+
+	stor_dev = get_in_stor_device(dev);
+	host = stor_dev->host;
 
 	vm_srb = &cmd_request->vstor_packet.vm_srb;
 	if (cmd_request->bounce_sgl_count) {
@@ -783,55 +837,18 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 					cmd_request->bounce_sgl_count);
 	}
 
-	/*
-	 * If there is an error; offline the device since all
-	 * error recovery strategies would have already been
-	 * deployed on the host side. However, if the command
-	 * were a pass-through command deal with it appropriately.
-	 */
 	scmnd->result = vm_srb->scsi_status;
 
-	if (vm_srb->srb_status == SRB_STATUS_ERROR) {
-		switch (scmnd->cmnd[0]) {
-		case ATA_16:
-		case ATA_12:
-			set_host_byte(scmnd, DID_PASSTHROUGH);
-			break;
-		default:
-			set_host_byte(scmnd, DID_TARGET_FAILURE);
-		}
-	}
-
-
-	/*
-	 * If the LUN is invalid; remove the device.
-	 */
-	if (vm_srb->srb_status == SRB_STATUS_INVALID_LUN) {
-		struct storvsc_device *stor_dev;
-		struct hv_device *dev = host_dev->dev;
-		struct Scsi_Host *host;
-
-		stor_dev = get_in_stor_device(dev);
-		host = stor_dev->host;
-
-		wrk = kmalloc(sizeof(struct storvsc_scan_work),
-				GFP_ATOMIC);
-		if (!wrk) {
-			scmnd->result = DID_TARGET_FAILURE << 16;
-		} else {
-			wrk->host = host;
-			wrk->lun = vm_srb->lun;
-			INIT_WORK(&wrk->work, storvsc_remove_lun);
-			schedule_work(&wrk->work);
-		}
-	}
-
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
 			scsi_print_sense_hdr("storvsc", &sense_hdr);
 	}
 
+	if (vm_srb->srb_status != SRB_STATUS_SUCCESS)
+		storvsc_handle_error(vm_srb, scmnd, host, sense_hdr.asc,
+					 sense_hdr.ascq);
+
 	scsi_set_resid(scmnd,
 		cmd_request->data_buffer.len -
 		vm_srb->data_transfer_length);
-- 
1.7.4.1

