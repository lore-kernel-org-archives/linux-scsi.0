From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/28] libfc: add method for setting handler for incoming
	exchange
Date: Fri, 28 Jan 2011 16:04:08 -0800
Message-ID: <20110129000408.1784.69975.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24267 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab1A2AEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:09 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Add a method for setting handler for incoming exchange.
For multi-sequence exchanges, this allows the target driver
to add a response handler for handling subsequent sequences,
and exchange manager resets.

The new function is called fc_seq_set_resp().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   19 +++++++++++++++++++
 include/scsi/libfc.h         |   10 ++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index e0b5b15..1f124c0 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -558,6 +558,22 @@ static struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
 	return sp;
 }
 
+/*
+ * Set the response handler for the exchange associated with a sequence.
+ */
+static void fc_seq_set_resp(struct fc_seq *sp,
+			    void (*resp)(struct fc_seq *, struct fc_frame *,
+					 void *),
+			    void *arg)
+{
+	struct fc_exch *ep = fc_seq_exch(sp);
+
+	spin_lock_bh(&ep->ex_lock);
+	ep->resp = resp;
+	ep->arg = arg;
+	spin_unlock_bh(&ep->ex_lock);
+}
+
 /**
  * fc_seq_exch_abort() - Abort an exchange and sequence
  * @req_sp:	The sequence to be aborted
@@ -2329,6 +2345,9 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_start_next)
 		lport->tt.seq_start_next = fc_seq_start_next;
 
+	if (!lport->tt.seq_set_resp)
+		lport->tt.seq_set_resp = fc_seq_set_resp;
+
 	if (!lport->tt.exch_seq_send)
 		lport->tt.exch_seq_send = fc_exch_seq_send;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 3ae2a76..3b8f5d8 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -555,6 +555,16 @@ struct libfc_function_template {
 	struct fc_seq *(*seq_start_next)(struct fc_seq *);
 
 	/*
+	 * Set a response handler for the exchange of the sequence.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	void (*seq_set_resp)(struct fc_seq *sp,
+			     void (*resp)(struct fc_seq *, struct fc_frame *,
+					  void *),
+			     void *arg);
+
+	/*
 	 * Assign a sequence for an incoming request frame.
 	 *
 	 * STATUS: OPTIONAL

