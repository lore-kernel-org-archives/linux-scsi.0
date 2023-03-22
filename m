Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B058C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCVT6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCVT5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:52 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A50F62B6B
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:29 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id z19so9877070plo.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldCwiaYTLduiQcwSYGjGWFRviZrHcq79whkQrMLz5c8=;
        b=oB8QT0GHOcYj96Sc9AbpQnUOpCCDfRw+eOdK3O4j2vZxaP2aFounZyPVjIa7z2gRBQ
         FIWrKdnhuRGEvIcVAuKfttdXGlT4vzEzYSL5pZpuinvArQWrR6dj7QDOjN3CwmpRon4s
         qr48HzK+zQp4zCJN2Z2X7UGZc8lAIW3Y/Glo5tIFRE64bEC1WlkHK/jxh4wk+/OWScyU
         2mCtcCMxoqqkHFyovjJvg9dKMuwNz/XZ7Q5GkQKqVamW+VNwRq5IsofWB1Agkmv3m1El
         Og64C1FE058pw3ATsgfK2qSFJhgbPsqnMmd1DlnmR/ChtC8mMElj3T5SdlCRovAFL878
         id1A==
X-Gm-Message-State: AO0yUKVg1v6Coua1QwiQ+XKl1KottYI3u9MZrok8eArrUEAvZXk+jXfC
        pMv7l1cI2n56widNmO8ySN0=
X-Google-Smtp-Source: AK7set9s6hgJR+DP35nv/ez22vV2EXAbuMwXY7HKPEuQW4n467vlBBqc7neHoPaIUp6uyFDXiruDlQ==
X-Received: by 2002:a17:90b:3a83:b0:23b:569d:fe41 with SMTP id om3-20020a17090b3a8300b0023b569dfe41mr4544373pjb.7.1679515048756;
        Wed, 22 Mar 2023 12:57:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 35/80] scsi: fcoe: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:30 -0700
Message-Id: <20230322195515.1267197-36-bvanassche@acm.org>
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
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 38774a272e62..f1429f270170 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -260,7 +260,7 @@ static struct fc_function_template fcoe_vport_fc_functions = {
 	.bsg_request = fc_lport_bsg_request,
 };
 
-static struct scsi_host_template fcoe_shost_template = {
+static const struct scsi_host_template fcoe_shost_template = {
 	.module = THIS_MODULE,
 	.name = "FCoE Driver",
 	.proc_name = FCOE_NAME,
