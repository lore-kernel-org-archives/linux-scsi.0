Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E37C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D8F60EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhJLXjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:20 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:54039 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhJLXjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:18 -0400
Received: by mail-pj1-f43.google.com with SMTP id ls18so796049pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ttBrfGfVvdCJO0vAdUa5pmDj9rhhdRZtsp4QZiZrF2U=;
        b=cNWbRYNCt1sIzXX2NYBqOGaaGQSzgUzHeXXUj4+/pZWHxQqCbWdl14iZJ41aFkTDU4
         FwbrRFFVAmZc0kyXFw0mfpWR9vXdWLfYv+MRyoqandpa7uBqizic3hGDYv1oJXFOQYIo
         srzlGFcX4kW1YJSmuULF1Ca3yyMzNNbinU7qRylmkLVndATfRW9Bu82oRh43j3o9bv75
         E4wsEFCtrzixRF8BdCcG18pfao4gLkS5gfi11/qsGidNG7E2h9Mqpw8JdQem+xmJliLY
         giyKAQHqP50BBvwIdeLyeVbDIGeO8uvPLS0iRr2LY34susT/+/JGYvjs+773gHp9t6a6
         A0ug==
X-Gm-Message-State: AOAM5317BC1QTJ73qudZUYyAPVp1DAk9ipMRMttqd4hKNv7z5BjV+knX
        TqFtOfzGDMXt2M7ylxYHqfebwig/UGIskQ==
X-Google-Smtp-Source: ABdhPJwYcJAzVXbyTph0NtDTfv3PaahGecREN1Vs2KdQOi0ZpZJMwrDegPYzFA2z2h054yh75bEYVQ==
X-Received: by 2002:a17:902:d88d:b0:13e:807b:d52b with SMTP id b13-20020a170902d88d00b0013e807bd52bmr32636032plz.69.1634081836350;
        Tue, 12 Oct 2021 16:37:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 36/46] scsi: pmcraid: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:48 -0700
Message-Id: <20211012233558.4066756-37-bvanassche@acm.org>
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
 
