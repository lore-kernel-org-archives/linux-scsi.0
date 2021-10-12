Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B937C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FF060ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhJLXjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:13 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:41757 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbhJLXjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:10 -0400
Received: by mail-pj1-f54.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so898275pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0A/Jo7ruNv71phDeQouqyaE0CgD5Vcq7kG8jaJjaCc=;
        b=KhUBOeI5uiqMShfmncQljtxnjbz6Pe39o3iTTMDIjPuV2u67DYlLjJYWJpy9ZWC0LD
         +YV366HBQX47uHKzTzlvt1hlwbsI5RhRgFSpkuW7Cp8c/Jw7JWX22K/yvPH/HRpeXWfk
         Y7t0T/pptj9sX60Xj1ogNpOQ6T4H4jHmKdc4Kiak/gpQf6bw1jxgUKg2tbm13M2uIGao
         exkSKkBCzhHRsHDuJx4LpOUXXGygfuDZSZMynXlPb/d6o0W782nsIvx8cIL+uB8OiSZr
         GbhsMh1eoKNZoVS32CQqkMB8ZxdZ4pT0z/Rv1Oq4uOkNGpbdL0IgsW1kIMn+gUvkxLyh
         IGlQ==
X-Gm-Message-State: AOAM531uZ9jJlAG4pa3cZzN119miHJnta52vrVSMyGfp+pBRoE2HLlM0
        z1+6DtBgACgBYW6oHnzrxUnpupWw75g4kg==
X-Google-Smtp-Source: ABdhPJzFL8ENMIv+GnGSvNoAJO8U97XSONMNHR/0qfZn6jh0txzBxO27DA/uvc91E4kPvulmqe11Ng==
X-Received: by 2002:a17:903:41d0:b0:13f:1bbf:1535 with SMTP id u16-20020a17090341d000b0013f1bbf1535mr23757270ple.52.1634081828287;
        Tue, 12 Oct 2021 16:37:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 33/46] scsi: ncr53c8xx: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:45 -0700
Message-Id: <20211012233558.4066756-34-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 2b8c6fa5e775..57fa29a1bcc0 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8039,11 +8039,13 @@ static struct device_attribute ncr53c8xx_revision_attr = {
 	.show	= show_ncr53c8xx_revision,
 };
   
-static struct device_attribute *ncr53c8xx_host_attrs[] = {
-	&ncr53c8xx_revision_attr,
+static struct attribute *ncr53c8xx_host_attrs[] = {
+	&ncr53c8xx_revision_attr.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(ncr53c8xx_host);
+
 /*==========================================================
 **
 **	Boot command line.
@@ -8085,8 +8087,8 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 
 	if (!tpnt->name)
 		tpnt->name	= SCSI_NCR_DRIVER_NAME;
-	if (!tpnt->shost_attrs)
-		tpnt->shost_attrs = ncr53c8xx_host_attrs;
+	if (!tpnt->shost_groups)
+		tpnt->shost_groups = ncr53c8xx_host_groups;
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
 	tpnt->slave_configure	= ncr53c8xx_slave_configure;
