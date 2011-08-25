From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/4] libfc: fix referencing to fc_fcp_pkt from the frame
 pointer via fr_fsp()
Date: Thu, 25 Aug 2011 12:41:03 -0700
Message-ID: <20110825194102.9599.58746.stgit@localhost6.localdomain6>
References: <20110825194042.9599.50292.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1HYTlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 15:41:04 -0400
In-Reply-To: <20110825194042.9599.50292.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

In commit 6a716a8, while releasing the DDP context in case frame_send() failed,
the frame may already be freed, so we should store the pointer to fc_fcp_pkt and
release the DDP context using the locally stored fsp instead of getting fsp from
the fr_fsp(fp) on a frame.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Reported-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 744fefe..d261e98 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1981,6 +1981,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	struct fc_exch *ep;
 	struct fc_seq *sp = NULL;
 	struct fc_frame_header *fh;
+	struct fc_fcp_pkt *fsp = NULL;
 	int rc = 1;
 
 	ep = fc_exch_alloc(lport, fp);
@@ -2003,8 +2004,10 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	fc_exch_setup_hdr(ep, fp, ep->f_ctl);
 	sp->cnt++;
 
-	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD)
+	if (ep->xid <= lport->lro_xid && fh->fh_r_ctl == FC_RCTL_DD_UNSOL_CMD) {
+		fsp = fr_fsp(fp);
 		fc_fcp_ddp_setup(fr_fsp(fp), ep->xid);
+	}
 
 	if (unlikely(lport->tt.frame_send(lport, fp)))
 		goto err;
@@ -2018,7 +2021,8 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	spin_unlock_bh(&ep->ex_lock);
 	return sp;
 err:
-	fc_fcp_ddp_done(fr_fsp(fp));
+	if (fsp)
+		fc_fcp_ddp_done(fsp);
 	rc = fc_exch_done_locked(ep);
 	spin_unlock_bh(&ep->ex_lock);
 	if (!rc)

