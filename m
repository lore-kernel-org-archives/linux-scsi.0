Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447CEC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCIT2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCIT2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:04 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37C440C9
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:55 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so6320853pjn.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGAtFpoWpz/OcncKuNsqhXl/J3Y5AN3EUnYkklVU1uo=;
        b=Z9kVsi17Ldq+a1cInQ9ytD8AP16Fvh+bSBuOZQmHTUEltL7AnS83r395QExcWVv24S
         n7NYioxmFsANCnimKoA5ABgO17XJskE7H3tP9twtOoCV3YlWMPwUU+q2X+hX0ESNAR0x
         bbdoD7PR2b9KKs9p31VH+tkcWKM3dStNo76hWUZJ0HVePyd+HPt83tx5g9O4oamul0/p
         tT52s5EWFb6sc9mTbuDplhQbXczcr97VJopQm5uDxMaflTW0jADGYpTJ1MbLOyCI/7rF
         XP29vNwMwKjFVbCICGimgniXG9IoflRMId7e8A+zfFs7NmDNTDNzOwR0yQWtY0ezW+xp
         yK7g==
X-Gm-Message-State: AO0yUKX9p6zNJ+q1xlASSwhoibrWY5Qp5cSDjMURRcnff8P7f6ls+Gw4
        s0w3Ddwtmi7MynSLjD0eJbP0GoiXjfB7dw==
X-Google-Smtp-Source: AK7set+Yi0sOfc3PPtYsF0ZJj/tsprBBa0GcKPMA5JmajeDeq21MM5LoyAt7DnhVWhNBheHdoawz4A==
X-Received: by 2002:a05:6a20:6712:b0:cb:ec3d:4783 with SMTP id q18-20020a056a20671200b000cbec3d4783mr20343839pzh.21.1678390075426;
        Thu, 09 Mar 2023 11:27:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 21/82] scsi: arcmsr: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:13 -0800
Message-Id: <20230309192614.2240602-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
index d3fb8a9c1c39..32bc77200eaa 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -152,7 +152,7 @@ static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_de
 	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
-static struct scsi_host_template arcmsr_scsi_host_template = {
+static const struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "Areca SAS/SATA RAID driver",
 	.info			= arcmsr_info,
