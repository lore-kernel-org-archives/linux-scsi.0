From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/10] libfc: set seq_id for incoming sequence
Date: Fri, 07 May 2010 15:18:13 -0700
Message-ID: <20100507221813.14971.63789.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0EGWSO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:14 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

After the recent patch "fixes unnecessary seq id jump"
the SCST module fcst stopped working because multi-sequence
write data wasn't finding the sequence after the first frame.

Add back the setting of the seq_id when the first frame arrives.
Also fix indentation on two lines.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index daff880..6addbd6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -918,6 +918,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 	if (fc_sof_is_init(fr_sof(fp))) {
 		sp = &ep->seq;
 		sp->ssb_stat |= SSB_ST_RESP;
+		sp->id = fh->fh_seq_id;
 	} else {
 		sp = &ep->seq;
 		if (sp->id != fh->fh_seq_id) {
@@ -1322,11 +1323,12 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	}
 	sof = fr_sof(fp);
 	sp = &ep->seq;
-	if (fc_sof_is_init(sof))
+	if (fc_sof_is_init(sof)) {
 		sp->ssb_stat |= SSB_ST_RESP;
-	else if (sp->id != fh->fh_seq_id) {
-			atomic_inc(&mp->stats.seq_not_found);
-			goto rel;
+		sp->id = fh->fh_seq_id;
+	} else if (sp->id != fh->fh_seq_id) {
+		atomic_inc(&mp->stats.seq_not_found);
+		goto rel;
 	}
 
 	f_ctl = ntoh24(fh->fh_f_ctl);

