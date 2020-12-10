Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42567C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16F723DC4
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404553AbgLJUjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:39:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55295 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404626AbgLJUgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632600; x=1639168600;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qr1uoSVRwOkhUWNa7Bs1gXPzqwPTf5qlOU4iHhcyRsM=;
  b=s3Qo+L/LqQAyUkPv/joMShOwvo8+5mGIDd2gDVpre9oQxhYNtQPtisaL
   wOGbtQWHld5EBLm20QOS4kdJknwuB8qYsiiYHkTDBBTxnccanoGZ+Sjm0
   1ef5igAk2+qDYGluVhWD5r96aRGCXjhguby+P3J0nxBwUo1CSykjOIqJf
   07pT8mBThwQV/hjz4jh9apunf/SEjHF3TM+n718qpSk+DbPEy08yMUQp6
   NaACzmH3d0y2lNL7AfDh3EsDIxMqfgYlM8hNRaSDMpedHhk2ZgxNVl56+
   3ElAZkHQz2xbtDlfo7CRwFyy/6SJIE6fRCJMGwyqYZJjvhkeeF8SzYBIH
   Q==;
IronPort-SDR: s47OjpnVWvp9zKsqa4EWIvOmlNLId1Tvh15FdKUZ2ZSj8AcDBbp3BJh85Uk+eOHdsH+YE8140C
 fik6LTPp4Gc1BykMPwGx3sArdd1aDhN5AlX5OwW87nfzJZMi0sKMvfSCNdO91ugQ+kGzfKQ5V9
 XGu/TKMsVzfI94MsHqzrNBoK3tyyfkfQkzZJJx9UwIKm//xAk5YQ6odillq6NUscQ+gUYZvvSs
 z9M/5W25elYXOzuYMnPlNYTU9T8jjQzW9KdzCDlcU2BXciN6JZbY/4wHbRoe4Wmbcf65p319bP
 7e0=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="36986733"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:24 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:24 -0700
Subject: [PATCH V3 11/25] smartpqi: add host level stream detection enable
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:24 -0600
Message-ID: <160763252438.26927.15696823365021360866.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Allow R5/R6 stream detection to be disabled/enabled.
  using sysfs entry enable_stream_detection.

Example usage:

lsscsi
[2:2:0:0]    storage Adaptec  3258P-32i /e     0010
 ^
 |
 +---- NOTE: here host is host2

find /sys -name \*enable_stream\*
/sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:39:00.0/host2/scsi_host/host2/enable_stream_detection
/sys/devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host3/scsi_host/host3/enable_stream_detection

Current stream detection:
cat /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:39:00.0/host2/scsi_host/host2/enable_stream_detection
1

Turn off stream detection:
echo 0 > /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:39:00.0/host2/scsi_host/host2/enable_stream_detection

Turn on stream detection:
echo 1 > /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:39:00.0/host2/scsi_host/host2/enable_stream_detection

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 96383d047a88..9a449bbc1898 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6724,6 +6724,34 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
 	return -EINVAL;
 }
 
+static ssize_t pqi_host_enable_stream_detection_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+
+	return scnprintf(buffer, 10, "%hhx\n",
+			ctrl_info->enable_stream_detection);
+}
+
+static ssize_t pqi_host_enable_stream_detection_store(struct device *dev,
+	struct device_attribute *attr, const char *buffer, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+	u8 set_stream_detection = 0;
+
+	if (kstrtou8(buffer, 0, &set_stream_detection))
+		return -EINVAL;
+
+	if (set_stream_detection > 0)
+		set_stream_detection = 1;
+
+	ctrl_info->enable_stream_detection = set_stream_detection;
+
+	return count;
+}
+
 static ssize_t pqi_host_enable_r5_writes_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
@@ -6786,6 +6814,9 @@ static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
 static DEVICE_ATTR(lockup_action, 0644, pqi_lockup_action_show,
 	pqi_lockup_action_store);
+static DEVICE_ATTR(enable_stream_detection, 0644,
+	pqi_host_enable_stream_detection_show,
+	pqi_host_enable_stream_detection_store);
 static DEVICE_ATTR(enable_r5_writes, 0644,
 	pqi_host_enable_r5_writes_show, pqi_host_enable_r5_writes_store);
 static DEVICE_ATTR(enable_r6_writes, 0644,
@@ -6799,6 +6830,7 @@ static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_vendor,
 	&dev_attr_rescan,
 	&dev_attr_lockup_action,
+	&dev_attr_enable_stream_detection,
 	&dev_attr_enable_r5_writes,
 	&dev_attr_enable_r6_writes,
 	NULL

