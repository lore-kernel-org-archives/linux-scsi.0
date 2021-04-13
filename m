Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDACC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89182613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347092AbhDMRH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:58 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:39613 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347094AbhDMRHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:50 -0400
Received: by mail-pj1-f54.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so11016660pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vpvIXFMO2/MgdDMwxCoeYsr1AYU+YR9iqCp/6zOQB3U=;
        b=pM2Mgptbo9ZHN9U8GVWTTJWRRwno3EMpwAEgvQW/5GcTQZQesA+CrqbBJvT0FveFb4
         0GJc5dKOAoPT3ObbsPmBEOoyShPZ0DZlrJcHYbVUepzostDosvHltAPHhMNBO4qZB1Ww
         vPA4AvTL+nT7RWGuoxE39rW771PhmFglflN6Vh21NkbW+ulzWUKr51aolldit+tQhaog
         5/rF+jDWgDzMkWSqFK4rt6YXFvW6ecrl1C0YwB2WdNVBM/iAsNNc6THjHqBAr/xo43mR
         8QdpzxhWK9vbO7brLt2fcjGvxPFVDTp1K9TDKgrAgNVHwMJhvVH8/39XfzZ26gW0WoNh
         jOkA==
X-Gm-Message-State: AOAM531hAF5qH4+7yR21PusRbA5EgmYMgynS+CJIGMrdFI96g1W0QTG2
        44FjyH61ZnwvGJretzrvbAc=
X-Google-Smtp-Source: ABdhPJwyCCqe0YYdjhkRPfnwII+pA/ccpXV0woiJZKGot6KT40d1nBfFqiAVK6bMNqsMipcRA4KTFw==
X-Received: by 2002:a17:902:b709:b029:e7:49bd:6833 with SMTP id d9-20020a170902b709b02900e749bd6833mr33446183pls.57.1618333645696;
        Tue, 13 Apr 2021 10:07:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 04/20] Modify the scsi_send_eh_cmnd() return value for the SDEV_BLOCK case
Date:   Tue, 13 Apr 2021 10:06:58 -0700
Message-Id: <20210413170714.2119-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The comment above scsi_send_eh_cmnd() says: "Returns SUCCESS or FAILED or
NEEDS_RETRY". This patch makes all values returned by scsi_send_eh_cmnd()
match the documentation of this function. This change does not affect the
behavior of scsi_eh_tur() nor of scsi_eh_try_stu() nor of the
scsi_request_sense() callers.

See also commit bbe9fb0d04b9 ("scsi: Avoid that .queuecommand() gets called
for a blocked SCSI device"; v5.3).

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c0a3497fc474..28b287e9f50a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1112,7 +1112,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	if (sdev->sdev_state != SDEV_BLOCK)
 		rtn = shost->hostt->queuecommand(shost, scmd);
 	else
-		rtn = SCSI_MLQUEUE_DEVICE_BUSY;
+		rtn = FAILED;
 	mutex_unlock(&sdev->state_mutex);
 
 	if (rtn) {
