From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] fnic: clean up
Date: Thu, 16 Jul 2009 13:23:26 +0200
Message-ID: <4A5F0DAE.5010800@gmail.com>
References: <4A5E4648.5020006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:36784 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZGPLVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 07:21:42 -0400
Received: by ewy26 with SMTP id 26so40264ewy.37
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 04:21:40 -0700 (PDT)
In-Reply-To: <4A5E4648.5020006@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: abjoglek@cisco.com
Cc: jeykholt@cisco.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

In fnic_abort_cmd() and  fnic_device_reset() assign `rport' earlier
to make FNIC_SCSI_DBG() calls cleaner.

In fnic_clean_pending_aborts() `rport' is not used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
thanks abhijeet, is this ackable?

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index bfc9969..c04b7e8 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1265,11 +1265,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	lp = shost_priv(sc->device->host);
 
 	fnic = lport_priv(lp);
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
-		      (starget_to_rport(scsi_target(sc->device)))->port_id,
-		      sc->device->lun, sc->request->tag);
+	rport = starget_to_rport(scsi_target(sc->device));
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Abort Cmd called FCID 0x%x, LUN 0x%x TAG %d\n",
+			rport->port_id, sc->device->lun, sc->request->tag);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
 		ret = FAILED;
@@ -1318,7 +1317,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	 * port is up, then send abts to the remote port to terminate
 	 * the IO. Else, just locally terminate the IO in the firmware
 	 */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else
@@ -1437,7 +1435,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	unsigned long flags;
 	int ret = 0;
 	struct scsi_cmnd *sc;
-	struct fc_rport *rport;
 	struct scsi_lun fc_lun;
 	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1477,7 +1474,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 
 		/* Now queue the abort command to firmware */
 		int_to_scsilun(sc->device->lun, &fc_lun);
-		rport = starget_to_rport(scsi_target(sc->device));
 
 		if (fnic_queue_abort_io_req(fnic, tag,
 					    FCPIO_ITMF_ABT_TASK_TERM,
@@ -1547,18 +1543,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	lp = shost_priv(sc->device->host);
 
 	fnic = lport_priv(lp);
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%x\n",
-		      (starget_to_rport(scsi_target(sc->device)))->port_id,
-		      sc->device->lun);
 
+	rport = starget_to_rport(scsi_target(sc->device));
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Device reset called FCID 0x%x, LUN 0x%x\n",
+			rport->port_id, sc->device->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
 
 	/* Check if remote port up */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport))
 		goto fnic_device_reset_end;
 
