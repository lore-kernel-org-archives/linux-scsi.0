Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52203C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 313C061130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhJGVVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:01 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:40651 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhJGVVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:00 -0400
Received: by mail-pj1-f50.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so7905942pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=buSuDP4vBxSyJVBvFp1R+c0HMrmsuxbhAawkNxUQA5M=;
        b=T6l4Qq4h+hVZDdudHQ9AIwKvSuTDpbvYxmi0s3sJruPQovl7nzZPP7NBhLahBv0QS2
         8FUGgBPs3TTbr1J7yqEyQkfOP8tT93bsSLFFU0V1cHN8rIA21eiAjNWwtvAfLwHslsEN
         HrFg6t712OEwc4Usx4kxCRbDSOQBm/NyagIXKzWEvORVJ3tG7ZH15Aa2UzpKuknVdCPc
         kvhdc4R/1u4fXimO3tMpdUYUGaMNfDuB/FIwhAtaQD/c/26UdlN+jyZEPHtUZ0Tjq7Td
         xGC9D96jFjBNqQZZFqnwVgkrdsOGjFSnKBbFW3RYNYeQC0oX6KRamlo99FQey8vCMvU2
         RCZQ==
X-Gm-Message-State: AOAM5304/3+A9LbLn17UiAnaYvor7R0ldp0QR9yOLgmANUweF3aOujZ7
        kpmMkNBGLNFPRLqy24FM2XYQe2FTadRHvQ==
X-Google-Smtp-Source: ABdhPJzzCpnQEMiPjmUGyKTXQ76tGiowURjyosOsYC5M8N+mTdyfxdoluVl8J17yNQIQQ7zTzlcRsA==
X-Received: by 2002:a17:90a:ab15:: with SMTP id m21mr8034170pjq.166.1633641546437;
        Thu, 07 Oct 2021 14:19:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v2 03/46] firewire: sbp2: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:09 -0700
Message-Id: <20211007211852.256007-4-bvanassche@acm.org>
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
 drivers/firewire/sbp2.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 4d5054211550..f0fcd81402e3 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1578,8 +1578,17 @@ static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);
 
-static struct device_attribute *sbp2_scsi_sysfs_attrs[] = {
-	&dev_attr_ieee1394_id,
+static struct attribute *sbp2_scsi_sysfs_attrs[] = {
+	&dev_attr_ieee1394_id.attr,
+	NULL
+};
+
+static const struct attribute_group sbp2_scsi_sysfs_attr_group = {
+	.attrs = sbp2_scsi_sysfs_attrs
+};
+
+static const struct attribute_group *sbp2_scsi_sysfs_attr_groups[] = {
+	&sbp2_scsi_sysfs_attr_group,
 	NULL
 };
 
@@ -1595,7 +1604,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.max_segment_size	= SBP2_MAX_SEG_SIZE,
 	.can_queue		= 1,
-	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.sdev_groups		= sbp2_scsi_sysfs_attr_groups,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
