From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 44/64] libfc: rearrange code in fc_disc_gpn_ft_resp()
Date: Tue, 25 Aug 2009 14:02:22 -0700
Message-ID: <20090825210222.1553.64923.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbZHYVCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:20 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Code cleanup for fc_disc_gpn_ft_resp().

Some of the fc_disc.c code was poorly formatted. For example, some lines
in fc_disc.c were unnecessarily truncated and the buf variable could
be eliminated.

Also moved the increment of seq_count into fc_disc_gpn_ft_parse(), to
avoid doing it separately before each call.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index fd3a6b2..819ec62 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -469,6 +469,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
+	disc->seq_count++;
 
 	/*
 	 * Handle partial name record left over from previous call.
@@ -582,10 +583,10 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_disc *disc = disc_arg;
 	struct fc_ct_hdr *cp;
 	struct fc_frame_header *fh;
+	enum fc_disc_event event = DISC_EV_NONE;
 	unsigned int seq_cnt;
-	void *buf = NULL;
 	unsigned int len;
-	int error;
+	int error = 0;
 
 	mutex_lock(&disc->disc_mutex);
 	FC_DISC_DBG(disc, "Received a GPN_FT response\n");
@@ -600,8 +601,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	fh = fc_frame_header_get(fp);
 	len = fr_len(fp) - sizeof(*fh);
 	seq_cnt = ntohs(fh->fh_seq_cnt);
-	if (fr_sof(fp) == FC_SOF_I3 && seq_cnt == 0 &&
-	    disc->seq_count == 0) {
+	if (fr_sof(fp) == FC_SOF_I3 && seq_cnt == 0 && disc->seq_count == 0) {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (!cp) {
 			FC_DISC_DBG(disc, "GPN_FT response too short, len %d\n",
@@ -609,33 +609,29 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
 			/* Accepted, parse the response. */
-			buf = cp + 1;
 			len -= sizeof(*cp);
+			error = fc_disc_gpn_ft_parse(disc, cp + 1, len);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
 			FC_DISC_DBG(disc, "GPN_FT rejected reason %x exp %x "
 				    "(check zoning)\n", cp->ct_reason,
 				    cp->ct_explan);
-			fc_disc_done(disc, DISC_EV_FAILED);
+			event = DISC_EV_FAILED;
 		} else {
 			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
 				    "%x\n", ntohs(cp->ct_cmd));
 		}
-	} else if (fr_sof(fp) == FC_SOF_N3 &&
-		   seq_cnt == disc->seq_count) {
-		buf = fh + 1;
+	} else if (fr_sof(fp) == FC_SOF_N3 && seq_cnt == disc->seq_count) {
+		error = fc_disc_gpn_ft_parse(disc, fh + 1, len);
 	} else {
 		FC_DISC_DBG(disc, "GPN_FT unexpected frame - out of sequence? "
 			    "seq_cnt %x expected %x sof %x eof %x\n",
 			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
 	}
-	if (buf) {
-		disc->seq_count++;
-		error = fc_disc_gpn_ft_parse(disc, buf, len);
-		if (error)
-			fc_disc_error(disc, fp);
-	}
+	if (error)
+		fc_disc_error(disc, fp);
+	else if (event != DISC_EV_NONE)
+		fc_disc_done(disc, event);
 	fc_frame_free(fp);
-
 	mutex_unlock(&disc->disc_mutex);
 }
 

