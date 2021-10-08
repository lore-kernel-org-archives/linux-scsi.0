Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE6EC43219
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3783861073
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbhJHU0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:09 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:33721 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242366AbhJHU0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:07 -0400
Received: by mail-pj1-f53.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso7747757pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjKCG2T1ZRnPvoHNzt683A74Q4/xP4EPAort/dG+Q+Y=;
        b=QUvXsxbnupKNY1xut5WDei4YCpk0N2DM1Fk9sBa6TAmZRzZ5P0dd6eGfV6DHMf/ham
         gS9X5xTn/mmNCPwSN8ahZk0SAqyvga1ojbMK0ShVHVe9RsG5Q1CmpWE5QfEK1Ndn0imK
         0PnDsuRtviqINhlu2CwX4Y6FTyVPqND2C3zAOYG/jIu/7RexOdThjZ4RGfKd5DQIUAE9
         s2LmkOifVLUqQ12HQ9kitu/GCuQNI+1roj+PLxQ3HQ3sA40yViLfvnN63vMXt11nl9d5
         x7JWu2xTfPB06oWH4fdIq6/T8D1rx1nZ/bdsrRGMqNXnRo0g1X5fs4h8YuSjEMf9Y8kS
         cLVg==
X-Gm-Message-State: AOAM530vr39jFyPBWkUkjHbEAZcCY6o4QA0gIzWF1Dh6f9pL6dcyZ43c
        McJ9VEIBxq9gDFyMCK66wi0=
X-Google-Smtp-Source: ABdhPJwYHzDyQmIazIyvyoRJcGdfgI3IFFgu37GEAT6mR7qbYfepI4W5DME56EzKE5cK4KZurdB7Ug==
X-Received: by 2002:a17:903:283:b0:13e:f38c:2282 with SMTP id j3-20020a170903028300b0013ef38c2282mr10973087plr.82.1633724651872;
        Fri, 08 Oct 2021 13:24:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 08/46] scsi: 3w-sas: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:15 -0700
Message-Id: <20211008202353.1448570-9-bvanassche@acm.org>
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
 drivers/scsi/3w-sas.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..42414a58f368 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -198,11 +198,13 @@ static struct device_attribute twl_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twl_host_attrs[] = {
-	&twl_host_stats_attr,
+static struct attribute *twl_host_attrs[] = {
+	&twl_host_stats_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(twl_host);
+
 /* This function will look up an AEN severity string */
 static char *twl_aen_severity_lookup(unsigned char severity_code)
 {
@@ -1544,7 +1546,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_LIBERATOR_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= twl_host_attrs,
+	.shost_groups		= twl_host_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
