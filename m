Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D178C4320E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357B361002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhHIXFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:01 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41775 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbhHIXEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:53 -0400
Received: by mail-pj1-f41.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so2489174pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLBqhpYN0grV+1zqOeqSk0d9e0RE5O4DnT9sKxruf4I=;
        b=e7KxM+lKPNVmfJdDssJOUAL9zoShbhkL3QwQSuvUYczgoyNyNKvzR1jYeM5+tP+L+2
         UlljlSZk/6yqO8gQnmP27SQyhCp/YvII21OI7JfBy7/uOU5ODRNRw7V7Do53jSRHex3F
         ISjlUUvU8nLJ+EY2oAlDyEQNyxJHSUyhXIyKvUQnMcPD2FPi5UQ53hf8/IWuio5vU6lG
         bAsh9vIqPwAOcoqIu6Wj8rBFh+Nf8f5hx+fRF8YH+RalSWH8x/Fq1zQErENWf7H8TAB0
         w9aqbDDWt1uLd2HuDZmSYCSG9okyp+PQm2FeFco0Zxli5th8DKBlqnyPQ6Css+CERStA
         51PQ==
X-Gm-Message-State: AOAM532JS5rEmPCE9zGzpAD3KLQ+JpNJDAb/xppXw+HHB8TkDazKSEBe
        TFsicfxe5Zntp/pYxi6K+Ow=
X-Google-Smtp-Source: ABdhPJz6TGgMH/QsLRfX1ooqmxu1JnZ5LDjFZmvICrh6Hpddft6fZle/sNLYHCSuKFdcAJWPnTcheA==
X-Received: by 2002:a62:cdc8:0:b029:3c4:e67e:2c0b with SMTP id o191-20020a62cdc80000b02903c4e67e2c0bmr20319127pfg.65.1628550272627;
        Mon, 09 Aug 2021 16:04:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 19/52] dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:22 -0700
Message-Id: <20210809230355.8186-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
