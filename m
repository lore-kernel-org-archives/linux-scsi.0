Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AF6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C41610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbhJGVWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:15 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:45010 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbhJGVWK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:10 -0400
Received: by mail-pj1-f44.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so6194358pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ON3CAl199Wqr8BQIEBjX4WfHt1Cnlq6QAbdeBW4d6B8=;
        b=oQxjIb11YdY3tmhFsA0FRjlcOHGTdOpJqEEowBhgZSW6lpLZrMK7TWN06eripB0i/c
         g4T9NgSqGX8VVnae3erUevOp0SlrNN+Fz2S/oU8ELGd5u/qJee7EhNF6wgJzhJMsrq3m
         yBzvjxaXLjiTYMHO+Vm0gPyFE9wGVvsk8aqSbZM5S4kWMQKGRjTZABD004mRnsbx2609
         3QsGyOoiunJLXGwxPXSYih3ECzPxe5014ND7zvnuP/kMMbOpbCvs6lT5+cSINGh30qub
         h2znZt/doTT3sBjHC/EMSdIbWu8C3lpYmqoS9hiMFkdVN1gtqDTetpcpCUQwq4wfq5pQ
         tSPA==
X-Gm-Message-State: AOAM532i0qQPJih5ZeaWqvmpQYtfBs/i40Iqtt60Sbp/p9os/FNkBQt6
        +gmwJZabr53Oyc/Jjn77eTQ=
X-Google-Smtp-Source: ABdhPJzu9eKP0eP2emenoROQ6WfKaJ4BMcrJ5sVs6n8IVggcP/gyTbSZIe9LUDSY8OwaF0y8zR5emw==
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr7451293pjb.208.1633641615440;
        Thu, 07 Oct 2021 14:20:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v2 30/46] scsi: mvsas: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:36 -0700
Message-Id: <20211007211852.256007-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f18dd9703595..34fe54a6050f 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -25,7 +25,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64, 8,  9, &mvs_94xx_dispatch, },
 };
 
-static struct device_attribute *mvst_host_attrs[];
+static const struct attribute_group *mvst_host_attr_groups[];
 
 #define SOC_SAS_NUM 2
 
@@ -52,7 +52,7 @@ static struct scsi_host_template mvs_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= mvst_host_attrs,
+	.shost_groups		= mvst_host_attr_groups,
 	.track_queue_depth	= 1,
 };
 
@@ -773,12 +773,21 @@ static void __exit mvs_exit(void)
 	sas_release_transport(mvs_stt);
 }
 
-static struct device_attribute *mvst_host_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_interrupt_coalescing,
+static struct attribute *mvst_host_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_interrupt_coalescing.attr,
 	NULL,
 };
 
+static const struct attribute_group mvst_host_attr_group = {
+	.attrs = mvst_host_attrs
+};
+
+static const struct attribute_group *mvst_host_attr_groups[] = {
+	&mvst_host_attr_group,
+	NULL
+};
+
 module_init(mvs_init);
 module_exit(mvs_exit);
 
