From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/20] libfc: Replace ->lport_recv with function call
Date: Tue, 18 Oct 2016 10:01:37 +0200
Message-ID: <1476777714-3543-4-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbcJRIC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:26 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->lport_recv callback only ever had one implementation,
so call the function directly and remove the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c  | 4 ++--
 drivers/scsi/libfc/fc_lport.c | 9 +++------
 include/scsi/libfc.h          | 8 +-------
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 3f58aeb..cc320a9 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1527,7 +1527,7 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 	 * The upper-level protocol may request one later, if needed.
 	 */
 	if (fh->fh_rx_id == htons(FC_XID_UNKNOWN))
-		return lport->tt.lport_recv(lport, fp);
+		return fc_lport_recv(lport, fp);
 
 	reject = fc_seq_lookup_recip(lport, mp, fp);
 	if (reject == FC_RJT_NONE) {
@@ -1548,7 +1548,7 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 		 * first.
 		 */
 		if (!fc_invoke_resp(ep, sp, fp))
-			lport->tt.lport_recv(lport, fp);
+			fc_lport_recv(lport, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
 		FC_LPORT_DBG(lport, "exch/seq lookup failed: reject %x\n",
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 05f83a6..42dcb72 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -944,15 +944,14 @@ struct fc4_prov fc_lport_els_prov = {
 };
 
 /**
- * fc_lport_recv_req() - The generic lport request handler
+ * fc_lport_recv() - The generic lport request handler
  * @lport: The lport that received the request
  * @fp: The frame the request is in
  *
  * Locking Note: This function should not be called with the lport
  *		 lock held because it may grab the lock.
  */
-static void fc_lport_recv_req(struct fc_lport *lport,
-			      struct fc_frame *fp)
+void fc_lport_recv(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_seq *sp = fr_seq(fp);
@@ -983,6 +982,7 @@ static void fc_lport_recv_req(struct fc_lport *lport,
 	if (sp)
 		lport->tt.exch_done(sp);
 }
+EXPORT_SYMBOL(fc_lport_recv);
 
 /**
  * fc_lport_reset() - Reset a local port
@@ -1865,9 +1865,6 @@ int fc_lport_config(struct fc_lport *lport)
  */
 int fc_lport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.lport_recv)
-		lport->tt.lport_recv = fc_lport_recv_req;
-
 	fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
 	fc_host_node_name(lport->host) = lport->wwnn;
 	fc_host_port_name(lport->host) = lport->wwpn;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7ee0d27..7bba81e 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -621,13 +621,6 @@ struct libfc_function_template {
 	void (*rport_flush_queue)(void);
 
 	/*
-	 * Receive a frame for a local port.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*lport_recv)(struct fc_lport *, struct fc_frame *);
-
-	/*
 	 * Set the local port FC_ID.
 	 *
 	 * This may be provided by the LLD to allow it to be
@@ -1060,6 +1053,7 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
 void fc_vports_linkchange(struct fc_lport *);
 int fc_lport_config(struct fc_lport *);
 int fc_lport_reset(struct fc_lport *);
+void fc_lport_recv(struct fc_lport *lport, struct fc_frame *fp);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
 struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
-- 
1.8.5.6

