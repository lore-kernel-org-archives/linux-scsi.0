From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/4] libfc: block SCSI eh thread for blocked rports
Date: Thu, 25 Aug 2011 12:40:57 -0700
Message-ID: <20110825194057.9599.20554.stgit@localhost6.localdomain6>
References: <20110825194042.9599.50292.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1HYTk6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 15:40:58 -0400
In-Reply-To: <20110825194042.9599.50292.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Call fc_block_scsi_eh() in all fcoe eh to blocks
the scsi_eh thread for blocked rports.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index afb63c8..4c41ee8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2019,6 +2019,11 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	struct fc_fcp_internal *si;
 	int rc = FAILED;
 	unsigned long flags;
+	int rval;
+
+	rval = fc_block_scsi_eh(sc_cmd);
+	if (rval)
+		return rval;
 
 	lport = shost_priv(sc_cmd->device->host);
 	if (lport->state != LPORT_ST_READY)
@@ -2068,9 +2073,9 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 	int rval;
 
-	rval = fc_remote_port_chkready(rport);
+	rval = fc_block_scsi_eh(sc_cmd);
 	if (rval)
-		goto out;
+		return rval;
 
 	lport = shost_priv(sc_cmd->device->host);
 
@@ -2116,6 +2121,8 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
 
+	fc_block_scsi_eh(sc_cmd);
+
 	lport->tt.lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,

