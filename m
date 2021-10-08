Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDFAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636576112D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbhJHU1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:18 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:44791 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242783AbhJHU1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:08 -0400
Received: by mail-pj1-f50.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so8631045pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ttBrfGfVvdCJO0vAdUa5pmDj9rhhdRZtsp4QZiZrF2U=;
        b=22NQpr6x6U3f7LWBY3JhCIAohWVegzJTA5xmj4+THbrjQtRfBiZtt02Bdrgr4/eSsd
         k1l1lZPNY1n4i0A3cbSrbOJzezaiCMRt/Kt4xCaWL4RRZ7PWaiXseGpnV3EzxQcJ5adN
         Ok+3YVtBuuq9dp+EJ93sPYn211jzrAw52O4UVbiIq8WIWR+Oq+shuoJjIj3tt2gApVbh
         JzbUdjbBPcQi8uxaMrOAK0B8raVSjAMvSAxgSm2/yHZlFrdjFlHO3B7IMwEXXWHLMMrz
         O/tnJCoVfNo1tNqnBa3u3F5cBVKpVqVsD1mbKr/NGkI7GmI7tkCg8rwU3KJNAdtChH81
         o1IQ==
X-Gm-Message-State: AOAM530S1UwLYKCFtIO5rFUKse1kqtddz2sH2Fk7DmXNv1ZyIX3a1pIx
        1ker8yTVmhN0VgspGmqz6iCwq/temtxAjQ==
X-Google-Smtp-Source: ABdhPJx1OSdj6CtpMvqUUjRzU8Ood4LZtApeKa61gkYffAbfTqG2M1FOe3i3uJgpnt2PQOMj8aH7wA==
X-Received: by 2002:a17:903:2287:b0:13e:5d9f:1ebf with SMTP id b7-20020a170903228700b0013e5d9f1ebfmr11178870plh.75.1633724713020;
        Fri, 08 Oct 2021 13:25:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 36/46] scsi: pmcraid: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:43 -0700
Message-Id: <20211008202353.1448570-37-bvanassche@acm.org>
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
 drivers/scsi/pmcraid.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..ce08bd34f205 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4097,13 +4097,14 @@ static struct device_attribute pmcraid_adapter_id_attr = {
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
 
+ATTRIBUTE_GROUPS(pmcraid_host);
 
 /* host template structure for pmcraid driver */
 static struct scsi_host_template pmcraid_host_template = {
@@ -4126,7 +4127,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
 	.no_write_same = 1,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
-	.shost_attrs = pmcraid_host_attrs,
+	.shost_groups = pmcraid_host_groups,
 	.proc_name = PMCRAID_DRIVER_NAME,
 };
 
