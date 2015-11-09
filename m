From: Alison Schofield <amsfield22@gmail.com>
Subject: [PATCH v3] scsi: pmcraid: replace struct timeval with ktime_get_real_seconds()
Date: Mon,  9 Nov 2015 11:34:20 -0800
Message-ID: <1447097660-3063-1-git-send-email-amsfield22@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, outreachy-kernel@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Replace the use of struct timeval and do_gettimeofday() with
64 bit ktime_get_real_seconds. Prevents 32-bit type overflow
in year 2038 on 32-bit systems.

Driver was using the seconds portion of struct timeval (.tv_secs)
to pass a millseconds timestamp to the firmware. This change maintains
that same behavior using ktime_get_real_seconds.

The structure used to pass the timestamp to firmware is 48 bits and
works fine as long as the top 16 bits are zero and they will be zero
for a long time..ie. thousands of years.

Alternative Change:  Add sub second granularity to timestamp

As noted above, the driver only used the seconds portion of timeval,
ignores the microseconds portion, and by multiplying by 1000 effectively
does a <<10 and always writes zero into timestamp[0].

The alternative change would pass all the bits to the firmware:

        struct timespec64 ts;

        ktime_get_real_ts64(&ts);
        timestamp = ts.tv_sec * MSEC_PER_SEC + ts.tv_nsec / NSEC_PER_MSEC;

MAINTAINER: Please request alternate change if preferred.

Signed-off-by: Alison Schofield <amsfield22@gmail.com>
---
Change in v3:
* move alternative change proposal above the '---' to save
Changes in v2:
* add pmcraid to subject line
* update commit msg w additional detail
* add alternative change proposal per reviewer feedback

 drivers/scsi/pmcraid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ed31d8c..3f64275 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -45,6 +45,7 @@
 #include <asm/processor.h>
 #include <linux/libata.h>
 #include <linux/mutex.h>
+#include <linux/ktime.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
@@ -5563,11 +5564,9 @@ static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
 	__be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
 	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
 
-	struct timeval tv;
 	__le64 timestamp;
 
-	do_gettimeofday(&tv);
-	timestamp = tv.tv_sec * 1000;
+	timestamp = ktime_get_real_seconds() * 1000;
 
 	pinstance->timestamp_data->timestamp[0] = (__u8)(timestamp);
 	pinstance->timestamp_data->timestamp[1] = (__u8)((timestamp) >> 8);
-- 
2.1.4
