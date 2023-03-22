Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458AAC76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCVT5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCVT4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:47 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5460F61AB8
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:37 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so24654036pjt.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOqT7dLP4YcCtL1jZVtGdq9lau6Z+QsWChHpf/+Jq3I=;
        b=OIDQfUyaQ2eejhuZtGIVEBYpWEJg4S/LR22QAY+JCkRFZXZ4oU7BYFVNhydhB1B/sU
         OwpGQ2JD/WsGKi14y1pwds8Sk1ctUo6OHzfkedTYb15fSvmWLrXYgEaZPx2BODBwspuA
         iKby2FLC82zSpc/LBK+Kyk6z2JW/TKPC6xjFBa9PFpT2fkuBZVRXBGhdX8SpVOWEdD+B
         2mhjR0/V3ajeD/vApEhd0cA+77OeOg4k798/uUYJ9B01qjq28/I2pK4GN1GG1CIssK0Y
         PHFWtt53Uk78ZE1aY9twcVSOwWRTshQ3MXe+xq0Pavq8hBxQLxwONWT72X1O5EZyU8HA
         MmEQ==
X-Gm-Message-State: AO0yUKWy9cj9wCWvc+82HQM3BMjLmzYk5H2+xEKKF8/nAOqyWbksfnwt
        JrL+GC+0hfjN76OZF5ce568=
X-Google-Smtp-Source: AK7set9jzNuu3QaDD0+DoKXEIRcf9y2bSKHFqj2hcgUBO5XXvGbP2unr5vy+Rqf57OnbmBadLyxRQg==
X-Received: by 2002:a17:90b:1d10:b0:23f:2661:f94c with SMTP id on16-20020a17090b1d1000b0023f2661f94cmr4902838pjb.47.1679514996776;
        Wed, 22 Mar 2023 12:56:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 14/80] scsi: a2091: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:09 -0700
Message-Id: <20230322195515.1267197-15-bvanassche@acm.org>
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
 drivers/scsi/a2091.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 74312400468b..204448bfd04b 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -180,7 +180,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template a2091_scsi_template = {
+static const struct scsi_host_template a2091_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
 	.show_info		= wd33c93_show_info,
