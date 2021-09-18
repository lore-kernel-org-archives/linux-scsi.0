Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB157C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9304F60F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbhIRAIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:00 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:37826 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244132AbhIRAH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:58 -0400
Received: by mail-pf1-f181.google.com with SMTP id j6so10671123pfa.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8MRMWPJSDpVLigpGgyfOKRrKOSbB0dYT6RnvRin88ZY=;
        b=4ZzAfGljNatppNN2pZKKyh9qc3TiyAa2/81u/LAcGCKxgEW7+0rRRbqepcehxazLDc
         2LSdJ81SdN+XiPiKEiRonN3asD5iOEb9NQz2HDV4HZ9eGBzjQfXbIyhvL3zg2EWi99gQ
         YzAW8oDXrtXW1u5oFXCgRYYzT3lImjAzT7Kc2UZAA6p5lJrIoXcxJxue0kF4Nhr5sGYO
         2LTexKMTYKbLH8Y5NYBx9HWlJHoUk6kiDoKYXyHtZ9TIOJMXcbB2cTz7rxdrs/ohnMz6
         VdWATgniK65SeeWoM5AiKkjZ39h7hbaaaBqRdCYx8PiqPALrOeEbV8R9TDDtc9Jv4mMq
         MHbQ==
X-Gm-Message-State: AOAM531XjsNzznajTKowe9dCfMGDw5udl6qvpwFaA3oeZGT8nowYG8Um
        Cggxg8Wr4+04s2ReBBPIIac=
X-Google-Smtp-Source: ABdhPJwuD7dXRol1EubjKN+kZHZbyOYda0NRGPyJa/beM/M+0RcI6BfSi4t/vmKtgaV+jL0kfttnxg==
X-Received: by 2002:a62:e317:0:b0:43d:e047:a6c4 with SMTP id g23-20020a62e317000000b0043de047a6c4mr13587889pfh.44.1631923595692;
        Fri, 17 Sep 2021 17:06:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 15/84] a100u2w: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:58 -0700
Message-Id: <20210918000607.450448-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 028af6b1057c..68343bcb4616 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -917,7 +917,6 @@ static int inia100_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_c
 	struct orc_host *host;		/* Point to Host adapter control block */
 
 	host = (struct orc_host *) cmd->device->host->hostdata;
-	cmd->scsi_done = done;
 	/* Get free SCSI control block  */
 	if ((scb = orc_alloc_scb(host)) == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1042,7 +1041,7 @@ static void inia100_scb_handler(struct orc_host *host, struct orc_scb *scb)
 	}
 	cmd->result = scb->tastat | (scb->hastat << 16);
 	scsi_dma_unmap(cmd);
-	cmd->scsi_done(cmd);	/* Notify system DONE           */
+	scsi_done(cmd);		/* Notify system DONE           */
 	orc_release_scb(host, scb);	/* Release SCB for current channel */
 }
 
