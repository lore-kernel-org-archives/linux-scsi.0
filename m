From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Adding Check Condition counter to misc fnicstats
Date: Tue, 28 Feb 2017 16:15:44 -0800
Message-ID: <1488327344-8817-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:24425 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdCAAaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 19:30:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

Just a simple counter of number of check conditions encountered on
that host.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c  | 3 +++
 drivers/scsi/fnic/fnic_stats.h | 1 +
 drivers/scsi/fnic/fnic_trace.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..d3b32da 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -919,6 +919,9 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		if (icmnd_cmpl->flags & FCPIO_ICMND_CMPL_RESID_UNDER)
 			xfer_len -= icmnd_cmpl->residual;
 
+		if (icmnd_cmpl->scsi_status == SAM_STAT_CHECK_CONDITION)
+			atomic64_inc(&fnic_stats->misc_stats.check_condition);
+
 		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
 			atomic64_inc(&fnic_stats->misc_stats.queue_fulls);
 		break;
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 540cceb8..69acdac 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -88,6 +88,7 @@ struct misc_stats {
 	atomic64_t devrst_cpwq_alloc_failures;
 	atomic64_t io_cpwq_alloc_failures;
 	atomic64_t no_icmnd_itmf_cmpls;
+	atomic64_t check_condition;
 	atomic64_t queue_fulls;
 	atomic64_t rport_not_ready;
 	atomic64_t frame_errors;
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 5a5fa01..ec20b3e 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -357,6 +357,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  "Number of Copy WQ Alloc Failures for Device Reset: %lld\n"
 		  "Number of Copy WQ Alloc Failures for IOs: %lld\n"
 		  "Number of no icmnd itmf Completions: %lld\n"
+		  "Number of Check Conditions encountered: %lld\n"
 		  "Number of QUEUE Fulls: %lld\n"
 		  "Number of rport not ready: %lld\n"
 		  "Number of receive frame errors: %lld\n",
@@ -377,6 +378,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 			  &stats->misc_stats.devrst_cpwq_alloc_failures),
 		  (u64)atomic64_read(&stats->misc_stats.io_cpwq_alloc_failures),
 		  (u64)atomic64_read(&stats->misc_stats.no_icmnd_itmf_cmpls),
+		  (u64)atomic64_read(&stats->misc_stats.check_condition),
 		  (u64)atomic64_read(&stats->misc_stats.queue_fulls),
 		  (u64)atomic64_read(&stats->misc_stats.rport_not_ready),
 		  (u64)atomic64_read(&stats->misc_stats.frame_errors));
-- 
2.5.5
