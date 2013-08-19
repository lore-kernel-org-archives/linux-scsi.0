From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: [RFC PATCH] scsi: Add failfast mode to avoid infinite retry loop
Date: Mon, 19 Aug 2013 18:39:25 +0900
Message-ID: <20130819093925.7867.19221.stgit@ltc223.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch adds scsi device failfast mode to avoid infinite retry loop.

Currently, scsi error handling in scsi_decide_disposition() and
scsi_io_completion() unconditionally retries on some errors. This is because
retryable errors are thought to be temporary and the scsi device will soon
recover from those errors. Normally, such retry policy is appropriate because
the device will soon recover from temporary error state.
But there is no guarantee that device is able to recover from error state
immediately. Some hardware error may prevent device from recovering.
Therefore hardware error can results in infinite command retry loop. In fact,
CHECK_CONDITION error with the sense-key = UNIT_ATTENTION caused infinite
retry loop in our environment. As the comments in kernel source code says,
UNIT_ATTENTION means the device must have been a power glitch and expected
to immediately recover from the state. But it seems that hardware error
caused permanent UNIT_ATTENTION error.

To solve the above problem, this patch introduces scsi device "failfast mode".
If failfast mode is enabled, retry counts of all scsi commands are limited to
scsi->allowed(== SD_MAX_RETRIES == 5). All commands are prohibited to retry
infinitely, and immediately fails when the retry count exceeds upper limit.
Failfast mode is useful on mission critical systems which are required
to keep running flawlessly because they need to failover to the secondary
system once they detect failures.
On default, failfast mode is disabled because failfast policy is not suitable
for most use cases which can accept I/O latency due to device hardware error.

To enable failfast mode(default disabled):
         # echo 1 > /sys/bus/scsi/devices/X:X:X:X/failfast
To disable:
         # echo 0 > /sys/bus/scsi/devices/X:X:X:X/failfast

Furthermore, I'm planning to make the upper limit count configurable.
Currently, I have two plans to implement it:
(1) set same upper limit count on all errors.
(2) set upper limit count on each error.
The first implementation is simple and easy to implement but not flexible.
Someone wants to set different upper limit count on each errors depends on the
scsi device they use. The second implementation satisfies such requirement
but can be too fine-grained and annoying to configure because scsi error
codes are so much. The default 5 times retry may too much on some errors but
too few on other errors.

Which would be the appropriate implementation?
Any comments or suggestions are welcome as usual.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/scsi_error.c  |   44 +++++++++++++++++++++++++++++++-------------
 drivers/scsi/scsi_lib.c    |   10 ++++++++++
 drivers/scsi/scsi_sysfs.c  |    8 +++-----
 include/scsi/scsi_device.h |    1 +
 4 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2150596..1b6a4b6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1442,7 +1442,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
  */
 int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
-	int rtn;
+	int rtn, disposition;
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -1492,12 +1492,14 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		goto maybe_retry;
+		disposition = NEEDS_RETRY;
+		goto limited_retry;
 	case DID_IMM_RETRY:
-		return NEEDS_RETRY;
-
+		disposition = NEEDS_RETRY;
+		goto retry;
 	case DID_REQUEUE:
-		return ADD_TO_MLQUEUE;
+		disposition = ADD_TO_MLQUEUE;
+		goto retry;
 	case DID_TRANSPORT_DISRUPTED:
 		/*
 		 * LLD/transport was disrupted during processing of the IO.
@@ -1506,7 +1508,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * based on its timers and recovery capablilities if
 		 * there are enough retries.
 		 */
-		goto maybe_retry;
+		disposition = NEEDS_RETRY;
+		goto limited_retry;
 	case DID_TRANSPORT_FAILFAST:
 		/*
 		 * The transport decided to failfast the IO (most likely
@@ -1524,7 +1527,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		/* fallthrough */
 	case DID_BUS_BUSY:
 	case DID_PARITY:
-		goto maybe_retry;
+		disposition = NEEDS_RETRY;
+		goto limited_retry;
 	case DID_TIME_OUT:
 		/*
 		 * when we scan the bus, we get timeout messages for
@@ -1566,17 +1570,21 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the empty queue handling to trigger a stall in the
 		 * device.
 		 */
-		return ADD_TO_MLQUEUE;
+		disposition = ADD_TO_MLQUEUE;
+		goto retry;
 	case GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case TASK_ABORTED:
-		goto maybe_retry;
+		disposition = NEEDS_RETRY;
+		goto limited_retry;
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
-		if (rtn == NEEDS_RETRY)
-			goto maybe_retry;
+		if (rtn == NEEDS_RETRY) {
+			disposition = NEEDS_RETRY;
+			goto limited_retry;
+		}
 		else if (rtn == TARGET_ERROR) {
 			/*
 			 * Need to modify host byte to signal a
@@ -1609,7 +1617,17 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 	return FAILED;
 
-      maybe_retry:
+retry:
+
+	/*
+	 * if failfast mode is enabled, all retryable commands are
+	 * retried only finite times to avoid infinite retry loop caused
+	 * by hardware error.
+	 */
+	if (!scmd->device->failfast)
+		return disposition;
+
+limited_retry:
 
 	/* we requeue for retry because the error was retryable, and
 	 * the request was not marked fast fail.  Note that above,
@@ -1617,7 +1635,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
 	if ((++scmd->retries) <= scmd->allowed
 	    && !scsi_noretry_cmd(scmd)) {
-		return NEEDS_RETRY;
+		return disposition;
 	} else {
 		/*
 		 * no more retries - report this one back to upper level.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 124392f..6145e00 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -989,6 +989,16 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	/*
+	 * if failfast mode is enabled, all retryable commands are
+	 * retried only finite times to avoid infinite retry loop caused
+	 * by hardware error.
+	 */
+	if (cmd->device->failfast) {
+		if (action != ACTION_FAIL && ++cmd->retries > cmd->allowed)
+			action = ACTION_FAIL;
+	}
+
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7e50061..c6dc5c6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -481,11 +481,8 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
 
-/* Currently we don't export bit fields, but we might in future,
- * so leave this code in */
-#if 0
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr_bit: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
@@ -523,7 +520,6 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 	} else
 		return -EINVAL;
 }
-#endif
 /*
  * Create the actual show/store functions and data structures.
  */
@@ -534,6 +530,7 @@ sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rw_attr_bit(failfast);
 
 /*
  * TODO: can we make these symlinks to the block layer ones?
@@ -758,6 +755,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_iodone_cnt.attr,
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
+	&dev_attr_failfast.attr,
 	REF_EVT(media_change),
 	NULL
 };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a44954c..f6f96b3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -160,6 +160,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned failfast:1;    /* Failfast mode enabled */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
