From: Robert Love <robert.w.love@intel.com>
Subject: [Open-FCoE PATCH 1/6] libfc: Pass lport in exch_mgr_reset
Date: Wed, 21 Jan 2009 12:44:44 -0800
Message-ID: <20090121204444.2468.66245.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35892 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZAUUop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 15:44:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

From: Abhijeet Joglekar <abjoglek@cisco.com>

fc_exch_mgr structure is private to fc_exch.c. To export exch_mgr_reset to
transport, transport needs access to the exch manager. Change
exch_mgr_reset to use lport param which is the shared structure between
libFC and transport.

Alternatively, fc_exch_mgr definition can be moved to libfc.h so that lport
can be accessed from mp*.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c  |    3 ++-
 drivers/scsi/libfc/fc_lport.c |    4 ++--
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 include/scsi/libfc.h          |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 66db08a..a09416f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1480,10 +1480,11 @@ static void fc_exch_reset(struct fc_exch *ep)
  * If sid is non-zero, reset only exchanges we source from that FID.
  * If did is non-zero, reset only exchanges destined to that FID.
  */
-void fc_exch_mgr_reset(struct fc_exch_mgr *mp, u32 sid, u32 did)
+void fc_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
 {
 	struct fc_exch *ep;
 	struct fc_exch *next;
+	struct fc_exch_mgr *mp = lp->emp;
 
 	spin_lock_bh(&mp->em_lock);
 restart:
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b9bdb1..5db223c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -663,7 +663,7 @@ int fc_lport_destroy(struct fc_lport *lport)
 {
 	lport->tt.frame_send = fc_frame_drop;
 	lport->tt.fcp_abort_io(lport);
-	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_destroy);
@@ -973,7 +973,7 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 
 	lport->tt.disc_stop(lport);
 
-	lport->tt.exch_mgr_reset(lport->emp, 0, 0);
+	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
 	fc_host_port_id(lport->host) = 0;
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e780d8c..dec7bae 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1285,7 +1285,7 @@ void fc_rport_terminate_io(struct fc_rport *rport)
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
-	lport->tt.exch_mgr_reset(lport->emp, 0, rport->port_id);
-	lport->tt.exch_mgr_reset(lport->emp, rport->port_id, 0);
+	lport->tt.exch_mgr_reset(lport, 0, rport->port_id);
+	lport->tt.exch_mgr_reset(lport, rport->port_id, 0);
 }
 EXPORT_SYMBOL(fc_rport_terminate_io);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9f28763..042f4ad 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -472,7 +472,7 @@ struct libfc_function_template {
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.
 	 */
-	void (*exch_mgr_reset)(struct fc_exch_mgr *,
+	void (*exch_mgr_reset)(struct fc_lport *,
 			       u32 s_id, u32 d_id);
 
 	void (*rport_flush_queue)(void);
@@ -916,7 +916,7 @@ struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
  * If s_id is non-zero, reset only exchanges originating from that FID.
  * If d_id is non-zero, reset only exchanges sending to that FID.
  */
-void fc_exch_mgr_reset(struct fc_exch_mgr *, u32 s_id, u32 d_id);
+void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 
 /*
  * Functions for fc_functions_template

