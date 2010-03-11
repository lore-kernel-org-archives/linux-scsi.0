From: akpm@linux-foundation.org
Subject: [patch 02/26] drivers/scsi/fnic/fnic_scsi.c: clean up
Date: Thu, 11 Mar 2010 14:09:34 -0800
Message-ID: <201003112209.o2BM9ZdE013602@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758349Ab0CKWJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, abjoglek@cisco.com

From: Roel Kluin <roel.kluin@gmail.com>

In fnic_abort_cmd() and fnic_device_reset() assign `rport' earlier to make
FNIC_SCSI_DBG() calls cleaner.

In fnic_clean_pending_aborts() `rport' is not used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fnic/fnic_scsi.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/fnic/fnic_scsi.c~drivers-scsi-fnic-fnic_scsic-clean-up drivers/scsi/fnic/fnic_scsi.c
--- a/drivers/scsi/fnic/fnic_scsi.c~drivers-scsi-fnic-fnic_scsic-clean-up
+++ a/drivers/scsi/fnic/fnic_scsi.c
@@ -1245,11 +1245,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
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
@@ -1298,7 +1297,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	 * port is up, then send abts to the remote port to terminate
 	 * the IO. Else, just locally terminate the IO in the firmware
 	 */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else
@@ -1417,7 +1415,6 @@ static int fnic_clean_pending_aborts(str
 	unsigned long flags;
 	int ret = 0;
 	struct scsi_cmnd *sc;
-	struct fc_rport *rport;
 	struct scsi_lun fc_lun;
 	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1457,7 +1454,6 @@ static int fnic_clean_pending_aborts(str
 
 		/* Now queue the abort command to firmware */
 		int_to_scsilun(sc->device->lun, &fc_lun);
-		rport = starget_to_rport(scsi_target(sc->device));
 
 		if (fnic_queue_abort_io_req(fnic, tag,
 					    FCPIO_ITMF_ABT_TASK_TERM,
@@ -1527,18 +1523,16 @@ int fnic_device_reset(struct scsi_cmnd *
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
 
_
