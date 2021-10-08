Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1231C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D935461019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242698AbhJHU0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:45 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:33747 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbhJHU0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:42 -0400
Received: by mail-pj1-f53.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso7748363pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVOj+z+fC+OkziZLouFRzUSU9wn71Bv1br5KDIOkAMU=;
        b=sZGNpX76CL+xm49XrGjLzVLjsjpEo1Cp3L/2V2/siKehuhe6uY5GUGgKffpja1cKKP
         evpbbFTtuKWSwp6EgPn26ywHejljMbRMaNhbzdbnYpJiJa7qAUeJdNw46BMWufPSoLN4
         CmxspBnkmKY00yEqaYkLRsuNYwjs4g4WgZEXlrleqEbpwte+zfBtBr4dl7gHEB+KMP8A
         gCx1WAMXC5ADKijqRZTfVUWMLd78UlltzqHbrGDBPONu/EkZp9qNJnFToJP6qxcpcPAS
         2Yy2tu0kSvvif229a/2DO8kJ2XK/rSm4rWqR6OKdh0Sn5h2/nFi4plDpz/ik+gDaLZLQ
         RkDA==
X-Gm-Message-State: AOAM530hczF/i83afEflHpLSEUyJ23FpXmvGU7XfbvhHekTeIwwxW1u0
        H0xEaGPRPweUU/JE5I2UjQY=
X-Google-Smtp-Source: ABdhPJyTcuTsH7wTQ0R2jTrB72ejNT1z8tiE6vvWFpyPgHi8CeJT+5+97V8yvz38dPC3D15FQw+s8g==
X-Received: by 2002:a17:902:e743:b0:13f:18ba:c8a8 with SMTP id p3-20020a170902e74300b0013f18bac8a8mr3670550plf.72.1633724686917;
        Fri, 08 Oct 2021 13:24:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 22/46] scsi: hptiop: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:29 -0700
Message-Id: <20211008202353.1448570-23-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..7250c1d7fffb 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1150,12 +1150,14 @@ static struct device_attribute hptiop_attr_fw_version = {
 	.show = hptiop_show_fw_version,
 };
 
-static struct device_attribute *hptiop_attrs[] = {
-	&hptiop_attr_version,
-	&hptiop_attr_fw_version,
+static struct attribute *hptiop_host_attrs[] = {
+	&hptiop_attr_version.attr,
+	&hptiop_attr_fw_version.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(hptiop_host);
+
 static int hptiop_slave_config(struct scsi_device *sdev)
 {
 	if (sdev->type == TYPE_TAPE)
@@ -1172,7 +1174,7 @@ static struct scsi_host_template driver_template = {
 	.info                       = hptiop_info,
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
-	.shost_attrs                = hptiop_attrs,
+	.shost_groups		    = hptiop_host_groups,
 	.slave_configure            = hptiop_slave_config,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
