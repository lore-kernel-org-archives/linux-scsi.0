Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0A1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537E7208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgHSP0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39602 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728692AbgHSPZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 928F0B1CB9DFE1F7A85A;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:51 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 13/18] scsi: core: Show nr_hw_queues in sysfs
Date:   Wed, 19 Aug 2020 23:20:31 +0800
Message-ID: <1597850436-116171-14-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So that we don't use a value of 0 for when Scsi_Host.nr_hw_queues is unset,
use the tag_set->nr_hw_queues (which holds 1 for this case).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_sysfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..d6e344fa33ad 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -393,6 +393,16 @@ show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
 
+static ssize_t
+show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct blk_mq_tag_set *tag_set = &shost->tag_set;
+
+	return snprintf(buf, 20, "%d\n", tag_set->nr_hw_queues);
+}
+static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
+
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_use_blk_mq.attr,
 	&dev_attr_unique_id.attr,
@@ -411,6 +421,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_prot_guard_type.attr,
 	&dev_attr_host_reset.attr,
 	&dev_attr_eh_deadline.attr,
+	&dev_attr_nr_hw_queues.attr,
 	NULL
 };
 
-- 
2.26.2

