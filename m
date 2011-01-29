From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/28] libfc: Remove usage of the Scsi_Host's host_lock
Date: Fri, 28 Jan 2011 16:04:29 -0800
Message-ID: <20110129000429.1784.71077.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14827 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1A2AEp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:45 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch removes the use of the Scsi_Host's host_lock
within fc_queuecommand. It also removes the DEF_SCSI_QCMD
usage so that libfc has fully moved on to the new
queuecommand interface.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Reviewed-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libfc/fc_fcp.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 383a982..b1b03af 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1789,15 +1789,14 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
 
 /**
  * fc_queuecommand() - The queuecommand function of the SCSI template
+ * @shost: The Scsi_Host that the command was issued to
  * @cmd:   The scsi_cmnd to be executed
- * @done:  The callback function to be called when the scsi_cmnd is complete
  *
- * This is the i/o strategy routine, called by the SCSI layer. This routine
- * is called with the host_lock held.
+ * This is the i/o strategy routine, called by the SCSI layer.
  */
-static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
+int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 {
-	struct fc_lport *lport;
+	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport_libfc_priv *rpriv;
@@ -1805,15 +1804,12 @@ static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scs
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
-	lport = shost_priv(sc_cmd->device->host);
-
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		done(sc_cmd);
+		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
-	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
@@ -1821,7 +1817,7 @@ static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scs
 		 * online
 		 */
 		sc_cmd->result = DID_IMM_RETRY << 16;
-		done(sc_cmd);
+		sc_cmd->scsi_done(sc_cmd);
 		goto out;
 	}
 
@@ -1845,7 +1841,6 @@ static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scs
 	 */
 	fsp->cmd = sc_cmd;	/* save the cmd */
 	fsp->rport = rport;	/* set the remote port ptr */
-	sc_cmd->scsi_done = done;
 
 	/*
 	 * set up the transfer length
@@ -1886,11 +1881,8 @@ static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scs
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 out:
-	spin_lock_irq(lport->host->host_lock);
 	return rc;
 }
-
-DEF_SCSI_QCMD(fc_queuecommand)
 EXPORT_SYMBOL(fc_queuecommand);
 
 /**

