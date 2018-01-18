From: "Satish Kharat (satishkh)" <satishkh@cisco.com>
Subject: RE: [PATCH] [RESEND] scsi: fnic: use 64-bit timestamps
Date: Thu, 18 Jan 2018 01:17:01 +0000
Message-ID: <ed302c81f8d143449a26ecdb33a6f730@XCH-RCD-012.cisco.com>
References: <20180117151708.3359303-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117151708.3359303-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.

Acked-by: Satish Kharat <satishkh@cisco.com>

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]=20
Sent: Wednesday, January 17, 2018 7:17 AM
To: Satish Kharat (satishkh) <satishkh@cisco.com>; Sesidhar Baddela (sebadd=
el) <sebaddel@cisco.com>; Karan Tilak Kumar (kartilak) <kartilak@cisco.com>=
; James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <marti=
n.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>; Vasyl Gomonovych <gomonovych@gmail.com>;=
 linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] scsi: fnic: use 64-bit timestamps

struct timespec is deprecated since it overflows in 2038 on 32-bit architec=
tures, so we should use timespec64 consistently.

I'm slightly adapting the format strings here, to make sure we print the na=
noseconds with the correct number of leading zeroes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Originally submitted in November 2017. Martin asked Satish to review my pat=
ch, but I never heard back after that, so I'm trying again now.
---
 drivers/scsi/fnic/fnic_debugfs.c |  2 +-
 drivers/scsi/fnic/fnic_stats.h   |  4 +--
 drivers/scsi/fnic/fnic_trace.c   | 58 ++++++++++++++++++++----------------=
----
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debu=
gfs.c
index 9858484dd126..6d3e1cb4fea6 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -614,7 +614,7 @@ static ssize_t fnic_reset_stats_write(struct file *file=
,
 			sizeof(struct io_path_stats) - sizeof(u64));
 		memset(fw_stats_p+1, 0,
 			sizeof(struct fw_stats) - sizeof(u64));
-		getnstimeofday(&stats->stats_timestamps.last_reset_time);
+		ktime_get_real_ts64(&stats->stats_timestamps.last_reset_time);
 	}
=20
 	(*ppos)++;
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.=
h index e007feedbf72..9daa6ada6fa0 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -18,8 +18,8 @@
 #define _FNIC_STATS_H_
=20
 struct stats_timestamps {
-	struct timespec last_reset_time;
-	struct timespec last_read_time;
+	struct timespec64 last_reset_time;
+	struct timespec64 last_read_time;
 };
=20
 struct io_path_stats {
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.=
c index 4826f596cb31..abddde11982b 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -111,7 +111,7 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 	int len =3D 0;
 	unsigned long flags;
 	char str[KSYM_SYMBOL_LEN];
-	struct timespec val;
+	struct timespec64 val;
 	fnic_trace_data_t *tbp;
=20
 	spin_lock_irqsave(&fnic_trace_lock, flags); @@ -129,10 +129,10 @@ int fni=
c_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			/* Convert function pointer to function name */
 			if (sizeof(unsigned long) < 8) {
 				sprint_symbol(str, tbp->fnaddr.low);
-				jiffies_to_timespec(tbp->timestamp.low, &val);
+				jiffies_to_timespec64(tbp->timestamp.low, &val);
 			} else {
 				sprint_symbol(str, tbp->fnaddr.val);
-				jiffies_to_timespec(tbp->timestamp.val, &val);
+				jiffies_to_timespec64(tbp->timestamp.val, &val);
 			}
 			/*
 			 * Dump trace buffer entry to memory file @@ -140,8 +140,8 @@ int fnic_=
get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			 */
 			len +=3D snprintf(fnic_dbgfs_prt->buffer + len,
 				  (trace_max_pages * PAGE_SIZE * 3) - len,
-				  "%16lu.%16lu %-50s %8x %8x %16llx %16llx "
-				  "%16llx %16llx %16llx\n", val.tv_sec,
+				  "%16llu.%09lu %-50s %8x %8x %16llx %16llx "
+				  "%16llx %16llx %16llx\n", (u64)val.tv_sec,
 				  val.tv_nsec, str, tbp->host_no, tbp->tag,
 				  tbp->data[0], tbp->data[1], tbp->data[2],
 				  tbp->data[3], tbp->data[4]);
@@ -171,10 +171,10 @@ int fnic_get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			/* Convert function pointer to function name */
 			if (sizeof(unsigned long) < 8) {
 				sprint_symbol(str, tbp->fnaddr.low);
-				jiffies_to_timespec(tbp->timestamp.low, &val);
+				jiffies_to_timespec64(tbp->timestamp.low, &val);
 			} else {
 				sprint_symbol(str, tbp->fnaddr.val);
-				jiffies_to_timespec(tbp->timestamp.val, &val);
+				jiffies_to_timespec64(tbp->timestamp.val, &val);
 			}
 			/*
 			 * Dump trace buffer entry to memory file @@ -182,8 +182,8 @@ int fnic_=
get_trace_data(fnic_dbgfs_t *fnic_dbgfs_prt)
 			 */
 			len +=3D snprintf(fnic_dbgfs_prt->buffer + len,
 				  (trace_max_pages * PAGE_SIZE * 3) - len,
-				  "%16lu.%16lu %-50s %8x %8x %16llx %16llx "
-				  "%16llx %16llx %16llx\n", val.tv_sec,
+				  "%16llu.%09lu %-50s %8x %8x %16llx %16llx "
+				  "%16llx %16llx %16llx\n", (u64)val.tv_sec,
 				  val.tv_nsec, str, tbp->host_no, tbp->tag,
 				  tbp->data[0], tbp->data[1], tbp->data[2],
 				  tbp->data[3], tbp->data[4]);
@@ -217,29 +217,29 @@ int fnic_get_stats_data(struct stats_debug_info *debu=
g,  {
 	int len =3D 0;
 	int buf_size =3D debug->buf_size;
-	struct timespec val1, val2;
+	struct timespec64 val1, val2;
=20
-	getnstimeofday(&val1);
+	ktime_get_real_ts64(&val1);
 	len =3D snprintf(debug->debug_buffer + len, buf_size - len,
 		"------------------------------------------\n"
 		 "\t\tTime\n"
 		"------------------------------------------\n");
=20
 	len +=3D snprintf(debug->debug_buffer + len, buf_size - len,
-		"Current time :          [%ld:%ld]\n"
-		"Last stats reset time:  [%ld:%ld]\n"
-		"Last stats read time:   [%ld:%ld]\n"
-		"delta since last reset: [%ld:%ld]\n"
-		"delta since last read:  [%ld:%ld]\n",
-	val1.tv_sec, val1.tv_nsec,
-	stats->stats_timestamps.last_reset_time.tv_sec,
+		"Current time :          [%lld:%ld]\n"
+		"Last stats reset time:  [%lld:%09ld]\n"
+		"Last stats read time:   [%lld:%ld]\n"
+		"delta since last reset: [%lld:%ld]\n"
+		"delta since last read:  [%lld:%ld]\n",
+	(s64)val1.tv_sec, val1.tv_nsec,
+	(s64)stats->stats_timestamps.last_reset_time.tv_sec,
 	stats->stats_timestamps.last_reset_time.tv_nsec,
-	stats->stats_timestamps.last_read_time.tv_sec,
+	(s64)stats->stats_timestamps.last_read_time.tv_sec,
 	stats->stats_timestamps.last_read_time.tv_nsec,
-	timespec_sub(val1, stats->stats_timestamps.last_reset_time).tv_sec,
-	timespec_sub(val1, stats->stats_timestamps.last_reset_time).tv_nsec,
-	timespec_sub(val1, stats->stats_timestamps.last_read_time).tv_sec,
-	timespec_sub(val1, stats->stats_timestamps.last_read_time).tv_nsec);
+	(s64)timespec64_sub(val1, stats->stats_timestamps.last_reset_time).tv_sec=
,
+	timespec64_sub(val1, stats->stats_timestamps.last_reset_time).tv_nsec,
+	(s64)timespec64_sub(val1, stats->stats_timestamps.last_read_time).tv_sec,
+	timespec64_sub(val1, stats->stats_timestamps.last_read_time).tv_nsec);
=20
 	stats->stats_timestamps.last_read_time =3D val1;
=20
@@ -403,12 +403,12 @@ int fnic_get_stats_data(struct stats_debug_info *debu=
g,
 		  "\t\tOther Important Statistics\n"
 		  "------------------------------------------\n");
=20
-	jiffies_to_timespec(stats->misc_stats.last_isr_time, &val1);
-	jiffies_to_timespec(stats->misc_stats.last_ack_time, &val2);
+	jiffies_to_timespec64(stats->misc_stats.last_isr_time, &val1);
+	jiffies_to_timespec64(stats->misc_stats.last_ack_time, &val2);
=20
 	len +=3D snprintf(debug->debug_buffer + len, buf_size - len,
-		  "Last ISR time: %llu (%8lu.%8lu)\n"
-		  "Last ACK time: %llu (%8lu.%8lu)\n"
+		  "Last ISR time: %llu (%8llu.%09lu)\n"
+		  "Last ACK time: %llu (%8llu.%09lu)\n"
 		  "Number of ISRs: %lld\n"
 		  "Maximum CQ Entries: %lld\n"
 		  "Number of ACK index out of range: %lld\n"
@@ -425,9 +425,9 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  "Number of rport not ready: %lld\n"
 		  "Number of receive frame errors: %lld\n",
 		  (u64)stats->misc_stats.last_isr_time,
-		  val1.tv_sec, val1.tv_nsec,
+		  (s64)val1.tv_sec, val1.tv_nsec,
 		  (u64)stats->misc_stats.last_ack_time,
-		  val2.tv_sec, val2.tv_nsec,
+		  (s64)val2.tv_sec, val2.tv_nsec,
 		  (u64)atomic64_read(&stats->misc_stats.isr_count),
 		  (u64)atomic64_read(&stats->misc_stats.max_cq_entries),
 		  (u64)atomic64_read(&stats->misc_stats.ack_index_out_of_range),
--
2.9.0
