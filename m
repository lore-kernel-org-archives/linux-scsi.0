Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEC7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20AE061077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbhJGVWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:00 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:55854 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbhJGVV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:57 -0400
Received: by mail-pj1-f46.google.com with SMTP id on6so5889696pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TNx97LLmUQsTBLc+IBu2Z/Z4w2d3Be8G2j9YSn8di4=;
        b=QsOLVIq8XuZfFwMzau3zSGBp1kABG5/8U5KfEkXifyBWumg/hYObzqdS8gzYQ3ROdq
         Myw0FyXdPclzjwrTFkWttpMjT7BCl0N9xZ7EloKfd9hdXDY3+qI+3tSjrS4CDKVBaNCC
         EL+BJyf4NBGOk4B7mXFuyHOexWAoGP/SyucUyucusKIelZu+jNJp4LFLEP1ibEQ4RIgh
         PCVdTWZA15/U0K4fxwOmaIXDBoriJ8yWy+7GL5V3JWM5WkvnQHNRKrVu3z5kkII2w8hG
         /jeEJoByOk+fYtS+GeljVl2i/WKxT5LHjdrkgrGRQ3wSn7sXa6p1wsjZm6st3XEqzqJ7
         pZrA==
X-Gm-Message-State: AOAM530ybyg0Y/UTLMP/nR4PtAO2zWYfB5G23OWqgxtEknM/mc7uQSd6
        U0hfZz1u8tu5LbsaS/ipn5I=
X-Google-Smtp-Source: ABdhPJwYa/xu52JeXQbyVRsCrMtCQ+0p8wwvaUb2Ix6GZh/jAl5gsYNkM3DKGhBoQxftK+qwTdEjiw==
X-Received: by 2002:a17:902:be0f:b0:13a:19b6:6870 with SMTP id r15-20020a170902be0f00b0013a19b66870mr5970264pls.64.1633641603156;
        Thu, 07 Oct 2021 14:20:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 26/46] scsi: isci: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:32 -0700
Message-Id: <20211007211852.256007-27-bvanassche@acm.org>
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
 drivers/scsi/isci/init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index ffd33e5decae..ae7b6baade99 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -142,8 +142,17 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
 
-static struct device_attribute *isci_host_attrs[] = {
-	&dev_attr_isci_id,
+static struct attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id.attr,
+	NULL
+};
+
+static const struct attribute_group isci_host_attr_group = {
+	.attrs = isci_host_attrs
+};
+
+static const struct attribute_group *isci_host_attr_groups[] = {
+	&isci_host_attr_group,
 	NULL
 };
 
@@ -173,7 +182,7 @@ static struct scsi_host_template isci_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl			= sas_ioctl,
 #endif
-	.shost_attrs			= isci_host_attrs,
+	.shost_groups			= isci_host_attr_groups,
 	.track_queue_depth		= 1,
 };
 
