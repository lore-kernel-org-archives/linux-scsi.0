From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH v3] scsi: Introduce sdev_printk_ratelimited to throttle frequent printk
Date: Tue, 3 Apr 2018 14:04:40 +0800
Message-ID: <1522735480-159023-1-git-send-email-wen.yang99@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, wen.yang99@zte.com.cn, Tan Hu <tan.hu@zte.com.cn>, JasonYan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

There would be so many same lines printed by frequent printk if one
disk went wrong, like,
[  546.185242] sd 0:1:0:0: rejecting I/O to offline device
[  546.185258] sd 0:1:0:0: rejecting I/O to offline device
[  546.185280] sd 0:1:0:0: rejecting I/O to offline device
[  546.185307] sd 0:1:0:0: rejecting I/O to offline device
[  546.185334] sd 0:1:0:0: rejecting I/O to offline device
[  546.185364] sd 0:1:0:0: rejecting I/O to offline device
[  546.185390] sd 0:1:0:0: rejecting I/O to offline device
[  546.185410] sd 0:1:0:0: rejecting I/O to offline device
For slow serial console, the frequent printk may be blocked for a
long time, and if any spin_lock has been acquired before the printk
like in scsi_request_fn, watchdog could be triggered.

Related disscussion can be found here,
https://bugzilla.kernel.org/show_bug.cgi?id=199003
And Petr brought the idea to throttle the frequent printk, it's
useless to print the same lines frequently after all.

v2: fix some typos
v3: limit the print only for the same device

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
Signed-off-by: Tan Hu <tan.hu@zte.com.cn>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
CC: BartVanAssche <Bart.VanAssche@wdc.com>
CC: Petr Mladek <pmladek@suse.com>
CC: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
CC: Martin K. Petersen <martin.petersen@oracle.com>
CC: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>
CC: JasonYan <yanaijie@huawei.com>
---
 drivers/scsi/scsi_lib.c    | 6 +++---
 drivers/scsi/scsi_scan.c   | 3 +++
 include/scsi/scsi_device.h | 8 ++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c84f931..f77e801 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1301,7 +1301,7 @@ static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 			 * commands.  The device must be brought online
 			 * before trying any recovery commands.
 			 */
-			sdev_printk(KERN_ERR, sdev,
+			sdev_printk_ratelimited(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
 			ret = BLKPREP_KILL;
 			break;
@@ -1310,7 +1310,7 @@ static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 			 * If the device is fully deleted, we refuse to
 			 * process any commands as well.
 			 */
-			sdev_printk(KERN_ERR, sdev,
+			sdev_printk_ratelimited(KERN_ERR, sdev,
 				    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
@@ -1802,7 +1802,7 @@ static void scsi_request_fn(struct request_queue *q)
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			sdev_printk(KERN_ERR, sdev,
+			sdev_printk_ratelimited(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0880d97..a6da935 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -288,6 +288,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
 					sdev->host->cmd_per_lun : 1);
 
+	/* Enable message ratelimiting. Default is 10 messages per 5 secs. */
+	ratelimit_state_init(&sdev->sdev_ratelimit_state,
+			DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
 	scsi_sysfs_device_initialize(sdev);
 
 	if (shost->hostt->slave_alloc) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ae177c..f1db7f3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -215,6 +215,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct ratelimit_state sdev_ratelimit_state; /* Ratelimit sdev messages. */
+
 	struct execute_work	ew; /* used to get process context on put */
 	struct work_struct	requeue_work;
 
@@ -249,6 +251,12 @@ struct scsi_device {
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
 
+#define sdev_printk_ratelimited(l, sdev, fmt, a...)			\
+({									\
+	if (sdev && __ratelimit(&sdev->sdev_ratelimit_state))		\
+		sdev_prefix_printk(l, sdev, NULL, fmt, ##a);		\
+})
+
 __printf(3, 4) void
 scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
 
-- 
1.8.3.1
