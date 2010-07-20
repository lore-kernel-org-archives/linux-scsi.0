From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 23/28] libfc: add interface to allocate a sequence for
	incoming requests
Date: Tue, 20 Jul 2010 15:21:07 -0700
Message-ID: <20100720222107.17116.68176.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47552 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824Ab0GTWVH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:07 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

For incoming ELS and FCP requests, we often don't require an
exchange and sequence, however, sometimes we do.  For those cases,
(primarily FCP requests for targets) add a function to set up
the exchange and sequence.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   25 +++++++++++++++++++++++++
 include/scsi/libfc.h         |    7 +++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 61eabd3..027042a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1231,6 +1231,28 @@ free:
 }
 
 /**
+ * fc_seq_assign() - Assign exchange and sequence for incoming request
+ * @lport: The local port that received the request
+ * @fp:    The request frame
+ *
+ * On success, the sequence pointer will be returned and also in fr_seq(@fp).
+ */
+static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_exch_mgr_anchor *ema;
+
+	WARN_ON(lport != fr_dev(fp));
+	WARN_ON(fr_seq(fp));
+	fr_seq(fp) = NULL;
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list)
+		if ((!ema->match || ema->match(fp)) &&
+		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
+			break;
+	return fr_seq(fp);
+}
+
+/**
  * fc_exch_recv_req() - Handler for an incoming request where is other
  *			end is originating the sequence
  * @lport: The local port that received the request
@@ -2283,6 +2305,9 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_exch_abort)
 		lport->tt.seq_exch_abort = fc_seq_exch_abort;
 
+	if (!lport->tt.seq_assign)
+		lport->tt.seq_assign = fc_seq_assign;
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_exch_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a6414ec..605f1d7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -556,6 +556,13 @@ struct libfc_function_template {
 	struct fc_seq *(*seq_start_next)(struct fc_seq *);
 
 	/*
+	 * Assign a sequence for an incoming request frame.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	struct fc_seq *(*seq_assign)(struct fc_lport *, struct fc_frame *);
+
+	/*
 	 * Reset an exchange manager, completing all sequences and exchanges.
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.

