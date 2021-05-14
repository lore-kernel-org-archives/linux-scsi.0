Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7B6C43600
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A2061440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhENVgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:50 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:40721 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhENVgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:43 -0400
Received: by mail-pl1-f179.google.com with SMTP id n3so99407plf.7
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=49OUNDUeZ7yw6tebP3MXbIdlh8usnk8t/VrBmcA7Q/U=;
        b=eav08uXfr8rTBD0/Wxj3Xwz3fPx/nORoOZuStsxkjH/4mW5GNvyRG2o+y6M9tHgl11
         6Q6PEGuDSfrjK2SyoWTZ2tcStqNmEFmhr+85IvjK3w9M8e7YqzLwQ22cJNxnqLy3A62s
         oh6w5jDWkgqddHmYqnwHzQzi+P861y6hAAncz5kV/KAKZGRhl08yx6J9mtQiWCje6HW+
         6PtKPuyasuAmbPsiNv1djcIl/5C3WO6b3+WmmmurMSm3ER9swziEmjIeSMhyvXpvEisJ
         nZ5wZhQc0r8Bdpho8qcKUtnRFCwKrMm16f0x+YvZSzXuzJQEUVm88nu6A7UxSB2HHmSB
         wUuA==
X-Gm-Message-State: AOAM530pn7VWYzNCBh8ufZRegnWiWpCZ/SzP/5BDLb3oPUJ0ffJ0T66J
        ZytD3ghw/q06oIcj2ub/SE8HJB+cBw5H/A==
X-Google-Smtp-Source: ABdhPJzVz8Hw6jnM79xS5U9PHci9/Pv6CNYFbn8iXJbywoYHnnYl+7WTxJLdXQxSpfap/P7qLAwzvA==
X-Received: by 2002:a17:90b:84:: with SMTP id bb4mr12725989pjb.60.1621028130977;
        Fri, 14 May 2021 14:35:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 49/50] usb-storage: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:04 -0700
Message-Id: <20210514213356.5264-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index f4304ce69350..53cc76b51ed7 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -551,7 +551,7 @@ static void last_sector_hacks(struct us_data *us, struct scsi_cmnd *srb)
 	/* Did this command access the last sector? */
 	sector = (srb->cmnd[2] << 24) | (srb->cmnd[3] << 16) |
 			(srb->cmnd[4] << 8) | (srb->cmnd[5]);
-	disk = srb->request->rq_disk;
+	disk = blk_req(srb)->rq_disk;
 	if (!disk)
 		goto done;
 	sdkp = scsi_disk(disk);
