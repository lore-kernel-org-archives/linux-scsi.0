Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92ACC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B11610C7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbhIQV3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:29:21 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:52976 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbhIQV3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 17:29:20 -0400
Received: by mail-pj1-f50.google.com with SMTP id v19so7818501pjh.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 14:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dpv0IguX0I04U03vE+eJ+SuP/GrkIfHDIYx9RU+hTX8=;
        b=DKyY9d3yOCRJ0wg/yG8U6CxBxsYpj4oT8N5Z31lPaU0bXcgFc2GH8bfiy7W7Qgdlfk
         NLuLp2iURhipWN2A+YSm5tHKAHKrcb+6q07Q6hVSRVLpYTjCv8udtN7GVTo8VuoNUUsz
         kpaefhSZnS/ywZHA+XP1U0R9oYyV6LxQWv6WBBgkmEL8yOTVUjoBArCtmCAb1jGRWQIL
         mY6BkOE2tqa7wBTzkMxHscOKDJLMn1vA2CPsvQ2SfCeq7xytbLLvMErw1Czm4UFPGA5b
         T7FhKoIZYgjLU+lPDMa2wY+j7Sblz31mmqXzOKP4753bPrKkx199GT29o8l0hxAj7hvU
         g6mw==
X-Gm-Message-State: AOAM530NuTUisYIze0tAQPffWT4W8b65WceQleiBBxOr5cd9lPNb69Xe
        LmlZqDNb1sVdsqlHFR/SfTY=
X-Google-Smtp-Source: ABdhPJzIFI36JvdS24fSnxko9QtzqeD+4MYrjfO2cfa+MC2ksxQKn+uc/5OgWUzP5SI26j5YHJSxiw==
X-Received: by 2002:a17:902:bcc6:b0:138:d3ca:c356 with SMTP id o6-20020a170902bcc600b00138d3cac356mr11238941pls.6.1631914077898;
        Fri, 17 Sep 2021 14:27:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id b12sm7003465pfp.5.2021.09.17.14.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 14:27:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH] scsi: core: Remove include <scsi/scsi_host.h> from scsi_cmnd.h
Date:   Fri, 17 Sep 2021 14:27:51 -0700
Message-Id: <20210917212751.2676054-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are no dependencies in <scsi/scsi_cmnd.h> on the <scsi/scsi_host.h>
header file. Hence remove the scsi_host.h include directive from
scsi_cmnd.h. This include directive was introduced in February 2021 by
commit af1830956dc3 ("scsi: core: Add mq_poll support to SCSI layer").

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index eaf04c9a1dfc..a2315aac93c7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -10,7 +10,6 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>
 
 struct Scsi_Host;
