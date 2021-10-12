Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC308C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D352960FDA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhJLXi0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:26 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35582 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbhJLXiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:22 -0400
Received: by mail-pf1-f169.google.com with SMTP id c29so859266pfp.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSy9HxHylqv2QQOMeguWwGRixQQsbcPSN7ac2lLyVBI=;
        b=lysHqHNgxSBRoMIQIYsqW9SyeLyO+AsfVCEr9xSJRY22jgJu1VZhCt/IRTRuSUqaoN
         WczsWk53XkWEbMgt2wuDjcX1xwWtKq8RmSW6ZczWaVJ6xoAWq05LQ9MTzu2YrQ7IzPE7
         LGXNeHpD6+GOWGTs4oW9qE25M2GDqjWB8o3Q8zWn7XH3ehzzDFRxsV3qJcwy2s4FAUZp
         3refMgwidmb/rPIqB2ZuivaGwHr31u8OBUutNIPYxqe7WY0e5k5V0nxJNQhQZnPrIvbK
         4BMT6ysmwJtb1woEaZ4ACEvTxDmGs/hAGfl79Umq0ckQQXvJxicbTteTY3oo60yCh2hb
         Pfyg==
X-Gm-Message-State: AOAM533sgpw/KLMm5e3doL4PQ3mskkv1WsU/53AG1JROjO6RT+NOomCU
        vC7aVPKYwDeSByncY9LTqLQ=
X-Google-Smtp-Source: ABdhPJwuWi7UwiV6UhpDqNdFtijBm/WH0vn46XSND/JVgY5IlEGUekFlTG6ek4JkJpdzpEB1QbXylw==
X-Received: by 2002:a62:5257:0:b0:44c:ed84:350a with SMTP id g84-20020a625257000000b0044ced84350amr23301979pfb.79.1634081779700;
        Tue, 12 Oct 2021 16:36:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 09/46] scsi: 3w-xxxx: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:21 -0700
Message-Id: <20211012233558.4066756-10-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..db4e5449d516 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -532,11 +532,13 @@ static struct device_attribute tw_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *tw_host_attrs[] = {
-	&tw_host_stats_attr,
+static struct attribute *tw_host_attrs[] = {
+	&tw_host_stats_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(tw_host);
+
 /* This function will read the aen queue from the isr */
 static int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 {
@@ -2242,7 +2244,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= tw_host_attrs,
+	.shost_groups		= tw_host_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
