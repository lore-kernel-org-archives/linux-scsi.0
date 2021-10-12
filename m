Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46654C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4E160F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhJLXjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:09 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:46799 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhJLXjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:06 -0400
Received: by mail-pj1-f52.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so829016pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/iwhY8URVTeMCs+2vc+hIQceR1frC9+0UnoeCjR46U=;
        b=g6mukVZ0xrv8KOKqSkQfGhl6u5Ink6ZfiM8YzXVtdqLDGfk6V5ClCB2/KOZJw8+XCu
         BfksWFwKN1Kwe+fWOcmRAoaKChe1kADhi04co1gHI6QHwng0NGBhckoSItDtIij6Qv9e
         fAVsjO/wbzuN3xdiO15QA+/3KCzCE3OS09dyaF1G4hpnPVe8/pUGAfxyWRtWOBoGUL12
         19tQ4sgpiXbuXsUgilyhO6EpZeq3FsSY9gC0ms5KYYFZhsgss2ofJe7rPZpXJDV7wAb3
         1OCwZmBcJWyNG3ywaWQSJoFUIXuDyU3gsjXqIT2+oizC3C9ytd6OQUGpD9DOI0LtR02n
         8FSA==
X-Gm-Message-State: AOAM533jfUBxH41drR9y3BS/NTCIzoW1jhS8b+KVJhij7r87xtaUOR+E
        2gj8r9y9PXx77P4PgZswxxw=
X-Google-Smtp-Source: ABdhPJxzrtGQyWryT9aWkQmE10jkAhP1iJryUSGJhQFFokU5p5cJPSbeKqlQfNWLwqGmS+aqYaBlsg==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr9446010pjb.186.1634081824383;
        Tue, 12 Oct 2021 16:37:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v4 30/46] scsi: mvsas: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:42 -0700
Message-Id: <20211012233558.4066756-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
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
 
