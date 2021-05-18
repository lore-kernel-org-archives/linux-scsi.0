Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF23C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFF4361209
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351216AbhERRqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:31 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:39499 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351173AbhERRq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:28 -0400
Received: by mail-pg1-f180.google.com with SMTP id v14so4801621pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzKvqzuA/WFu9Oar88tH0h8JNjeKZGFwFrdGi+tFRcQ=;
        b=ct4VJbhEz31H3uOb7HreG1sB2V/m/sFEU114z4bCfRB9S/RTJN/Xad2IMYEAAlnndL
         Tw1htwvrB/trfZy/EH7qmIPYyYyCynXZswqmITiO0/2uCie9pc+gQidJxhptf+wp+zK4
         TRerg6L9MLyZXzpN6HW7n26UmBz/Mkg+ZqKHnC5ie4fY2NT6+uwQpRyEyGjH1pefjE3E
         9s8hO7kCQYWDmRhrdcIERFciGgqmImfIB48R5tzuGd8un1OJ4eU6nadAABNhWSxuOXaQ
         N8hBJiWdeW0aWudHNz0oBf2xGm+p3NS9RpIwfIaXQhWA0SBWrZHnaAkhviNx4YMLbMnq
         G7CA==
X-Gm-Message-State: AOAM531HhFteG7HrGEr45RfFqFQwiwNSEjeFvGIXCJ62mgsIGCO7hvnm
        bspwY88NfW97OKZz+4U8MqW8YsgD1fU=
X-Google-Smtp-Source: ABdhPJwR2kChHvPNj8Bl7J4qHH3WijSbquU7dNK8Sf2cMhtOQNfV+laZ243dW1adQ8L28l1D0SUdvw==
X-Received: by 2002:a63:5947:: with SMTP id j7mr6395167pgm.248.1621359909106;
        Tue, 18 May 2021 10:45:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 11/50] 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:11 -0700
Message-Id: <20210518174450.20664-12-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 77ccb96e5ed4..4bff29169f19 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1823,7 +1823,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
 	    SCp->device->simple_tags) {
-		slot->tag = SCp->request->tag;
+		slot->tag = scsi_cmd_to_rq(SCp)->tag;
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
 	} else {
