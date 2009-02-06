From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/17] libfc: Logging review changes
Date: Fri, 06 Feb 2009 10:56:43 -0800
Message-ID: <20090206185643.26188.15541.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZBFS4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:44 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

1) Rename FC_DEBUG_* to FC_*_DBG
   - Most of our functions in libfc are named fc_<component>_<action>().
     for example fc_rport_recv_plogi_resp(). Also converting DEBUG to
     DBG saves a little bit of space on the line.

2) Convert all FC_DBG() calls to FC_*_DBG() calls
   - There's no need for the FC_DBG macro with the new runtime tunable
     debug macros.

3) Remove FC_DBG definition

4) Removed a "list_del" debug statement that wasn't useful

5) Converted one FC_*_DBG to a printk when we receive a FLOGI from port
   with same WWPN as our lport.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   82 +++++++++++------------
 drivers/scsi/libfc/fc_exch.c  |   41 ++++++-----
 drivers/scsi/libfc/fc_fcp.c   |   77 +++++++++++----------
 drivers/scsi/libfc/fc_lport.c |  147 +++++++++++++++++++++--------------------
 drivers/scsi/libfc/fc_rport.c |  112 ++++++++++++++++---------------
 include/scsi/fc_encode.h      |    2 -
 include/scsi/libfc.h          |   22 +-----
 7 files changed, 236 insertions(+), 247 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 05189f6..f37ce94 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -125,8 +125,8 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 	struct fc_disc *disc = &lport->disc;
 	int found = 0;
 
-	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
-		      rport->port_id);
+	FC_DISC_DBG("Received a %d event for port (%6x)\n", event,
+		    rport->port_id);
 
 	if (event == RPORT_EV_CREATED) {
 		if (disc) {
@@ -138,8 +138,8 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 	}
 
 	if (!found)
-		FC_DEBUG_DISC("The rport (%6x) is not maintained "
-			      "by the discovery layer\n", rport->port_id);
+		FC_DISC_DBG("The rport (%6x) is not maintained "
+			    "by the discovery layer\n", rport->port_id);
 }
 
 /**
@@ -169,8 +169,8 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 
 	lport = disc->lport;
 
-	FC_DEBUG_DISC("Received an RSCN event on port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG("Received an RSCN event on port (%6x)\n",
+		    fc_host_port_id(lport->host));
 
 	/* make sure the frame contains an RSCN message */
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
@@ -203,8 +203,8 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		 */
 		switch (fmt) {
 		case ELS_ADDR_FMT_PORT:
-			FC_DEBUG_DISC("Port address format for port (%6x)\n",
-				      ntoh24(pp->rscn_fid));
+			FC_DISC_DBG("Port address format for port (%6x)\n",
+				    ntoh24(pp->rscn_fid));
 			dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 			if (!dp) {
 				redisc = 1;
@@ -221,19 +221,19 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		case ELS_ADDR_FMT_DOM:
 		case ELS_ADDR_FMT_FAB:
 		default:
-			FC_DEBUG_DISC("Address format is (%d)\n", fmt);
+			FC_DISC_DBG("Address format is (%d)\n", fmt);
 			redisc = 1;
 			break;
 		}
 	}
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	if (redisc) {
-		FC_DEBUG_DISC("RSCN received: rediscovering\n");
+		FC_DISC_DBG("RSCN received: rediscovering\n");
 		fc_disc_restart(disc);
 	} else {
-		FC_DEBUG_DISC("RSCN received: not rediscovering. "
-			      "redisc %d state %d in_prog %d\n",
-			      redisc, lport->state, disc->pending);
+		FC_DISC_DBG("RSCN received: not rediscovering. "
+			    "redisc %d state %d in_prog %d\n",
+			    redisc, lport->state, disc->pending);
 		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
 			list_del(&dp->peers);
 			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
@@ -248,7 +248,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 	return;
 reject:
-	FC_DEBUG_DISC("Received a bad RSCN frame\n");
+	FC_DISC_DBG("Received a bad RSCN frame\n");
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_LOGIC;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -280,7 +280,8 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
-		FC_DBG("Received an unsupported request. opcode (%x)\n", op);
+		FC_DISC_DBG("Received an unsupported request, "
+			    "the opcode is (%x)\n", op);
 		break;
 	}
 }
@@ -298,12 +299,11 @@ static void fc_disc_restart(struct fc_disc *disc)
 	struct fc_rport_libfc_priv *rdata, *next;
 	struct fc_lport *lport = disc->lport;
 
-	FC_DEBUG_DISC("Restarting discovery for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG("Restarting discovery for port (%6x)\n",
+		    fc_host_port_id(lport->host));
 
 	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
 		rport = PRIV_TO_RPORT(rdata);
-		FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
 		list_del(&rdata->peers);
 		lport->tt.rport_logoff(rport);
 	}
@@ -458,8 +458,8 @@ static void fc_disc_done(struct fc_disc *disc)
 {
 	struct fc_lport *lport = disc->lport;
 
-	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG("Discovery complete for port (%6x)\n",
+		    fc_host_port_id(lport->host));
 
 	disc->disc_callback(lport, disc->event);
 	disc->event = DISC_EV_NONE;
@@ -479,9 +479,9 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 {
 	struct fc_lport *lport = disc->lport;
 	unsigned long delay = 0;
-	FC_DEBUG_DISC("Error %ld, retries %d/%d\n",
-		      PTR_ERR(fp), disc->retry_count,
-		      FC_DISC_RETRY_LIMIT);
+	FC_DISC_DBG("Error %ld, retries %d/%d\n",
+		    PTR_ERR(fp), disc->retry_count,
+		    FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -615,9 +615,9 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 				rdata->local_port = lport;
 				lport->tt.rport_login(rport);
 			} else
-				FC_DBG("Failed to allocate memory for "
-				       "the newly discovered port (%6x)\n",
-				       dp.ids.port_id);
+				printk(KERN_WARNING "libfc: Failed to allocate "
+				       "memory for the newly discovered port "
+				       "(%6x)\n", dp.ids.port_id);
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
@@ -637,9 +637,9 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	 */
 	if (error == 0 && len > 0 && len < sizeof(*np)) {
 		if (np != &disc->partial_buf) {
-			FC_DEBUG_DISC("Partial buffer remains "
-				      "for discovery by (%6x)\n",
-				      fc_host_port_id(lport->host));
+			FC_DISC_DBG("Partial buffer remains "
+				    "for discovery by (%6x)\n",
+				    fc_host_port_id(lport->host));
 			memcpy(&disc->partial_buf, np, len);
 		}
 		disc->buf_len = (unsigned char) len;
@@ -683,8 +683,8 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int len;
 	int error;
 
-	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
-		      fc_host_port_id(disc->lport->host));
+	FC_DISC_DBG("Received a GPN_FT response on port (%6x)\n",
+		    fc_host_port_id(disc->lport->host));
 
 	if (IS_ERR(fp)) {
 		fc_disc_error(disc, fp);
@@ -699,8 +699,8 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    disc->seq_count == 0) {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (!cp) {
-			FC_DBG("GPN_FT response too short, len %d\n",
-			       fr_len(fp));
+			FC_DISC_DBG("GPN_FT response too short, len %d\n",
+				    fr_len(fp));
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
 			/*
@@ -709,22 +709,22 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
-			FC_DBG("GPN_FT rejected reason %x exp %x "
-			       "(check zoning)\n", cp->ct_reason,
-			       cp->ct_explan);
+			FC_DISC_DBG("GPN_FT rejected reason %x exp %x "
+				    "(check zoning)\n", cp->ct_reason,
+				    cp->ct_explan);
 			disc->event = DISC_EV_FAILED;
 			fc_disc_done(disc);
 		} else {
-			FC_DBG("GPN_FT unexpected response code %x\n",
-			       ntohs(cp->ct_cmd));
+			FC_DISC_DBG("GPN_FT unexpected response code %x\n",
+				    ntohs(cp->ct_cmd));
 		}
 	} else if (fr_sof(fp) == FC_SOF_N3 &&
 		   seq_cnt == disc->seq_count) {
 		buf = fh + 1;
 	} else {
-		FC_DBG("GPN_FT unexpected frame - out of sequence? "
-		       "seq_cnt %x expected %x sof %x eof %x\n",
-		       seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
+		FC_DISC_DBG("GPN_FT unexpected frame - out of sequence? "
+			    "seq_cnt %x expected %x sof %x eof %x\n",
+			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
 	}
 	if (buf) {
 		error = fc_disc_gpn_ft_parse(disc, buf, len);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index ce608d7..b0d3ec7 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -322,8 +322,8 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
 		return;
 
-	FC_DEBUG_EXCH("Exchange (%4x) timed out, notifying the upper layer\n",
-		      ep->xid);
+	FC_EXCH_DBG("Exchange (%4x) timed out, notifying the upper layer\n",
+		    ep->xid);
 	if (schedule_delayed_work(&ep->timeout_work,
 				  msecs_to_jiffies(timer_msec)))
 		fc_exch_hold(ep);		/* hold for timer */
@@ -534,7 +534,7 @@ struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
 		/* alloc a new xid */
 		xid = fc_em_alloc_xid(mp, fp);
 		if (!xid) {
-			printk(KERN_ERR "fc_em_alloc_xid() failed\n");
+			printk(KERN_WARNING "libfc: Failed to allocate an exhange\n");
 			goto err;
 		}
 	}
@@ -822,8 +822,8 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp)
 	struct fc_exch *ep = fc_seq_exch(sp);
 
 	sp = fc_seq_alloc(ep, ep->seq_id++);
-	FC_DEBUG_EXCH("exch %4x f_ctl %6x seq %2x\n",
-		      ep->xid, ep->f_ctl, sp->id);
+	FC_EXCH_DBG("exch %4x f_ctl %6x seq %2x\n",
+		    ep->xid, ep->f_ctl, sp->id);
 	return sp;
 }
 /*
@@ -903,7 +903,7 @@ void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
 		fc_exch_els_rec(sp, els_data->fp);
 		break;
 	default:
-		FC_DBG("Invalid ELS CMD:%x\n", els_cmd);
+		FC_EXCH_DBG("Invalid ELS CMD:%x\n", els_cmd);
 	}
 }
 EXPORT_SYMBOL(fc_seq_els_rsp_send);
@@ -1136,7 +1136,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			lp->tt.lport_recv(lp, sp, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
-		FC_DEBUG_EXCH("exch/seq lookup failed: reject %x\n", reject);
+		FC_EXCH_DBG("exch/seq lookup failed: reject %x\n", reject);
 		fc_frame_free(fp);
 	}
 }
@@ -1240,10 +1240,10 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
 	if (!sp) {
 		atomic_inc(&mp->stats.xid_not_found);
-		FC_DEBUG_EXCH("seq lookup failed\n");
+		FC_EXCH_DBG("seq lookup failed\n");
 	} else {
 		atomic_inc(&mp->stats.non_bls_resp);
-		FC_DEBUG_EXCH("non-BLS response to sequence");
+		FC_EXCH_DBG("non-BLS response to sequence");
 	}
 	fc_frame_free(fp);
 }
@@ -1264,8 +1264,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	int rc = 1, has_rec = 0;
 
 	fh = fc_frame_header_get(fp);
-	FC_DEBUG_EXCH("exch: BLS rctl %x - %s\n",
-		      fh->fh_r_ctl, fc_exch_rctl_name(fh->fh_r_ctl));
+	FC_EXCH_DBG("exch: BLS rctl %x - %s\n", fh->fh_r_ctl,
+		    fc_exch_rctl_name(fh->fh_r_ctl));
 
 	if (cancel_delayed_work_sync(&ep->timeout_work))
 		fc_exch_release(ep);	/* release from pending timer hold */
@@ -1357,9 +1357,8 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		case FC_RCTL_ACK_0:
 			break;
 		default:
-			FC_DEBUG_EXCH("BLS rctl %x - %s received",
-				      fh->fh_r_ctl,
-				      fc_exch_rctl_name(fh->fh_r_ctl));
+			FC_EXCH_DBG("BLS rctl %x - %s received", fh->fh_r_ctl,
+				    fc_exch_rctl_name(fh->fh_r_ctl));
 			break;
 		}
 		fc_frame_free(fp);
@@ -1597,7 +1596,7 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
 			goto cleanup;
-		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
+		FC_EXCH_DBG("Cannot process RRQ, frame error %d\n", err);
 		return;
 	}
 
@@ -1606,12 +1605,12 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 	switch (op) {
 	case ELS_LS_RJT:
-		FC_DBG("LS_RJT for RRQ");
+		FC_EXCH_DBG("LS_RJT for RRQ");
 		/* fall through */
 	case ELS_LS_ACC:
 		goto cleanup;
 	default:
-		FC_DBG("unexpected response op %x for RRQ", op);
+		FC_EXCH_DBG("unexpected response op %x for RRQ", op);
 		return;
 	}
 
@@ -1738,8 +1737,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	size_t len;
 
 	if (max_xid <= min_xid || min_xid == 0 || max_xid == FC_XID_UNKNOWN) {
-		FC_DBG("Invalid min_xid 0x:%x and max_xid 0x:%x\n",
-		       min_xid, max_xid);
+		FC_EXCH_DBG("Invalid min_xid 0x:%x and max_xid 0x:%x\n",
+			    min_xid, max_xid);
 		return NULL;
 	}
 
@@ -1874,7 +1873,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 
 	/* lport lock ? */
 	if (!lp || !mp || (lp->state == LPORT_ST_NONE)) {
-		FC_DBG("fc_lport or EM is not allocated and configured");
+		FC_EXCH_DBG("fc_lport or EM is not allocated and configured");
 		fc_frame_free(fp);
 		return;
 	}
@@ -1900,7 +1899,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			fc_exch_recv_req(lp, mp, fp);
 		break;
 	default:
-		FC_DBG("dropping invalid frame (eof %x)", fr_eof(fp));
+		FC_EXCH_DBG("dropping invalid frame (eof %x)", fr_eof(fp));
 		fc_frame_free(fp);
 		break;
 	}
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 3f93930..0d75b23 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -293,8 +293,8 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
 			goto crc_err;
-		FC_DEBUG_FCP("data received past end. len %zx offset %zx "
-			     "data_len %x\n", len, offset, fsp->data_len);
+		FC_FCP_DBG("data received past end. len %zx offset %zx "
+			   "data_len %x\n", len, offset, fsp->data_len);
 		fc_fcp_retry_cmd(fsp);
 		return;
 	}
@@ -356,7 +356,7 @@ crc_err:
 			stats = lp->dev_stats[smp_processor_id()];
 			stats->ErrorFrames++;
 			if (stats->InvalidCRCCount++ < 5)
-				FC_DBG("CRC error on data frame\n");
+				FC_FCP_DBG("CRC error on data frame\n");
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -419,14 +419,14 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	WARN_ON(seq_blen <= 0);
 	if (unlikely(offset + seq_blen > fsp->data_len)) {
 		/* this should never happen */
-		FC_DEBUG_FCP("xfer-ready past end. seq_blen %zx offset %zx\n",
-			     seq_blen, offset);
+		FC_FCP_DBG("xfer-ready past end. seq_blen %zx offset %zx\n",
+			   seq_blen, offset);
 		fc_fcp_send_abort(fsp);
 		return 0;
 	} else if (offset != fsp->xfer_len) {
 		/* Out of Order Data Request - no problem, but unexpected. */
-		FC_DEBUG_FCP("xfer-ready non-contiguous. "
-			     "seq_blen %zx offset %zx\n", seq_blen, offset);
+		FC_FCP_DBG("xfer-ready non-contiguous. "
+			   "seq_blen %zx offset %zx\n", seq_blen, offset);
 	}
 
 	/*
@@ -705,7 +705,7 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 		fc_fcp_resp(fsp, fp);
 	} else {
-		FC_DBG("unexpected frame.  r_ctl %x\n", r_ctl);
+		FC_FCP_DBG("unexpected frame.  r_ctl %x\n", r_ctl);
 	}
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -811,17 +811,17 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			return;
 		}
 		fsp->status_code = FC_DATA_OVRRUN;
-		FC_DBG("tgt %6x xfer len %zx greater than expected len %x. "
-		       "data len %x\n",
-		       fsp->rport->port_id,
-		       fsp->xfer_len, expected_len, fsp->data_len);
+		FC_FCP_DBG("tgt %6x xfer len %zx greater than expected, "
+			   "len %x, data len %x\n",
+			   fsp->rport->port_id,
+			   fsp->xfer_len, expected_len, fsp->data_len);
 	}
 	fc_fcp_complete_locked(fsp);
 	return;
 
 len_err:
-	FC_DBG("short FCP response. flags 0x%x len %u respl %u snsl %u\n",
-	       flags, fr_len(fp), respl, snsl);
+	FC_FCP_DBG("short FCP response. flags 0x%x len %u respl %u snsl %u\n",
+		   flags, fr_len(fp), respl, snsl);
 err:
 	fsp->status_code = FC_ERROR;
 	fc_fcp_complete_locked(fsp);
@@ -1041,13 +1041,11 @@ static void fc_fcp_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	if (fc_fcp_lock_pkt(fsp))
 		return;
 
-	switch (error) {
-	case -FC_EX_CLOSED:
+	if (error == -FC_EX_CLOSED) {
 		fc_fcp_retry_cmd(fsp);
 		goto unlock;
-	default:
-		FC_DBG("unknown error %ld\n", PTR_ERR(fp));
 	}
+
 	/*
 	 * clear abort pending, because the lower layer
 	 * decided to force completion.
@@ -1079,10 +1077,10 @@ static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
 	fsp->wait_for_comp = 0;
 
 	if (!rc) {
-		FC_DBG("target abort cmd  failed\n");
+		FC_FCP_DBG("target abort cmd  failed\n");
 		rc = FAILED;
 	} else if (fsp->state & FC_SRB_ABORTED) {
-		FC_DBG("target abort cmd  passed\n");
+		FC_FCP_DBG("target abort cmd  passed\n");
 		rc = SUCCESS;
 		fc_fcp_complete_locked(fsp);
 	}
@@ -1147,7 +1145,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 
 	if (!rc) {
-		FC_DBG("lun reset failed\n");
+		FC_FCP_DBG("lun reset failed\n");
 		return FAILED;
 	}
 
@@ -1155,7 +1153,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	if (fsp->cdb_status != FCP_TMF_CMPL)
 		return FAILED;
 
-	FC_DBG("lun reset to lun %u completed\n", lun);
+	FC_FCP_DBG("lun reset to lun %u completed\n", lun);
 	fc_fcp_cleanup_each_cmd(lp, id, lun, FC_CMD_ABORTED);
 	return SUCCESS;
 }
@@ -1322,13 +1320,13 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		switch (rjt->er_reason) {
 		default:
-			FC_DEBUG_FCP("device %x unexpected REC reject "
-				     "reason %d expl %d\n",
-				     fsp->rport->port_id, rjt->er_reason,
-				     rjt->er_explan);
+			FC_FCP_DBG("device %x unexpected REC reject "
+				   "reason %d expl %d\n",
+				   fsp->rport->port_id, rjt->er_reason,
+				   rjt->er_explan);
 			/* fall through */
 		case ELS_RJT_UNSUP:
-			FC_DEBUG_FCP("device does not support REC\n");
+			FC_FCP_DBG("device does not support REC\n");
 			rp = fsp->rport->dd_data;
 			/*
 			 * if we do not spport RECs or got some bogus
@@ -1448,8 +1446,8 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		break;
 
 	default:
-		FC_DBG("REC %p fid %x error unexpected error %d\n",
-		       fsp, fsp->rport->port_id, error);
+		FC_FCP_DBG("REC %p fid %x error unexpected error %d\n",
+			   fsp, fsp->rport->port_id, error);
 		fsp->status_code = FC_CMD_PLOGO;
 		/* fall through */
 
@@ -1458,9 +1456,9 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		 * Assume REC or LS_ACC was lost.
 		 * The exchange manager will have aborted REC, so retry.
 		 */
-		FC_DBG("REC fid %x error error %d retry %d/%d\n",
-		       fsp->rport->port_id, error, fsp->recov_retry,
-		       FC_MAX_RECOV_RETRY);
+		FC_FCP_DBG("REC fid %x error error %d retry %d/%d\n",
+			   fsp->rport->port_id, error, fsp->recov_retry,
+			   FC_MAX_RECOV_RETRY);
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
@@ -1943,7 +1941,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 
 	fsp = fc_fcp_pkt_alloc(lp, GFP_NOIO);
 	if (fsp == NULL) {
-		FC_DBG("could not allocate scsi_pkt\n");
+		printk(KERN_WARNING "libfc: could not allocate scsi_pkt\n");
 		sc_cmd->result = DID_NO_CONNECT << 16;
 		goto out;
 	}
@@ -1984,11 +1982,12 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 		msleep(1000);
 
 	if (fc_fcp_lport_queue_ready(lp)) {
-		shost_printk(KERN_INFO, shost, "Host reset succeeded.\n");
+		shost_printk(KERN_INFO, shost, "Host reset succeeded on port "
+			     "(%6x)\n", fc_host_port_id(lp->host));
 		return SUCCESS;
 	} else {
-		shost_printk(KERN_INFO, shost, "Host reset failed. "
-			     "lport not ready.\n");
+		shost_printk(KERN_INFO, shost, "Host reset failed, port (%6x) "
+			     "is not ready.\n", fc_host_port_id(lp->host));
 		return FAILED;
 	}
 }
@@ -2047,7 +2046,8 @@ void fc_fcp_destroy(struct fc_lport *lp)
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
 
 	if (!list_empty(&si->scsi_pkt_queue))
-		printk(KERN_ERR "Leaked scsi packets.\n");
+		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
+		       "port (%6x)\n", fc_host_port_id(lp->host));
 
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
@@ -2096,7 +2096,8 @@ static int __init libfc_init(void)
 					    sizeof(struct fc_fcp_pkt),
 					    0, SLAB_HWCACHE_ALIGN, NULL);
 	if (scsi_pkt_cachep == NULL) {
-		FC_DBG("Unable to allocate SRB cache...module load failed!");
+		printk(KERN_ERR "libfc: Unable to allocate SRB cache, "
+		       "module load failed!");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index f777723..54ef40e 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -143,8 +143,8 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				    struct fc_rport *rport,
 				    enum fc_rport_event event)
 {
-	FC_DEBUG_LPORT("Received a %d event for port (%6x)\n", event,
-		       rport->port_id);
+	FC_LPORT_DBG("Received a %d event for port (%6x)\n", event,
+		     rport->port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -154,19 +154,19 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				lport->dns_rp = rport;
 				fc_lport_enter_rpn_id(lport);
 			} else {
-				FC_DEBUG_LPORT("Received an CREATED event on "
-					       "port (%6x) for the directory "
-					       "server, but the lport is not "
-					       "in the DNS state, it's in the "
-					       "%d state", rport->port_id,
-					       lport->state);
+				FC_LPORT_DBG("Received an CREATED event on "
+					     "port (%6x) for the directory "
+					     "server, but the lport is not "
+					     "in the DNS state, it's in the "
+					     "%d state", rport->port_id,
+					     lport->state);
 				lport->tt.rport_logoff(rport);
 			}
 			mutex_unlock(&lport->lp_mutex);
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG("Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
@@ -177,9 +177,9 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 			mutex_unlock(&lport->lp_mutex);
 
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG("Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_NONE:
 		break;
@@ -354,8 +354,8 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
 				   struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG("Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
@@ -380,8 +380,8 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	void *dp;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG("Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(in_fp, len);
@@ -428,8 +428,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RNID request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG("Received RNID request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -489,8 +489,8 @@ static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received ADISC request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG("Received ADISC request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -565,8 +565,8 @@ EXPORT_SYMBOL(fc_fabric_login);
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Link is up for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link up on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up) {
@@ -586,8 +586,8 @@ EXPORT_SYMBOL(fc_linkup);
 void fc_linkdown(struct fc_lport *lport)
 {
 	mutex_lock(&lport->lp_mutex);
-	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link down on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	if (lport->link_up) {
 		lport->link_up = 0;
@@ -683,12 +683,12 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 {
 	switch (event) {
 	case DISC_EV_SUCCESS:
-		FC_DEBUG_LPORT("Got a SUCCESS event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		FC_LPORT_DBG("Discovery succeeded for port (%6x)\n",
+			     fc_host_port_id(lport->host));
 		break;
 	case DISC_EV_FAILED:
-		FC_DEBUG_LPORT("Got a FAILED event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		printk(KERN_ERR "libfc: Discovery failed for port (%6x)\n",
+		       fc_host_port_id(lport->host));
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -708,8 +708,8 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
  */
 static void fc_lport_enter_ready(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered Ready from state %s\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered READY from state %s\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
 
@@ -744,8 +744,8 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	u32 local_fid;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received FLOGI request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG("Received FLOGI request while in state %s\n",
+		     fc_lport_state(lport));
 
 	fh = fc_frame_header_get(rx_fp);
 	remote_fid = ntoh24(fh->fh_s_id);
@@ -754,11 +754,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
-		FC_DBG("FLOGI from port with same WWPN %llx "
-		       "possible configuration error\n", remote_wwpn);
+		printk(KERN_WARNING "libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n", remote_wwpn);
 		goto out;
 	}
-	FC_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
+	FC_LPORT_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?
@@ -890,7 +890,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			}
 		}
 	} else {
-		FC_DBG("dropping invalid frame (eof %x)\n", fr_eof(fp));
+		FC_LPORT_DBG("dropping invalid frame (eof %x)\n", fr_eof(fp));
 		fc_frame_free(fp);
 	}
 	mutex_unlock(&lport->lp_mutex);
@@ -927,8 +927,8 @@ EXPORT_SYMBOL(fc_lport_reset);
  */
 static void fc_lport_enter_reset(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered RESET state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered RESET state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 	cancel_delayed_work_sync(&lport->retry_work);
@@ -963,9 +963,9 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 {
 	unsigned long delay = 0;
-	FC_DEBUG_LPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_lport_state(lport),
-		       lport->retry_count);
+	FC_LPORT_DBG("Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_lport_state(lport),
+		     lport->retry_count);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -1021,7 +1021,7 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RFT_ID response\n");
+	FC_LPORT_DBG("Received a RFT_ID response\n");
 
 	if (IS_ERR(fp)) {
 		fc_lport_error(lport, fp);
@@ -1029,8 +1029,8 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (lport->state != LPORT_ST_RFT_ID) {
-		FC_DBG("Received a RFT_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG("Received a RFT_ID response, but in state %s\n",
+			     fc_lport_state(lport));
 		goto out;
 	}
 
@@ -1073,7 +1073,7 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RPN_ID response\n");
+	FC_LPORT_DBG("Received a RPN_ID response\n");
 
 	if (IS_ERR(fp)) {
 		fc_lport_error(lport, fp);
@@ -1081,8 +1081,8 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (lport->state != LPORT_ST_RPN_ID) {
-		FC_DBG("Received a RPN_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG("Received a RPN_ID response, but in state %s\n",
+			     fc_lport_state(lport));
 		goto out;
 	}
 
@@ -1123,7 +1123,7 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a SCR response\n");
+	FC_LPORT_DBG("Received a SCR response\n");
 
 	if (IS_ERR(fp)) {
 		fc_lport_error(lport, fp);
@@ -1131,8 +1131,8 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (lport->state != LPORT_ST_SCR) {
-		FC_DBG("Received a SCR response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG("Received a SCR response, but in state %s\n",
+			     fc_lport_state(lport));
 		goto out;
 	}
 
@@ -1159,8 +1159,8 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered SCR state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered SCR state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_SCR);
 
@@ -1188,8 +1188,8 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	struct fc_ns_fts *lps;
 	int i;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RFT_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered RFT_ID state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
 
@@ -1228,8 +1228,8 @@ static void fc_lport_enter_rpn_id(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RPN_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered RPN_ID state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RPN_ID);
 
@@ -1269,8 +1269,8 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	dp.lp = lport;
 
-	FC_DEBUG_LPORT("Port (%6x) entered DNS state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered DNS state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
@@ -1349,7 +1349,7 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a LOGO response\n");
+	FC_LPORT_DBG("Received a LOGO response\n");
 
 	if (IS_ERR(fp)) {
 		fc_lport_error(lport, fp);
@@ -1357,8 +1357,8 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (lport->state != LPORT_ST_LOGO) {
-		FC_DBG("Received a LOGO response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG("Received a LOGO response, but in state %s\n",
+			     fc_lport_state(lport));
 		goto out;
 	}
 
@@ -1386,8 +1386,8 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 	struct fc_frame *fp;
 	struct fc_els_logo *logo;
 
-	FC_DEBUG_LPORT("Port (%6x) entered LOGO state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG("Port (%6x) entered LOGO state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 
@@ -1433,7 +1433,7 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a FLOGI response\n");
+	FC_LPORT_DBG("Received a FLOGI response\n");
 
 	if (IS_ERR(fp)) {
 		fc_lport_error(lport, fp);
@@ -1441,8 +1441,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (lport->state != LPORT_ST_FLOGI) {
-		FC_DBG("Received a FLOGI response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG("Received a FLOGI response, but in state %s\n",
+			     fc_lport_state(lport));
 		goto out;
 	}
 
@@ -1450,7 +1450,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
 
-		FC_DEBUG_LPORT("Assigned fid %x\n", did);
+		printk(KERN_INFO "libfc: Assigned FID (%6x) in FLOGI response\n",
+		       did);
 		fc_host_port_id(lport->host) = did;
 
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
@@ -1469,7 +1470,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				if (e_d_tov > lport->e_d_tov)
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
-				FC_DBG("Point-to-Point mode\n");
+				printk(KERN_INFO "libfc: Port (%6x) entered "
+				       "point to point mode\n", did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1492,7 +1494,7 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			}
 		}
 	} else {
-		FC_DBG("bad FLOGI response\n");
+		FC_LPORT_DBG("bad FLOGI response\n");
 	}
 
 out:
@@ -1512,7 +1514,8 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Processing FLOGI state\n");
+	FC_LPORT_DBG("Port (%6x) entered FLOGI state from %s state\n",
+		     fc_host_port_id(lport->host), fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 05330c0..d4f6e01 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -89,7 +89,7 @@ static const char *fc_rport_state_names[] = {
 static void fc_rport_rogue_destroy(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
-	FC_DEBUG_RPORT("Destroying rogue rport (%6x)\n", rport->port_id);
+	FC_RPORT_DBG("Destroying rogue rport (%6x)\n", rport->port_id);
 	kfree(rport);
 }
 
@@ -255,8 +255,8 @@ static void fc_rport_work(struct work_struct *work)
 
 			fc_rport_state_enter(new_rport, RPORT_ST_READY);
 		} else {
-			FC_DBG("Failed to create the rport for port "
-			       "(%6x).\n", ids.port_id);
+			printk(KERN_WARNING "libfc: Failed to allocate "
+			       " memory for rport (%6x)\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
 		put_device(&rport->dev);
@@ -297,7 +297,7 @@ int fc_rport_login(struct fc_rport *rport)
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Login to port (%6x)\n", rport->port_id);
+	FC_LPORT_DBG("Login to port (%6x)\n", rport->port_id);
 
 	fc_rport_enter_plogi(rport);
 
@@ -320,7 +320,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
+	FC_LPORT_DBG("Remove port (%6x)\n", rport->port_id);
 
 	fc_rport_enter_logo(rport);
 
@@ -357,7 +357,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 
 	fc_rport_state_enter(rport, RPORT_ST_READY);
 
-	FC_DEBUG_RPORT("Port (%6x) is Ready\n", rport->port_id);
+	FC_LPORT_DBG("Port (%6x) is Ready\n", rport->port_id);
 
 	rdata->event = RPORT_EV_CREATED;
 	queue_work(rport_event_queue, &rdata->event_work);
@@ -414,8 +414,8 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 
-	FC_DEBUG_RPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
+	FC_LPORT_DBG("Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
@@ -456,8 +456,8 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 		return fc_rport_error(rport, fp);
 
 	if (rdata->retries < rdata->local_port->max_retry_count) {
-		FC_DEBUG_RPORT("Error %ld in state %s, retrying\n",
-			       PTR_ERR(fp), fc_rport_state(rport));
+		FC_LPORT_DBG("Error %ld in state %s, retrying\n",
+			     PTR_ERR(fp), fc_rport_state(rport));
 		rdata->retries++;
 		/* no additional delay on exchange timeouts */
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
@@ -494,8 +494,8 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
-		       rport->port_id);
+	FC_LPORT_DBG("Received a PLOGI response from port (%6x)\n",
+		     rport->port_id);
 
 	if (IS_ERR(fp)) {
 		fc_rport_error_retry(rport, fp);
@@ -503,8 +503,8 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
-		FC_DBG("Received a PLOGI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_LPORT_DBG("Received a PLOGI response, but in state %s\n",
+			     fc_rport_state(rport));
 		goto out;
 	}
 
@@ -558,8 +558,8 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PLOGI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_LPORT_DBG("Port (%6x) entered PLOGI state from %s state\n",
+		     rport->port_id, fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PLOGI);
 
@@ -603,8 +603,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
-		       rport->port_id);
+	FC_LPORT_DBG("Received a PRLI response from port (%6x)\n",
+		     rport->port_id);
 
 	if (IS_ERR(fp)) {
 		fc_rport_error_retry(rport, fp);
@@ -612,8 +612,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (rdata->rp_state != RPORT_ST_PRLI) {
-		FC_DBG("Received a PRLI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_LPORT_DBG("Received a PRLI response, but in state %s\n",
+			     fc_rport_state(rport));
 		goto out;
 	}
 
@@ -636,7 +636,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_rport_enter_rtv(rport);
 
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_LPORT_DBG("Bad ELS response for PRLI command\n");
 		rdata->event = RPORT_EV_FAILED;
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
@@ -667,7 +667,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
+	FC_LPORT_DBG("Received a LOGO response from port (%6x)\n",
 		       rport->port_id);
 
 	if (IS_ERR(fp)) {
@@ -676,8 +676,8 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (rdata->rp_state != RPORT_ST_LOGO) {
-		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
-			       fc_rport_state(rport));
+		FC_LPORT_DBG("Received a LOGO response, but in state %s\n",
+			     fc_rport_state(rport));
 		goto out;
 	}
 
@@ -685,7 +685,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	if (op == ELS_LS_ACC) {
 		fc_rport_enter_rtv(rport);
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_LPORT_DBG("Bad ELS response for LOGO command\n");
 		rdata->event = RPORT_EV_LOGO;
 		queue_work(rport_event_queue, &rdata->event_work);
 	}
@@ -714,8 +714,8 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 	} *pp;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PRLI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_LPORT_DBG("Port (%6x) entered PRLI state from %s state\n",
+		     rport->port_id, fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PRLI);
 
@@ -753,8 +753,8 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
-		       rport->port_id);
+	FC_LPORT_DBG("Received a RTV response from port (%6x)\n",
+		     rport->port_id);
 
 	if (IS_ERR(fp)) {
 		fc_rport_error(rport, fp);
@@ -762,8 +762,8 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (rdata->rp_state != RPORT_ST_RTV) {
-		FC_DBG("Received a RTV response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_LPORT_DBG("Received a RTV response, but in state %s\n",
+			     fc_rport_state(rport));
 		goto out;
 	}
 
@@ -811,8 +811,8 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
-	FC_DEBUG_RPORT("Port (%6x) entered RTV state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_LPORT_DBG("Port (%6x) entered RTV state from %s state\n",
+		     rport->port_id, fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_RTV);
 
@@ -842,8 +842,8 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered LOGO state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_LPORT_DBG("Port (%6x) entered LOGO state from %s state\n",
+		     rport->port_id, fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_LOGO);
 
@@ -950,14 +950,14 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PLOGI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_LPORT_DBG("Received PLOGI request from port (%6x) "
+		     "while in state %s\n", ntoh24(fh->fh_s_id),
+		     fc_rport_state(rport));
 
 	sid = ntoh24(fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		FC_DBG("incoming PLOGI from %x too short\n", sid);
+		FC_LPORT_DBG("Incoming PLOGI from (%6x) too short\n", sid);
 		WARN_ON(1);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
@@ -979,26 +979,26 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	 */
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
-		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
-			       "- reject\n", sid, wwpn);
+		FC_LPORT_DBG("incoming PLOGI from %6x wwpn %llx state INIT "
+			     "- reject\n", sid, wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in PLOGI state %d\n",
-			       sid, rdata->rp_state);
+		FC_LPORT_DBG("incoming PLOGI from %x in PLOGI state %d\n",
+			     sid, rdata->rp_state);
 		if (wwpn < lport->wwpn)
 			reject = ELS_RJT_INPROG;
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in logged-in state %d "
-			       "- ignored for now\n", sid, rdata->rp_state);
+		FC_LPORT_DBG("incoming PLOGI from %x in logged-in state %d "
+			     "- ignored for now\n", sid, rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_NONE:
 	default:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
-			       "state %d\n", sid, rdata->rp_state);
+		FC_LPORT_DBG("incoming PLOGI from %x in unexpected "
+			     "state %d\n", sid, rdata->rp_state);
 		break;
 	}
 
@@ -1080,9 +1080,9 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(rx_fp);
 
-	FC_DEBUG_RPORT("Received PRLI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_LPORT_DBG("Received PRLI request from port (%6x) "
+		     "while in state %s\n", ntoh24(fh->fh_s_id),
+		     fc_rport_state(rport));
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
@@ -1215,9 +1215,9 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PRLO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_LPORT_DBG("Received PRLO request from port (%6x) "
+		     "while in state %s\n", ntoh24(fh->fh_s_id),
+		     fc_rport_state(rport));
 
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_UNAB;
@@ -1244,9 +1244,9 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received LOGO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_LPORT_DBG("Received LOGO request from port (%6x) "
+		     "while in state %s\n", ntoh24(fh->fh_s_id),
+		     fc_rport_state(rport));
 
 	rdata->event = RPORT_EV_LOGO;
 	queue_work(rport_event_queue, &rdata->event_work);
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 6300f55..a0ff61c 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -107,7 +107,6 @@ static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 	*r_ctl = FC_RCTL_DD_UNSOL_CTL;
@@ -298,7 +297,6 @@ static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 01f68f6..a774e78 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -33,18 +33,6 @@
 
 #include <scsi/fc_frame.h>
 
-#define LIBFC_DEBUG
-
-#ifdef LIBFC_DEBUG
-/* Log messages */
-#define FC_DBG(fmt, args...)						\
-	do {								\
-		printk(KERN_INFO "%s " fmt, __func__, ##args);		\
-	} while (0)
-#else
-#define FC_DBG(fmt, args...)
-#endif
-
 #define FC_LPORT_LOGGING 0x01
 #define FC_DISC_LOGGING  0x02
 #define FC_RPORT_LOGGING 0x04
@@ -61,23 +49,23 @@ do {								\
 		} while (0);					\
 } while (0)
 
-#define FC_DEBUG_LPORT(fmt, args...)					\
+#define FC_LPORT_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
 			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
 
-#define FC_DEBUG_DISC(fmt, args...)					\
+#define FC_DISC_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
 			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
 
-#define FC_DEBUG_RPORT(fmt, args...)					\
+#define FC_RPORT_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
 			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
 
-#define FC_DEBUG_FCP(fmt, args...)					\
+#define FC_FCP_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
 			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
 
-#define FC_DEBUG_EXCH(fmt, args...)					\
+#define FC_EXCH_DBG(fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
 			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
 

