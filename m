From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 16/21] fnic: Use time64_t to represent trace timestamps
Date: Wed,  8 Jun 2016 22:05:00 -0700
Message-ID: <1465448705-25055-17-git-send-email-deepa.kernel@gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, y2038@lists.linaro.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

trace timestamps use struct timespec and CURRENT_TIME which
are not y2038 safe.
These timestamps are only part of the trace log on the machine
and are not shared with the fnic.
Replace then with y2038 safe struct timespec64 and
ktime_get_real_ts64(), respectively.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/fnic/fnic_trace.c | 4 ++--
 drivers/scsi/fnic/fnic_trace.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 4e15c4b..5a5fa01 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -613,7 +613,7 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 			fc_trace_entries.rd_idx = 0;
 	}
 
-	fc_buf->time_stamp = CURRENT_TIME;
+	ktime_get_real_ts64(&fc_buf->time_stamp);
 	fc_buf->host_no = host_no;
 	fc_buf->frame_type = frame_type;
 
@@ -740,7 +740,7 @@ void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
 
 	len = *orig_len;
 
-	time_to_tm(tdata->time_stamp.tv_sec, 0, &tm);
+	time64_to_tm(tdata->time_stamp.tv_sec, 0, &tm);
 
 	fmt = "%02d:%02d:%04ld %02d:%02d:%02d.%09lu ns%8x       %c%8x\t";
 	len += snprintf(fnic_dbgfs_prt->buffer + len,
diff --git a/drivers/scsi/fnic/fnic_trace.h b/drivers/scsi/fnic/fnic_trace.h
index a8aa057..e375d0c 100644
--- a/drivers/scsi/fnic/fnic_trace.h
+++ b/drivers/scsi/fnic/fnic_trace.h
@@ -72,7 +72,7 @@ struct fnic_trace_data {
 typedef struct fnic_trace_data fnic_trace_data_t;
 
 struct fc_trace_hdr {
-	struct timespec time_stamp;
+	struct timespec64 time_stamp;
 	u32 host_no;
 	u8 frame_type;
 	u8 frame_len;
-- 
1.9.1
