Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548E8C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D9CD61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhJGVWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:16 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:39680 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbhJGVWO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:14 -0400
Received: by mail-pg1-f181.google.com with SMTP id g184so1035956pgc.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1AJLD3n469rpGWe1gMcw0PT8DJOqxM5sBHdkCfKoKI=;
        b=uFkdeCLd/tg8jh509xFWRtsoMyg6Qar95fj70Gaycn/1k2RSoIcWCCn9h4cxPyEPRY
         19g699wKvyGHDlhKKIJ0NXC99x8UjVs9SKZGZRdVURHIcLMMvT6Mev1pJiWoa1yzfmtG
         m/nOM67VzzNCtsBEiaEF/LtUPOR6sbLnJhl1X2XENvnq62gMsmDPDw3Cc7+HcXBx6YSM
         3DlB4yM3W3G4ApOaba2fg//3/8LFKh8DPJOuuLkKdCjccFvqUOM4W2sTuwtBxHB6EaKS
         q+n1QKE2LLQQAiUvMqjX4millit8r+lGKwv29MgR/ox15Lv1yeN04SGhBPSEm2Uu663k
         KUeg==
X-Gm-Message-State: AOAM5306VndBWR7Xza+G0FztvC0jXYvPgD4hSSej5zuFfhyyOO6iO8Wy
        +n2Tli8W+9+lL3nJTudOOOU78dRKHJiDLg==
X-Google-Smtp-Source: ABdhPJw9fxxnyX0FKseTpJoHLkiCSRG2K/g+U7ZFw9ZDT5Vw7agOXsSrj5WqlYX8b1m1srX/hxOmbw==
X-Received: by 2002:a62:3287:0:b0:439:bfec:8374 with SMTP id y129-20020a623287000000b00439bfec8374mr6296288pfy.15.1633641619687;
        Thu, 07 Oct 2021 14:20:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 33/46] scsi: ncr53c8xx: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:39 -0700
Message-Id: <20211007211852.256007-34-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 2b8c6fa5e775..a3e397ce9d24 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8039,8 +8039,17 @@ static struct device_attribute ncr53c8xx_revision_attr = {
 	.show	= show_ncr53c8xx_revision,
 };
   
-static struct device_attribute *ncr53c8xx_host_attrs[] = {
-	&ncr53c8xx_revision_attr,
+static struct attribute *ncr53c8xx_host_attrs[] = {
+	&ncr53c8xx_revision_attr.attr,
+	NULL
+};
+
+static const struct attribute_group ncr53c8xx_host_attr_group = {
+	.attrs = ncr53c8xx_host_attrs
+};
+
+static const struct attribute_group *ncr53c8xx_host_attr_groups[] = {
+	&ncr53c8xx_host_attr_group,
 	NULL
 };
 
@@ -8085,8 +8094,8 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 
 	if (!tpnt->name)
 		tpnt->name	= SCSI_NCR_DRIVER_NAME;
-	if (!tpnt->shost_attrs)
-		tpnt->shost_attrs = ncr53c8xx_host_attrs;
+	if (!tpnt->shost_groups)
+		tpnt->shost_groups = ncr53c8xx_host_attr_groups;
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
 	tpnt->slave_configure	= ncr53c8xx_slave_configure;
