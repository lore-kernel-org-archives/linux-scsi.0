From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH] fnic: Use time64_t to represent trace timestamps
Date: Sat,  1 Oct 2016 16:48:14 -0700
Message-ID: <1475365694-8582-1-git-send-email-deepa.kernel@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33552 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbcJAXsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2016 19:48:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, y2038@lists.linaro.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

trace timestamps use struct timespec and CURRENT_TIME which
are not y2038 safe.
These timestamps are only part of the trace log on the machine
and are not shared with the fnic.
Replace then with y2038 safe struct timespec64 and
ktime_get_real_ts64(), respectively.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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
2.7.4

