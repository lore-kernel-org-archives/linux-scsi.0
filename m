Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56099C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FDA4610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhJGVWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:25 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:37467 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhJGVWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:25 -0400
Received: by mail-pf1-f170.google.com with SMTP id q19so5927987pfl.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygEv+xZST9StHiLezL0C7azIwOvIYy/dJeMwCEgSM7E=;
        b=oj+uMGFQWF2p0EZpJujKF928rR12DZFh9dcMSZXdC8R6idkjg5Kk3oigw5Q33ntSJp
         6R2qcPFz7nSg8OgqX5lwu2LFpBnHnnRpxTJUugo0PEUkhs71+YASWF4F+TCALjKr/sOa
         uruaI2hqccr+ad4XHvOYXMvWNwijVjYx7wN7mPlUZeIvr8Jk4gumvNFf7ropWwE0Bstl
         yZwm+2hc8s5feOzEzvYphjfGAjkFD2DewdVL2wqHemwlF/3BbRi93aveS1/znQY7yuy2
         mm99YOKx57fMr4fDm7qx/1Q+wB4lf9LCJxWAU6Sk0Y6EETWUXmUhYnUapM36yxY/b9Kv
         my+w==
X-Gm-Message-State: AOAM533yC2473y/LMiGjlV+jce4K2TojyTLjNxFJneDVn/kvyG314g4h
        E5ai+tgIXOdjSyBH4M81S1E=
X-Google-Smtp-Source: ABdhPJwiKu2rRFqvqGhPiAjGRrt/dzMebMBbP0Hq2/ZRPGopfglpJDrWwslWkmgLQPXD6r8dkpSpTw==
X-Received: by 2002:a05:6a00:10c6:b0:44c:56ff:91ea with SMTP id d6-20020a056a0010c600b0044c56ff91eamr6495115pfu.25.1633641629515;
        Thu, 07 Oct 2021 14:20:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 36/46] scsi: pmcraid: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:42 -0700
Message-Id: <20211007211852.256007-37-bvanassche@acm.org>
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
 drivers/scsi/pmcraid.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..2cdddb53ca21 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4097,13 +4097,21 @@ static struct device_attribute pmcraid_adapter_id_attr = {
 	.show = pmcraid_show_adapter_id,
 };
 
-static struct device_attribute *pmcraid_host_attrs[] = {
-	&pmcraid_log_level_attr,
-	&pmcraid_driver_version_attr,
-	&pmcraid_adapter_id_attr,
+static struct attribute *pmcraid_host_attrs[] = {
+	&pmcraid_log_level_attr.attr,
+	&pmcraid_driver_version_attr.attr,
+	&pmcraid_adapter_id_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group pmcraid_host_attr_group = {
+	.attrs = pmcraid_host_attrs
+};
+
+static const struct attribute_group *pmcraid_host_attr_groups[] = {
+	&pmcraid_host_attr_group,
+	NULL
+};
 
 /* host template structure for pmcraid driver */
 static struct scsi_host_template pmcraid_host_template = {
@@ -4126,7 +4134,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
 	.no_write_same = 1,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
-	.shost_attrs = pmcraid_host_attrs,
+	.shost_groups = pmcraid_host_attr_groups,
 	.proc_name = PMCRAID_DRIVER_NAME,
 };
 
