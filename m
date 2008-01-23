From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/10] [FCoE] Changing all ASSERT_NOTIMPL to WARN_ON(1)
Date: Tue, 22 Jan 2008 16:35:39 -0800
Message-ID: <20080123003538.8469.24974.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36448 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbYAWAta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:49:30 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Trigger the warning every time the block is encountered.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/libfc/fc_exch.c       |   11 +----------
 drivers/scsi/ofc/libfc/fc_frame.c      |    2 +-
 drivers/scsi/ofc/libfc/fc_local_port.c |    2 +-
 drivers/scsi/ofc/openfc/openfc_scsi.c  |    4 ++--
 4 files changed, 5 insertions(+), 14 deletions(-)


diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index 4a19936..9a5cd98 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -203,14 +203,6 @@ static int fc_exch_mgr_init(struct fc_exch_mgr *mp, enum fc_class class,
 	u_int pool_count;
 	u_int cpu;
 
-	/*
-	 * Check to make sure the declaration of ESB and SSB structures came out
-	 * with the right size and no unexpected padding.
-	 */
-	ASSERT_NOTIMPL(sizeof(struct fc_esb) == FC_ESB_SIZE);
-	ASSERT_NOTIMPL(sizeof(struct fc_ssb) == FC_SSB_SIZE);
-	ASSERT_NOTIMPL(sizeof(struct fc_frame_header) == FC_FRAME_HEADER_LEN);
-
 	mp->em_class = class;
 
 	/*
@@ -562,7 +554,6 @@ static struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp)
 
 	spin_lock_bh(&pp->emp_lock);
 	if (list_empty(&pp->emp_exch_free)) {
-		ASSERT_NOTIMPL(ep);	/* not generally handled */
 		atomic_inc(&mp->em_stats.ems_error_no_free_exch);
 		spin_unlock_bh(&pp->emp_lock);
 	} else {
@@ -1144,7 +1135,7 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 	 */
 	if (fc_sof_needs_ack(rx_fp->fr_sof)) {
 		fp = fc_frame_alloc(fc_seq_exch(sp)->ex_port, 0);
-		ASSERT_NOTIMPL(fp);
+		BUG_ON(!fp);
 		if (!fp)
 			return;
 		fc_seq_fill_hdr(sp, fp);
diff --git a/drivers/scsi/ofc/libfc/fc_frame.c b/drivers/scsi/ofc/libfc/fc_frame.c
index 056df3d..c609ebd 100644
--- a/drivers/scsi/ofc/libfc/fc_frame.c
+++ b/drivers/scsi/ofc/libfc/fc_frame.c
@@ -44,7 +44,7 @@ u_int32_t fc_frame_crc_check(struct fc_frame *fp)
 	const u_int8_t *bp;
 	u_int len;
 
-	ASSERT_NOTIMPL(fc_frame_is_linear(fp));
+	WARN_ON(!fc_frame_is_linear(fp));
 	fp->fr_flags &= ~FCPHF_CRC_UNCHECKED;
 	len = (fp->fr_len + 3) & ~3;	/* round up length to include fill */
 	bp = (const u_int8_t *)fp->fr_hdr;
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 311b5e9..cd70c74 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -1329,7 +1329,7 @@ static void fc_local_port_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			if (fc_local_port_debug)
 				OFC_DBG("RSCN received: rediscovering");
 			error = fc_disc_targ_restart(lp);
-			ASSERT_NOTIMPL(error == 0);
+			WARN_ON(error != 0);
 		} else if (fc_local_port_debug) {
 			OFC_DBG("RSCN received: not rediscovering. "
 			       "redisc %d state %d disc_cb %p in_prog %d",
diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index cd3afb7..9c7f9bb 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -309,7 +309,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 							 tlen);
 				data = (void *)(fp->fr_hdr + 1);
 			}
-			ASSERT_NOTIMPL(fp != NULL);	/* XXX */
+			BUG_ON(!fp);
 			fc_frame_setup(fp, FC_RCTL_DD_SOL_DATA, FC_TYPE_FCP);
 			fc_frame_set_offset(fp, frame_offset);
 		}
@@ -442,7 +442,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		 */
 		ASSERT(!(fp->fr_flags & FCPHF_CRC_UNCHECKED));
 		dd = fc_frame_payload_get(fp, sizeof(*dd));
-		ASSERT_NOTIMPL(dd != NULL);
+		WARN_ON(!dd);
 		fsp->state = OPENFC_SRB_IN_DATA_TRANS;
 
 		/*

