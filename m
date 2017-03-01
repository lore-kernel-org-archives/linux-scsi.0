From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Adding debug IO and Abort latency counter to fnic stats
Date: Tue, 28 Feb 2017 16:15:59 -0800
Message-ID: <1488327359-8866-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:44083 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdCABj3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 20:39:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

The IO and Abort latency counter count the time taken to complete
the IO and abort command into broad buckets. It is not intend for
performance measurement, just a debug stat.
current_max_io_time tries to keep tarck of the maximun time an IO
has taken to complete if it > 30sec, it just another debug stat.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic.h       |  2 +-
 drivers/scsi/fnic/fnic_scsi.c  | 43 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_stats.h | 15 ++++++++++++++
 drivers/scsi/fnic/fnic_trace.c | 47 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 9ddc920..99d00c9 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.21"
+#define DRV_VERSION		"1.6.0.34"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..1f116b4 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -823,6 +823,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	spinlock_t *io_lock;
 	u64 cmd_trace;
 	unsigned long start_time;
+	unsigned long io_duration_time;
 
 	/* Decode the cmpl description to get the io_req id */
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
@@ -1017,6 +1018,28 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	else
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
+
+	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+
+	if(io_duration_time <= 10)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
+	else if(io_duration_time <= 100)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_10_to_100_msec);
+	else if(io_duration_time <= 500)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_100_to_500_msec);
+	else if(io_duration_time <= 5000)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_500_to_5000_msec);
+	else if(io_duration_time <= 10000)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_5000_to_10000_msec);
+	else if(io_duration_time <= 30000)
+		atomic64_inc(&fnic_stats->io_stats.io_btw_10000_to_30000_msec);
+	else {
+		atomic64_inc(&fnic_stats->io_stats.io_greater_than_30000_msec);
+
+		if(io_duration_time > atomic64_read(&fnic_stats->io_stats.current_max_io_time))
+			atomic64_set(&fnic_stats->io_stats.current_max_io_time, io_duration_time);
+	}
+
 	/* Call SCSI completion function to complete the IO */
 	if (sc->scsi_done)
 		sc->scsi_done(sc);
@@ -1793,6 +1816,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	struct terminate_stats *term_stats;
 	enum fnic_ioreq_state old_ioreq_state;
 	int tag;
+	unsigned long abt_issued_time;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
@@ -1846,6 +1870,25 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		spin_unlock_irqrestore(io_lock, flags);
 		goto wait_pending;
 	}
+
+	abt_issued_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	if (abt_issued_time <= 6000)
+		atomic64_inc(&abts_stats->abort_issued_btw_0_to_6_sec);
+	else if (abt_issued_time > 6000 && abt_issued_time <= 20000)
+		atomic64_inc(&abts_stats->abort_issued_btw_6_to_20_sec);
+	else if (abt_issued_time > 20000 && abt_issued_time <= 30000)
+		atomic64_inc(&abts_stats->abort_issued_btw_20_to_30_sec);
+	else if (abt_issued_time > 30000 && abt_issued_time <= 40000)
+		atomic64_inc(&abts_stats->abort_issued_btw_30_to_40_sec);
+	else if (abt_issued_time > 40000 && abt_issued_time <= 50000)
+		atomic64_inc(&abts_stats->abort_issued_btw_40_to_50_sec);
+	else if (abt_issued_time > 50000 && abt_issued_time <= 60000)
+		atomic64_inc(&abts_stats->abort_issued_btw_50_to_60_sec);
+	else
+		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
+
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+		"CBD Opcode: %02x Abort issued time: %lu msec\n", sc->cmnd[0], abt_issued_time);
 	/*
 	 * Command is still pending, need to abort it
 	 * If the firmware completes the command after this point,
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 540cceb8..fc47955 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -26,6 +26,14 @@ struct io_path_stats {
 	atomic64_t sc_null;
 	atomic64_t io_not_found;
 	atomic64_t num_ios;
+	atomic64_t io_btw_0_to_10_msec;
+	atomic64_t io_btw_10_to_100_msec;
+	atomic64_t io_btw_100_to_500_msec;
+	atomic64_t io_btw_500_to_5000_msec;
+	atomic64_t io_btw_5000_to_10000_msec;
+	atomic64_t io_btw_10000_to_30000_msec;
+	atomic64_t io_greater_than_30000_msec;
+	atomic64_t current_max_io_time;
 };
 
 struct abort_stats {
@@ -34,6 +42,13 @@ struct abort_stats {
 	atomic64_t abort_drv_timeouts;
 	atomic64_t abort_fw_timeouts;
 	atomic64_t abort_io_not_found;
+	atomic64_t abort_issued_btw_0_to_6_sec;
+	atomic64_t abort_issued_btw_6_to_20_sec;
+	atomic64_t abort_issued_btw_20_to_30_sec;
+	atomic64_t abort_issued_btw_30_to_40_sec;
+	atomic64_t abort_issued_btw_40_to_50_sec;
+	atomic64_t abort_issued_btw_50_to_60_sec;
+	atomic64_t abort_issued_greater_than_60_sec;
 };
 
 struct terminate_stats {
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 5a5fa01..0dba5d5 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -229,7 +229,16 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  "Number of IO Failures: %lld\nNumber of IO NOT Found: %lld\n"
 		  "Number of Memory alloc Failures: %lld\n"
 		  "Number of IOREQ Null: %lld\n"
-		  "Number of SCSI cmd pointer Null: %lld\n",
+		  "Number of SCSI cmd pointer Null: %lld\n"
+
+		  "\nIO completion times: \n"
+		  "            < 10 ms : %lld\n"
+		  "     10 ms - 100 ms : %lld\n"
+		  "    100 ms - 500 ms : %lld\n"
+		  "    500 ms -   5 sec: %lld\n"
+		  "     5 sec -  10 sec: %lld\n"
+		  "    10 sec -  30 sec: %lld\n"
+		  "            > 30 sec: %lld\n",
 		  (u64)atomic64_read(&stats->io_stats.active_ios),
 		  (u64)atomic64_read(&stats->io_stats.max_active_ios),
 		  (u64)atomic64_read(&stats->io_stats.num_ios),
@@ -238,28 +247,58 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->io_stats.io_not_found),
 		  (u64)atomic64_read(&stats->io_stats.alloc_failures),
 		  (u64)atomic64_read(&stats->io_stats.ioreq_null),
-		  (u64)atomic64_read(&stats->io_stats.sc_null));
+		  (u64)atomic64_read(&stats->io_stats.sc_null),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_0_to_10_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_10_to_100_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_100_to_500_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_500_to_5000_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_5000_to_10000_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_btw_10000_to_30000_msec),
+		  (u64)atomic64_read(&stats->io_stats.io_greater_than_30000_msec));
+
+	len += snprintf(debug->debug_buffer + len, buf_size - len,
+		  "\nCurrent Max IO time : %lld\n",
+		  (u64)atomic64_read(&stats->io_stats.current_max_io_time));
 
 	len += snprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tAbort Statistics\n"
 		  "------------------------------------------\n");
+
 	len += snprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Aborts: %lld\n"
 		  "Number of Abort Failures: %lld\n"
 		  "Number of Abort Driver Timeouts: %lld\n"
 		  "Number of Abort FW Timeouts: %lld\n"
-		  "Number of Abort IO NOT Found: %lld\n",
+		  "Number of Abort IO NOT Found: %lld\n"
+
+		  "Abord issued times: \n"
+		  "            < 6 sec : %lld\n"
+		  "     6 sec - 20 sec : %lld\n"
+		  "    20 sec - 30 sec : %lld\n"
+		  "    30 sec - 40 sec : %lld\n"
+		  "    40 sec - 50 sec : %lld\n"
+		  "    50 sec - 60 sec : %lld\n"
+		  "            > 60 sec: %lld\n",
+
 		  (u64)atomic64_read(&stats->abts_stats.aborts),
 		  (u64)atomic64_read(&stats->abts_stats.abort_failures),
 		  (u64)atomic64_read(&stats->abts_stats.abort_drv_timeouts),
 		  (u64)atomic64_read(&stats->abts_stats.abort_fw_timeouts),
-		  (u64)atomic64_read(&stats->abts_stats.abort_io_not_found));
+		  (u64)atomic64_read(&stats->abts_stats.abort_io_not_found),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_0_to_6_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_6_to_20_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_20_to_30_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_30_to_40_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_40_to_50_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_50_to_60_sec),
+		  (u64)atomic64_read(&stats->abts_stats.abort_issued_greater_than_60_sec));
 
 	len += snprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tTerminate Statistics\n"
 		  "------------------------------------------\n");
+
 	len += snprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Terminates: %lld\n"
 		  "Maximum Terminates: %lld\n"
-- 
2.5.5
