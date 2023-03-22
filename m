Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91498C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjCVUCZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjCVUBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:54 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3096BC12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:00 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso1751558pjc.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmH/5IDY29elfLiT8SdhUeTtrZ6olPcPm8Il5WJPzag=;
        b=sXkw7btRB+r/dsoUITJiz8jUwo+h+o00TAFlmAHsufheq28VAvFbS0+vmAStAtgYHh
         VtHrOshqwUG6UfSAdVKhcnQhm6pLSM4ltwBv/uQq8BrUT6vbA/kyIr/nUXDJ+kL2nOLA
         bqbFGDEbmEiGJoXq+e5TX8qSFYE/DZj+baAroszNPPCaSsS8bBhahFTpoEMngnTflo1P
         wJPTzIhLdxY267YOD48zyX4loFPp58JOS3N8eipLIS9BntxWlft/2I5ZhTMYB80y4WOs
         1zhmJC3kR9LPvJ9+bJ6RkYxxMxGo96iJx7HmtgUiI+aFHtsJogjYFHnUPejhQmPzRGQc
         8UPg==
X-Gm-Message-State: AO0yUKV/CNJl9FmEWJI9vrVc+78/Tg+fIcguaKcT8hIvO6yJAqBEAeCN
        tVq//e4pVDX744Y1q4SZ//udNwMOdTxWUw==
X-Google-Smtp-Source: AK7set+z+cRRijgZyiGjmGRdw/w2lHfJ9HmJb4frxwWK+QGYYgF2QtTOwPZeHKK0kPcD32pWaETP+g==
X-Received: by 2002:a17:90b:1d88:b0:237:99b9:c415 with SMTP id pf8-20020a17090b1d8800b0023799b9c415mr4831822pjb.38.1679515122982;
        Wed, 22 Mar 2023 12:58:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 69/80] scsi: sgiwd93: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:04 -0700
Message-Id: <20230322195515.1267197-70-bvanassche@acm.org>
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
 drivers/scsi/sgiwd93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 57d5dff62f63..88e2b5eb9caa 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -204,7 +204,7 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
  * arguments not with pointers.  So this is going to blow up beautyfully
  * on 64-bit systems with memory outside the compat address spaces.
  */
-static struct scsi_host_template sgiwd93_template = {
+static const struct scsi_host_template sgiwd93_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
