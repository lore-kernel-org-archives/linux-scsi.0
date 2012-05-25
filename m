From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 4/4] libfc: update fcp and exch stats
Date: Fri, 25 May 2012 10:26:54 -0700
Message-ID: <20120525172654.6980.11184.stgit@localhost6.localdomain6>
References: <20120525172638.6980.40338.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab2EYRmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 13:42:37 -0400
In-Reply-To: <20120525172638.6980.40338.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, devel@open-fcoe.org

Updates newly added stats from fc_get_host_stats,
added new function fc_exch_update_stats to
update exches related stats from fc_exch.c
by going thru internal ema_list elements.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by : Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---

 drivers/scsi/libfc/fc_exch.c  |   30 +++++++++++++++++++++++++-----
 drivers/scsi/libfc/fc_lport.c |    7 +++++++
 include/scsi/libfc.h          |    1 +
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1d0334f..10a6a2a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -99,11 +99,6 @@ struct fc_exch_mgr {
 	u16		max_xid;
 	u16		pool_max_index;
 
-	/*
-	 * currently exchange mgr stats are updated but not used.
-	 * either stats can be expose via sysfs or remove them
-	 * all together if not used XXX
-	 */
 	struct {
 		atomic_t no_free_exch;
 		atomic_t no_free_exch_xid;
@@ -2156,6 +2151,31 @@ out:
 }
 
 /**
+ * fc_exch_update_stats() - update exches stats to lport
+ * @lport: The local port to update exchange manager stats
+ */
+void fc_exch_update_stats(struct fc_lport *lport)
+{
+	struct fc_host_statistics *st;
+	struct fc_exch_mgr_anchor *ema;
+	struct fc_exch_mgr *mp;
+
+	st = &lport->host_stats;
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list) {
+		mp = ema->mp;
+		st->fc_no_free_exch += atomic_read(&mp->stats.no_free_exch);
+		st->fc_no_free_exch_xid +=
+				atomic_read(&mp->stats.no_free_exch_xid);
+		st->fc_xid_not_found += atomic_read(&mp->stats.xid_not_found);
+		st->fc_xid_busy += atomic_read(&mp->stats.xid_busy);
+		st->fc_seq_not_found += atomic_read(&mp->stats.seq_not_found);
+		st->fc_non_bls_resp += atomic_read(&mp->stats.non_bls_resp);
+	}
+}
+EXPORT_SYMBOL(fc_exch_update_stats);
+
+/**
  * fc_exch_mgr_add() - Add an exchange manager to a local port's list of EMs
  * @lport: The local port to add the exchange manager to
  * @mp:	   The exchange manager to be added to the local port
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 3e8c48d..ca278d4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -329,6 +329,9 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 		fc_stats->fcp_control_requests += stats->ControlRequests;
 		fcp_in_bytes += stats->InputBytes;
 		fcp_out_bytes += stats->OutputBytes;
+		fc_stats->fcp_packet_alloc_failures += stats->FcpPktAllocFails;
+		fc_stats->fcp_packet_aborts += stats->FcpPktAborts;
+		fc_stats->fcp_frame_alloc_failures += stats->FcpFrameAllocFails;
 		fc_stats->link_failure_count += stats->LinkFailureCount;
 	}
 	fc_stats->fcp_input_megabytes = div_u64(fcp_in_bytes, 1000000);
@@ -339,6 +342,10 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fc_stats->loss_of_signal_count = -1;
 	fc_stats->prim_seq_protocol_err_count = -1;
 	fc_stats->dumped_frames = -1;
+
+	/* update exches stats */
+	fc_exch_update_stats(lport);
+
 	return fc_stats;
 }
 EXPORT_SYMBOL(fc_get_host_stats);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f257a74..399162b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1121,6 +1121,7 @@ void fc_fill_hdr(struct fc_frame *, const struct fc_frame *,
  * EXCHANGE MANAGER LAYER
  *****************************/
 int fc_exch_init(struct fc_lport *);
+void fc_exch_update_stats(struct fc_lport *lport);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
 					   struct fc_exch_mgr *,
 					   bool (*match)(struct fc_frame *));

