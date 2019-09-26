Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F4DC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 16:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D357421D56
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 16:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfIZQ0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 12:26:15 -0400
Received: from h1.fbrelay.privateemail.com ([131.153.2.42]:49748 "EHLO
        h1.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbfIZQ0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 12:26:15 -0400
Received: from MTA-05-3.privateemail.com (mta-05.privateemail.com [198.54.127.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 2BC3180685
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2019 12:26:14 -0400 (EDT)
Received: from MTA-05.privateemail.com (localhost [127.0.0.1])
        by MTA-05.privateemail.com (Postfix) with ESMTP id C59B46004A;
        Thu, 26 Sep 2019 12:26:12 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.229])
        by MTA-05.privateemail.com (Postfix) with ESMTPA id 2713B60058;
        Thu, 26 Sep 2019 16:26:12 +0000 (UTC)
From:   Ryan Attard <ryanattard@ryanattard.info>
To:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Ryan Attard <ryanattard@ryanattard.info>
Subject: [PATCH v2] scsi: Add sysfs attributes for VPD pages 0h and 89h
Date:   Thu, 26 Sep 2019 11:22:17 -0500
Message-Id: <20190926162216.56591-1-ryanattard@ryanattard.info>
X-Mailer: git-send-email 2.23.0
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
index 571ddb49b926..f4f176c79fae 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -135,8 +135,10 @@ struct scsi_device {
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 
 #define SCSI_VPD_PG_LEN                255
+	struct scsi_vpd __rcu *vpd_pg0;
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
+	struct scsi_vpd __rcu *vpd_pg89;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
2.23.0

