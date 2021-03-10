Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786A9C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABEE64FB3
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhCJUCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22617 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhCJUB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406517; x=1646942517;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBMUaUMicppnIbKd7+RJ+PkZhNq1eyCxXIlOsZouwwI=;
  b=QqmNXkQJHsXmj+hb0GVzsgCo4cXjwgcnBgWXtBgCSZjIbApNVaMQ9Pog
   6jZ/utHg1UhuerReuuv1ItDoFCxD5trSSOViB4jlftB7iX2z9G5krhoWB
   o6dHx5qymOltaGRKaiTg8wrgOoFdyr49wf0l493Eh9PXCUvekGwY75H5O
   J2nm/p3eYqcvD/DV1s0jCAdi6ozQ8S+nA/FpnW3uDmihBuKTJY2R91Hfz
   boGre+oVgk95kbI2sCCATdxRk/TAxoOFtJlyHUAac+8Cf4UU2Mm89Tr9Z
   TfRZzNnMpdCqKVY1b2K5H70xaxAoEA/WvCzlUeCKI1Xm8bjvnwNFsBnR9
   A==;
IronPort-SDR: 6bXb5DoBNW2+/GNCUD0SDWuO3Y3CyUTOiWgR9GYFB3l0+wgu/FZ+RnLr+w8revaH6hODsvvMz+
 TV6c+aHpGpCfKTZ2fBbnaz4P2sNxGBXtl449cp+8BUmrPPpnk18oxk4ozCbO6W4xDby5KUEtO0
 NfZjlSOhcYGvsH48qSwRBD/vaZtTP00R6gSzFBqj07X7o7qMkWrWN+yFNNEKXE9T+sQDQx5oCS
 7yKicQh2G/W3mpkNTXw+7qeGffb89jiGaATzwmNnIrt58JHGKKXUlKRpmYx8MOVMB6fncCTI2T
 Dzg=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389597"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:01:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:01:55 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:01:55 -0700
Subject: [PATCH V4 12/31] smartpqi: add host level stream detection enable
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:01:55 -0600
Message-ID: <161540651522.19430.5706835202837667563.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
index c2f366c614d7..991883ada641 100644
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

