From: Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] [SCSI] bfa: Use boottime
Date: Tue, 11 Aug 2015 12:10:09 -0400
Message-ID: <1439309409-10158-1-git-send-email-klock.android@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33088 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbHKQKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 12:10:12 -0400
Received: by iods203 with SMTP id s203so10210034iod.0
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 09:10:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sudarsana.kalluru@qlogic.com, anil.gurumurthy@qlogic.com, Abhilash Jindal <klock.android@gmail.com>

Wall time obtained from do_gettimeofday is susceptible to sudden jumps due to
user setting the time or due to NTP.  Boot time is constantly increasing time
better suited for comparing two timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/scsi/bfa/bfa_svc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..a4f59c7 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -307,8 +307,8 @@ static u64
 bfa_get_log_time(void)
 {
 	u64 system_time = 0;
-	struct timeval tv;
-	do_gettimeofday(&tv);
+	struct timespec tv;
+	getboottime(&tv);
 
 	/* We are interested in seconds only. */
 	system_time = tv.tv_sec;
@@ -3092,7 +3092,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(bfa);
 	struct bfa_port_cfg_s *port_cfg = &fcport->cfg;
 	struct bfa_fcport_ln_s *ln = &fcport->ln;
-	struct timeval tv;
+	struct timespec tv;
 
 	fcport->bfa = bfa;
 	ln->fcport = fcport;
@@ -3105,7 +3105,7 @@ bfa_fcport_attach(struct bfa_s *bfa, void *bfad, struct bfa_iocfc_cfg_s *cfg,
 	/*
 	 * initialize time stamp for stats reset
 	 */
-	do_gettimeofday(&tv);
+	getboottime(&tv);
 	fcport->stats_reset_time = tv.tv_sec;
 	fcport->stats_dma_ready = BFA_FALSE;
 
@@ -3358,9 +3358,9 @@ __bfa_cb_fcport_stats_get(void *cbarg, bfa_boolean_t complete)
 	union bfa_fcport_stats_u *ret;
 
 	if (complete) {
-		struct timeval tv;
+		struct timespec tv;
 		if (fcport->stats_status == BFA_STATUS_OK)
-			do_gettimeofday(&tv);
+			getboottime(&tv);
 
 		list_for_each_safe(qe, qen, &fcport->stats_pending_q) {
 			bfa_q_deq(&fcport->stats_pending_q, &qe);
@@ -3436,12 +3436,12 @@ __bfa_cb_fcport_stats_clr(void *cbarg, bfa_boolean_t complete)
 	struct list_head *qe, *qen;
 
 	if (complete) {
-		struct timeval tv;
+		struct timespec tv;
 
 		/*
 		 * re-initialize time stamp for stats reset
 		 */
-		do_gettimeofday(&tv);
+		getboottime(&tv);
 		fcport->stats_reset_time = tv.tv_sec;
 		list_for_each_safe(qe, qen, &fcport->statsclr_pending_q) {
 			bfa_q_deq(&fcport->statsclr_pending_q, &qe);
-- 
1.7.9.5

