From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/28] libfc: Add local port point-to-multipoint flag
Date: Tue, 20 Jul 2010 15:20:03 -0700
Message-ID: <20100720222003.17116.9373.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761863Ab0GTWUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:04 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

For VN_port to VN_port mode, the transport sets the port_id and
there's no lport FLOGI.  This is similar to FC loop mode.

Add a point_to_multipoint flag that indicates the local port is in
point-to-multipoint mode.  This skips FLOGI and discovery.
It also skips resetting the port_id on resets other than link down.

Add function fc_lport_set_local_id() that sets the local port_id.
This is called by libfcoe on behalf of the low-level driver
to set the port_id when the link comes up.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   36 +++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h          |    2 ++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 79c9e3c..f7bff2c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -755,6 +755,34 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 }
 
 /**
+ * fc_lport_set_port_id() - set the local port Port ID for point-to-multipoint
+ * @lport: The local port which will have its Port ID set.
+ * @port_id: The new port ID.
+ *
+ * Called by the lower-level driver when transport sets the local port_id.
+ * This is used in VN_port to VN_port mode for FCoE, and causes FLOGI and
+ * discovery to be skipped.
+ */
+void fc_lport_set_local_id(struct fc_lport *lport, u32 port_id)
+{
+	mutex_lock(&lport->lp_mutex);
+
+	fc_lport_set_port_id(lport, port_id, NULL);
+
+	switch (lport->state) {
+	case LPORT_ST_RESET:
+	case LPORT_ST_FLOGI:
+		if (port_id)
+			fc_lport_enter_ready(lport);
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&lport->lp_mutex);
+}
+EXPORT_SYMBOL(fc_lport_set_local_id);
+
+/**
  * fc_lport_recv_flogi_req() - Receive a FLOGI request
  * @sp_in: The sequence the FLOGI is on
  * @rx_fp: The FLOGI frame
@@ -954,7 +982,7 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
 
-	if (lport->port_id)
+	if (lport->port_id && (!lport->point_to_multipoint || !lport->link_up))
 		fc_lport_set_port_id(lport, 0, NULL);
 }
 
@@ -1536,6 +1564,12 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
 
+	if (lport->point_to_multipoint) {
+		if (lport->port_id)
+			fc_lport_enter_ready(lport);
+		return;
+	}
+
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp)
 		return fc_lport_error(lport, fp);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 5f64e59..bd05605 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -846,6 +846,7 @@ struct fc_lport {
 	u32			       lro_enabled:1;
 	u32			       does_npiv:1;
 	u32			       npiv_enabled:1;
+	u32			       point_to_multipoint:1;
 	u32			       mfs;
 	u8			       max_retry_count;
 	u8			       max_rport_retry_count;
@@ -991,6 +992,7 @@ int fc_set_mfs(struct fc_lport *, u32 mfs);
 struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
 int fc_lport_bsg_request(struct fc_bsg_job *);
+void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
 
 /*
  * REMOTE PORT LAYER

