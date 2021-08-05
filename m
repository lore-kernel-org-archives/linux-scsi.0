Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2504C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21DA61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbhHETUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:40 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:51989 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbhHETUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:39 -0400
Received: by mail-pj1-f46.google.com with SMTP id mt6so11334931pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjbZV+3MrAdmbLBg1BOHv8e475oZ5SyVoPXmEaezYSc=;
        b=tF4q3PsFpvd2KJ4M0uDhVGETQVFUj2g36VaAlS78z5cyrBQ7hOJHrHbphY5JwTha8n
         ZdoQ3cj3dOq2wxgvmjpsvJR32Gk+Ll/VGIxjiEF1JnIPZOzhUqSbtlXHzCoeXTUUZ8SP
         wJn3/gSpDkzDo2aeKHr9701SsqypsUa2/9gY9O0w96Bu+m8160M23m0MLO0Koq4qKZ0Q
         wGMzl1r2SOOQ05soOg4GZdAoN0OP0/g1Pf0OY4c+jsIJdC61E0KDNHfaU6FekgbSrczY
         mm9OG1LEXgGFrf5PcX24I8ayWSoV7R+OpUJfkNGICpb7PAaZKizhkwWo81DWqnQD9Yhc
         XCvg==
X-Gm-Message-State: AOAM530yS0YbMq/pgCLpJz9PtGb9w9LN9CS3SNCFs6p6QmuTnY+H2mJw
        OxezfSEf8z55mbGj+z94Pis=
X-Google-Smtp-Source: ABdhPJxZd7Yri4LH20BK7Bibhz8ODcOFyCHpgF2dOHSmt7K19Hx392fc4CrGfw0UF5ylL04tS+oA2g==
X-Received: by 2002:a17:90b:3ec5:: with SMTP id rm5mr16384437pjb.132.1628191224162;
        Thu, 05 Aug 2021 12:20:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 51/52] usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:27 -0700
Message-Id: <20210805191828.3559897-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index f4304ce69350..4c5a0a49035f 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -551,7 +551,7 @@ static void last_sector_hacks(struct us_data *us, struct scsi_cmnd *srb)
 	/* Did this command access the last sector? */
 	sector = (srb->cmnd[2] << 24) | (srb->cmnd[3] << 16) |
 			(srb->cmnd[4] << 8) | (srb->cmnd[5]);
-	disk = srb->request->rq_disk;
+	disk = scsi_cmd_to_rq(srb)->rq_disk;
 	if (!disk)
 		goto done;
 	sdkp = scsi_disk(disk);
