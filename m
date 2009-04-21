From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/11] libfc: Fix compilation warnings with allmodconfig
Date: Tue, 21 Apr 2009 16:27:41 -0700
Message-ID: <20090421232741.8165.80786.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46988 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZDUX1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:50 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

When building with a .config generated from 'make allmodconfig'
some build warnings are generated. This patch corrects the warnings,
adds a FC_FID_NONE (= 0) enumeration for FC-IDs and cleans up one
variable naming to meet our variable naming conventions. For example,
fc_lport's should be named "lport," not "lp."

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_elsct.c |    2 +-
 drivers/scsi/libfc/fc_fcp.c   |    7 +++----
 drivers/scsi/libfc/fc_rport.c |    2 +-
 include/scsi/fc/fc_fs.h       |    1 +
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index dd47fe6..5878b34 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -41,7 +41,7 @@ static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
 				    void *arg, u32 timer_msec)
 {
 	enum fc_rctl r_ctl;
-	u32 did;
+	u32 did = FC_FID_NONE;
 	enum fc_fh_type fh_type;
 	int rc;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f555ae9..521f996 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -713,7 +713,7 @@ done:
 static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 {
 	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)arg;
-	struct fc_lport *lp;
+	struct fc_lport *lport = fsp->lp;
 	struct fc_frame_header *fh;
 	struct fcp_txrdy *dd;
 	u8 r_ctl;
@@ -724,9 +724,8 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 	fh = fc_frame_header_get(fp);
 	r_ctl = fh->fh_r_ctl;
-	lp = fsp->lp;
 
-	if (!(lp->state & LPORT_ST_READY))
+	if (!(lport->state & LPORT_ST_READY))
 		goto out;
 	if (fc_fcp_lock_pkt(fsp))
 		goto out;
@@ -779,7 +778,7 @@ errout:
 	if (IS_ERR(fp))
 		fc_fcp_error(fsp, fp);
 	else if (rc == -ENOMEM)
-		fc_fcp_reduce_can_queue(lp);
+		fc_fcp_reduce_can_queue(lport);
 }
 
 static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e675f5a..747d73c 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -509,7 +509,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_rport *rport = rp_arg;
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_els_flogi *plp;
+	struct fc_els_flogi *plp = NULL;
 	unsigned int tov;
 	u16 csp_seq;
 	u16 cssp_seq;
diff --git a/include/scsi/fc/fc_fs.h b/include/scsi/fc/fc_fs.h
index 1b7af3a..ac4cd38 100644
--- a/include/scsi/fc/fc_fs.h
+++ b/include/scsi/fc/fc_fs.h
@@ -149,6 +149,7 @@ enum fc_rctl {
  * Well-known fabric addresses.
  */
 enum fc_well_known_fid {
+	FC_FID_NONE =           0x000000,       /* No destination */
 	FC_FID_BCAST =		0xffffff,	/* broadcast */
 	FC_FID_FLOGI =		0xfffffe,	/* fabric login */
 	FC_FID_FCTRL =		0xfffffd,	/* fabric controller */

