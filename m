Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1E0C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C52561074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351260AbhERRql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:41 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33683 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351256AbhERRqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:36 -0400
Received: by mail-pg1-f182.google.com with SMTP id i5so7576066pgm.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLBqhpYN0grV+1zqOeqSk0d9e0RE5O4DnT9sKxruf4I=;
        b=TO/dsq47RVNrXF5ZFTrumWzgqAF31fW/kbJYZkiSUIfD2rsjSxn/WArJrByKzxB8H1
         LCnxuVF6dDaccDu3tXB8lXPsxFAd5JYrCIC1mO3vj9DECUZdqg06lqumQezhtOCsOcDf
         DVRYQ5efhIdUn6ziYBUw2B9whjMMLG/6IstVuhFjzu8pNAmDNk/s1LVV2meATzy4e/15
         g3VoAyhMSK2Q5DP0NjHDCXQeF+vz4kPDlebS7VEEnuLrIDpKnvMZHNBxswq5U7DAmE8q
         v4Gt+K28g8SYYV7QEwua1ULMxbJqeC6NS0OwGxCe0VY9Q4acnOXzMqDdEPKb4KXLrgIO
         ZijA==
X-Gm-Message-State: AOAM531NGw69g7qa5gIeRRp6v+3y6U9t84hKFFLw/bBln1Mn+iW4QpaV
        OsPw8pWxyjNjll97RvevjOE=
X-Google-Smtp-Source: ABdhPJxgfXYU5dswdg0pvzQnwYCXbKK443+2aKPH38/b3dv2ZxwBa7GEiLpJF33JMjhqgR5lv6cjcQ==
X-Received: by 2002:a62:17cc:0:b029:2de:39c1:7eb7 with SMTP id 195-20020a6217cc0000b02902de39c17eb7mr4931586pfx.26.1621359918353;
        Tue, 18 May 2021 10:45:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 18/50] dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:18 -0700
Message-Id: <20210518174450.20664-19-bvanassche@acm.org>
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
