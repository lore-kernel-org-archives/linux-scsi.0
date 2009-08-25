From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 34/64] libfc: eliminate disc->event
Date: Tue, 25 Aug 2009 14:01:29 -0700
Message-ID: <20090825210128.1553.13915.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbZHYVB2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:28 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

There was no need to have the discovery status stored in struct fc_disc.

Change fc_disc_done() to take the discovery status as an argument
and just pass it on to the discovery callback.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |   31 ++++++++++++-------------------
 include/scsi/libfc.h         |    1 -
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index bbea41e..736f917 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -49,7 +49,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport_priv *,
 			      struct fc_rport_identifiers *);
-static void fc_disc_done(struct fc_disc *);
+static void fc_disc_done(struct fc_disc *, enum fc_disc_event);
 static void fc_disc_timeout(struct work_struct *);
 static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
 static void fc_disc_restart(struct fc_disc *);
@@ -329,8 +329,7 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
 	if (rdata) {
 		kref_get(&rdata->kref);
 		if (!fc_disc_new_target(disc, rdata, &rdata->ids)) {
-			disc->event = DISC_EV_SUCCESS;
-			fc_disc_done(disc);
+			fc_disc_done(disc, DISC_EV_SUCCESS);
 		}
 		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	} else {
@@ -404,20 +403,18 @@ static int fc_disc_new_target(struct fc_disc *disc,
 /**
  * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
+ * @event: discovery completion status
+ *
  * Locking Note: This function expects that the disc mutex is locked before
  * it is called. The discovery callback is then made with the lock released,
  * and the lock is re-taken before returning from this function
  */
-static void fc_disc_done(struct fc_disc *disc)
+static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 {
 	struct fc_lport *lport = disc->lport;
-	enum fc_disc_event event;
 
 	FC_DISC_DBG(disc, "Discovery complete\n");
 
-	event = disc->event;
-	disc->event = DISC_EV_NONE;
-
 	if (disc->requested)
 		fc_disc_gpn_ft_req(disc);
 	else
@@ -460,11 +457,8 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 			}
 			disc->retry_count++;
 			schedule_delayed_work(&disc->disc_work, delay);
-		} else {
-			/* exceeded retries */
-			disc->event = DISC_EV_FAILED;
-			fc_disc_done(disc);
-		}
+		} else
+			fc_disc_done(disc, DISC_EV_FAILED);
 	}
 }
 
@@ -503,10 +497,12 @@ err:
 }
 
 /**
- * fc_disc_gpn_ft_parse() - Parse the list of IDs and names resulting from a request
+ * fc_disc_gpn_ft_parse() - Parse the body of the dNS GPN_FT response.
  * @lport: Fibre Channel host port instance
  * @buf: GPN_FT response buffer
  * @len: size of response buffer
+ *
+ * Goes through the list of IDs and names resulting from a request.
  */
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 {
@@ -577,8 +573,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
-			disc->event = DISC_EV_SUCCESS;
-			fc_disc_done(disc);
+			fc_disc_done(disc, DISC_EV_SUCCESS);
 			len = 0;
 			break;
 		}
@@ -669,8 +664,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			FC_DISC_DBG(disc, "GPN_FT rejected reason %x exp %x "
 				    "(check zoning)\n", cp->ct_reason,
 				    cp->ct_explan);
-			disc->event = DISC_EV_FAILED;
-			fc_disc_done(disc);
+			fc_disc_done(disc, DISC_EV_FAILED);
 		} else {
 			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
 				    "%x\n", ntohs(cp->ct_cmd));
@@ -782,7 +776,6 @@ int fc_disc_init(struct fc_lport *lport)
 
 	disc->lport = lport;
 	disc->delay = FC_DISC_DELAY;
-	disc->event = DISC_EV_NONE;
 
 	return 0;
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index bf4b1c2..f3f320f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -679,7 +679,6 @@ struct fc_disc {
 	unsigned char		requested;
 	unsigned short		seq_count;
 	unsigned char		buf_len;
-	enum fc_disc_event	event;
 
 	void (*disc_callback)(struct fc_lport *,
 			      enum fc_disc_event);

