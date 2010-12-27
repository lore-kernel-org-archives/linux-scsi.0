From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/8] [SCSI] scst: Split version and stats attributes
Date: Mon, 27 Dec 2010 14:37:30 +0100
Message-ID: <201012271437.30550.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:51858 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0L0Nhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:37:38 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Split the scst_local 'stats' sysfs attribute into three attributes such
that the "one value per file" rule is honered. The three new attributes
are: aborts, device_resets and target_resets. Export the scst_local
release date via the module information instead of sysfs. Remove the
build options from the 'version' attribute of scst_local and scst since
this duplicates information already available in the kernel .config.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>
---
 Documentation/ABI/stable/sysfs-driver-scst_target  |    9 +---
 .../ABI/stable/sysfs-driver-scst_target-scst_local |   23 ++++++---
 drivers/scst/scst_local/scst_local.c               |   49 +++++++++++--------
 drivers/scst/scst_sysfs.c                          |   47 +------------------
 4 files changed, 47 insertions(+), 81 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target b/Documentation/ABI/stable/sysfs-driver-scst_target
index 0c2b6a1..ca8944a 100644
--- a/Documentation/ABI/stable/sysfs-driver-scst_target
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target
@@ -48,12 +48,7 @@ What:		/sys/bus/scst_target/drivers/*/version
 Date:		December 2010
 Contact:	Bart Van Assche <bvanassche@acm.org>
 Description:
-		Target driver version and build options. The driver version
-		and build date appear on the first line separated by a
-		slash and the build options appear on subsequent
-		lines. Read-only. An example:
+		Target driver version. Read-only. An example:
 
 		$ cat /sys/bus/scst_target/drivers/scst_local/version
-		1.0.0/20100910
-		TRACING
-		DEBUG
+		1.0.0
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
index 56e50f7..3ea28dc 100644
--- a/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
@@ -1,11 +1,20 @@
-What:		/sys/bus/scst_target/drivers/scst_local/stats
+What:		/sys/bus/scst_target/drivers/scst_local/aborts
 Date:		December 2010
 Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
 Description:
-		Statistics about processing of SCSI commands received via the
-		Linux SCSI initiator: the number of SCSI commands that have
-		been aborted, the number of SCSI device resets and the number
-		of SCSI target resets. Read-only. An example:
+		Number of SCSI commands that have been aborted by the SCSI
+		initiator. Read-only.
 
-		# cat /sys/bus/scst_target/drivers/scst_local/stats
-		Aborts: 0, Device Resets: 0, Target Resets: 0
+What:		/sys/bus/scst_target/drivers/scst_local/device_resets
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		Number of SCSI device resets that have been performed by the
+		SCSI initiator. Read-only.
+
+What:		/sys/bus/scst_target/drivers/scst_local/target_resets
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		Number of SCSI target resets that have been performed by the
+		SCSI initiator. Read-only.
diff --git a/drivers/scst/scst_local/scst_local.c b/drivers/scst/scst_local/scst_local.c
index 14c8fd9..b0c989a 100644
--- a/drivers/scst/scst_local/scst_local.c
+++ b/drivers/scst/scst_local/scst_local.c
@@ -54,7 +54,7 @@ static unsigned long scst_local_trace_flag = SCST_LOCAL_DEFAULT_LOG_FLAGS;
 #define FALSE 0
 
 #define SCST_LOCAL_VERSION "1.0.0"
-static const char *scst_local_version_date = "20100910";
+#define SCST_LOCAL_VERSION_DATE "20100910"
 
 /* Some statistics */
 static atomic_t num_aborts = ATOMIC_INIT(0);
@@ -128,6 +128,7 @@ MODULE_AUTHOR("Richard Sharpe, Vladislav Bolkhovitin + ideas from SCSI_DEBUG");
 MODULE_DESCRIPTION("SCSI+SCST local adapter driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(SCST_LOCAL_VERSION);
+MODULE_INFO(release_date, SCST_LOCAL_VERSION_DATE);
 
 static int scst_local_get_sas_transport_id(struct scst_local_sess *sess,
 	uint8_t **transport_id, int *len)
@@ -222,38 +223,44 @@ out:
 
 static ssize_t scst_local_version_show(struct device_driver *drv, char *buf)
 {
-	sprintf(buf, "%s/%s\n", SCST_LOCAL_VERSION, scst_local_version_date);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", SCST_LOCAL_VERSION);
+}
 
-#ifdef CONFIG_SCST_EXTRACHECKS
-	strcat(buf, "EXTRACHECKS\n");
-#endif
+static struct driver_attribute scst_local_version_attr =
+	__ATTR(version, S_IRUGO, scst_local_version_show, NULL);
 
-#ifdef CONFIG_SCST_TRACING
-	strcat(buf, "TRACING\n");
-#endif
+static ssize_t scst_local_aborts_show(struct device_driver *drv, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%u\n", atomic_read(&num_aborts));
+}
 
-#ifdef CONFIG_SCST_DEBUG
-	strcat(buf, "DEBUG\n");
-#endif
-	return strlen(buf);
+static struct driver_attribute scst_local_aborts_attr =
+	__ATTR(aborts, S_IRUGO, scst_local_aborts_show, NULL);
+
+static ssize_t scst_local_device_resets_show(struct device_driver *drv,
+					     char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%u\n", atomic_read(&num_dev_resets));
 }
 
-static struct driver_attribute scst_local_version_attr =
-	__ATTR(version, S_IRUGO, scst_local_version_show, NULL);
+static struct driver_attribute scst_local_device_resets_attr =
+	__ATTR(device_resets, S_IRUGO, scst_local_device_resets_show, NULL);
 
-static ssize_t scst_local_stats_show(struct device_driver *drv, char *buf)
+static ssize_t scst_local_target_resets_show(struct device_driver *drv,
+					     char *buf)
 {
-	return sprintf(buf, "Aborts: %d, Device Resets: %d, Target Resets: %d",
-		atomic_read(&num_aborts), atomic_read(&num_dev_resets),
-		atomic_read(&num_target_resets));
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 atomic_read(&num_target_resets));
 }
 
-static struct driver_attribute scst_local_stats_attr =
-	__ATTR(stats, S_IRUGO, scst_local_stats_show, NULL);
+static struct driver_attribute scst_local_target_resets_attr =
+	__ATTR(target_resets, S_IRUGO, scst_local_target_resets_show, NULL);
 
 static const struct driver_attribute *scst_local_tgtt_attrs[] = {
 	&scst_local_version_attr,
-	&scst_local_stats_attr,
+	&scst_local_aborts_attr,
+	&scst_local_device_resets_attr,
+	&scst_local_target_resets_attr,
 	NULL,
 };
 
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 23cba83..05344cc 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -3611,52 +3611,7 @@ out:
 static ssize_t scst_version_show(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
-	sprintf(buf, "%s\n", SCST_VERSION_STRING);
-
-#ifdef CONFIG_SCST_STRICT_SERIALIZING
-	strcat(buf, "STRICT_SERIALIZING\n");
-#endif
-
-#ifdef CONFIG_SCST_EXTRACHECKS
-	strcat(buf, "EXTRACHECKS\n");
-#endif
-
-#ifdef CONFIG_SCST_TRACING
-	strcat(buf, "TRACING\n");
-#endif
-
-#ifdef CONFIG_SCST_DEBUG
-	strcat(buf, "DEBUG\n");
-#endif
-
-#ifdef CONFIG_SCST_DEBUG_TM
-	strcat(buf, "DEBUG_TM\n");
-#endif
-
-#ifdef CONFIG_SCST_DEBUG_RETRY
-	strcat(buf, "DEBUG_RETRY\n");
-#endif
-
-#ifdef CONFIG_SCST_DEBUG_OOM
-	strcat(buf, "DEBUG_OOM\n");
-#endif
-
-#ifdef CONFIG_SCST_DEBUG_SN
-	strcat(buf, "DEBUG_SN\n");
-#endif
-
-#ifdef CONFIG_SCST_USE_EXPECTED_VALUES
-	strcat(buf, "USE_EXPECTED_VALUES\n");
-#endif
-
-#ifdef CONFIG_SCST_TEST_IO_IN_SIRQ
-	strcat(buf, "TEST_IO_IN_SIRQ\n");
-#endif
-
-#ifdef CONFIG_SCST_STRICT_SECURITY
-	strcat(buf, "STRICT_SECURITY\n");
-#endif
-	return strlen(buf);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", SCST_VERSION_STRING);
 }
 
 static struct device_attribute scst_mgmt_attr =
-- 
1.7.1

