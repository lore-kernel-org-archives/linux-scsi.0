Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96949C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E7E61100
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhJHU0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:51 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:44856 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbhJHU0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:48 -0400
Received: by mail-pl1-f176.google.com with SMTP id t11so6837618plq.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIZc4myGIvO1lQfZsYDnY5KKqCZ0WsbuHlQI25Sk/3k=;
        b=T0kK1f79+Xh20Rj+44n/fPDTtDvN9C4JQeQHTrED+CP8lQ4HAr4jzv9CZbjM4m9Bu/
         +Rw9MxlAyZnPuieLR53mvk6OYKmmCh9TDzAQeGJ0RNnSOMlqXsJZ/tLpWzR6XdtNxc+C
         m0Qu8cUns7TdOPqsbd88TSyLTkDRJz5FH20G5tuwTnMS5+aoc9po9FyIg7WUbDyW3lNx
         NaGWRFVZnBFQjknkLYufAWRVK3wvr4oOtEqqAjSI3itmeBmoP2hh8j9yrMO+WH/9x3Fs
         W+zC1xdaNW85b3WyYoVjP0VKx9xwobNM+ZcBLvBDAOzsEGIFQpC74IVP5KeVFatsYxfQ
         FG5Q==
X-Gm-Message-State: AOAM531/L2YB14nMCBAzli9/wZIqCl84D2tavUd+93EZB0hcr/TQmIlb
        sGRfA0VCCX0saalouRABchVeoZx96zSkZA==
X-Google-Smtp-Source: ABdhPJwgWbw9mdY2Wnt4+ITzqonwePo56JS76QbCzHyoMRNm0fTxFHIcy3F++f9gDXK9117LdD3wmg==
X-Received: by 2002:a17:902:8a83:b0:13d:9572:86c2 with SMTP id p3-20020a1709028a8300b0013d957286c2mr11450535plo.48.1633724692602;
        Fri, 08 Oct 2021 13:24:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 26/46] scsi: isci: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:33 -0700
Message-Id: <20211008202353.1448570-27-bvanassche@acm.org>
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
 drivers/scsi/isci/init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index ffd33e5decae..aade707c5553 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -142,11 +142,13 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
 
-static struct device_attribute *isci_host_attrs[] = {
-	&dev_attr_isci_id,
+static struct attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(isci_host);
+
 static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -173,7 +175,7 @@ static struct scsi_host_template isci_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl			= sas_ioctl,
 #endif
-	.shost_attrs			= isci_host_attrs,
+	.shost_groups			= isci_host_groups,
 	.track_queue_depth		= 1,
 };
 
