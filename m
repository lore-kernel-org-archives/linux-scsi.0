Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFD5C8300E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE312065E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbgKYRZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 12:25:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8037 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731631AbgKYRYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 12:24:53 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Ch76f5frfzhf7m;
        Thu, 26 Nov 2020 01:24:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 01:24:38 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <lenb@kernel.org>, <rjw@rjwysocki.net>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <linux-acpi@vger.kernel.org>,
        <maz@kernel.org>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 3/5] driver core: platform: Add platform_put_irq()
Date:   Thu, 26 Nov 2020 01:20:39 +0800
Message-ID: <1606324841-217570-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606324841-217570-1-git-send-email-john.garry@huawei.com>
References: <1606324841-217570-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a function to tear down the work which was done in platform_get_irq()
for when the device driver is done with the irq.

For ACPI companion devices the irq resource is set as disabled, as this
resource is configured from platform_get_irq()->acpi_irq_get() and requires
resetting.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/base/platform.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 88aef93eb4dd..3eeda3746701 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -289,6 +289,20 @@ int platform_irq_count(struct platform_device *dev)
 }
 EXPORT_SYMBOL_GPL(platform_irq_count);
 
+void platform_put_irq(struct platform_device *dev, unsigned int num)
+{
+	unsigned int virq = platform_get_irq(dev, num);
+
+	irq_dispose_mapping(virq);
+	if (has_acpi_companion(&dev->dev)) {
+		struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ,
+							   num);
+
+		if (r)
+			acpi_dev_irqresource_disabled(r, 0);
+	}
+}
+
 /**
  * platform_get_resource_byname - get a resource for a device by name
  * @dev: platform device
-- 
2.26.2

