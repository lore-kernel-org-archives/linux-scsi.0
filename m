From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/15] libfc: Convert debug statements in fc_exch.c to use new
	libfc debug macros.
Date: Fri, 03 Apr 2009 14:59:15 -0700
Message-ID: <20090403215915.10856.39708.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936823AbZDCV7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:59:24 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert debug statements in fc_exch.c to use new libfc
debug macros.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   58 ++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 992af05..3b82591 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -32,18 +32,7 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-/*
- * fc_exch_debug can be set in debugger or at compile time to get more logs.
- */
-static int fc_exch_debug;
-
-#define FC_DEBUG_EXCH(fmt...)			\
-	do {					\
-		if (fc_exch_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
-static struct kmem_cache *fc_em_cachep;	/* cache for exchanges */
+static struct kmem_cache *fc_em_cachep;        /* cache for exchanges */
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -333,8 +322,8 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
 		return;
 
-	FC_DEBUG_EXCH("Exchange (%4x) timed out, notifying the upper layer\n",
-		      ep->xid);
+	FC_EXCH_DBG(ep, "Exchange timed out, notifying the upper layer\n");
+
 	if (schedule_delayed_work(&ep->timeout_work,
 				  msecs_to_jiffies(timer_msec)))
 		fc_exch_hold(ep);		/* hold for timer */
@@ -545,7 +534,7 @@ struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
 		/* alloc a new xid */
 		xid = fc_em_alloc_xid(mp, fp);
 		if (!xid) {
-			printk(KERN_ERR "fc_em_alloc_xid() failed\n");
+			printk(KERN_WARNING "libfc: Failed to allocate an exhange\n");
 			goto err;
 		}
 	}
@@ -820,8 +809,8 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp)
 	struct fc_exch *ep = fc_seq_exch(sp);
 
 	sp = fc_seq_alloc(ep, ep->seq_id++);
-	FC_DEBUG_EXCH("exch %4x f_ctl %6x seq %2x\n",
-		      ep->xid, ep->f_ctl, sp->id);
+	FC_EXCH_DBG(ep, "f_ctl %6x seq %2x\n",
+		    ep->f_ctl, sp->id);
 	return sp;
 }
 /*
@@ -901,7 +890,7 @@ void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
 		fc_exch_els_rec(sp, els_data->fp);
 		break;
 	default:
-		FC_DBG("Invalid ELS CMD:%x\n", els_cmd);
+		FC_EXCH_DBG(fc_seq_exch(sp), "Invalid ELS CMD:%x\n", els_cmd);
 	}
 }
 EXPORT_SYMBOL(fc_seq_els_rsp_send);
@@ -1134,7 +1123,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			lp->tt.lport_recv(lp, sp, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
-		FC_DEBUG_EXCH("exch/seq lookup failed: reject %x\n", reject);
+		FC_EM_DBG(mp, "exch/seq lookup failed: reject %x\n", reject);
 		fc_frame_free(fp);
 	}
 }
@@ -1238,10 +1227,10 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
 	if (!sp) {
 		atomic_inc(&mp->stats.xid_not_found);
-		FC_DEBUG_EXCH("seq lookup failed\n");
+		FC_EM_DBG(mp, "seq lookup failed\n");
 	} else {
 		atomic_inc(&mp->stats.non_bls_resp);
-		FC_DEBUG_EXCH("non-BLS response to sequence");
+		FC_EM_DBG(mp, "non-BLS response to sequence");
 	}
 	fc_frame_free(fp);
 }
@@ -1262,8 +1251,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	int rc = 1, has_rec = 0;
 
 	fh = fc_frame_header_get(fp);
-	FC_DEBUG_EXCH("exch: BLS rctl %x - %s\n",
-		      fh->fh_r_ctl, fc_exch_rctl_name(fh->fh_r_ctl));
+	FC_EXCH_DBG(ep, "exch: BLS rctl %x - %s\n", fh->fh_r_ctl,
+		    fc_exch_rctl_name(fh->fh_r_ctl));
 
 	if (cancel_delayed_work_sync(&ep->timeout_work))
 		fc_exch_release(ep);	/* release from pending timer hold */
@@ -1355,9 +1344,9 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		case FC_RCTL_ACK_0:
 			break;
 		default:
-			FC_DEBUG_EXCH("BLS rctl %x - %s received",
-				      fh->fh_r_ctl,
-				      fc_exch_rctl_name(fh->fh_r_ctl));
+			FC_EXCH_DBG(ep, "BLS rctl %x - %s received",
+				    fh->fh_r_ctl,
+				    fc_exch_rctl_name(fh->fh_r_ctl));
 			break;
 		}
 		fc_frame_free(fp);
@@ -1595,7 +1584,8 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
 			goto cleanup;
-		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
+		FC_EXCH_DBG(aborted_ep, "Cannot process RRQ, "
+			    "frame error %d\n", err);
 		return;
 	}
 
@@ -1604,12 +1594,13 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 	switch (op) {
 	case ELS_LS_RJT:
-		FC_DBG("LS_RJT for RRQ");
+		FC_EXCH_DBG(aborted_ep, "LS_RJT for RRQ");
 		/* fall through */
 	case ELS_LS_ACC:
 		goto cleanup;
 	default:
-		FC_DBG("unexpected response op %x for RRQ", op);
+		FC_EXCH_DBG(aborted_ep, "unexpected response op %x "
+			    "for RRQ", op);
 		return;
 	}
 
@@ -1736,8 +1727,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	size_t len;
 
 	if (max_xid <= min_xid || min_xid == 0 || max_xid == FC_XID_UNKNOWN) {
-		FC_DBG("Invalid min_xid 0x:%x and max_xid 0x:%x\n",
-		       min_xid, max_xid);
+		FC_LPORT_DBG(lp, "Invalid min_xid 0x:%x and max_xid 0x:%x\n",
+			     min_xid, max_xid);
 		return NULL;
 	}
 
@@ -1874,7 +1865,8 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 
 	/* lport lock ? */
 	if (!lp || !mp || (lp->state == LPORT_ST_NONE)) {
-		FC_DBG("fc_lport or EM is not allocated and configured");
+		FC_LPORT_DBG(lp, "Receiving frames for an lport that "
+			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
 		return;
 	}
@@ -1900,7 +1892,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			fc_exch_recv_req(lp, mp, fp);
 		break;
 	default:
-		FC_DBG("dropping invalid frame (eof %x)", fr_eof(fp));
+		FC_EM_DBG(mp, "dropping invalid frame (eof %x)", fr_eof(fp));
 		fc_frame_free(fp);
 		break;
 	}

