From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/4] scsi: Added support for adapter and firmware reset
Date: Fri, 12 Aug 2011 02:51:28 -0700
Message-ID: <1313142689-13388-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1313142689-13388-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:47488
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab1HLKBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 06:01:21 -0400
In-Reply-To: <1313142689-13388-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Added new sysfs attr 'host_reset' in scsi_sysfs.c to
perform adapter or firmware reset as suggested by
Mike Christie here:
http://marc.info/?l=linux-scsi&m=127359347111167&w=2

user/application can write "adapter" or "firmware" on
this attr and it will call newly added function hook
in scsi_host_template to call LDD adapter or firmware
reset implementation.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_sysfs.c |   38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h  |   13 +++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e0bd3f7..04c2a27 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -246,6 +246,43 @@ show_shost_active_mode(struct device *dev,
 
 static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
 
+static int check_reset_type(char *str)
+{
+	if (strncmp(str, "adapter", 10) == 0)
+		return SCSI_ADAPTER_RESET;
+	else if (strncmp(str, "firmware", 10) == 0)
+		return SCSI_FIRMWARE_RESET;
+	else
+		return 0;
+}
+
+static ssize_t
+store_host_reset(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct scsi_host_template *sht = shost->hostt;
+	int ret = -EINVAL;
+	char str[10];
+	int type;
+
+	sscanf(buf, "%s", str);
+	type = check_reset_type(str);
+
+	if (!type)
+		goto exit_store_host_reset;
+
+	if (sht->host_reset)
+		ret = sht->host_reset(shost, type);
+
+exit_store_host_reset:
+	if (ret == 0)
+		ret = count;
+	return ret;
+}
+
+static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -272,6 +309,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_active_mode.attr,
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
+	&dev_attr_host_reset.attr,
 	NULL
 };
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f1f2644..fc22ad9 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -355,6 +355,19 @@ struct scsi_host_template {
 	 */
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
+	/* This is an optional routine that allows transport to initiate
+	 * LLD adapter or firmware reset using sysfs attribute.
+	 *
+	 * Return values: 0 on success, -ve value on failure.
+	 *
+	 * Status: OPTIONAL
+	 */
+
+	int (*host_reset)(struct Scsi_Host *shost, int reset_type);
+#define SCSI_ADAPTER_RESET	1
+#define SCSI_FIRMWARE_RESET	2
+
+
 	/*
 	 * Name of proc directory
 	 */
-- 
1.7.6


