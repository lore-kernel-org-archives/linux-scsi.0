Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1BEC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F84611C3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbhIRAHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:51 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:40755 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbhIRAHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:50 -0400
Received: by mail-pj1-f45.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso11116860pjh.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIOMgr4RgNn4c34AWPObS5b7BbWiXFclO6pTLpBw3g0=;
        b=07WFhtB5qpN7iyJN2JnvQa6TEcddSIKlaJowA8uZRMcwb3Xc6nBZUplPJ44IgeG7pC
         OTAA5kzErUcakSzkWprDThD78l3TpiwJ1OAxLeObIaKZEDRA6yTLOZkO3LLbU+hqSaBK
         hpzXTtl8n3L6k0BDCqsvjjH2y15hdxJ/S70gEH5kKHImiLKv+A2rj3a5WiR2Zz9QECpK
         3F8JMomcrTsv/mgyZ5hqXAFNVh/divdCixBFtL/+v6iynFyhELGNx2GYqI88k1H/8Jb9
         ekqWmAsUFQth10T85oaTMddzPQUtHvdJ7V+Jm4PwlH6QZsp/aiqvd8TSO0c3E0lzvKrO
         2gWQ==
X-Gm-Message-State: AOAM533cX+YUpoEY0HZnQ/np8Id41IvHdgww8bUQF2ghXGpLymlcHYzf
        gEX4SncGpGkM8Oko8T9szLZdenN/6no=
X-Google-Smtp-Source: ABdhPJwB0fZdso5v7akQL7t2Dc/uaKxqixcnIQZFDFReFIHXxTfrEpzYUmpYMWnSXCy8e9QkWBnfOQ==
X-Received: by 2002:a17:90a:51:: with SMTP id 17mr15492637pjb.185.1631923587237;
        Fri, 17 Sep 2021 17:06:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 09/84] 3w-9xxx: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:52 -0700
Message-Id: <20210918000607.450448-10-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e41cc354cc8a..4ebc2c79f45f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1352,7 +1352,7 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				/* Now complete the io */
 				if (twa_command_mapped(cmd))
 					scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
 				tw_dev->posted_request_count--;
@@ -1596,7 +1596,7 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 				cmd->result = (DID_RESET << 16);
 				if (twa_command_mapped(cmd))
 					scsi_dma_unmap(cmd);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 			}
 		}
 	}
@@ -1763,9 +1763,6 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		goto out;
 	}
 
-	/* Save done function into scsi_cmnd struct */
-	SCpnt->scsi_done = done;
-
 	/* Get a free request id */
 	twa_get_request_id(tw_dev, &request_id);
 
