Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7EDC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B21AB6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhHETTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:36 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:51092 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbhHETTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:32 -0400
Received: by mail-pj1-f49.google.com with SMTP id l19so11380175pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLBqhpYN0grV+1zqOeqSk0d9e0RE5O4DnT9sKxruf4I=;
        b=Fm/O5KDlLPtYPtF/A89i1dNp2a/PIKrOutSCENVhlMCBRI7ktkPPKniPKvhkMJy31X
         HoL4d97pmtEFWlLYS7sXCnbnwE2yNCzt4dGOt9Ej/Y6/Ljp7np72oqdNTlwZgFnRkFxb
         JJspBl7Wa2oR6ZRjXoyx2rlh4S4s5aX/kFZAPJlV+A09LxQfDi20zhSEq0luRt5/m4in
         VTmU6VK48QTVtN3GMivpKNh2c1W+KJLErREu73Grqo3NcQVc78GlqEBAyS4cym2wIeZy
         mqCi9ywZ9iGPQdSC6y0/g4etiiIXNX7UVRtwxmfDJM4261dapWH/PYIojNiBuqnIReei
         tXtw==
X-Gm-Message-State: AOAM530N2uB6KdqYBUXh+gyu+CUhhUk+vFxzGMSYKs2aq05WaGWBYlv8
        6fXit5NwFQI49ArS8gmeBIM=
X-Google-Smtp-Source: ABdhPJwPl0YG7YPTzY+7FFPECHd9Kf6fc+kV4OAc1LSX+Q6HDQvAsHFhyBP0R9EzByqIWd/AByY1aA==
X-Received: by 2002:a63:ce54:: with SMTP id r20mr1403320pgi.164.1628191154000;
        Thu, 05 Aug 2021 12:19:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 19/52] dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:55 -0700
Message-Id: <20210805191828.3559897-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dpt_i2o.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index a18a4a08f049..7af96d14c9bc 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -652,7 +652,7 @@ static int adpt_abort(struct scsi_cmnd * cmd)
 	msg[2] = 0;
 	msg[3]= 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[4] = cmd->request->tag + 1;
+	msg[4] = scsi_cmd_to_rq(cmd)->tag + 1;
 	if (pHba->host)
 		spin_lock_irq(pHba->host->host_lock);
 	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
@@ -2236,7 +2236,7 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 	msg[1] = ((0xff<<24)|(HOST_TID<<12)|d->tid);
 	msg[2] = 0;
 	/* Add 1 to avoid firmware treating it as invalid command */
-	msg[3] = cmd->request->tag + 1;
+	msg[3] = scsi_cmd_to_rq(cmd)->tag + 1;
 	// Our cards use the transaction context as the tag for queueing
 	// Adaptec/DPT Private stuff 
 	msg[4] = I2O_CMD_SCSI_EXEC|(DPT_ORGANIZATION_ID<<16);
