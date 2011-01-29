From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/28] libfc: always initialize the FCoE DDP exchange id for
	fsp as FC_XID_UNKNOWN
Date: Fri, 28 Jan 2011 16:03:15 -0800
Message-ID: <20110129000315.1784.42112.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:55185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1A2ADQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:16 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The fsp's xfer_ddp is used as indication of the exchange id for the DDPed
I/O. We should always initialize it as FC_XID_UNKNOWN for a newly allocated
fsp, otherwise the fsp allocated in fc_fcp, i.e., not from queuecommand like
LUN RESET that is not doing DDP may still think DDP is setup for it since xid
0 is valid and goes on to call fc_fcp_ddp_done() in fc_fcp_resp() from
fc_tm_done(). So, set xfer_ddp as FC_XID_UNKNOWN in fc_fcp_pkt_alloc() now.

Also removes the setting of fsp->lp as it's already done when fsp is allocated.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5962d1a..21a64d4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -155,6 +155,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 	if (fsp) {
 		memset(fsp, 0, sizeof(*fsp));
 		fsp->lp = lport;
+		fsp->xfer_ddp = FC_XID_UNKNOWN;
 		atomic_set(&fsp->ref_cnt, 1);
 		init_timer(&fsp->timer);
 		INIT_LIST_HEAD(&fsp->list);
@@ -1842,9 +1843,7 @@ static int fc_queuecommand_lck(struct scsi_cmnd *sc_cmd, void (*done)(struct scs
 	 * build the libfc request pkt
 	 */
 	fsp->cmd = sc_cmd;	/* save the cmd */
-	fsp->lp = lport;	/* save the softc ptr */
 	fsp->rport = rport;	/* set the remote port ptr */
-	fsp->xfer_ddp = FC_XID_UNKNOWN;
 	sc_cmd->scsi_done = done;
 
 	/*
@@ -2112,7 +2111,6 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	 * the sc passed in is not setup for execution like when sent
 	 * through the queuecommand callout.
 	 */
-	fsp->lp = lport;	/* save the softc ptr */
 	fsp->rport = rport;	/* set the remote port ptr */
 
 	/*

