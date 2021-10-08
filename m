Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6916C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C467610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbhJHU0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:13 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33607 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242570AbhJHU0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:12 -0400
Received: by mail-pf1-f170.google.com with SMTP id s16so9166537pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bke2QLpps6GpzDcXZNnBKyGGpzVgxKxfRpS6Pp+DtoM=;
        b=bWKF3QzZl3Ag9qjACPcdjCgrbbIGrS7p4fau6MoEg6W44roxJHzt1m3FqVc+raidQ3
         RXWaMpfRTW6XINiQ5NWGSAsdc0rjVW1r0Jhyu6N1GgDxbfLD3OU2CI9DI4Rnht6Qd/Ne
         bYy0nKtfjELAnBZV7vMUAQ6NlrtkzgpWlG09RfbTNPoH5ZEehM+MgF3y6P7ysUO8Fqev
         dd1sx7jng7W6mgIebVBD1x9J6gV0Y0idMZZvVUrqwlnfZX99VmYJ9WlpfBOhvxy/GGVR
         VGnuHyDoVdJdtBtA+7inOUrhmnyE+tZ3iWyIterinPntJFlsg9fTlYtwqcB2+RnF44By
         9pQA==
X-Gm-Message-State: AOAM530Dj/xcOSid5+kuvSASt1VmGAxuKUSf8+ojI2GRI1RtOUYLePmo
        JtU4vYBRytq0zUP27NMhJ5Lyazqerdl3CQ==
X-Google-Smtp-Source: ABdhPJx0cFLO3C3sAsq6yNtBalM2KSN/K8/baY6fJiwZLvGYSIIXaTYacEHYkXBYwPfGNSRbS/63Bw==
X-Received: by 2002:a63:4f25:: with SMTP id d37mr6476015pgb.61.1633724654578;
        Fri, 08 Oct 2021 13:24:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 10/46] scsi: 53c700: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:17 -0700
Message-Id: <20211008202353.1448570-11-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..931f9d44e83c 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -163,7 +163,7 @@ STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
-STATIC struct device_attribute *NCR_700_dev_attrs[];
+STATIC const struct attribute_group *NCR_700_dev_groups[];
 
 STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
 
@@ -300,8 +300,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	static int banner = 0;
 	int j;
 
-	if(tpnt->sdev_attrs == NULL)
-		tpnt->sdev_attrs = NCR_700_dev_attrs;
+	if (tpnt->sdev_groups == NULL)
+		tpnt->sdev_groups = NCR_700_dev_groups;
 
 	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
 	if (!memory) {
@@ -2087,11 +2087,13 @@ static struct device_attribute NCR_700_active_tags_attr = {
 	.show = NCR_700_show_active_tags,
 };
 
-STATIC struct device_attribute *NCR_700_dev_attrs[] = {
-	&NCR_700_active_tags_attr,
+STATIC struct attribute *NCR_700_dev_attrs[] = {
+	&NCR_700_active_tags_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(NCR_700_dev);
+
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
