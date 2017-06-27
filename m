From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic:added timestamp reporting in fnic debug stats
Date: Mon, 26 Jun 2017 17:48:08 -0700
Message-ID: <1498524488-32453-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:9920 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdF0A5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 20:57:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, Sesidhar Baddela <sebaddel@cisco.com>

Added the timestamps for
1. current timestamp
2. last fnic stats read timestamp
3. last fnic stats reset timestamp
and the deltas since last stats read and last reset in fnic stats.
fnic stats uses debugfs

Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic_debugfs.c |  1 +
 drivers/scsi/fnic/fnic_stats.h   |  7 +++++++
 drivers/scsi/fnic/fnic_trace.c   | 24 ++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index d6498fa..5e3d909 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -632,6 +632,7 @@ static ssize_t fnic_reset_stats_write(struct file *file,
 			sizeof(struct io_path_stats) - sizeof(u64));
 		memset(fw_stats_p+1, 0,
 			sizeof(struct fw_stats) - sizeof(u64));
+		getnstimeofday(&stats->stats_timestamps.last_reset_time);
 	}
 
 	(*ppos)++;
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 88c73cc..e007fee 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -16,6 +16,12 @@
  */
 #ifndef _FNIC_STATS_H_
 #define _FNIC_STATS_H_
+
+struct stats_timestamps {
+	struct timespec last_reset_time;
+	struct timespec last_read_time;
+};
+
 struct io_path_stats {
 	atomic64_t active_ios;
 	atomic64_t max_active_ios;
@@ -110,6 +116,7 @@ struct misc_stats {
 };
 
 struct fnic_stats {
+	struct stats_timestamps stats_timestamps;
 	struct io_path_stats io_stats;
 	struct abort_stats abts_stats;
 	struct terminate_stats term_stats;
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index b5ac538..4826f59 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -219,7 +219,31 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 	int buf_size = debug->buf_size;
 	struct timespec val1, val2;
 
+	getnstimeofday(&val1);
 	len = snprintf(debug->debug_buffer + len, buf_size - len,
+		"------------------------------------------\n"
+		 "\t\tTime\n"
+		"------------------------------------------\n");
+
+	len += snprintf(debug->debug_buffer + len, buf_size - len,
+		"Current time :          [%ld:%ld]\n"
+		"Last stats reset time:  [%ld:%ld]\n"
+		"Last stats read time:   [%ld:%ld]\n"
+		"delta since last reset: [%ld:%ld]\n"
+		"delta since last read:  [%ld:%ld]\n",
+	val1.tv_sec, val1.tv_nsec,
+	stats->stats_timestamps.last_reset_time.tv_sec,
+	stats->stats_timestamps.last_reset_time.tv_nsec,
+	stats->stats_timestamps.last_read_time.tv_sec,
+	stats->stats_timestamps.last_read_time.tv_nsec,
+	timespec_sub(val1, stats->stats_timestamps.last_reset_time).tv_sec,
+	timespec_sub(val1, stats->stats_timestamps.last_reset_time).tv_nsec,
+	timespec_sub(val1, stats->stats_timestamps.last_read_time).tv_sec,
+	timespec_sub(val1, stats->stats_timestamps.last_read_time).tv_nsec);
+
+	stats->stats_timestamps.last_read_time = val1;
+
+	len += snprintf(debug->debug_buffer + len, buf_size - len,
 		  "------------------------------------------\n"
 		  "\t\tIO Statistics\n"
 		  "------------------------------------------\n");
-- 
2.7.4
