Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913A5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0C060FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347071AbhI2WIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:17 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:33727 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347056AbhI2WIL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:11 -0400
Received: by mail-pj1-f43.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso612514pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3g9GybVmhn5NcVSEf+e0j0/kR3Jt4ybQmvybi1gAxcA=;
        b=xSyi5Lv79bwwDiGIyGPq0jkFJ2rumlXKQ2JsDwWgYFiTC8RiJM2BFplw9DZAmd7swL
         Z1OVZb0F/wXmpmMaFoWAZmGCXacAYh3M8jU7Byj0H5orIRfN2s2A/bVrvR5F0J60iT34
         1+WMQwHZPi5cwb0csKum6+ratBd5oIe9YvvZhLLf4TRBSMHe+UhTJB7ax/cLDPy/xpR/
         nRqtDeAlveUtUsJZYmGem4mR6YRSa67zu4XvadcKP0nUwyIKOP1nN3VMC2xKTNxTRrVm
         gbaddQS7sDT/+5E/Njk6COwd3lck5tsOIA01ccsjK8+MvFI+ld26h/bJ7iC9TeJhytaG
         SQGQ==
X-Gm-Message-State: AOAM531apZ3MXSRB/zU3ETkrFn2UUEqVr5Is9jwwvXlKMBn9zbjy9jeM
        aiUPvUyB0yjnECtwwBV4Wqg=
X-Google-Smtp-Source: ABdhPJxrY7Yu1bFhvrEKj1jXeRbt0tWvIvcUyowoz3IVkpZYwAmsk3nDslJ6ySTGwPFZZqsheMPCRg==
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr2383949pjb.220.1632953189583;
        Wed, 29 Sep 2021 15:06:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 09/84] 3w-sas: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:45 -0700
Message-Id: <20210929220600.3509089-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/3w-sas.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..e6f51904f5b1 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1216,7 +1216,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 
 			/* Now complete the io */
 			scsi_dma_unmap(cmd);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			twl_free_request_id(tw_dev, request_id);
 			tw_dev->posted_request_count--;
@@ -1369,7 +1369,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 			if (cmd) {
 				cmd->result = (DID_RESET << 16);
 				scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 			}
 		}
 	}
@@ -1461,9 +1461,6 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		goto out;
 	}
 
-	/* Save done function into scsi_cmnd struct */
-	SCpnt->scsi_done = done;
-
 	/* Get a free request id */
 	twl_get_request_id(tw_dev, &request_id);
 
