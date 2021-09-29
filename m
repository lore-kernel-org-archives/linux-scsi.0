Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DD8C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21A46138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347064AbhI2WIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:15 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:41970 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347057AbhI2WIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:10 -0400
Received: by mail-pj1-f51.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso3174755pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIOMgr4RgNn4c34AWPObS5b7BbWiXFclO6pTLpBw3g0=;
        b=gFI2QAjBlL/Hw4KheDNpPJyPDbcn1812TJGySy178G3ztckrTd9xmHtohIZ8WDR/Ot
         Q2FDf/qOMEkPBh+MvK+S0sUTdmTFoFSyaCOzWgaV138S36Vg6svWiI72tSOl9hk8BzDY
         do0CC4woPXnvaQZ0Qy8vXUyqgi7uT9/DGSiD5F0wh0QMze7DQi0KRs8jL0qIH/MlVOqQ
         uBLBDgnYJrzDQ52VmVFyg1FJ/GPKcl02K2D8bUHiwBnOH/FmiGMpxgSZw0SpPXxB1Aet
         EZYdhGkfli2huVclqpaEgmnop1IzzzKCcmwcSMwkTeygl96XOw2c7MkejRwBtXaM1e6L
         y4mA==
X-Gm-Message-State: AOAM531LnKm9mCoXV+9mZpqfUVH+eQQZL4Nl8he0wZEd2Za7d1RBZdCA
        clIVoqQ3OomOcInUUwoNln1z2/WXrlQ=
X-Google-Smtp-Source: ABdhPJwQ0OnB+9KKriwQPhyfD2/1c3/q+WiJb1Mmo6gBaC9oGnz8nwjLTskxvcsKZLzUdlw0Haqrgw==
X-Received: by 2002:a17:90b:1d04:: with SMTP id on4mr2421632pjb.48.1632953188297;
        Wed, 29 Sep 2021 15:06:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 08/84] 3w-9xxx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:44 -0700
Message-Id: <20210929220600.3509089-9-bvanassche@acm.org>
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
 
