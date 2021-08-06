Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB60C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6657F611C9
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245391AbhHFLM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47134 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245395AbhHFLMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248325; x=1659784325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxUqBpMfBGL8QgT/G4aYqB14OK8eppkoSmc37wpGAVA=;
  b=au1wQGUyU6en67ig4kqRa/K6m3sw85gvO4uMFiDIArQ8JPK8x/DWrLsf
   EMnPe4AOvT1w9Z9OWB0tMKcJ1KnE6TYul3DD3sRCwU6aivGVvy3omoCbm
   V2BSfxhdC8KSg4keeZBnH4QUzkI45agv3UBzlA/U7EWpsz0AEBKiVZboh
   xhQGtUazem/ivmzYHt0z+gIJHpyErnpmsCOnzh838/f/GQ+8ChRSwQDwJ
   U5/EreDA57o4oe7ke4uNdW7Wup7cNIIWIxPXBsM/rJRQg0svAQwhF9MOG
   hAUOOMnFP8DUUZtwCccmy4GTSndwvfu3BjlIdXEYYvpTJhWYwRonAUpLe
   g==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055563"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:12:02 +0800
IronPort-SDR: QXbh5YTgbL5QMQrp8Ng/Lj3DhTKqNg6fKxJVAZPiX9jYoRt3Uef4HJcaiJEncopB17BYaed9i4
 Kwxd+1QTCnLcjFyxa7MCJe9bQXr+s8Drj8e+lk8mF3Y5gn5pc4Dcf9XxLidDJFxNsmvoZk9aEu
 FQ+MHnNv24IQwY1Js0XmDjrwB0mpv7o0nMvDx6+X2P1fq79JSQPhD6FfmhpW63FKOC1+1dIcOx
 rrc73Ink2wYTZliD9PjBBEsHfh/nQmde6WfZHOC8acsT+lKGUH4m9Cnkq4pj7IoYaWbKWbNk0I
 /D/iWYH420s16B/4RvXY1EZD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:37 -0700
IronPort-SDR: AWMpyBiZhzbGjGjZydmfsg3id2MCFAeAir1gFuQfJ04kO5o2LIp0RifK713IbMHvhjKUR36SYy
 c8i/oBoV2pIBT8PMPwpfUu3E8Xuyu9Vq9mhxILbj6AmbRMQ7BK0SNuqA6V3qp7DKg1caiwOSBs
 7iu04vTWXr2zaSahD6HnGhxGcUHt8T5CcHSW7u1bcWXqlR/EVd2ocXd8l/dsIl/Co3hxRO5Dhn
 5F/8mjHw/Zk1GZym6liANH96pUeiqz6kWc+FFJcknax3985k5NlYt/sXcdRtKlcZ5WnalPviPn
 kj4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:12:01 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 8/9] libahci: Introduce ncq_prio_supported sysfs sttribute
Date:   Fri,  6 Aug 2021 20:11:44 +0900
Message-Id: <20210806111145.445697-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
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

