Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EADC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB93464F8B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCKUQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62215 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhCKUQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493775; x=1647029775;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WIgMLzJQYUpTKdvrrhk5DcUZJ5abs0mH2ugTLpxCxYg=;
  b=e/g4spjmpey0cmYBgB1F9e+MoPBYP2TSWng22kUZFWX8NFCqaWjxDWmD
   XXafrv3Eh1WLtbSrdM3M//g6UvRGop4t5+Vc8851RSAxm29c60qkZlYM/
   aaJ7O+IXOjeDnqKtV4e2/Va6QbZYDfe9rlzTF4f+RspZAYl8zwhBa+Iwf
   IU47bM8HsRSmtiap1H8prKz0r/t82wuoWn7S8j9ndv4Fj7JyA6Klqdhn1
   lEPv9c1uH75mFVhidsbrRnwanQS29rIujFEfKuBYyh/eUJ6r5uz9Z03C0
   eWsiyQ7b5v8O3lUPhDLTgEiD3oqJ8B0xDf06NuDRzwn2odt3AHv/wHLm8
   w==;
IronPort-SDR: F3XeLM5OcsHoE3vKeGjFQbaO0VVmj9sJ0UvthlLuTGfw7SXRj6OCZrgqKjNv+1igKulXISWlTj
 IjudUvY5z3HW7nfBebS2wHbyp11TOGfntS9wtFUlIUdRDWm6yQBTug6nzO8O2RWK4eOF4L7qzz
 FChZs7qU9CL2l65NrY4aqP8fjmV1P4jH6LvlC/rgVYC5BrgkukX5oN7YKG05zR91+9+6yH0JQk
 TpRtxqghGQxTV5DKva7GahQCpf+qhKkHxP8UWo6EScooyosg4DMOCwudD3/1cvemO7AakmCnmL
 lVE=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112888382"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:03 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:02 -0700
Subject: [PATCH V5 12/31] smartpqi: add host level stream detection enable
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:02 -0600
Message-ID: <161549376281.25025.1132304698441513738.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 27bd3d9a3810..dce832f2614a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6696,6 +6696,34 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
 	return -EINVAL;
 }
 
+static ssize_t pqi_host_enable_stream_detection_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
+
+	return scnprintf(buffer, 10, "%x\n",
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
@@ -6758,6 +6786,9 @@ static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
 static DEVICE_ATTR(lockup_action, 0644, pqi_lockup_action_show,
 	pqi_lockup_action_store);
+static DEVICE_ATTR(enable_stream_detection, 0644,
+	pqi_host_enable_stream_detection_show,
+	pqi_host_enable_stream_detection_store);
 static DEVICE_ATTR(enable_r5_writes, 0644,
 	pqi_host_enable_r5_writes_show, pqi_host_enable_r5_writes_store);
 static DEVICE_ATTR(enable_r6_writes, 0644,
@@ -6771,6 +6802,7 @@ static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_vendor,
 	&dev_attr_rescan,
 	&dev_attr_lockup_action,
+	&dev_attr_enable_stream_detection,
 	&dev_attr_enable_r5_writes,
 	&dev_attr_enable_r6_writes,
 	NULL

