Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FB2C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjCVUCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCVUB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:56 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B356BC18
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:01 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id l7so2457510pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrCJy7oKZ0NcxdBtk/yFFeEQwBZTbtLM0nNDWv0I1ic=;
        b=loxDEXZEnvc5V3bxgJ3d3Fzy5WDx9vyaxgiWaMlFInAsMgOlOylvIFcra2ShWS8tTb
         LKjOXJTVqs1t5T8YpcC/KkKZkDt/afQ2Q06mKTbtJqKZ2bdAiBmo9Ol46mEt1omhSgfL
         gqQXNs28arKcuxVQNaab87NIiHAwCRh7wFgd+rGr+KO70OBgI7iYDiReOYpXpBa0G8uK
         fQwk3LFrfPQihWdA2AhuennD73mC/dzk3UTQcVwuZw9PVnZKdnLXfIB+Cjumkq+XlZrQ
         KP9lIfBxen2JlBy68xj0Kl4IZmhvbb+4h7B4kP1hA767unD/ScqUzpyYTQZyQqsFf27y
         BpSA==
X-Gm-Message-State: AO0yUKXRLA/HYpgiucAnuZDXRodQOo9y6utYpotqL3a/nzC3TGBfdDQO
        eaIn/AiTpjLqw4TyqyS4MUc=
X-Google-Smtp-Source: AK7set8xz/8Rn6WAcqSNn7qmUMzhCSGmq/N8OV3XD2eMCu/tdGE3wt4zSRq2Nqegvsb4izVQcHTJ4g==
X-Received: by 2002:a17:90b:4d0f:b0:23b:355f:b26c with SMTP id mw15-20020a17090b4d0f00b0023b355fb26cmr5103746pjb.23.1679515124115;
        Wed, 22 Mar 2023 12:58:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 70/80] scsi: smartpqi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:05 -0700
Message-Id: <20230322195515.1267197-71-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 49a8f91810b6..03de97cd72c2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7403,7 +7403,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 
 ATTRIBUTE_GROUPS(pqi_sdev);
 
-static struct scsi_host_template pqi_driver_template = {
+static const struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
 	.proc_name = DRIVER_NAME_SHORT,
