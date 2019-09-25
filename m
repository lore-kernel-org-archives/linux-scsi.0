Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B444C432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 18:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E980B207E0
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 18:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408470AbfIYSPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:15:54 -0400
Received: from h1.fbrelay.privateemail.com ([131.153.2.42]:49672 "EHLO
        h1.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407511AbfIYSPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Sep 2019 14:15:54 -0400
Received: from MTA-08-4.privateemail.com (mta-08.privateemail.com [68.65.122.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id AA48580ADC
        for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2019 14:03:24 -0400 (EDT)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id 948736005D;
        Wed, 25 Sep 2019 14:03:23 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.218])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id F1FF860038;
        Wed, 25 Sep 2019 18:03:22 +0000 (UTC)
From:   Ryan Attard <ryanattard@ryanattard.info>
To:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Ryan Attard <ryanattard@ryanattard.info>
Subject: [PATCH] scsi: Add sysfs attributes for VPD pages 0h and 89h
Date:   Wed, 25 Sep 2019 13:02:52 -0500
Message-Id: <20190925180251.49980-2-ryanattard@ryanattard.info>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925180251.49980-1-ryanattard@ryanattard.info>
References: <20190925180251.49980-1-ryanattard@ryanattard.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add sysfs attributes for the ATA information page and
Supported VPD Pages page.

Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>
---
 drivers/scsi/scsi.c        |  4 ++++
 drivers/scsi/scsi_sysfs.c  | 19 +++++++++++++++++++
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a7e4fba724b7..088b8ca473e6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -485,10 +485,14 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 		return;
 
 	for (i = 4; i < vpd_buf->len; i++) {
+		if (vpd_buf->data[i] == 0x0)
+			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
 		if (vpd_buf->data[i] == 0x80)
 			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
 		if (vpd_buf->data[i] == 0x83)
 			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
+		if (vpd_buf->data[i] == 0x89)
+			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
 	}
 	kfree(vpd_buf);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8ce12ffcbb7a..eb6764f92c93 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -429,6 +429,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
+	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
@@ -458,16 +459,24 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	sdev->request_queue = NULL;
 
 	mutex_lock(&sdev->inquiry_mutex);
+	rcu_swap_protected(sdev->vpd_pg0, vpd_pg0,
+			   lockdep_is_held(&sdev->inquiry_mutex));
 	rcu_swap_protected(sdev->vpd_pg80, vpd_pg80,
 			   lockdep_is_held(&sdev->inquiry_mutex));
 	rcu_swap_protected(sdev->vpd_pg83, vpd_pg83,
 			   lockdep_is_held(&sdev->inquiry_mutex));
+	rcu_swap_protected(sdev->vpd_pg89, vpd_pg89,
+			   lockdep_is_held(&sdev->inquiry_mutex));
 	mutex_unlock(&sdev->inquiry_mutex);
 
+	if (vpd_pg0)
+		kfree_rcu(vpd_pg0, rcu);
 	if (vpd_pg83)
 		kfree_rcu(vpd_pg83, rcu);
 	if (vpd_pg80)
 		kfree_rcu(vpd_pg80, rcu);
+	if (vpd_pg89)
+		kfree_rcu(vpd_pg89, rcu);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -840,6 +849,8 @@ static struct bin_attribute dev_attr_vpd_##_page = {		\
 
 sdev_vpd_pg_attr(pg83);
 sdev_vpd_pg_attr(pg80);
+sdev_vpd_pg_attr(pg89);
+sdev_vpd_pg_attr(pg0);
 
 static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
@@ -1136,12 +1147,18 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 
+	if (attr == &dev_attr_vpd_pg0 && !sdev->vpd_pg0)
+		return 0;
+
 	if (attr == &dev_attr_vpd_pg80 && !sdev->vpd_pg80)
 		return 0;
 
 	if (attr == &dev_attr_vpd_pg83 && !sdev->vpd_pg83)
 		return 0;
 
+	if (attr == &dev_attr_vpd_pg89 && !sdev->vpd_pg89)
+		return 0;
+
 	return S_IRUGO;
 }
 
@@ -1183,8 +1200,10 @@ static struct attribute *scsi_sdev_attrs[] = {
 };
 
 static struct bin_attribute *scsi_sdev_bin_attrs[] = {
+	&dev_attr_vpd_pg0,
 	&dev_attr_vpd_pg83,
 	&dev_attr_vpd_pg80,
+	&dev_attr_vpd_pg89,
 	&dev_attr_inquiry,
 	NULL
 };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 571ddb49b926..5e91b0d00393 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -137,6 +137,8 @@ struct scsi_device {
 #define SCSI_VPD_PG_LEN                255
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
+	struct scsi_vpd __rcu *vpd_pg89;
+	struct scsi_vpd __rcu *vpd_pg0;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
2.23.0

