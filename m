From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/35] libfc: fix ddp in fc_fcp for 0 xid
Date: Fri, 11 Sep 2009 16:57:32 -0700
Message-ID: <20090911235732.27223.96560.stgit@localhost.localdomain>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56440 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbZIKX53 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:29 -0400
In-Reply-To: <20090911235655.27223.69728.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

xid 0 was used as an indication of invalid xid before but now xid 0
can be used as a valid exchange i. This patch fixes the ddp completion
in fcp layer, i.e., in fc_fcp.c:fc_fcp_ddp_done() function, to make sure it
does not use xid 0 for indication of an invalid xid, instead, it now
uses use FC_XID_UNKNOWN for such indication.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 389c9d5..aa3eafd 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -296,10 +296,13 @@ static void fc_fcp_ddp_done(struct fc_fcp_pkt *fsp)
 	if (!fsp)
 		return;
 
+	if (fsp->xfer_ddp == FC_XID_UNKNOWN)
+		return;
+
 	lp = fsp->lp;
-	if (fsp->xfer_ddp && lp->tt.ddp_done) {
+	if (lp->tt.ddp_done) {
 		fsp->xfer_len = lp->tt.ddp_done(lp, fsp->xfer_ddp);
-		fsp->xfer_ddp = 0;
+		fsp->xfer_ddp = FC_XID_UNKNOWN;
 	}
 }
 
@@ -1702,6 +1705,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	fsp->cmd = sc_cmd;	/* save the cmd */
 	fsp->lp = lp;		/* save the softc ptr */
 	fsp->rport = rport;	/* set the remote port ptr */
+	fsp->xfer_ddp = FC_XID_UNKNOWN;
 	sc_cmd->scsi_done = done;
 
 	/*

