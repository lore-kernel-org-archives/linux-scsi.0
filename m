From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 5/6] scsi: bfa: bfa_port: Remove 'struct timeval'
Date: Sat, 9 Jan 2016 20:05:08 +0530
Message-ID: <20160109143508.GA7563@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33672 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcAIOfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2016 09:35:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org

32 bit systems using 'struct timeval' will break in the year 2038, so
we modify the code appropriately.

We only need to find elapsed seconds rather than absolute time and we
only care about full seconds so it's better to use monotonic time, so
using ktime_get_seconds() also makes the code more efficient and more
robust against a concurrent settimeofday().

stats_reset_time variable has been changed to 'time64_t' type to store
the monotonic time returned by ktime_get_seconds().

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/scsi/bfa/bfa_port.c | 16 ++++------------
 drivers/scsi/bfa/bfa_port.h |  2 +-
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 8ea7697..0c86ea7 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -95,14 +95,12 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 	port->stats_busy = BFA_FALSE;
 
 	if (status == BFA_STATUS_OK) {
-		struct timeval tv;
-
 		memcpy(port->stats, port->stats_dma.kva,
 		       sizeof(union bfa_port_stats_u));
 		bfa_port_stats_swap(port, port->stats);
 
-		do_gettimeofday(&tv);
-		port->stats->fc.secs_reset = tv.tv_sec - port->stats_reset_time;
+		port->stats->fc.secs_reset = ktime_get_seconds() -
+							port->stats_reset_time;
 	}
 
 	if (port->stats_cbfn) {
@@ -123,16 +121,13 @@ bfa_port_get_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 static void
 bfa_port_clear_stats_isr(struct bfa_port_s *port, bfa_status_t status)
 {
-	struct timeval tv;
-
 	port->stats_status = status;
 	port->stats_busy   = BFA_FALSE;
 
 	/*
 	* re-initialize time stamp for stats reset
 	*/
-	do_gettimeofday(&tv);
-	port->stats_reset_time = tv.tv_sec;
+	port->stats_reset_time = ktime_get_seconds();
 
 	if (port->stats_cbfn) {
 		port->stats_cbfn(port->stats_cbarg, status);
@@ -470,8 +465,6 @@ void
 bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 		 void *dev, struct bfa_trc_mod_s *trcmod)
 {
-	struct timeval tv;
-
 	WARN_ON(!port);
 
 	port->dev    = dev;
@@ -493,8 +486,7 @@ bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 	/*
 	 * initialize time stamp for stats reset
 	 */
-	do_gettimeofday(&tv);
-	port->stats_reset_time = tv.tv_sec;
+	port->stats_reset_time = ktime_get_seconds();
 
 	bfa_trc(port, 0);
 }
diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.h
index 2fcab6b..5f6a9d0 100644
--- a/drivers/scsi/bfa/bfa_port.h
+++ b/drivers/scsi/bfa/bfa_port.h
@@ -35,7 +35,7 @@ struct bfa_port_s {
 	bfa_port_stats_cbfn_t		stats_cbfn;
 	void				*stats_cbarg;
 	bfa_status_t			stats_status;
-	u32			stats_reset_time;
+	time64_t			stats_reset_time;
 	union bfa_port_stats_u		*stats;
 	struct bfa_dma_s		stats_dma;
 	bfa_boolean_t			endis_pending;
-- 
1.9.1

