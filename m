From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: [PATCH v2] scsi: Add 'retry_timeout' to avoid infinite command retry
Date: Fri, 07 Feb 2014 09:22:41 +0900
Message-ID: <20140207002241.11465.87367.stgit@ltc223.sdl.hitachi.co.jp>
References: <52F30B5E.8020202@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52F30B5E.8020202@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Currently, scsi error handling in scsi_io_completion() tries to
unconditionally requeue scsi command when device keeps some error state.
For example, UNIT_ATTENTION causes infinite retry with
action == ACTION_RETRY.
This is because retryable errors are thought to be temporary and the scsi
device will soon recover from those errors. Normally, such retry policy is
appropriate because the device will soon recover from temporary error state.

But there is no guarantee that device is able to recover from error state
immediately. Actually, we've experienced an infinite retry on some hardware.
Therefore hardware error can results in infinite command retry loop.

This patch adds 'retry_timeout' sysfs attribute which limits the retry time
of each scsi command. This attribute is located in scsi sysfs directory
for example "/sys/bus/scsi/devices/X:X:X:X/" and value is in seconds.
Once scsi command retry time is longer than this timeout,
the command is treated as failure. 'retry_timeout' is set to '0' by default
which means no timeout set.

Usage:
 - To set retry timeout(set retry_timeout to 30 sec):
	# echo 30 > /sys/bus/scsi/devices/X:X:X:X/retry_timeout

Changes in v2:
 - check retry timeout in scsi_io_completion() instead of scsi_softirq_done()

Signed-off-by: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/scsi_lib.c    |   22 ++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   |    1 +
 drivers/scsi/scsi_sysfs.c  |   32 ++++++++++++++++++++++++++++++++
 include/scsi/scsi.h        |    1 +
 include/scsi/scsi_device.h |    1 +
 5 files changed, 57 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..813b287 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -741,6 +741,24 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 }
 
 /*
+ * Check if scsi command excessed retry timeout
+ */
+static int scsi_retry_timed_out(struct scsi_cmnd *cmd)
+{
+	unsigned int retry_timeout;
+
+	retry_timeout = cmd->device->retry_timeout;
+	if (retry_timeout &&
+	    time_before(cmd->jiffies_at_alloc + retry_timeout, jiffies)) {
+		scmd_printk(KERN_ERR, cmd, "retry timeout, waited %us\n",
+			    retry_timeout/HZ);
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -989,6 +1007,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	if ((action == ACTION_RETRY || action == ACTION_DELAYED_RETRY) &&
+	    scsi_retry_timed_out(cmd))
+		action = ACTION_FAIL;
+
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..4ab044a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -925,6 +925,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->no_dif = 1;
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
+	sdev->retry_timeout = SCSI_DEFAULT_RETRY_TIMEOUT;
 
 	if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8ff62c2..eaa2118 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -627,6 +627,37 @@ sdev_store_eh_timeout(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(eh_timeout, S_IRUGO | S_IWUSR, sdev_show_eh_timeout, sdev_store_eh_timeout);
 
 static ssize_t
+sdev_show_retry_timeout(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%u\n", sdev->retry_timeout / HZ);
+}
+
+static ssize_t
+sdev_store_retry_timeout(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	unsigned int retry_timeout;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	sdev = to_scsi_device(dev);
+	err = kstrtouint(buf, 10, &retry_timeout);
+	if (err)
+		return err;
+	sdev->retry_timeout = retry_timeout * HZ;
+
+	return count;
+}
+static DEVICE_ATTR(retry_timeout, S_IRUGO | S_IWUSR,
+		   sdev_show_retry_timeout, sdev_store_retry_timeout);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
@@ -797,6 +828,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_timeout.attr,
 	&dev_attr_eh_timeout.attr,
+	&dev_attr_retry_timeout.attr,
 	&dev_attr_iocounterbits.attr,
 	&dev_attr_iorequest_cnt.attr,
 	&dev_attr_iodone_cnt.attr,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66d42ed..545408d 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -16,6 +16,7 @@ struct scsi_cmnd;
 
 enum scsi_timeouts {
 	SCSI_DEFAULT_EH_TIMEOUT		= 10 * HZ,
+	SCSI_DEFAULT_RETRY_TIMEOUT	= 0,	/* disabled by default */
 };
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..04fc5ee 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -121,6 +121,7 @@ struct scsi_device {
 				 * pass settings from slave_alloc to scsi
 				 * core. */
 	unsigned int eh_timeout; /* Error handling timeout */
+	unsigned int retry_timeout;	/* Command retry timeout */
 	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
