Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9360BC4361A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAAC22C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgLDXCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:02:51 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:45753 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgLDXCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:02:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122970; x=1638658970;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BeGyAEb7MMOkxayLp9BSFwHQPHKdIa+beHKD1giNJSM=;
  b=qUHAnLrSmuOfobLnk/Av0tUM9UVAv7YJbj5OkH3gagqFrnoQspnQf2xZ
   tyiUUh/TAepoQRC37N8woiEFtcVTg9vgvfz9ncM6gSnH3ozJRBHfOjheS
   DHfWPQ/DYwq6ZVvCcuvLrlCRp/R7uo4T0ATF8lR8tEKA/byt6OgShAoYT
   lKSdn2dLa/G6p0Esz5hDcMhPBm0c7z7DGaPvnGUz5NLKSIStPVhrExT99
   K4jb7o2CvgyQ8+d1WwHix3XTup9enJy+FgIThzvf7taa5Zs7mOrFm02lu
   Whng91DugctQdUu4p5z3+8OlbuEMYl6NjslMplC5z+J01iNvYK90BUcFA
   A==;
IronPort-SDR: QcotMrK6wrMsg7PoY2GgjAfZE3jS6+7t9ei/Zdk7VSNipu7IKonabGnCjflnthBGa8R6zzCDLL
 N2XNfnTZD//LeeFLYbS25kbakGL8gS4vwOTtZsKXOkXJGUec2z49S6Q5gQZjmocwLw54B+H2Dl
 psiNh7rWaco/Pv993jxKX335e+50VtVmY+TAgtYA9lF2ZyHNt4xLDNQ8o1TsD1fl98aPMlft3g
 JwOSwr4WPdB/X90Z0rQl4rSrb9zSrugjIZviSEI78IsImDdijSGf4CwP5lDl48cd1kcXEpBFwE
 JOk=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="98684113"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:01:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:01:55 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:01:54 -0700
Subject: [PATCH 11/25] smartpqi: add host level stream detection enable
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:01:54 -0600
Message-ID: <160712291461.21372.5830547651591062444.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index 25896e7dbd1b..9604e08e58cb 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6655,6 +6655,34 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
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
@@ -6717,6 +6745,9 @@ static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
 static DEVICE_ATTR(lockup_action, 0644, pqi_lockup_action_show,
 	pqi_lockup_action_store);
+static DEVICE_ATTR(enable_stream_detection, 0644,
+	pqi_host_enable_stream_detection_show,
+	pqi_host_enable_stream_detection_store);
 static DEVICE_ATTR(enable_r5_writes, 0644,
 	pqi_host_enable_r5_writes_show, pqi_host_enable_r5_writes_store);
 static DEVICE_ATTR(enable_r6_writes, 0644,
@@ -6730,6 +6761,7 @@ static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_vendor,
 	&dev_attr_rescan,
 	&dev_attr_lockup_action,
+	&dev_attr_enable_stream_detection,
 	&dev_attr_enable_r5_writes,
 	&dev_attr_enable_r6_writes,
 	NULL

