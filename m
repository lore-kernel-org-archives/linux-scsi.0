Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C365AC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83F96115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhEXDLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:04 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:33487 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhEXDLD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:03 -0400
Received: by mail-pj1-f44.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so714465pjr.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLBqhpYN0grV+1zqOeqSk0d9e0RE5O4DnT9sKxruf4I=;
        b=Gx+5P9jj7IU68klnEcTiq09Wmbtq1eMylCkZrp+tuB8RoOrgN1n4tQMLidmnGs6Rsa
         vuicoXrzxflQey1jug40D7VQi4mAoigqi7MyngzbvmYRjEDN4jCapd6NSwIRXoc6uYWx
         bgEx90wVw8QCdNEHHg1+1yEvf/NsNlEkU8FGxSTod/xnWHbxTTQeHrOFabRYyHhc9UhE
         qH8Fv9ex1015HaEpfKyCaFnH1Ddg181iyjC1PkfFpH+dAWR4CYkIKittoYqlHRl6if4J
         VR23t7AWmTZcV9HUzKjsjVqtED13TJ7N46MIB5bWXW/04qLeUfV1dTm8wicLa2pN/nd7
         FWIA==
X-Gm-Message-State: AOAM5308LKz4BG6+hiG3AsUt6Wn4KryV1e94LlBCSo+dUq33jJjaAa/u
        n9R+zvEjJum/5B/6x05mMfU=
X-Google-Smtp-Source: ABdhPJxYIBZUVvu33ejnnl85peMPoDKCQT7GqT7zKb5KWCp1b8yjqYhXw4FDO+uUAcdX3NdVnyupaw==
X-Received: by 2002:a17:90a:b38d:: with SMTP id e13mr22157096pjr.222.1621825774784;
        Sun, 23 May 2021 20:09:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 19/51] dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:24 -0700
Message-Id: <20210524030856.2824-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
