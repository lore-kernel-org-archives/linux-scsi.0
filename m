From: Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] [SCSI] bfa: Use monotonic clock
Date: Tue, 11 Aug 2015 12:06:45 -0400
Message-ID: <1439309205-9337-1-git-send-email-klock.android@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38156 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202AbbHKQGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 12:06:47 -0400
Received: by igfj19 with SMTP id j19so75291604igf.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 09:06:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sudarsana.kalluru@qlogic.com, anil.gurumurthy@qlogic.com, Abhilash Jindal <klock.android@gmail.com>

Wall time obtained from do_gettimeofday is susceptible to sudden jumps due to
user setting the time or due to NTP.

Monotonic time is constantly increasing time better suited for comparing two
timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/scsi/bfa/bfa_port.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 8ea7697..179ab23 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -95,13 +95,13 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->stats_busy = BFA_FALSE;
 
 	if (status == BFA_STATUS_OK) {
-		struct timeval tv;
+		struct timespec tv;
 
 		memcpy(port->stats, port->stats_dma.kva,
 		       sizeof(union bfa_port_stats_u));
 		bfa_port_stats_swap(port, port->stats);
 
-		do_gettimeofday(&tv);
+		ktime_get_ts(&tv);
 		port->stats->fc.secs_reset = tv.tv_sec - port->stats_reset_time;
 	}
 
@@ -123,7 +123,7 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 static void
 bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 {
-	struct timeval tv;
+	struct timespec tv;
 
 	port->stats_status = status;
 	port->stats_busy   = BFA_FALSE;
@@ -131,7 +131,7 @@ bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	/*
 	* re-initialize time stamp for stats reset
 	*/
-	do_gettimeofday(&tv);
+	ktime_get_ts(&tv);
 	port->stats_reset_time = tv.tv_sec;
 
 	if (port->stats_cbfn) {
@@ -470,7 +470,7 @@ void
 bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 		 void *dev, struct bfa_trc_mod_s *trcmod)
 {
-	struct timeval tv;
+	struct timespec tv;
 
 	WARN_ON(!port);
 
@@ -493,7 +493,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 	/*
 	 * initialize time stamp for stats reset
 	 */
-	do_gettimeofday(&tv);
+	ktime_get_ts(&tv);
 	port->stats_reset_time = tv.tv_sec;
 
 	bfa_trc(port, 0);
-- 
1.7.9.5

