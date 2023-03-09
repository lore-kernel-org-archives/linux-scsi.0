Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8086C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCITaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCIT3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:16 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C845F146B
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:12 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7309383pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4THt1XWxiaNA5/lNNqEHujl/AmU30SJrb0Ru4wIejY=;
        b=1HY3yMzrzQJ6/NnUu/JOu+Uh8/9fIaSiaoxNLKkmjyf2qkaBQGAQBQ/2ROk9QYVv7Z
         U5BcOWHfSVi9El/tUbVqwFr+Y8hdAA1NMr2xJ14Psml9mOZwffvmeXI54WWzFzRio66I
         LFFQ7eZggWPjqSc23bMYBxvGpT6WxTheUKHgg2FcPu/DK8S4sN3UFvJtyc0DlFRT44u5
         fKsswlykHFAup05b0ecXHf5KC3Rr5P5j1iusstTr1HkVaZoY4KMJX0Y/GomWAXu0MGN9
         iAti7wBfLQq9awjBZhIPFsvcxVMzP50iqw1eo66z/KbLrgzSLyONfgzlp9X43Z5mo2dg
         +dkQ==
X-Gm-Message-State: AO0yUKWmf9EQzjEXg+nqItn9OBVAQF7qFdpZzb4GxC7ktVbCuPFbzf6T
        gTdx7lbx3ayPT66x4z27jGU=
X-Google-Smtp-Source: AK7set91cU/5m35VLLLqwP2zQ8/zcPy1rmVnqhuDVk5fL9PTcCfZsqjlgEFPv3YhtSvpe0yrp5oZwA==
X-Received: by 2002:a05:6a20:7f8f:b0:d0:15c9:4e67 with SMTP id d15-20020a056a207f8f00b000d015c94e67mr15119629pzj.19.1678390151651;
        Thu, 09 Mar 2023 11:29:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 51/82] scsi: mac_scsi: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:43 -0800
Message-Id: <20230309192614.2240602-52-bvanassche@acm.org>
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
 drivers/scsi/mac_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2e511697fce3..1d13f1ebc094 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -422,7 +422,7 @@ static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
 #define DRV_MODULE_NAME         "mac_scsi"
 #define PFX                     DRV_MODULE_NAME ": "
 
-static struct scsi_host_template mac_scsi_template = {
+struct scsi_host_template mac_scsi_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
 	.name			= "Macintosh NCR5380 SCSI",
