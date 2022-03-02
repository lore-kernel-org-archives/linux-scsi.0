Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3571C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbiCBFhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbiCBFhN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56305B16DA
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222jYNA010945
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=6MeIGjyLcXc7nLxRjHNUMype0upcrKejx82eHH9RsUM=;
 b=W0nAf89BZx6MliGzlNSHxyCrgUe/OLJ66SxVFCj1UXjjS3J+vFYN60zh/a9D61wMICcQ
 wlYOdd6YiJ5SI0CRuXOMtdaZLwRVhS+mK2C8kOULRSV5I2XRnIZCE3K6IQaQnkKxQBkI
 i+Cvg5sM1eO5vKDUll/r88DJCDeQ/7avYN4pObWVDasEPegiASr4P+7nu2nqHzAfxAlT
 sq73yOsdIC2hXis2iWd03f8ZAfdK06chU5mYP4oRyNbpfPz1yfEzyobFU+eJefLt9vYO
 CNKe6rY9qaPa8I7hI4M/g9BZgfRVtCLjLOsyGQkEiR1zHVhBofineCmFiZtBh/ZRz0B9 Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IpAg175833
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vahk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:29 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZd014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-6;
        Wed, 02 Mar 2022 05:36:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Date:   Wed,  2 Mar 2022 00:35:50 -0500
Message-Id: <20220302053559.32147-6-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: vEqFnmZBRPRGU2igZyzj93NljSZpG99i
X-Proofpoint-ORIG-GUID: vEqFnmZBRPRGU2igZyzj93NljSZpG99i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c        |  6 ++++++
 drivers/scsi/scsi_sysfs.c  | 28 ++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  4 ++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c6221a2ca04e..524e03aba9ef 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -488,6 +488,12 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
 		if (vpd_buf->data[i] == 0x89)
 			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
+		if (vpd_buf->data[i] == 0xb0)
+			scsi_update_vpd_page(sdev, 0xb0, &sdev->vpd_pgb0);
+		if (vpd_buf->data[i] == 0xb1)
+			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
+		if (vpd_buf->data[i] == 0xb2)
+			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
 	}
 	kfree(vpd_buf);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 226a50944c00..1ed45de9970d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -448,6 +448,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
+	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
 	struct module *mod;
 
@@ -490,6 +491,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 				       lockdep_is_held(&sdev->inquiry_mutex));
 	vpd_pg89 = rcu_replace_pointer(sdev->vpd_pg89, vpd_pg89,
 				       lockdep_is_held(&sdev->inquiry_mutex));
+	vpd_pgb0 = rcu_replace_pointer(sdev->vpd_pgb0, vpd_pgb0,
+				       lockdep_is_held(&sdev->inquiry_mutex));
+	vpd_pgb1 = rcu_replace_pointer(sdev->vpd_pgb1, vpd_pgb1,
+				       lockdep_is_held(&sdev->inquiry_mutex));
+	vpd_pgb2 = rcu_replace_pointer(sdev->vpd_pgb2, vpd_pgb2,
+				       lockdep_is_held(&sdev->inquiry_mutex));
 	mutex_unlock(&sdev->inquiry_mutex);
 
 	if (vpd_pg0)
@@ -500,6 +507,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree_rcu(vpd_pg80, rcu);
 	if (vpd_pg89)
 		kfree_rcu(vpd_pg89, rcu);
+	if (vpd_pgb0)
+		kfree_rcu(vpd_pgb0, rcu);
+	if (vpd_pgb1)
+		kfree_rcu(vpd_pgb1, rcu);
+	if (vpd_pgb2)
+		kfree_rcu(vpd_pgb2, rcu);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -913,6 +926,9 @@ static struct bin_attribute dev_attr_vpd_##_page = {		\
 sdev_vpd_pg_attr(pg83);
 sdev_vpd_pg_attr(pg80);
 sdev_vpd_pg_attr(pg89);
+sdev_vpd_pg_attr(pgb0);
+sdev_vpd_pg_attr(pgb1);
+sdev_vpd_pg_attr(pgb2);
 sdev_vpd_pg_attr(pg0);
 
 static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
@@ -1250,6 +1266,15 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_vpd_pg89 && !sdev->vpd_pg89)
 		return 0;
 
+	if (attr == &dev_attr_vpd_pgb0 && !sdev->vpd_pgb0)
+		return 0;
+
+	if (attr == &dev_attr_vpd_pgb1 && !sdev->vpd_pgb1)
+		return 0;
+
+	if (attr == &dev_attr_vpd_pgb2 && !sdev->vpd_pgb2)
+		return 0;
+
 	return S_IRUGO;
 }
 
@@ -1296,6 +1321,9 @@ static struct bin_attribute *scsi_sdev_bin_attrs[] = {
 	&dev_attr_vpd_pg83,
 	&dev_attr_vpd_pg80,
 	&dev_attr_vpd_pg89,
+	&dev_attr_vpd_pgb0,
+	&dev_attr_vpd_pgb1,
+	&dev_attr_vpd_pgb2,
 	&dev_attr_inquiry,
 	NULL
 };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 144d3a801c8d..fd6a803ac8cd 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -149,6 +149,10 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
+	struct scsi_vpd __rcu *vpd_pgb0;
+	struct scsi_vpd __rcu *vpd_pgb1;
+	struct scsi_vpd __rcu *vpd_pgb2;
+
 	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
-- 
2.32.0

