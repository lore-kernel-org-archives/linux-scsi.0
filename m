Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D805C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCIV4m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjCIVzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:54 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B2AF5A83;
        Thu,  9 Mar 2023 13:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398950; x=1709934950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1i4sqNn+3mjUau8eq/zzmlqAHqw+oYQkGo3JDQZfROE=;
  b=JB+T8ckYpZdaRHF/igpZs8Y2sMuVEjkoub4w2944PnKR0pZ3Nqgt/X/3
   OuOT2bcjskASkstLhKQ8lLtI9w3/E2BvDdtsa1k2mabqpxAWhb3d/Me2C
   S0U7vvONorhDKuctYrwvVK2ag5sj8tTICmjrLHr3HCoQyomniHmZEQBVc
   vk3ps2gF2UwhurdYU+VcuOe6oVsJ4j7Lbs0U7+5F0iCdzIg/G41knV6MO
   xl23f3Uz/2DP/JcVHELTxY36+ZErKGLkxhGIFwgRQBlg3cnZdwS1AFQUW
   p0CaIwbFrZhezF/aMSqjPDcLTYaXfdBSgK4evqf30NiGN1ikgYUNHRGQq
   w==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271013"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:50 +0800
IronPort-SDR: 0yVlf/yuIshtqFxTl3ARxVnZrzR94uQyRFCnXm9tOj26aoCbRrxdbmeHsVqHIznDez6hM7Goal
 3DZTDhhL3mggcbBmE0MkDF+PTXIz1cEqCYEm5vwdcfoFdlYAx/+cXB5uO3rrfH0pIC4yx+H8Sb
 SXV1rrfIGqOXQrVaLN5Dg3yZJUb4sbCR9FuVp3+7aJk2YlJYgD+jgSgYP3y596iZqqQDeuom/m
 RwEtx/fr4nfpBUBABsbUzjuOHx8jP/p/A8YZy6lHGPDEkHSfau5xctFgzqCqnDXbWImepQZP6U
 Nsc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:43 -0800
IronPort-SDR: tTiIOs8AcsVjZtIqbyJACIYchQBAcnxG99wRinwSbp9sZkRARbkpimgqOP+fRXGkkd1GfIqxaE
 4gJF8GTXM+hfK8vE3VujQ80JRx5I6blSN27turae4RMx+BK+d/gVFpnIlHLR5XrbO4u0Fxbe/M
 5IYchRm0KJ9C+TEoZeoONWOOeMr5qWbrzFkkDW+iO7EmuhORClPagyuoCfOnh3Z4EQkVhmY3BF
 EC7jNy+/dcBhTEbob0TpVkmOMymaGqKJJ/umayAeBsvwSZP69lnD/ToSOYAdaZHItt6F6uUj12
 K10=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:48 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 08/19] scsi: detect support for command duration limits
Date:   Thu,  9 Mar 2023 22:55:00 +0100
Message-Id: <20230309215516.3800571-9-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the function scsi_cdl_check() to detect if a device supports
command duration limits (CDL). Support for the READ 16, WRITE 16,
READ 32 and WRITE 32 commands are checked using the function
scsi_report_opcode() to probe the rwcdlp and cdlp bits as they indicate
the mode page defining the command duration limits descriptors that
apply to the command being tested.

If any of these commands support CDL, the field cdl_supported of
struct scsi_device is set to 1 to indicate that the device supports CDL.

Support for CDL for a device is advertizes through sysfs using the new
cdl_supported device attribute. This attribute value is 1 for a device
supporting CDL and 0 otherwise.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/ABI/testing/sysfs-block-device |  9 +++
 drivers/scsi/scsi.c                          | 81 ++++++++++++++++++++
 drivers/scsi/scsi_scan.c                     |  3 +
 drivers/scsi/scsi_sysfs.c                    |  2 +
 include/scsi/scsi_device.h                   |  3 +
 5 files changed, 98 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index 7ac7b19b2f72..ee3610a25845 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -95,3 +95,12 @@ Description:
 		This file does not exist if the HBA driver does not implement
 		support for the SATA NCQ priority feature, regardless of the
 		device support for this feature.
+
+
+What:		/sys/block/*/device/cdl_supported
+Date:		Mar, 2023
+KernelVersion:	v6.4
+Contact:	linux-scsi@vger.kernel.org
+Description:
+		(RO) Indicates if the device supports the command duration
+		limits feature found in some ATA and SCSI devices.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 43ef70556027..e233eb6cce11 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -560,6 +560,87 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 }
 EXPORT_SYMBOL(scsi_report_opcode);
 
+#define SCSI_CDL_CHECK_BUF_LEN	64
+
+static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
+			       unsigned char *buf)
+{
+	int ret;
+	u8 cdlp;
+
+	/* Check operation code */
+	ret = scsi_report_opcode(sdev, buf, SCSI_CDL_CHECK_BUF_LEN, opcode, sa);
+	if (ret <= 0)
+		return false;
+
+	if ((buf[1] & 0x03) != 0x03)
+		return false;
+
+	/* See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES */
+	cdlp = (buf[1] & 0x18) >> 3;
+	if (buf[0] & 0x01) {
+		/* rwcdlp == 1 */
+		switch (cdlp) {
+		case 0x01:
+			/* T2A page */
+			return true;
+		case 0x02:
+			/* T2B page */
+			return true;
+		}
+	} else {
+		/* rwcdlp == 0 */
+		switch (cdlp) {
+		case 0x01:
+			/* A page */
+			return true;
+		case 0x02:
+			/* B page */
+			return true;
+		}
+	}
+
+	return false;
+}
+
+/**
+ * scsi_cdl_check - Check if a SCSI device supports Command Duration Limits
+ * @sdev: The device to check
+ */
+void scsi_cdl_check(struct scsi_device *sdev)
+{
+	bool cdl_supported;
+	unsigned char *buf;
+
+	buf = kmalloc(SCSI_CDL_CHECK_BUF_LEN, GFP_KERNEL);
+	if (!buf) {
+		sdev->cdl_supported = 0;
+		return;
+	}
+
+	/* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
+	cdl_supported =
+		scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
+		scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
+		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
+		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
+	if (cdl_supported) {
+		/*
+		 * We have CDL support: force the use of READ16/WRITE16.
+		 * READ32 and WRITE32 will be used for devices that support
+		 * the T10_PI_TYPE2_PROTECTION protection type.
+		 */
+		sdev->use_16_for_rw = 1;
+		sdev->use_10_for_rw = 0;
+
+		sdev->cdl_supported = 1;
+	} else {
+		sdev->cdl_supported = 0;
+	}
+
+	kfree(buf);
+}
+
 /**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4e842d79de31..0b703c136266 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1084,6 +1084,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (sdev->scsi_level >= SCSI_3)
 		scsi_attach_vpd(sdev);
 
+	scsi_cdl_check(sdev);
+
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 	sdev->sdev_bflags = *bflags;
@@ -1621,6 +1623,7 @@ void scsi_rescan_device(struct device *dev)
 	device_lock(dev);
 
 	scsi_attach_vpd(sdev);
+	scsi_cdl_check(sdev);
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ee28f73af4d4..4994148e685b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -670,6 +670,7 @@ sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr (cdl_supported, "%d\n");
 
 static ssize_t
 sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
@@ -1300,6 +1301,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_preferred_path.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
+	&dev_attr_cdl_supported.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9564b47cf2ab..1cce42ad9f5c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -216,6 +216,8 @@ struct scsi_device {
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
 
+	unsigned cdl_supported:1;	/* Command duration limits supported */
+
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
@@ -362,6 +364,7 @@ extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
+void scsi_cdl_check(struct scsi_device *sdev);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
-- 
2.39.2

