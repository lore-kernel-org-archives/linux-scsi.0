Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B300EC35DF9
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 10:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8782824650
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 10:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfMioKOE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgBYKE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 05:04:28 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33784 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgBYKE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 05:04:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay11so5297715plb.0;
        Tue, 25 Feb 2020 02:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q1TTBZmS5hI2KOUyiQtNES1cxUuECkupynSXNPqJhto=;
        b=IfMioKOEb4ZGX4URyCr39nDMmmuVD98Q0qIp9+PE2+ehmkIG0Oh8yhQ4HK31B34j8y
         ya1EA1uK64SnW09YA4XJ96uEB1iFRh/nBBZ97NEAPZMIUEwazKYuQOwK8e19HHNg4lQs
         vL1ddR7+31PUBBBLovKlEOfNY8wl0ChJdBNubKX4N1uD+RZurVKMhezCLU8xyQLRHq4c
         1d3qHjbftOktkOTInmKyq+RydeVADbvN4pJvrYP3PB7Wf761F+dKmlbg72RR+BvM3LuT
         UYjWC6wN6OxrJE4cvjGR2d/BELfi9K1kl7/3ScyqPoWRXxX36U7LoWoLmE6VuFa18td9
         pFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q1TTBZmS5hI2KOUyiQtNES1cxUuECkupynSXNPqJhto=;
        b=L0/MCxA4xHXeT+1CpnGO0MwOJNqwsajdAzUS2I1QWg3u+DYpC5uuIz+RXXN98tUcMQ
         LBKTU7Z+soMTFMTQyuNwND2HuNKoANtpdJTeIjf/PhvDlgi7TgmcsgfophhaDSNDBP29
         P4ghS6yeSfOPJwIRFTm5TGEH2kfCUkpujhSJQLwqXe/ubYETBMRihIMNiLgJ6A/RWJ2w
         TVHHYmRmWxRCgTCBbcKTHiW3kJLjAFNlZBOyxbvn8sg92E8vGybbsGrAv+4a+GKZrFQ/
         LuKDzYqu/BSy3Pg0e0cKYyCbmEXSNC8az98FTVWHF/n3I67NnarUFxytodaj6jllqYJg
         4Qfw==
X-Gm-Message-State: APjAAAWb1zEuK/znH7ab7Hs5xYhPf6PHiqdjIqWagna5rDzgivyD4lQ6
        9+bWyTIzgrGyG+vu3rKfKU4=
X-Google-Smtp-Source: APXvYqwyKcwx0OfZ2G3eLBjW2d/FUQ74r0ivbu0yGG0sOiBjxUPnVeq3OCbhlIEl0ihomfzutmeD3g==
X-Received: by 2002:a17:90b:34b:: with SMTP id fh11mr4377690pjb.8.1582625067907;
        Tue, 25 Feb 2020 02:04:27 -0800 (PST)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id w18sm16172365pge.4.2020.02.25.02.04.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Feb 2020 02:04:27 -0800 (PST)
From:   guosongsu@gmail.com
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guosong Su <suguosong@xiaomi.com>
Subject: [PATCH] SCSI: use kobj_to_dev
Date:   Tue, 25 Feb 2020 18:04:11 +0800
Message-Id: <20200225100411.10250-1-guosongsu@gmail.com>
X-Mailer: git-send-email 2.14.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Guosong Su <suguosong@xiaomi.com>

Use kobj_to_dev to instead of open-coding it.

Signed-off-by: Guosong Su <suguosong@xiaomi.com>
---
 drivers/scsi/scsi_sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 677b5c5403d2..c3a30ba4ae08 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -856,7 +856,7 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 		 struct bin_attribute *bin_attr,			\
 		 char *buf, loff_t off, size_t count)			\
 {									\
-	struct device *dev = container_of(kobj, struct device, kobj);	\
+	struct device *dev = kobj_to_dev(kobj);				\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct scsi_vpd *vpd_page;					\
 	int ret = -EINVAL;						\
@@ -884,7 +884,7 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 			    struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 	if (!sdev->inquiry)
@@ -1181,7 +1181,7 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 
@@ -1207,7 +1207,7 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 					     struct bin_attribute *attr, int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 
-- 
2.14.1

