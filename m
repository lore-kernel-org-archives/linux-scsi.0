Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A71AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B91610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhJGVVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:12 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:40590 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhJGVVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:12 -0400
Received: by mail-pl1-f177.google.com with SMTP id j15so4777316plh.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PB9+oB5QIxFMeLVAlJ30VL45KwEso0vp/tcHd5OF3wI=;
        b=4X5ipb95/A63+ayuHUg78Nrg+1YXTL8SIDUwcOjT4UGJihD7VVrkgygSsBUwmpD48t
         ObIFVnH1hVrfdf88SPcbruNcOVIwu2EHTWNm6TsgPLvavolC3llzd8ad2z/pV7wfbf3P
         v1SgMiAbU8tZNdTfjv7AhJ7+y9/XHr1v1HMDtV0GtEBlr9lE8q5yDEJ9elJBaX4kGVg6
         YXAAAhUwRnSB9zkjQdga8brQf+16vqJjWlPNdWsQX9QCin8nW83O5uh7zeg6wGXdKl62
         9p6W6gY97RmYeSZyY+97mf0Cch4683qZAKgZIN8+vAHiTLh6FoutgbFnO6Z9y56LyVZd
         4lfA==
X-Gm-Message-State: AOAM532ANwrV2Ghja66qCBhrxZCf6Z+Rv/7xag5R68DPhmuMhQ+Meart
        XpKqmDJ+iiNMFTYj30HF2dQ=
X-Google-Smtp-Source: ABdhPJxUUUgugO2FPACcuHz1QuT85uBduTRJrryX1WOsJWAEBbITHEj8jVJXXLx2F3BFTGA0USz8qg==
X-Received: by 2002:a17:902:7fcf:b0:13e:c994:ee67 with SMTP id t15-20020a1709027fcf00b0013ec994ee67mr5847163plb.12.1633641557646;
        Thu, 07 Oct 2021 14:19:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 10/46] scsi: 53c700: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:16 -0700
Message-Id: <20211007211852.256007-11-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..9c2cc69dafdb 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -163,7 +163,7 @@ STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 
-STATIC struct device_attribute *NCR_700_dev_attrs[];
+STATIC const struct attribute_group *NCR_700_dev_attr_groups[];
 
 STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
 
@@ -300,8 +300,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	static int banner = 0;
 	int j;
 
-	if(tpnt->sdev_attrs == NULL)
-		tpnt->sdev_attrs = NCR_700_dev_attrs;
+	if (tpnt->sdev_groups == NULL)
+		tpnt->sdev_groups = NCR_700_dev_attr_groups;
 
 	memory = dma_alloc_coherent(dev, TOTAL_MEM_SIZE, &pScript, GFP_KERNEL);
 	if (!memory) {
@@ -2087,11 +2087,20 @@ static struct device_attribute NCR_700_active_tags_attr = {
 	.show = NCR_700_show_active_tags,
 };
 
-STATIC struct device_attribute *NCR_700_dev_attrs[] = {
-	&NCR_700_active_tags_attr,
+STATIC struct attribute *NCR_700_dev_attrs[] = {
+	&NCR_700_active_tags_attr.attr,
 	NULL,
 };
 
+STATIC const struct attribute_group NCR_700_dev_attr_group = {
+	.attrs = NCR_700_dev_attrs
+};
+
+STATIC const struct attribute_group *NCR_700_dev_attr_groups[] = {
+	&NCR_700_dev_attr_group,
+	NULL
+};
+
 EXPORT_SYMBOL(NCR_700_detect);
 EXPORT_SYMBOL(NCR_700_release);
 EXPORT_SYMBOL(NCR_700_intr);
