Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DCFC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31EC8611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351353AbhERRrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:21 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:37511 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351351AbhERRrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:17 -0400
Received: by mail-pf1-f170.google.com with SMTP id b13so4216321pfv.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjbZV+3MrAdmbLBg1BOHv8e475oZ5SyVoPXmEaezYSc=;
        b=NFZoTqWzjI5bR8mCjOfWzyNCav+p7o8ZRr35aZUHS9vaPJ4Vzg/sNYDAk5IS3WhiJW
         aC4KR7+zJ6O8C3i7FtW75VtKcW6ddzDwFcjcVOwqaJa/Shw0mzGnr2dGTcXrLQtRMlNL
         021FMte75RRoN20YZV08V1INYt3TxtIjsiPZdG6YUffjOyfBLnM2RGNQzwJ9yBO7O/T2
         3YikWSwwsmlgZYsUwbVc83pukEaXQxvlHLipHyWeeD9fo4Ne+zEt4e/1tSN2tp4365Yf
         TXBBKF2ZVM/ffwh7Nmcr/YJ938viMJ77hs1ilW98FNF8+ouUJMsimzRdtASpzcGcXuKW
         Hl/A==
X-Gm-Message-State: AOAM533D4EV2jSXTZVOWVAc4oBLw+2oW7+I99Ajf3Ts6gyl03ZPQ4/lU
        lTEOK9+l/k1SsGGHvdzsVSswUJhZzklGCw==
X-Google-Smtp-Source: ABdhPJyA2bYFWxcSmVCV9CgdZAe/CB/Paklnf8Rv6WhMEzIp9FOcjJMR/sB8/6zEGNQdUeHwYBmSYg==
X-Received: by 2002:a63:e058:: with SMTP id n24mr6204334pgj.91.1621359958118;
        Tue, 18 May 2021 10:45:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 49/50] usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:49 -0700
Message-Id: <20210518174450.20664-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
