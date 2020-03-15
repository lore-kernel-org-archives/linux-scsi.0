Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96ADC5ACBF
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A64206E9
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgCOJmv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:58100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgCOJmu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6EED5ACC3;
        Sun, 15 Mar 2020 09:42:45 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 3/8] scsi: fnic: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:36 +0100
Message-Id: <20200315094241.9086-4-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315094241.9086-1-tiwai@suse.de>
References: <20200315094241.9086-1-tiwai@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: no change

 drivers/scsi/fnic/fnic_trace.c | 58 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index a0d01aea28f7..9d52d83161ed 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -138,7 +138,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			 * Dump trace buffer entry to memory file
 			 * and increment read index @rd_idx
 			 */
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				  (trace_max_pages * PAGE_SIZE * 3) - len,
 				  "%16llu.%09lu %-50s %8x %8x %16llx %16llx "
 				  "%16llx %16llx %16llx\n", (u64)val.tv_sec,
@@ -180,7 +180,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			 * Dump trace buffer entry to memory file
 			 * and increment read index @rd_idx
 			 */
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				  (trace_max_pages * PAGE_SIZE * 3) - len,
 				  "%16llu.%09lu %-50s %8x %8x %16llx %16llx "
 				  "%16llx %16llx %16llx\n", (u64)val.tv_sec,
@@ -220,12 +220,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 	struct timespec64 val1, val2;
 
 	ktime_get_real_ts64(&val1);
-	len = snprintf(debug->debug_buffer + len, buf_size - len,
+	len = scnprintf(debug->debug_buffer + len, buf_size - len,
 		"------------------------------------------\n"
 		 "\t\tTime\n"
 		"------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		"Current time :          [%lld:%ld]\n"
 		"Last stats reset time:  [%lld:%09ld]\n"
 		"Last stats read time:   [%lld:%ld]\n"
@@ -243,11 +243,11 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 
 	stats->stats_timestamps.last_read_time = val1;
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "------------------------------------------\n"
 		  "\t\tIO Statistics\n"
 		  "------------------------------------------\n");
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Active IOs: %lld\nMaximum Active IOs: %lld\n"
 		  "Number of IOs: %lld\nNumber of IO Completions: %lld\n"
 		  "Number of IO Failures: %lld\nNumber of IO NOT Found: %lld\n"
@@ -280,16 +280,16 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->io_stats.io_btw_10000_to_30000_msec),
 		  (u64)atomic64_read(&stats->io_stats.io_greater_than_30000_msec));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\nCurrent Max IO time : %lld\n",
 		  (u64)atomic64_read(&stats->io_stats.current_max_io_time));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tAbort Statistics\n"
 		  "------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Aborts: %lld\n"
 		  "Number of Abort Failures: %lld\n"
 		  "Number of Abort Driver Timeouts: %lld\n"
@@ -318,12 +318,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->abts_stats.abort_issued_btw_50_to_60_sec),
 		  (u64)atomic64_read(&stats->abts_stats.abort_issued_greater_than_60_sec));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tTerminate Statistics\n"
 		  "------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Terminates: %lld\n"
 		  "Maximum Terminates: %lld\n"
 		  "Number of Terminate Driver Timeouts: %lld\n"
@@ -337,12 +337,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->term_stats.terminate_io_not_found),
 		  (u64)atomic64_read(&stats->term_stats.terminate_failures));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tReset Statistics\n"
 		  "------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Device Resets: %lld\n"
 		  "Number of Device Reset Failures: %lld\n"
 		  "Number of Device Reset Aborts: %lld\n"
@@ -368,12 +368,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 			  &stats->reset_stats.fnic_reset_completions),
 		  (u64)atomic64_read(&stats->reset_stats.fnic_reset_failures));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tFirmware Statistics\n"
 		  "------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Active FW Requests %lld\n"
 		  "Maximum FW Requests: %lld\n"
 		  "Number of FW out of resources: %lld\n"
@@ -383,12 +383,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->fw_stats.fw_out_of_resources),
 		  (u64)atomic64_read(&stats->fw_stats.io_fw_errs));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tVlan Discovery Statistics\n"
 		  "------------------------------------------\n");
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Number of Vlan Discovery Requests Sent %lld\n"
 		  "Vlan Response Received with no FCF VLAN ID: %lld\n"
 		  "No solicitations recvd after vlan set, expiry count: %lld\n"
@@ -398,7 +398,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->vlan_stats.sol_expiry_count),
 		  (u64)atomic64_read(&stats->vlan_stats.flogi_rejects));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "\n------------------------------------------\n"
 		  "\t\tOther Important Statistics\n"
 		  "------------------------------------------\n");
@@ -406,7 +406,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 	jiffies_to_timespec64(stats->misc_stats.last_isr_time, &val1);
 	jiffies_to_timespec64(stats->misc_stats.last_ack_time, &val2);
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 		  "Last ISR time: %llu (%8llu.%09lu)\n"
 		  "Last ACK time: %llu (%8llu.%09lu)\n"
 		  "Max ISR jiffies: %llu\n"
@@ -452,7 +452,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->misc_stats.rport_not_ready),
 		  (u64)atomic64_read(&stats->misc_stats.frame_errors));
 
-	len += snprintf(debug->debug_buffer + len, buf_size - len,
+	len += scnprintf(debug->debug_buffer + len, buf_size - len,
 			"Firmware reported port speed: %llu\n",
 			(u64)atomic64_read(
 				&stats->misc_stats.current_port_speed));
@@ -742,7 +742,7 @@ int fnic_fc_trace_get_data(fnic_dbgfs_t *fnic_dbgfs_prt, u8 rdata_flag)
 	rd_idx = fc_trace_entries.rd_idx;
 	wr_idx = fc_trace_entries.wr_idx;
 	if (rdata_flag == 0) {
-		len += snprintf(fnic_dbgfs_prt->buffer + len,
+		len += scnprintf(fnic_dbgfs_prt->buffer + len,
 			(fnic_fc_trace_max_pages * PAGE_SIZE * 3) - len,
 			"Time Stamp (UTC)\t\t"
 			"Host No:   F Type:  len:     FCoE_FRAME:\n");
@@ -762,11 +762,11 @@ int fnic_fc_trace_get_data(fnic_dbgfs_t *fnic_dbgfs_prt, u8 rdata_flag)
 		} else {
 			fc_trace = (char *)tdata;
 			for (j = 0; j < FC_TRC_SIZE_BYTES; j++) {
-				len += snprintf(fnic_dbgfs_prt->buffer + len,
+				len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				(fnic_fc_trace_max_pages * PAGE_SIZE * 3)
 				- len, "%02x", fc_trace[j] & 0xff);
 			} /* for loop */
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				(fnic_fc_trace_max_pages * PAGE_SIZE * 3) - len,
 				"\n");
 		}
@@ -810,7 +810,7 @@ void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
 	time64_to_tm(tdata->time_stamp.tv_sec, 0, &tm);
 
 	fmt = "%02d:%02d:%04ld %02d:%02d:%02d.%09lu ns%8x       %c%8x\t";
-	len += snprintf(fnic_dbgfs_prt->buffer + len,
+	len += scnprintf(fnic_dbgfs_prt->buffer + len,
 		max_size - len,
 		fmt,
 		tm.tm_mon + 1, tm.tm_mday, tm.tm_year + 1900,
@@ -823,25 +823,25 @@ void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
 	for (j = 0; j < min_t(u8, tdata->frame_len,
 		(u8)(FC_TRC_SIZE_BYTES - FC_TRC_HEADER_SIZE)); j++) {
 		if (tdata->frame_type == FNIC_FC_LE) {
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				max_size - len, "%c", fc_trace[j]);
 		} else {
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				max_size - len, "%02x", fc_trace[j] & 0xff);
-			len += snprintf(fnic_dbgfs_prt->buffer + len,
+			len += scnprintf(fnic_dbgfs_prt->buffer + len,
 				max_size - len, " ");
 			if (j == ethhdr_len ||
 				j == ethhdr_len + fcoehdr_len ||
 				j == ethhdr_len + fcoehdr_len + fchdr_len ||
 				(i > 3 && j%fchdr_len == 0)) {
-				len += snprintf(fnic_dbgfs_prt->buffer
+				len += scnprintf(fnic_dbgfs_prt->buffer
 					+ len, max_size - len,
 					"\n\t\t\t\t\t\t\t\t");
 				i++;
 			}
 		} /* end of else*/
 	} /* End of for loop*/
-	len += snprintf(fnic_dbgfs_prt->buffer + len,
+	len += scnprintf(fnic_dbgfs_prt->buffer + len,
 		max_size - len, "\n");
 	*orig_len = len;
 }
-- 
2.16.4

