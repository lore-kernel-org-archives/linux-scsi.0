Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE88C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38F761446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhENVfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:38 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:53012 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhENVfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:36 -0400
Received: by mail-pj1-f46.google.com with SMTP id q6so532710pjj.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DbVDOQUJOMiGJw0iWPNpt0I6b61hnveg3Q65/SZVxdI=;
        b=Jc8hZruYx29rC800fhSHs8A2iMm8+/gAFtNPE2SCb/B2Wpmz+hLNvi1VEf8NHIZfbO
         bzVYLzJNLTWNrRaNqQG5HqmAZE1RylcKSNjbRwhhZs1kxN2rQObhjn5rnL9/ESkjDZUw
         3IkgqFKG5r01UFrJsCzJdAGiTXq3zqbDnGIQ749sKfNmtD2F2nCf3N9s6Kjmz+haYbkr
         f9cMIetBPePXUfUWIdxEAkOkpSG6wb49X3rxcB3yPHV39VV+XW3Qn4t6s06bsrMJ5bkF
         3i2QJXn47qvclDzuHcjEBKwIudBWoCgSLMWzdmKQ39xoRhn3AGDAncvfLNRLsGIYoZbu
         Kuzw==
X-Gm-Message-State: AOAM530B/MGNNnMuD3XWFgZHoO9cMxOrrwga3L11wOa32S/U0sUgbr51
        9pEHWjMO0W1kLljwk4w/3Mg=
X-Google-Smtp-Source: ABdhPJzYlaf9AOOAg7VMuUEZQu5xU4QyinExnnleC6IOOFu3OOPYuDfX8iV6Gm8Rpk2FHyrnvYaumw==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr55334610pjb.213.1621028063690;
        Fri, 14 May 2021 14:34:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/50] 53c700: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:26 -0700
Message-Id: <20210514213356.5264-12-bvanassche@acm.org>
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
