From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 42/64] libfc: do not log off rports before or after discovery
Date: Tue, 25 Aug 2009 14:02:11 -0700
Message-ID: <20090825210211.1553.3597.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21314 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbZHYVCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:10 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When receiving an RSCN, do not log off all rports.  This is
extremely disruptive.  If, after the GPN_FT response, some
rports haven't been listed, delete them.

Add field disc_id to structs fc_rport_priv and fc_disc.
disc_id is an arbitrary serial number used to identify the
rports found by the latest discovery.  This eliminates the need
to go through the rport list when restarting discovery.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |   47 ++++++++++++++++++++++++++++++------------
 include/scsi/libfc.h         |    3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index f6762a5..ddf4944 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -221,17 +221,19 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
  */
 static void fc_disc_restart(struct fc_disc *disc)
 {
-	struct fc_rport_priv *rdata, *next;
-	struct fc_lport *lport = disc->lport;
-
 	FC_DISC_DBG(disc, "Restarting discovery\n");
 
-	list_for_each_entry_safe(rdata, next, &disc->rports, peers)
-		lport->tt.rport_logoff(rdata);
-
 	disc->requested = 1;
-	if (!disc->pending)
-		fc_disc_gpn_ft_req(disc);
+	if (disc->pending)
+		return;
+
+	/*
+	 * Advance disc_id.  This is an arbitrary non-zero number that will
+	 * match the value in the fc_rport_priv after discovery for all
+	 * freshly-discovered remote ports.  Avoid wrapping to zero.
+	 */
+	disc->disc_id = (disc->disc_id + 2) | 1;
+	fc_disc_gpn_ft_req(disc);
 }
 
 /**
@@ -278,6 +280,7 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 		}
 		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	} else {
+		disc->disc_id = (disc->disc_id + 2) | 1;
 		fc_disc_gpn_ft_req(disc);	/* get ports by FC-4 type */
 	}
 
@@ -345,13 +348,30 @@ static int fc_disc_new_target(struct fc_disc *disc,
 static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 {
 	struct fc_lport *lport = disc->lport;
+	struct fc_rport_priv *rdata;
 
 	FC_DISC_DBG(disc, "Discovery complete\n");
 
-	if (disc->requested)
-		fc_disc_gpn_ft_req(disc);
-	else
-		disc->pending = 0;
+	disc->pending = 0;
+	if (disc->requested) {
+		fc_disc_restart(disc);
+		return;
+	}
+
+	/*
+	 * Go through all remote ports.  If they were found in the latest
+	 * discovery, reverify or log them in.  Otherwise, log them out.
+	 * Skip ports which were never discovered.  These are the dNS port
+	 * and ports which were created by PLOGI.
+	 */
+	list_for_each_entry(rdata, &disc->rports, peers) {
+		if (!rdata->disc_id)
+			continue;
+		if (rdata->disc_id == disc->disc_id)
+			lport->tt.rport_login(rdata);
+		else
+			lport->tt.rport_logoff(rdata);
+	}
 
 	mutex_unlock(&disc->disc_mutex);
 	disc->disc_callback(lport, event);
@@ -496,7 +516,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		    ids.port_name != lport->wwpn) {
 			rdata = lport->tt.rport_create(lport, &ids);
 			if (rdata)
-				lport->tt.rport_login(rdata);
+				rdata->disc_id = disc->disc_id;
 			else
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
@@ -640,6 +660,7 @@ static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
 
 	rdata = lport->tt.rport_create(lport, &dp->ids);
 	if (rdata) {
+		rdata->disc_id = disc->disc_id;
 		kfree(dp);
 		lport->tt.rport_login(rdata);
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 093b043..517dce5 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -202,6 +202,7 @@ struct fc_rport_libfc_priv {
  * @ids: remote port identifiers and roles
  * @flags: REC and RETRY supported flags
  * @max_seq: maximum number of concurrent sequences
+ * @disc_id: discovery identifier
  * @maxframe_size: maximum frame size
  * @retries: retry count in current state
  * @e_d_tov: error detect timeout value (in msec)
@@ -218,6 +219,7 @@ struct fc_rport_priv {
 	struct fc_rport_identifiers ids;
 	u16			   flags;
 	u16		           max_seq;
+	u16			   disc_id;
 	u16			   maxframe_size;
 	unsigned int	           retries;
 	unsigned int	           e_d_tov;
@@ -678,6 +680,7 @@ struct fc_disc {
 	unsigned char		requested;
 	unsigned short		seq_count;
 	unsigned char		buf_len;
+	u16			disc_id;
 
 	void (*disc_callback)(struct fc_lport *,
 			      enum fc_disc_event);

