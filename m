Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23D5C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC736112D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242862AbhJHU1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:04 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:39726 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242688AbhJHU05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:57 -0400
Received: by mail-pl1-f177.google.com with SMTP id c4so6885723pls.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/iwhY8URVTeMCs+2vc+hIQceR1frC9+0UnoeCjR46U=;
        b=Hh7WJHXqwlh/lwPhlSsZW+1nOFCfuMA28ewnJvOqhUSRr51puzFY+XATGVRxLt8qeK
         ZaeqSYx2iQ3w91e+YDM9RZ676iAm4udku2KqCSaawtVVeAjRBS2Y3m2CqXajusk++pDt
         T9iQRAQ/NJWOLrGJbHCInijwCYP+sRI3Jm4DZIL/OjEjMcFJom1S9IP3V7FGv7J0VuGl
         H5KzB8u0+4Ge906hcsu1CAIpJ1QwLRruJdVtgZxVdfIRoNXmrwHY9iTkJxYwt4Xf5bXj
         B+ngdLs0LtcrLjAouoSfoNj+gH5U6rFtW5EYNCmrlTVzKbZQC7poHoowcOPAhrhNtKMF
         XLmg==
X-Gm-Message-State: AOAM533/pjNU2ppfaS0dOhRIxvQpvS1RTxEEQlflSHkOlb36Jpg/fBZm
        NJwY9KXWcA0KlRhmb6Gh9wr2hvHtiVuykw==
X-Google-Smtp-Source: ABdhPJwCTVRY9lBIuYkLk/5M4HwANTzJcm+vB0FNieXX75gd//LSM7DM+OvvLOWy6MqgvLQDFumZBw==
X-Received: by 2002:a17:90a:44:: with SMTP id 4mr14158989pjb.130.1633724701684;
        Fri, 08 Oct 2021 13:25:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Yufen Yu <yuyufen@huawei.com>, Jason Yan <yanaijie@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v3 30/46] scsi: mvsas: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:37 -0700
Message-Id: <20211008202353.1448570-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f18dd9703595..dcae2d4464f9 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -25,7 +25,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64, 8,  9, &mvs_94xx_dispatch, },
 };
 
-static struct device_attribute *mvst_host_attrs[];
+static const struct attribute_group *mvst_host_groups[];
 
 #define SOC_SAS_NUM 2
 
@@ -52,7 +52,7 @@ static struct scsi_host_template mvs_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
-	.shost_attrs		= mvst_host_attrs,
+	.shost_groups		= mvst_host_groups,
 	.track_queue_depth	= 1,
 };
 
@@ -773,12 +773,14 @@ static void __exit mvs_exit(void)
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
 
+ATTRIBUTE_GROUPS(mvst_host);
+
 module_init(mvs_init);
 module_exit(mvs_exit);
 
