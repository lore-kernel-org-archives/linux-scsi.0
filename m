From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix race in FCP layer
Date: Sun, 5 Dec 2010 12:50:09 +0800
Message-ID: <AANLkTi=aqDZyDF4z7AUt6uYOsAcgx=hHsjk68+n+pEUY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65148 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0LEEuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Dec 2010 23:50:11 -0500
Received: by wyb28 with SMTP id 28so10902361wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 04 Dec 2010 20:50:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There in fc_tm_done() race is detected incorrectly, since there is no
race if fcp pkt could still get locked.

The race is removed by extra holding fcp pkt before waiting for
completion, then it is safer to operate on fcp pkt both in tm
responser and after waiting for completion.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-12-05 12:39:14.000000000 +0800
@@ -1206,6 +1206,9 @@ static void fc_lun_reset_send(unsigned l
 		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
 		fc_fcp_unlock_pkt(fsp);
 	}
+	else
+		/* hold pkt for safe operations in tm responser */
+		fc_fcp_pkt_hold(fsp);
 }

 /**
@@ -1246,6 +1249,8 @@ static int fc_lun_reset(struct fc_lport
 	if (fsp->seq_ptr) {
 		lport->tt.exch_done(fsp->seq_ptr);
 		fsp->seq_ptr = NULL;
+		/* release hold for tm responser */
+		fc_fcp_pkt_release(fsp);
 	}
 	fsp->wait_for_comp = 0;
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
@@ -1276,6 +1281,7 @@ static void fc_tm_done(struct fc_seq *se
 	struct fc_frame_header *fh;

 	if (IS_ERR(fp)) {
+		fc_fcp_pkt_release(fsp);
 		/*
 		 * If there is an error just let it timeout or wait
 		 * for TMF to be aborted if it timedout.
@@ -1285,14 +1291,12 @@ static void fc_tm_done(struct fc_seq *se
 		return;
 	}

-	if (fc_fcp_lock_pkt(fsp))
-		return;
-
-	/*
-	 * raced with eh timeout handler.
-	 */
-	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
-		spin_unlock_bh(&fsp->scsi_pkt_lock);
+	if (fc_fcp_lock_pkt(fsp)) {
+		/*
+		 * race with fc_lun_reset(),
+		 * pkt has to be cleaned up there.
+		 */
+		fc_fcp_pkt_release(fsp);
 		return;
 	}

@@ -1301,8 +1305,10 @@ static void fc_tm_done(struct fc_seq *se
 		fc_fcp_resp(fsp, fp);
 	fsp->seq_ptr = NULL;
 	fsp->lp->tt.exch_done(seq);
-	fc_frame_free(fp);
 	fc_fcp_unlock_pkt(fsp);
+	/* release hold for tm responser */
+	fc_fcp_pkt_release(fsp);
+	fc_frame_free(fp);
 }

 /**
