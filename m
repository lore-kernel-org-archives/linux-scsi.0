Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA030C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjCIT3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCIT2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:42 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F6429E13
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:40 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id s18so1728979pgq.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIIFRGbiH4biuLQ8Ka3oAwiIlc3Ew6o8lJOxme8R1Gw=;
        b=r8VbmDrElx4QYKzE0xFNkOSEFhfFmSqgmKNRhe4qjnTRoONSFK2m1nfGiYIF38oRhF
         48M75UwY8aUIrEhmsBKdRFLoc7jG20XeP50UF/BwGjRb1+bxWxm1OVu7iHvNdTbkflbB
         eZxU+CRu70RjWNhgP2VjQL/tJ0orBF4R5uQlCFEo8pDJqYgFGVaDcVi7zx2oqfc7Etlx
         N9WLuwsNmGn1bXOXesTLmJqw/dSxpqDAbpQFzZZfZ2Tnt5fr5qoLy+oaVPgYTeskWdFh
         CSrJus6AGjx2mjYyjgg8Vms6//Xk/zCuaKyP/9aoeCYWR3+LeqiXBrDEinysMdC0iAay
         Rh5Q==
X-Gm-Message-State: AO0yUKXn3omLqYk9Tk39lE6mBITtErdAnyBJNHJ+6rQdnh1a6S3TV/HZ
        RlZsFmLaPm7EPKFJ3kHRDYo=
X-Google-Smtp-Source: AK7set+kID//RqwFLNkul161xj/xvqGy2zlL0vXgmty8od502u5HLZsmRzMd3FsyAjcWf4NQx+0lOg==
X-Received: by 2002:aa7:99cc:0:b0:5e0:fb42:7360 with SMTP id v12-20020aa799cc000000b005e0fb427360mr18920452pfi.11.1678390120001;
        Thu, 09 Mar 2023 11:28:40 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 42/82] scsi: hpsa: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:34 -0800
Message-Id: <20230309192614.2240602-43-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f6da34850af9..ff8436fe6dd1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -967,7 +967,7 @@ ATTRIBUTE_GROUPS(hpsa_shost);
 #define HPSA_NRESERVED_CMDS	(HPSA_CMDS_RESERVED_FOR_DRIVER +\
 				 HPSA_MAX_CONCURRENT_PASSTHRUS)
 
-static struct scsi_host_template hpsa_driver_template = {
+static const struct scsi_host_template hpsa_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= HPSA,
 	.proc_name		= HPSA,
