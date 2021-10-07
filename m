Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C20C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AD261262
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhJGVVK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:10 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:34566 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbhJGVVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:09 -0400
Received: by mail-pg1-f178.google.com with SMTP id 133so1052951pgb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cdegBQ5T6pWDHp5N0JyQN/xGdWSN4ESv7t9NASXDVPQ=;
        b=Vtd1Q8/R+LCX5cWYMMcdFhYQBekZCOhisCM3P7TUqP4Ho1NzmXYqJQS8HOYpKLpTSi
         Qf0iHu4YFQRlsFhlTxkd/8TSrHmWU+9BrF+LzWRVOwIFssO1tKDzA4KQD+0rkMNPCKmm
         aS6t72+JJjehdr+XjXkf9F/Ub0qaTMgCwfAF2G/tEccx3Api3FPcuy3orhJT1NBnY4qi
         RDNFL8V+oEwe3JCwR/JpgAUBaEutcidfwPj8itphQyLEodWf3ldqcuOlz1F6AGlm+e1W
         8ClHEEJzN0BfXbobqMIDK+f/O024u0D4tq5jnanevf2IcP4p6FhPJrpDRvbm/3DZT18n
         RinA==
X-Gm-Message-State: AOAM531zPky5U5rK5f7kQ/7CKQ5BtXp7h7moMJC1HNZWpAfu87lKk45Z
        gKOC9DM/sGYFpcO7Q5uWbgA=
X-Google-Smtp-Source: ABdhPJwJ4nxSKeTfZRcWoLqbgLZqlHcm9SAIBlUB0+AwJGwbrOQ9+mNI3DCHkKaYZilX3koxw9B74A==
X-Received: by 2002:a63:f145:: with SMTP id o5mr1497503pgk.273.1633641554851;
        Thu, 07 Oct 2021 14:19:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 08/46] scsi: 3w-sas: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:14 -0700
Message-Id: <20211007211852.256007-9-bvanassche@acm.org>
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
 drivers/scsi/3w-sas.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..26623a10a2f5 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -198,11 +198,20 @@ static struct device_attribute twl_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twl_host_attrs[] = {
-	&twl_host_stats_attr,
+static struct attribute *twl_host_attrs[] = {
+	&twl_host_stats_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group twl_host_attr_group = {
+	.attrs = twl_host_attrs,
+};
+
+static const struct attribute_group *twl_host_attr_groups[] = {
+	&twl_host_attr_group,
+	NULL
+};
+
 /* This function will look up an AEN severity string */
 static char *twl_aen_severity_lookup(unsigned char severity_code)
 {
@@ -1544,7 +1553,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_LIBERATOR_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= twl_host_attrs,
+	.shost_groups		= twl_host_attr_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
