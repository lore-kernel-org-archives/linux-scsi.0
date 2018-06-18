From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] snic: fix printing time intervals
Date: Mon, 18 Jun 2018 17:18:41 +0200
Message-ID: <20180618151907.1453733-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We don't want to use 'struct timespec' because of the y2038 overflow
problem. The overflow is not actually an issue here, but it's easy to
replace with 'timespec64' for consistency. However, it's worth pointing
out that nanosecond values have nine digits, not eight or ten, so I'm
fixing the format strings accordingly as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/snic/snic_debugfs.c | 10 +++++-----
 drivers/scsi/snic/snic_trc.c     |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 269ddf791a73..0abe17c1a73b 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -200,7 +200,7 @@ snic_stats_show(struct seq_file *sfp, void *data)
 {
 	struct snic *snic = (struct snic *) sfp->private;
 	struct snic_stats *stats = &snic->s_stats;
-	struct timespec last_isr_tms, last_ack_tms;
+	struct timespec64 last_isr_tms, last_ack_tms;
 	u64 maxio_tm;
 	int i;
 
@@ -312,12 +312,12 @@ snic_stats_show(struct seq_file *sfp, void *data)
 		   "\t\t Other Statistics\n"
 		   "\n---------------------------------------------\n");
 
-	jiffies_to_timespec(stats->misc.last_isr_time, &last_isr_tms);
-	jiffies_to_timespec(stats->misc.last_ack_time, &last_ack_tms);
+	jiffies_to_timespec64(stats->misc.last_isr_time, &last_isr_tms);
+	jiffies_to_timespec64(stats->misc.last_ack_time, &last_ack_tms);
 
 	seq_printf(sfp,
-		   "Last ISR Time               : %llu (%8lu.%8lu)\n"
-		   "Last Ack Time               : %llu (%8lu.%8lu)\n"
+		   "Last ISR Time               : %llu (%8llu.%09lu)\n"
+		   "Last Ack Time               : %llu (%8llu.%09lu)\n"
 		   "Ack ISRs                    : %llu\n"
 		   "IO Cmpl ISRs                : %llu\n"
 		   "Err Notify ISRs             : %llu\n"
diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
index f00ebf4717e0..fc60c933d6c0 100644
--- a/drivers/scsi/snic/snic_trc.c
+++ b/drivers/scsi/snic/snic_trc.c
@@ -65,12 +65,12 @@ static int
 snic_fmt_trc_data(struct snic_trc_data *td, char *buf, int buf_sz)
 {
 	int len = 0;
-	struct timespec tmspec;
+	struct timespec64 tmspec;
 
-	jiffies_to_timespec(td->ts, &tmspec);
+	jiffies_to_timespec64(td->ts, &tmspec);
 
 	len += snprintf(buf, buf_sz,
-			"%lu.%10lu %-25s %3d %4x %16llx %16llx %16llx %16llx %16llx\n",
+			"%llu.%09lu %-25s %3d %4x %16llx %16llx %16llx %16llx %16llx\n",
 			tmspec.tv_sec,
 			tmspec.tv_nsec,
 			td->fn,
-- 
2.9.0
