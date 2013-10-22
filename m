From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [SCSI] scsi_lib: avoid the "rejecting I/O to offline device" print
 storm
Date: Tue, 22 Oct 2013 23:51:40 +0800
Message-ID: <1382457100.26153.69.camel@cliu38-desktop-build>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bitbucket@online.de, chuansheng.liu@intel.com, dongxing.zhang@intel.com
List-Id: linux-scsi@vger.kernel.org


When handling the scsi_request_fn(), when the sd offline happened, sometimes
we will hit the print storm as below:
<3>[   95.365837] sd 0:0:0:0: rejecting I/O to offline device
<3>[   95.368633] sd 0:0:0:0: rejecting I/O to offline device
<3>[   95.369881] sd 0:0:0:0: rejecting I/O to offline device
<3>[   95.371088] sd 0:0:0:0: rejecting I/O to offline device
...
<3>[   99.026230] sd 0:0:0:0: rejecting I/O to offline device
<3>[   99.027196] sd 0:0:0:0: rejecting I/O to offline device
<3>[   99.028240] sd 0:0:0:0: rejecting I/O to offline device

In our case, the print last almost 4s, and it causes irq is disbled for 4s,
bring system unstable.

Here we create sd_printk_ratelimited to replace it.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/scsi/scsi_lib.c    |    2 +-
 include/scsi/scsi_device.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1549b7..7d8d476 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1570,7 +1570,7 @@ static void scsi_request_fn(struct request_queue *q)
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			sdev_printk(KERN_ERR, sdev,
+			sdev_printk_ratelimited(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..0d7d1be 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -7,6 +7,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
+#include <linux/ratelimit.h>
 
 struct device;
 struct request_queue;
@@ -235,6 +236,15 @@ struct scsi_dh_data {
 #define sdev_printk(prefix, sdev, fmt, a...)	\
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
+#define sdev_printk_ratelimited(prefix, sdev, fmt, a...)               \
+do {                                                                   \
+       static DEFINE_RATELIMIT_STATE(_rs,                              \
+                                       DEFAULT_RATELIMIT_INTERVAL,     \
+                                       DEFAULT_RATELIMIT_BURST);       \
+       if (__ratelimit(&_rs))                                          \
+               dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a);     \
+} while (0)
+
 #define scmd_printk(prefix, scmd, fmt, a...)				\
         (scmd)->request->rq_disk ?					\
 	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-- 
1.7.9.5
