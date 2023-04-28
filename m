Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23163C77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346512AbjD1Pib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346159AbjD1PiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EB359F5
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696269; x=1714232269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWLg7LYkQKndM0rSWaK48gTXg8ptc1DOkNmTvSSeh90=;
  b=rT53ZBN6WRcirgR4aQYPNjp4gPTnICYTFSChSGZ7O/7MK6asdxetpkfF
   bpiSQRkhXyqHPRtYwQDAZcjqaKgaKymdNymWiOtQKV+WH6VvB/58ndwYT
   GOxT+VmvnJDFoSRTFYFI8ptxVf2NvJGTNYzP8LIpFmVFrXo0Mmqz5BFFT
   V/wRGo4SK8vJJ3mT2UvH678wrbdpJ8HHcRzNTsmqptMq7/b8qqF2L5xgw
   iOl2hS+ubjqBExkHHbOpJRABGwlVv9YAs11bStjN+N59d0eJHpiTn1eyl
   auv+fjY0EzZHt5cns2Dpo/soyhsFRjEXM9xXER8UWssY4aVWx2w+LzCDn
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="149474303"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:06 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:05 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/12] smartpqi: Add sysfs entry for numa node in /sys/block/sdX/device.
Date:   Fri, 28 Apr 2023 10:37:10 -0500
Message-ID: <20230428153712.297638-11-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although numa node is a PCIe device level attribute, it was requested
the numa node be added for each exposed device similar to NVMe disks.

Example for NVME:
/sys/block/nvme1c1n1/device/numa_node

Example for smartpqi:
/sys/block/sdh/device/numa_node

cat /sys/block/sdh/device/numa_node
0

Reviewed-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 6883526db93c..0817dfa5a039 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1358,6 +1358,7 @@ struct pqi_ctrl_info {
 	u32		max_write_raid_5_6;
 	u32		max_write_raid_1_10_2drive;
 	u32		max_write_raid_1_10_3drive;
+	int		numa_node;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 324870477bae..ec5506a00cc2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7316,6 +7316,18 @@ static ssize_t pqi_sas_ncq_prio_enable_store(struct device *dev,
 	return  strlen(buf);
 }
 
+static ssize_t pqi_numa_node_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct scsi_device *sdev;
+	struct pqi_ctrl_info *ctrl_info;
+
+	sdev = to_scsi_device(dev);
+	ctrl_info = shost_to_hba(sdev->host);
+
+	return scnprintf(buffer, PAGE_SIZE, "%d\n", ctrl_info->numa_node);
+}
+
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);
 static DEVICE_ATTR(unique_id, 0444, pqi_unique_id_show, NULL);
 static DEVICE_ATTR(path_info, 0444, pqi_path_info_show, NULL);
@@ -7325,6 +7337,7 @@ static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 static DEVICE_ATTR(sas_ncq_prio_enable, 0644,
 		pqi_sas_ncq_prio_enable_show, pqi_sas_ncq_prio_enable_store);
+static DEVICE_ATTR(numa_node, 0444, pqi_numa_node_show, NULL);
 
 static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_lunid.attr,
@@ -7335,6 +7348,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 	&dev_attr_raid_level.attr,
 	&dev_attr_raid_bypass_cnt.attr,
 	&dev_attr_sas_ncq_prio_enable.attr,
+	&dev_attr_numa_node.attr,
 	NULL
 };
 
@@ -8955,6 +8969,7 @@ static int pqi_pci_probe(struct pci_dev *pci_dev,
 			"failed to allocate controller info block\n");
 		return -ENOMEM;
 	}
+	ctrl_info->numa_node = node;
 
 	ctrl_info->pci_dev = pci_dev;
 
-- 
2.40.1.375.g9ce9dea4e1

