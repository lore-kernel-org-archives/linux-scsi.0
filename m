From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/17] fnic: drivers/scsi/fnic/fnic_scsi.c: clean up
Date: Fri, 11 Jun 2010 16:44:46 -0700
Message-ID: <20100611234446.4616.94976.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952Ab0FKXoy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:54 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Abhijeet Joglekar <abjoglek@cisco.com>, Roel Kluin <roel.kluin@gmail.com>

From: Roel Kluin <roel.kluin@gmail.com>

In fnic_abort_cmd() and fnic_device_reset() assign `rport' earlier to make
FNIC_SCSI_DBG() calls cleaner.

In fnic_clean_pending_aborts() `rport' is not used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fnic/fnic_scsi.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 3cc47c6..198cbab 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1246,11 +1246,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
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
@@ -1299,7 +1298,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	 * port is up, then send abts to the remote port to terminate
 	 * the IO. Else, just locally terminate the IO in the firmware
 	 */
-	rport = starget_to_rport(scsi_target(sc->device));
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else
@@ -1418,7 +1416,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	unsigned long flags;
 	int ret = 0;
 	struct scsi_cmnd *sc;
-	struct fc_rport *rport;
 	struct scsi_lun fc_lun;
 	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1458,7 +1455,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 
 		/* Now queue the abort command to firmware */
 		int_to_scsilun(sc->device->lun, &fc_lun);
-		rport = starget_to_rport(scsi_target(sc->device));
 
 		if (fnic_queue_abort_io_req(fnic, tag,
 					    FCPIO_ITMF_ABT_TASK_TERM,
@@ -1528,18 +1524,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
 

