From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 5/7] libfc: hook scsi eh into fc_block_scsi_eh
Date: Thu, 23 Sep 2010 00:17:23 -0500
Message-ID: <1285219045-14645-6-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:48 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch just has libfc scsi eh callbacks call
fc_block_scsi_eh like other FC drivers

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_fcp.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..61e7045 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1997,8 +1997,13 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 {
 	struct fc_fcp_pkt *fsp;
 	struct fc_lport *lport;
-	int rc = FAILED;
 	unsigned long flags;
+	int rc;
+
+	rc = fc_block_scsi_eh(sc_cmd);
+	if (rc)
+		return rc;
+	rc = FAILED;
 
 	lport = shost_priv(sc_cmd->device->host);
 	if (lport->state != LPORT_ST_READY)
@@ -2044,12 +2049,15 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lport;
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
-	int rc = FAILED;
-	int rval;
+	int rc;
 
-	rval = fc_remote_port_chkready(rport);
-	if (rval)
-		goto out;
+	rc = fc_block_scsi_eh(sc_cmd);
+	if (rc)
+		return rc;
+	rc = FAILED;
+
+	if (fc_remote_port_chkready(rport))
+		return rc;
 
 	lport = shost_priv(sc_cmd->device->host);
 
@@ -2093,9 +2101,14 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 	struct Scsi_Host *shost = sc_cmd->device->host;
 	struct fc_lport *lport = shost_priv(shost);
 	unsigned long wait_tmo;
+	int rc;
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
 
+	rc = fc_block_scsi_eh(sc_cmd);
+	if (rc)
+		return rc;
+
 	lport->tt.lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,
-- 
1.7.2.2

