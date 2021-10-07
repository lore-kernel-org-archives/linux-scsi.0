Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFABFC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8FE61130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhJGVVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:09 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:47075 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhJGVVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:07 -0400
Received: by mail-pg1-f169.google.com with SMTP id m21so1009082pgu.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PweJP6JFLiU7G7nl2Q6zAbDmifO27Nz8sDlEo1R/SXE=;
        b=bHBQPZr2NMe3vui1bk/LgQmz7wTvSqleGMkRFumvYJN+PZr+Hb02nYyY1g+ql1VfIv
         gBW/ebMBY+WZmVQuRz4jBJ0XL5vG0Ph5QJ9K4sOvfi9UgAMzpvZgtbziGU5UjVkngLO0
         duBZF2VLNB7bKkkk8BNgBPMJ9AzVYjrrGL9tzIMFnA+ivDkQo8/iCa4e/yS7lEx0lTrJ
         NNXQaqv6FSrNAOgzedGmbWHtAhVEllouVWUHlkbX4CYQRoJ5651fdO2eXEkKtHiWaPJV
         VQTPCuBDI30/3Fh/QvvivZ0qNkoC8XIE0NH0xBdFCTlcrqHTSXvy4dhKFxUGgR3Kojd/
         BCbw==
X-Gm-Message-State: AOAM5338SrtmTgio9FIRGFVXlL8NYQTGutblbbzfe8zbZT04yq6kFIfb
        YC2p4HL0GM+OaX3Fyt6+aV4=
X-Google-Smtp-Source: ABdhPJwfGyRW7F+3LvMQPYVmBy0qpCcY+dBXnMRUE/5Qg7KoWUyPPxeHUb7rXqRPIXCm+g+0ETDbvg==
X-Received: by 2002:a65:6aa8:: with SMTP id x8mr1543460pgu.136.1633641553436;
        Thu, 07 Oct 2021 14:19:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 07/46] scsi: 3w-9xxx: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:13 -0700
Message-Id: <20211007211852.256007-8-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e41cc354cc8a..785b3819588e 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -197,11 +197,20 @@ static struct device_attribute twa_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twa_host_attrs[] = {
-	&twa_host_stats_attr,
+static struct attribute *twa_host_attrs[] = {
+	&twa_host_stats_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group twa_host_attr_group = {
+	.attrs = twa_host_attrs
+};
+
+static const struct attribute_group *twa_host_attr_groups[] = {
+	&twa_host_attr_group,
+	NULL
+};
+
 /* File operations struct for character device */
 static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
@@ -1990,7 +1999,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= twa_host_attrs,
+	.shost_groups		= twa_host_attr_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
