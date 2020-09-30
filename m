Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2A6C4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6FF720773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgI3CUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 22:20:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbgI3CUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 22:20:36 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 588C362693768E3B6495;
        Wed, 30 Sep 2020 10:20:34 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 10:20:27 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: megaraid_sas: Fix inconsistent of format with argument type in megaraid_sas_base.c
Date:   Wed, 30 Sep 2020 10:21:24 +0800
Message-ID: <20200930022124.2840018-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix follow warnings:
[drivers/scsi/megaraid/megaraid_sas_base.c:3294]: (warning) %d in format string (no. 1)
	requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/megaraid/megaraid_sas_base.c:3301]: (warning) %ld in format string (no. 1)
	requires 'long' but the argument type is 'unsigned long'.
[drivers/scsi/megaraid/megaraid_sas_base.c:3385]: (warning) %ld in format string (no. 1)
	requires 'long' but the argument type is 'unsigned long'.
[drivers/scsi/megaraid/megaraid_sas_base.c:5606]: (warning) %u in format string (no. 3)
	requires 'unsigned int' but the argument type is 'int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e158d3d62056..3dfc3057fb3f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3291,14 +3291,14 @@ fw_crash_state_show(struct device *cdev,
 	struct megasas_instance *instance =
 		(struct megasas_instance *) shost->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", instance->fw_crash_state);
+	return snprintf(buf, PAGE_SIZE, "%u\n", instance->fw_crash_state);
 }
 
 static ssize_t
 page_size_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%ld\n", (unsigned long)PAGE_SIZE - 1);
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)PAGE_SIZE - 1);
 }
 
 static ssize_t
@@ -3382,7 +3382,7 @@ raid_map_id_show(struct device *cdev, struct device_attribute *attr,
 	struct megasas_instance *instance =
 			(struct megasas_instance *)shost->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%ld\n",
+	return snprintf(buf, PAGE_SIZE, "%lu\n",
 			(unsigned long)instance->map_id);
 }
 
@@ -5603,7 +5603,7 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 	for (i = 0; i < instance->msix_vectors; i++) {
 		instance->irq_context[i].instance = instance;
 		instance->irq_context[i].MSIxIndex = i;
-		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%u",
+		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%d",
 			"megasas", instance->host->host_no, i);
 		if (request_irq(pci_irq_vector(pdev, i),
 			instance->instancet->service_isr, 0, instance->irq_context[i].name,
-- 
2.25.4

