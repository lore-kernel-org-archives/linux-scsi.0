Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0462FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2DEA60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347153AbhI2WJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:33 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:42643 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347178AbhI2WJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:27 -0400
Received: by mail-pj1-f48.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so3150513pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bc2hHq3UHgHOKwsd4O7CY40azxenFfvLTOrXTmqo+58=;
        b=NizdylML0Hi/quFASY+XrGpU/IqPPkZwfYrpRn9Zb0o8Dhq2YGiaSEhik60RwIrMDa
         SDMhXvcdxazmGYHGskFd3Dl+1BeOXi1in/HdC/n/F2JsQMOUzcp7OetTCRY5MJEd2kog
         k0pAqdNbX7bfuJ1RhxUy2AO8dcijcDwEzkAQP2LDX90g/qVJjRZML+jtHoUvhrG1jI2f
         s0HhewwFeoeF1L+7yRFVEGnC3/a+hqw4IwHRkOP+Q0UivEbQbTu4iOEN8JglmnoehKlD
         tVak/PXkQ8FIgnZwu90ASsZDIgaZUHT/wj5JmZeqn87MPfdA9TQBjsMPwmtOiSzPtFnG
         unFQ==
X-Gm-Message-State: AOAM531JexElhTosB5kE1zo4805BoNEhPIkorD9QUqOHFy9uVonRaXKz
        BklUHVWxX0I+godQ/o1Grw0=
X-Google-Smtp-Source: ABdhPJy18PZ3vf7YsBSP7s6l4EJTT6/WWDM2HJF5cN+1aBtXYT5mPtDbjayuy5cLhLIbeVcdp8MQig==
X-Received: by 2002:a17:902:9a97:b0:13e:2da4:8132 with SMTP id w23-20020a1709029a9700b0013e2da48132mr777132plp.34.1632953265118;
        Wed, 29 Sep 2021 15:07:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 56/84] ncr53c8xx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:32 -0700
Message-Id: <20210929220600.3509089-57-bvanassche@acm.org>
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
 drivers/scsi/ncr53c8xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..6c6cf111be5f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4006,7 +4006,7 @@ static inline void ncr_flush_done_cmds(struct scsi_cmnd *lcmd)
 	while (lcmd) {
 		cmd = lcmd;
 		lcmd = (struct scsi_cmnd *) cmd->host_scribble;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -7865,7 +7865,6 @@ static int ncr53c8xx_queue_command_lck (struct scsi_cmnd *cmd, void (*done)(stru
 printk("ncr53c8xx_queue_command\n");
 #endif
 
-     cmd->scsi_done     = done;
      cmd->host_scribble = NULL;
      cmd->__data_mapped = 0;
      cmd->__data_mapping = 0;
