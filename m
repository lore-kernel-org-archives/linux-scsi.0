Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E51EC6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCVT5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCVT5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:24 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57E969235
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:02 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso24514261pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mY8n6qv9N8LLv7AQOqbt+4UIwP3Foxsx5uXdnkkfbhc=;
        b=wQaX3DnXlvTQCHH/+KrO8hspnjNpUrRltKx8OiXXSjlVjQaigm/YSPT4kUeJE8cuf5
         1oViMbuKGC5zu+pfoNMrocOasm7iD5aJxuIiYKO4WzBmUEA+qE+Yb99X8Uflcsyn8Rle
         yzvvORliIjMutk3a+jubE97TTNA+E3RzSvP6Gcp3vb5vJbEeizQOQxKupvlsEByohBXO
         +IFUXR/zZg0VkNT+GnVfve40uSyPGf6QHiMRspl/UmEnfCGV5zd26bNALjgCBQC3OyZp
         7pv6LF3w8j/ikEHRb1/hnonbK7M9SFLJNQbfuM5PZjjdJe2ozFnGDVgWqFz6k/Nq9zhz
         rb/g==
X-Gm-Message-State: AO0yUKWaNR07E3Q4noKT3TmuiFmt1i86vI27zeXjur7lS8ynZyQHtMK3
        MvbjxLrijt8ixBn/qhJ3/i0=
X-Google-Smtp-Source: AK7set+ZzEN9KtFA9OihnAQAMhYbBLTOKxd3rrhYNm8uZM2ceD9ViW3DWRWjTJ1oqiWIU+SwqpItXg==
X-Received: by 2002:a17:90b:384b:b0:23d:5196:eca8 with SMTP id nl11-20020a17090b384b00b0023d5196eca8mr5245952pjb.20.1679515022198;
        Wed, 22 Mar 2023 12:57:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 21/80] scsi: arcmsr: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:16 -0700
Message-Id: <20230322195515.1267197-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 9d04cb6e62fa..b4242b1bd7b7 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -151,7 +151,7 @@ static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_de
 	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
-static struct scsi_host_template arcmsr_scsi_host_template = {
+static const struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "Areca SAS/SATA RAID driver",
 	.info			= arcmsr_info,
