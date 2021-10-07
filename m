Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E6DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D92C61077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhJGVVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:12 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:53106 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhJGVVK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:10 -0400
Received: by mail-pj1-f51.google.com with SMTP id oa4so5200708pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2TcWalGXcL8nJgIfJJ1nNqtxEmL5HXf/1lU9zJ13tqg=;
        b=V0cmHhKOzriY8kBMpk919gyn3IwO+2ONaeFVWUbQbfZWavGwck4r/SYjP/yT23KjXs
         HE6L0TDyS7vqbUbWp2S1KEs0Vo+CZjIEXxzIxYMoM2q62TLKAjFi+ERkQn/LJ3MT1YAt
         rWV9sf1xYC1slTtohmXOkVzNRRzmz0PcKKZSet9lxH/AgIixH2dKCGIXFwuaVDlrQC+O
         vSuwX92kczjCtrO5QzasBYGF/rrW4dESXCil8psQLRiMHtAfpZKY8b22zMUiFZd864/v
         HrwVIFOk6z7dQ5dUIEiL+XOFsEMOfSvqtcuzuEqmaOpTGNJJilXvqwHyiT1GGeWJTcEE
         eRDw==
X-Gm-Message-State: AOAM530U+nyGhc1TV1EquCg0Rrdq66naLBAFQyrDQUwclGSRjajEat/4
        WNCrD/N/g+VFair/7Q88NIg=
X-Google-Smtp-Source: ABdhPJxMGGjMayho3gPQ5exUk3JEvPUOmItI+SNEmlC30kFW1kRUqgyVLn47GIBUnjZXPntpns4DTQ==
X-Received: by 2002:a17:90b:4a45:: with SMTP id lb5mr7926159pjb.94.1633641556306;
        Thu, 07 Oct 2021 14:19:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 09/46] scsi: 3w-xxxx: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:15 -0700
Message-Id: <20211007211852.256007-10-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..3994df64b43b 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -532,11 +532,20 @@ static struct device_attribute tw_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *tw_host_attrs[] = {
-	&tw_host_stats_attr,
+static struct attribute *tw_host_attrs[] = {
+	&tw_host_stats_attr.attr,
 	NULL,
 };
 
+static const struct attribute_group tw_host_attr_group = {
+	.attrs = tw_host_attrs
+};
+
+static const struct attribute_group *tw_host_attr_groups[] = {
+	&tw_host_attr_group,
+	NULL
+};
+
 /* This function will read the aen queue from the isr */
 static int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 {
@@ -2242,7 +2251,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= tw_host_attrs,
+	.shost_groups		= tw_host_attr_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
