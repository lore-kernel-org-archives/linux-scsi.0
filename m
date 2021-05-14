Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0ABC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EEE4613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhENVhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:13 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:37396 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhENVhF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:05 -0400
Received: by mail-pl1-f171.google.com with SMTP id h20so106246plr.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DbVDOQUJOMiGJw0iWPNpt0I6b61hnveg3Q65/SZVxdI=;
        b=kv72Qfe8HW/X2BQhViObayHhwq1m+qCfcK1INlWAlQFcAWMxqC++PFxYhxPWiX13Az
         A+B8/SMNFjIkb3lqYUfiu+ed9eR6TQbFnd0Bc4xFZYYbv4SFIwVRERt3b28umNYtyhj+
         GjzdjsEwfjPqlMvn9/iugKd2vruPnoSfgU+0PimXj+eXWyk+W67vviViMAcjRnHPjR0q
         YEH7k4PvB/RpCDW8nc0hWnGWyqmLuV1KX4NhpXfhwrzvA4uj08FxhTKazvRAB059M/L0
         FoDz4maLRiasWIEwKkloB8nHShfGKNKimc4LXYXvPhIrzy0QzU60KH2ZuvnriTPiMcQn
         iVQg==
X-Gm-Message-State: AOAM533k8sdpvzEXvhi60qVfOAS3f1JOWpMuCqc9r7qMa0dLxeniHwdu
        r5OwFs9j6kIQEucSj2CVYQM=
X-Google-Smtp-Source: ABdhPJyjJASVkbaIviArsk0J1vi9ALjHk9LlSqjRVLso2eNOKdiY163jGoXkuHzHAvp7nYncvC+sXA==
X-Received: by 2002:a17:902:d482:b029:ef:28db:4405 with SMTP id c2-20020a170902d482b02900ef28db4405mr33066037plg.40.1621028152208;
        Fri, 14 May 2021 14:35:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/50] 53c700: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:17 -0700
Message-Id: <20210514213356.5264-63-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 77ccb96e5ed4..8dd686484857 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1823,7 +1823,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
 	    SCp->device->simple_tags) {
-		slot->tag = SCp->request->tag;
+		slot->tag = blk_req(SCp)->tag;
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
 	} else {
