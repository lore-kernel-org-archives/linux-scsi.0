From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libfc: call fc_remote_port_chkready under the host lock.
Date: Mon,  2 Aug 2010 16:02:24 -0500
Message-ID: <1280782944-22078-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0HBU6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 16:58:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com, devel@open-fcoe.org, Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The rport port state and flags are set under the host lock,
so this patch calls fc_remote_port_chkready with the host lock
held like is also done in the other fc drivers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_fcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index eac4d09..c797f6b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1765,14 +1765,14 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	struct fcoe_dev_stats *stats;
 
 	lport = shost_priv(sc_cmd->device->host);
-	spin_unlock_irq(lport->host->host_lock);
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
 		done(sc_cmd);
-		goto out;
+		return 0;
 	}
+	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
-- 
1.6.6.1

