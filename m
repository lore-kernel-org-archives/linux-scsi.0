Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9769FC74A4B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCIV4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbjCIVzz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:55 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1762EE765;
        Thu,  9 Mar 2023 13:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398953; x=1709934953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h9g1jLGd6LxgCdMzZ9k85RB7pGJOXNOjT0fPf0VF2wc=;
  b=LI2yMZajO5LSlWlIo0KsAA8PTaqcKI+ouVuoRiFZ3ruCjXNJTh4EcC+I
   xPgydwTnZd3rPMYg81IdVajId4UmUTw98uEt1gAfDeKVCmYksyS4XuLII
   qP3mUCmyDUGyMtsARcGHFIqPvQa58D4+wgSjcAjSIvMMcyng//iTsE9wc
   PUq8CEW8on0qzpfFiIhaSXFjCo50JnnS43vMqXGB5dD66ON3mfawCFkkC
   V8u0ycUN5UY/6tB5T3Yc7DoT8IDCjyTtX6Q+y5LFf/vKl8LYAuwRNB6aO
   +KCMG/W513O0Hk3Da4R71LNUskMjNghjGQQk0DYuE4lE5qyW1kDGQpe5k
   A==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271021"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:53 +0800
IronPort-SDR: ctiV8lhgQExAV1Lys63D7Vz8/yFndEqRAbFzQ9RWo0l1f+jn09u/yJKXPLDPC6OzRrr3fd5Upv
 Pc0zXXJVh66LsfZXqsFWvNMRgkTtj7KMxjTT+gVINezw/thbky3N2S9mxVeH14XKCWvkc16JgJ
 vxcl+gDHyaVztAR0dl+alsQkv7IJ7J8C+PVD9VjFV59aFyZQUm/hIjI4JV49QsGZQryWtgyVmp
 5WRl/SLkx5V+tOChJ4Aw5USeFwgYZsYy3VgPxK8KCZwiAKoP+Y7JhRYY1O5ujjSxO0zKVqO0RM
 GRA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:46 -0800
IronPort-SDR: Jv4H9MqlpqtlCusoiUpHUJQnbq9wdkQUdIz+IuCPrwITDfvCMdoiTUkHZgRSBlrb9FHgHDJ3No
 htn6LhpgsOywmS4Yfm4yioLktc43bdcxICnxOYbx9KTXv0oa01uOrQ42IVXuXoWCKICzMX4T8S
 TyMA1lmsoFs0tYmT/cy/XIkc1JgwIkarTQt/Exl8sBMEiPxdyNKv3K7d7uD90Jq6cZBD8EVLpC
 jhMJcvfV2jPYyi7DoWYPkhxdSIXYBV+hkZOobSa5FaW2vfI7DGPC+Qsho8EJ9xCKw9Uhoocbkp
 vAk=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:52 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 09/19] scsi: allow enabling and disabling command duration limits
Date:   Thu,  9 Mar 2023 22:55:01 +0100
Message-Id: <20230309215516.3800571-10-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Add the sysfs scsi device attribute cdl_enable to allow a user to turn
enable or disable a device command duration limits feature. CDL is
disabled by default. This feature must be explicitly enabled by a user by
setting the cdl_enable attribute to 1.

The new function scsi_cdl_enable() does not do anything beside setting
the cdl_enable field of struct scsi_device in the case of a (real) scsi
device (e.g. a SAS HDD). For ATA devices, the command duration limits
feature needs to be enabled/disabled using the ATA feature sub-page of
the control mode page. To do so, the scsi_cdl_enable() function checks
if this mode page is supported using scsi_mode_sense(). If it is,
scsi_mode_select() is used to enable and disable CDL.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/ABI/testing/sysfs-block-device | 13 ++++
 drivers/scsi/scsi.c                          | 62 ++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                    | 31 ++++++++++
 include/scsi/scsi_device.h                   |  2 +
 4 files changed, 108 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index ee3610a25845..626d48ac504b 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -104,3 +104,16 @@ Contact:	linux-scsi@vger.kernel.org
 Description:
 		(RO) Indicates if the device supports the command duration
 		limits feature found in some ATA and SCSI devices.
+
+
+What:		/sys/block/*/device/cdl_enable
+Date:		Mar, 2023
+KernelVersion:	v6.4
+Contact:	linux-scsi@vger.kernel.org
+Description:
+		(RW) For a device supporting the command duration limits
+		feature, write to the file to turn on or off the feature.
+		By default this feature is turned off.
+		Writing "1" to this file enables the use of command duration
+		limits for read and write commands in the kernel and turns on
+		the feature on the device. Writing "0" disables the feature.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e233eb6cce11..385a09a387b2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -641,6 +641,68 @@ void scsi_cdl_check(struct scsi_device *sdev)
 	kfree(buf);
 }
 
+/**
+ * scsi_cdl_enable - Enable or disable a SCSI device supports for Command
+ *                   Duration Limits
+ * @sdev: The target device
+ * @enable: the target state
+ */
+int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
+{
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_vpd *vpd;
+	bool is_ata = false;
+	char buf[64];
+	int ret;
+
+	if (!sdev->cdl_supported)
+		return -EOPNOTSUPP;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg89);
+	if (vpd)
+		is_ata = true;
+	rcu_read_unlock();
+
+	/*
+	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
+	 */
+	if (is_ata) {
+		char *buf_data;
+		int len;
+
+		ret = scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
+				      5 * HZ, 3, &data, NULL);
+		if (ret)
+			return -EINVAL;
+
+		/* Enable CDL using the ATA feature page */
+		len = min_t(size_t, sizeof(buf),
+			    data.length - data.header_length -
+			    data.block_descriptor_length);
+		buf_data = buf + data.header_length +
+			data.block_descriptor_length;
+		if (enable)
+			buf_data[4] = 0x02;
+		else
+			buf_data[4] = 0;
+
+		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
+				       &data, &sshdr);
+		if (ret) {
+			if (scsi_sense_valid(&sshdr))
+				scsi_print_sense_hdr(sdev,
+					dev_name(&sdev->sdev_gendev), &sshdr);
+			return ret;
+		}
+	}
+
+	sdev->cdl_enable = enable;
+
+	return 0;
+}
+
 /**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4994148e685b..9a54b2c0fee7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1222,6 +1222,36 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
 		   sdev_show_queue_ramp_up_period,
 		   sdev_store_queue_ramp_up_period);
 
+static ssize_t sdev_show_cdl_enable(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sysfs_emit(buf, "%d\n", (int)sdev->cdl_enable);
+}
+
+static ssize_t sdev_store_cdl_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int ret;
+	bool v;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	ret = scsi_cdl_enable(to_scsi_device(dev), v);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR(cdl_enable, S_IRUGO | S_IWUSR,
+		   sdev_show_cdl_enable, sdev_store_cdl_enable);
+
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
@@ -1302,6 +1332,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	&dev_attr_cdl_supported.attr,
+	&dev_attr_cdl_enable.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1cce42ad9f5c..970467d451bf 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -217,6 +217,7 @@ struct scsi_device {
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
 
 	unsigned cdl_supported:1;	/* Command duration limits supported */
+	unsigned cdl_enable:1;		/* Enable/disable Command duration limits */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
@@ -365,6 +366,7 @@ extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
+int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
-- 
2.39.2

