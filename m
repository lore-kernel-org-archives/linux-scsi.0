From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/28] libfc: export seq_release() for users of seq_assign()
Date: Fri, 28 Jan 2011 16:04:34 -0800
Message-ID: <20110129000434.1784.56821.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39084 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab1A2AEf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:35 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Joe Eykholt <jeykholt@cisco.com>

Target modules using lport->tt.seq_assign() get a hold on the
exchange but have no way of releasing it.  Add that.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libfc/fc_exch.c |   14 ++++++++++++++
 include/scsi/libfc.h         |    7 +++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1f124c0..a3d6402 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1282,6 +1282,8 @@ free:
  * @fp:    The request frame
  *
  * On success, the sequence pointer will be returned and also in fr_seq(@fp).
+ * A reference will be held on the exchange/sequence for the caller, which
+ * must call fc_seq_release().
  */
 static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 {
@@ -1299,6 +1301,15 @@ static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
+ * fc_seq_release() - Release the hold
+ * @sp:    The sequence.
+ */
+static void fc_seq_release(struct fc_seq *sp)
+{
+	fc_exch_release(fc_seq_exch(sp));
+}
+
+/**
  * fc_exch_recv_req() - Handler for an incoming request
  * @lport: The local port that received the request
  * @mp:	   The EM that the exchange is on
@@ -2369,6 +2380,9 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_assign)
 		lport->tt.seq_assign = fc_seq_assign;
 
+	if (!lport->tt.seq_release)
+		lport->tt.seq_release = fc_seq_release;
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_exch_init);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 79d1c76..6d64e44 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -572,6 +572,13 @@ struct libfc_function_template {
 	struct fc_seq *(*seq_assign)(struct fc_lport *, struct fc_frame *);
 
 	/*
+	 * Release the reference on the sequence returned by seq_assign().
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	void (*seq_release)(struct fc_seq *);
+
+	/*
 	 * Reset an exchange manager, completing all sequences and exchanges.
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.

