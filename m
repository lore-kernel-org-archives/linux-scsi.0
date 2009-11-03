From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 40/54] libfc: add set_fid function to libfc template
Date: Tue, 03 Nov 2009 11:49:05 -0800
Message-ID: <20091103194905.4085.67765.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbZKCTtA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:00 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

This is to notify the LLD when an FC_ID is assigned to the local port.

The fnic driver needs to push the assigned FC_ID to firmware.
It currently does this by intercepting the FLOGI responses, and
in order to make that code more common with FIP and NPIV, it
makes more sense to wait until the local port has completely
handled the FLOGI or FDISC response.  Also, when we fix
point-to-point FC_ID assignment, we'll need this callback as well.

Add a call to the libfc template, which is called whenever
the local port FC_ID is being assigned.  It defaults to
fc_lport_set_fid(), supplied by libfc.

As additional benefit of this function, the LLD may determine
the MAC address that caused the change by looking at the received frame.

We also print the assigned port ID as long as it isn't 0.
Setting port ID to 0 happens often in reset while retrying FLOGI,
and would be uninteresting.  This replaces the previous message
which didn't identify the host adapter instance.

patch v2 note: changed one word in a comment.  "intercepted" -> "provided".

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   34 +++++++++++++++++++++++++++-------
 include/scsi/libfc.h          |   20 ++++++++++++++++++++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 90930c4..653b52d 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -733,6 +733,27 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 }
 
 /**
+ * fc_lport_set_port_id() - set the local port Port ID
+ * @lport: The local port which will have its Port ID set.
+ * @port_id: The new port ID.
+ * @fp: The frame containing the incoming request, or NULL.
+ *
+ * Locking Note: The lport lock is expected to be held before calling
+ * this function.
+ */
+static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
+				 struct fc_frame *fp)
+{
+	if (port_id)
+		printk(KERN_INFO "host%d: Assigned Port ID %6x\n",
+		       lport->host->host_no, port_id);
+
+	fc_host_port_id(lport->host) = port_id;
+	if (lport->tt.lport_set_port_id)
+		lport->tt.lport_set_port_id(lport, port_id, fp);
+}
+
+/**
  * fc_lport_recv_flogi_req() - Receive a FLOGI request
  * @sp_in: The sequence the FLOGI is on
  * @rx_fp: The FLOGI frame
@@ -790,7 +811,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		remote_fid = FC_LOCAL_PTP_FID_HI;
 	}
 
-	fc_host_port_id(lport->host) = local_fid;
+	fc_lport_set_port_id(lport, local_fid, rx_fp);
 
 	fp = fc_frame_alloc(lport, sizeof(*flp));
 	if (fp) {
@@ -926,7 +947,9 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
-	fc_host_port_id(lport->host) = 0;
+
+	if (fc_host_port_id(lport->host))
+		fc_lport_set_port_id(lport, 0, NULL);
 }
 
 /**
@@ -1428,11 +1451,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	fh = fc_frame_header_get(fp);
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
-
-		printk(KERN_INFO "libfc: Assigned FID (%6x) in FLOGI response\n",
-		       did);
-		fc_host_port_id(lport->host) = did;
-
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
 		if (flp) {
 			mfs = ntohs(flp->fl_csp.sp_bb_data) &
@@ -1452,6 +1470,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				if (e_d_tov > lport->e_d_tov)
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
+				fc_lport_set_port_id(lport, did, fp);
 				printk(KERN_INFO "libfc: Port (%6x) entered "
 				       "point to point mode\n", did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
@@ -1464,6 +1483,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				lport->r_a_tov = r_a_tov;
 				fc_host_fabric_name(lport->host) =
 					get_unaligned_be64(&flp->fl_wwnn);
+				fc_lport_set_port_id(lport, did, fp);
 				fc_lport_enter_dns(lport);
 			}
 		}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 310d8a2..67ce9fa 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -581,6 +581,26 @@ struct libfc_function_template {
 	int (*lport_reset)(struct fc_lport *);
 
 	/*
+	 * Set the local port FC_ID.
+	 *
+	 * This may be provided by the LLD to allow it to be
+	 * notified when the local port is assigned a FC-ID.
+	 *
+	 * The frame, if non-NULL, is the incoming frame with the
+	 * FLOGI LS_ACC or FLOGI, and may contain the granted MAC
+	 * address for the LLD.  The frame pointer may be NULL if
+	 * no MAC is associated with this assignment (LOGO or PLOGI).
+	 *
+	 * If FC_ID is non-zero, r_a_tov and e_d_tov must be valid.
+	 *
+	 * Note: this is called with the local port mutex held.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	void (*lport_set_port_id)(struct fc_lport *, u32 port_id,
+				  struct fc_frame *);
+
+	/*
 	 * Create a remote port with a given port ID
 	 *
 	 * STATUS: OPTIONAL

