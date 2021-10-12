Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66F6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF3A60F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhJLXiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:23 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43572 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbhJLXiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:20 -0400
Received: by mail-pf1-f176.google.com with SMTP id 187so820151pfc.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjKCG2T1ZRnPvoHNzt683A74Q4/xP4EPAort/dG+Q+Y=;
        b=C4BEvB8CBQJuuuFEuj/pNvmtRuzFFXKa72tg5Rzf+qEobhYi5fHTDhlgQdO6l7qcXK
         iE55gppju3wLljEvfYseKb/g10UGUvDeDW8NyEICp9S/rknp0+vWvnK24/n3N23tr2zx
         nq+fWJxF8rK1r6KyA41IVA0mlPWSIJr/kJhoa98D2K5BUiOqlHusj6R+FfBpt6KNjNBF
         Q82gizKFYsB0DcPCmHRAQni+QkbzM6hn/m0H4FgfG5XEStO61v9IpIt4zaQPQgwpFldQ
         rRiI4UvT56iavgmQ77jz7Kz2bmsflr7qoe5JLbhzp8Ks6obtzYV2CqL5t6HzBckAxO6O
         fwBw==
X-Gm-Message-State: AOAM532iL9Lf8pd5xIK66agdzsR+x5nPq+bqAXSF90mQmBo9pptlLeip
        HojKzwi8+Y7yy5U9h0+9IE8=
X-Google-Smtp-Source: ABdhPJyashgFet2mWozvcJthjinlzpoDZGunb0eZvfx/QZQKVJsVDqxZygF9CJfAUEj6V/eLi0jjfQ==
X-Received: by 2002:a63:101c:: with SMTP id f28mr24880605pgl.330.1634081778427;
        Tue, 12 Oct 2021 16:36:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 08/46] scsi: 3w-sas: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:20 -0700
Message-Id: <20211012233558.4066756-9-bvanassche@acm.org>
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
