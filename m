Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5134AC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FF4610A7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhHBJDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:25 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6561 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhHBJCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894964; x=1659430964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8XjriTNRfkHpzNkE2dEravGJzqEPs8r8H0bC3ba6Ylw=;
  b=OJvhMctpgswapmXrmTbi/GDbrZBN1P/RtRTmlrgCf9q/X/rv6XY0J7Ns
   UGxonaEjo0tSXZWYuF24DVDK2bPkoQZJQu/m1vGVTjuNqML0ECvrnpSb1
   mapCI78nhK7JKpVmZuKWyMzreAsm596u72pAPETybq129ytX2wz1AoQbB
   dqlAfC5g9f6ZmCOrq/kJTt3MZK1vot86+Zae0V5lQToFGTl7aTncr2ZNp
   MNjwpMEv9+cOtH/F1mguKfAwFCwCddDSOfbfN0Kfk7HKtumRHyqum8l04
   9cBZIoSdxtjpoHamKXD6hRpqbWTDJ3Ug9pNEFvefHjS2uCXvSdhpR/BPY
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887625"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:41 +0800
IronPort-SDR: Y427aJf2VxpBkaEfic4MOv23kzrhhRyi0YF41AmOqF9cUoIc7bc9Lr/tA8ucsOeLFO9kOKxoU4
 TC3SiV7bKkNwwAkjPCb7O8aRfyNXQa0AvG7v5cFqNNA0i/7dxKH8UHdMeUjuboDjUWuETTNN8C
 ANAnTWYNm8H9ECKr9A/5aFlLL8QOWysWNljXKMdY+5O8V8mxG3SbPnhZy7AfaqH+QgjRTrRlLn
 Kny7QNBZnnkigwD9tom2WfgfmQEAfFklybfZl1qG7wotZL4xewn5NxNg1s/cXA63XF0AQEq6I1
 hCwZrVictqk40a4L3yfQFUjH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:18 -0700
IronPort-SDR: U6fhYddiq00W0X9oFl/7enRHYG4dZe5L+CWEZhJa17a+K5aNJenwRLqqCRaU16bmng3cnK+8NS
 EWQhygYs7/fknHIocZa2yqBFq4n03FoogB6AIvhcHMTSbhaHx1K9aYk7Z/TDZ/zF1Jw+6G+zrJ
 KHpb8jc8wkqYhaOk07CwccWnC1CdNN+C+1/gMIYV71dtyJi13wutF3aTrPjTtcM7wymyu3qYjS
 W3iOABSJbmGUf1loYpKe/sgulVikTgKx8yPbBEkLQp1U1yUjzXnHkVefD28FNm0vi63cXAHYbl
 dHw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:42 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 6/7] libahci: Introduce ncq_prio_supported sysfs sttribute
Date:   Mon,  2 Aug 2021 18:02:31 +0900
Message-Id: <20210802090232.1166195-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
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
index dc397ebda089..4a067384086b 100644
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
+	return rc ? rc : snprintf(buf, 20, "%u\n", ncq_prio_supported);
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

