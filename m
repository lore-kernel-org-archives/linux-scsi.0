From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/8] libfc: release DDP context if frame_send() fails
Date: Mon, 16 May 2011 16:45:40 -0700
Message-ID: <20110516234540.24502.70401.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1EPXpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:40 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

In case frame_send() fails, make sure to let the underlying HW release the DDP
context that has already been set up before calling frame_send().

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c  |    1 +
 drivers/scsi/libfc/fc_fcp.c   |    2 +-
 drivers/scsi/libfc/fc_libfc.h |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 77035a7..4d2994d 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1978,6 +1978,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	spin_unlock_bh(&ep->ex_lock);
 	return sp;
 err:
+	fc_fcp_ddp_done(fr_fsp(fp));
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 2a3a472..f880d40 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -312,7 +312,7 @@ void fc_fcp_ddp_setup(struct fc_fcp_pkt *fsp, u16 xid)
  *		       DDP related resources for a fcp_pkt
  * @fsp: The FCP packet that DDP had been used on
  */
-static void fc_fcp_ddp_done(struct fc_fcp_pkt *fsp)
+void fc_fcp_ddp_done(struct fc_fcp_pkt *fsp)
 {
 	struct fc_lport *lport;
 
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index fedc819..c7d0712 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -108,6 +108,7 @@ extern struct fc4_prov fc_rport_fcp_init;	/* FCP initiator provider */
  * Set up direct-data placement for this I/O request
  */
 void fc_fcp_ddp_setup(struct fc_fcp_pkt *fsp, u16 xid);
+void fc_fcp_ddp_done(struct fc_fcp_pkt *fsp);
 
 /*
  * Module setup functions

