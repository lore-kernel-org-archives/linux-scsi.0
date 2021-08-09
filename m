Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2016C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB5B60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhHIXFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:51 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:47090 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhHIXFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:50 -0400
Received: by mail-pj1-f52.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso2379039pjy.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjbZV+3MrAdmbLBg1BOHv8e475oZ5SyVoPXmEaezYSc=;
        b=sexUkDqTPWEd13ubHr7sxq0CE/DDHh2OKsoPFXwNVR2pd6Z9HJQ/aJXI2mVuTDAO0b
         AnS55hP2fx882SeDztq0bKF9Vay1+jfS6aoUyfKwm3vXbzHXkBQ3RQ0eFPmZAL57G0wg
         HUd0TaGMDK1TUOHpE4Qq0IyGq5XPlWMxkUM+FeCvJ13KHX+64z4to9JnJXjPQHqwDcwO
         mj9vv5vVoxa0vWhDr3iP/Nq2q2TXlMX4sD8g9RfBlkDA8DdX45Mek138nZ4ZfkOxjTxY
         XSegy5N5IJVDU9B2N7fnKpSu9G4b6BAU4ciikjoKZCzY3euNVV2zxPUFgj2dIHldcRQ4
         uHMw==
X-Gm-Message-State: AOAM5323m3z1UVuG40MivnNHb45dphYuI8rJu03OO6gfu4ijUCTKMcJ2
        6umWYAR1z7240o+QCZXUe0w=
X-Google-Smtp-Source: ABdhPJylxPEvIK7XPB4kCphUpx6pf/0bn2WecLXCY3YGRHFSVsvpCJN4gKo/0VjIjjkStw/cTfHfyg==
X-Received: by 2002:a63:ed47:: with SMTP id m7mr339276pgk.194.1628550328553;
        Mon, 09 Aug 2021 16:05:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 51/52] usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:54 -0700
Message-Id: <20210809230355.8186-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
