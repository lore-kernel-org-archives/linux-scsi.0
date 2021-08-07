Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10A1C19F34
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A113561184
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhHGETi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14411 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhHGETc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309954; x=1659845954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxUqBpMfBGL8QgT/G4aYqB14OK8eppkoSmc37wpGAVA=;
  b=T4kaCsY4S/i61S4FlzKiNK6FvGxmS0gspAdgHeWqC7hyyllTM4CpB1jh
   h4TgHYEwypJ/AlDpMSK+aD9iZo/hRNGteWNAUZYZTG++0STfMilplvl4e
   urqwxmfbYR7s/Ip1HGteHIx++8dFlX/0YprygOk6GTrlOVXpoD8Nzc4+r
   gs0oN1E8tA36DXtsMvFsfsD3CGWpHwTEWnkSfdOM7SpcB5f8vnaePkz8B
   n9ow7tDKD3w6Moe5/8jNPy9sUQ2runmLbSesFT4KFmGbdsWNcPpYzjYsN
   iS6NkvaaFyJ5Ezz+wZWQBEhbjMgieeS3COD/DbTajGHHMb446/ti05eo4
   g==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363689"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:14 +0800
IronPort-SDR: k2ayp3B3B3MwLukiFAQn7uYXBzYIjlMnw9ofsEnrXRxZlKh7Jim5IT4oD9wQ67Gju7oFjE6ZAP
 NOHocdV5PBmUcAN+r+XwNHqoz+CIesiwR7lWe3M48pmGbSzPwAtRVUvssE9o0fWMo+DLieOrvj
 YFamK00G0iq40WM9ZfbRzm7hl6s4UHzqiUt4VwWTUjQxAm1heG2iueuZLByr2NOARVRyAjaOj1
 s0E+WQMs4rub6ycxUwfe5i8SdjUrz09En8ewZvI4K0iAE8qujA/h00cGZpSp4ybVqofu/tdqoM
 B6J24CA8mSw/VmXxqlaUSzyX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:43 -0700
IronPort-SDR: 8rmxOSSryjFqWz/7bhlmZ+X8xxfu31AeLhhFPxuEHFqzqztKOzw9z2VVPK3ugdwSp88599dz2A
 8MiQ0zcwaLgxJHOle/IjdeuWfWYELnKfujJoFbFLQLBGLrJYZ6qbBRg1UR1VKTbXWWcIsgfrUF
 D2T0oBCHza4rqi+Wcntl18N2B4LkzANtCT6pzPim+l2qxyO0nGop7aoyu9KCXvXT64b58hlmwu
 O4pgsc/hbOMqSY2yiP818ZMdfu7AQax/6WUdKuFDM8984AS7ur2OMQ9jZtVb/hz3d7gmumo93b
 3bc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:15 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 09/10] libahci: Introduce ncq_prio_supported sysfs sttribute
Date:   Sat,  7 Aug 2021 13:18:58 +0900
Message-Id: <20210807041859.579409-10-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, the only way a user can determine if a SATA device supports
NCQ priority is to try to enable the use of this feature using the
ncq_prio_enable sysfs device attribute. If enabling the feature fails,
it is because the device does not support NCQ priority. Otherwise, the
feature is enabled and indicates that the device supports NCQ priority.

Improve this odd interface by introducing the read-only
ncq_prio_supported sysfs device attribute to indicate if a SATA device
supports NCQ priority. The value of this attribute reflects if the
device flag ATA_DFLAG_NCQ_PRIO is set or cleared.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libahci.c     |  1 +
 drivers/ata/libata-sata.c | 24 ++++++++++++++++++++++++
 include/linux/libata.h    |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index fec2e9754aed..5b3fa2cbe722 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -125,6 +125,7 @@ EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
 	&dev_attr_unload_heads,
+	&dev_attr_ncq_prio_supported,
 	&dev_attr_ncq_prio_enable,
 	NULL
 };
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index dc397ebda089..5566fd4bb38f 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -834,6 +834,30 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 	    ata_scsi_lpm_show, ata_scsi_lpm_store);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_ncq_prio_supported_show(struct device *device,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev;
+	bool ncq_prio_supported;
+	int rc = 0;
+
+	spin_lock_irq(ap->lock);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev)
+		rc = -ENODEV;
+	else
+		ncq_prio_supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_supported);
+}
+
+DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
+EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
+
 static ssize_t ata_ncq_prio_enable_show(struct device *device,
 					struct device_attribute *attr,
 					char *buf)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b23f28cfc8e0..a2d1bae7900b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -539,6 +539,7 @@ typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes)
 extern struct device_attribute dev_attr_unload_heads;
 #ifdef CONFIG_SATA_HOST
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_ncq_prio_supported;
 extern struct device_attribute dev_attr_ncq_prio_enable;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
-- 
2.31.1

