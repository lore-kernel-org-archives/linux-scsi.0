From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/3] lpfc 8.1.9 : Stall eh handlers if resetting while
	rport blocked
Date: Thu, 17 Aug 2006 11:58:04 -0400
Message-ID: <1155830284.24351.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4014 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932549AbWHQP54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 11:57:56 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7HFvtC1014580
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 08:57:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Stall error handler if attempting resets/aborts while an rport is blocked.
This avoids device offline scenarios due to errors in the error handler.

Background:
  Although the transport is using the scsi_timed_out functionality to
  restart the timeout if the rport is blocked, if the timeout has already
  fired before the block occurs, the eh handler still runs and can take
  the device offline. Ultimately, this window cannot be resolved without
  significant work in the error handler thread. Christoph noted the first
  level of these issues when he noted the poor error response handling
  by the error thread.

  We found, under heavy load and error testing, that time window from when
  the scsi_times_out() adds the io to the queue to when the scsi_error_handler
  gets around to servicing it, can be in the several seconds range. In most
  cases, these test conditions are highly unusual, but possible.
  As a result, we're stalling the error handler in this race window so that
  we can avoid the device_offline transitions.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -21,6 +21,7 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -841,6 +842,21 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	return 0;
 }
 
+static void
+lpfc_block_error_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+
+	spin_lock_irq(shost->host_lock);
+	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irq(shost->host_lock);
+		msleep(1000);
+		spin_lock_irq(shost->host_lock);
+	}
+	spin_unlock_irq(shost->host_lock);
+	return;
+}
 
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
@@ -855,6 +871,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	unsigned int loop_count = 0;
 	int ret = SUCCESS;
 
+	lpfc_block_error_handler(cmnd);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
@@ -957,6 +974,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	int ret = FAILED;
 	int cnt, loopcnt;
 
+	lpfc_block_error_handler(cmnd);
 	spin_lock_irq(shost->host_lock);
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
@@ -1073,6 +1091,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	int cnt, loopcnt;
 	struct lpfc_scsi_buf * lpfc_cmd;
 
+	lpfc_block_error_handler(cmnd);
 	spin_lock_irq(shost->host_lock);
 
 	lpfc_cmd = lpfc_get_scsi_buf(phba);


