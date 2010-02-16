From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/9] libfc: call ddp setup for only FCP reads to avoid
	accessing junk fsp pointer
Date: Tue, 16 Feb 2010 12:15:18 -0800
Message-ID: <20100216201518.26581.63877.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21251 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab0BPUPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:15:19 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Adds check to call fc_fcp_ddp_setup for only FCP read cmds to avoid
accessing junk fsp pointer at least in ESX since non FCP frame had
junk fsp value, though fsp is implicitly initialized to null
by __alloc_skb but with this patch no more relying on fsp
initialized to null value and hitting junk fsp ptr access.

Removes fsp pointer checking in fc_fcp_ddp_setup as this is not
needed any more since its only caller for FCP read will always
have a valid fsp.

Reported by: Frank Zhang <frank_1.zhang@intel.com>
Reported by: Rob Love <robert.w.love@intel.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 drivers/scsi/libfc/fc_fcp.c  |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 19d711c..7f43647 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1890,7 +1890,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
 	sp->cnt++;
 
-	if (ep->xid <= lport->lro_xid)
+	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD)
 		fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
 
 	if (unlikely(lport->tt.frame_send(lport, fp)))
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 881d5df..6fde2fa 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -298,9 +298,6 @@ void fc_fcp_ddp_setup(struct fc_fcp_pkt *fsp, u16 xid)
 {
 	struct fc_lport *lport;
 
-	if (!fsp)
-		return;
-
 	lport = fsp->lp;
 	if ((fsp->req_flags & FC_SRB_READ) &&
 	    (lport->lro_enabled) && (lport->tt.ddp_setup)) {

