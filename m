Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8433C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE5BC61209
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351288AbhERRq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:58 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:42502 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351255AbhERRqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:52 -0400
Received: by mail-pf1-f170.google.com with SMTP id x18so3661408pfi.9
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG69elz3fRIik+x0xPzidwBogqJG1UGznFLcOfDZOZo=;
        b=J+rMKQLdwxOJBDG/o2Rr76XQsOkGUaEMY/kY2CCfLoay06VXG0EB/O4DAJrpsvaQDd
         nsp+CronZW2q/3ZswA3I7FKw5mbcoZpWVK835a5oGtQt5i3Om13kO+KhC9e478mJQA+l
         IHgRUjmWqWglU3VeD0aljrez9NRcoDWRzHd95Nj991FNNEd/qutQQYp30sf1VRBv5gmI
         uqgUYj4ZsSiXlVkIenfnrgM6/bg1fVEndsLVD5eNsXZRgGAnapu08Rt1m0dnbZB/EQk0
         UNLhjI6nzn0oxXqfbR9jkeQ90dPdFWNtaxzVATwABFjft4dKMuxE9QPco6xvCTwgdJSW
         rkyA==
X-Gm-Message-State: AOAM533r0RQaXNM0Rym9un6iIGKjmHj4uJKVsDkLCSgZhkQqKBfGHE57
        TTif9nCaY3pXqJGgIzjXBqtZkFiahDp9bQ==
X-Google-Smtp-Source: ABdhPJyvjwegK6Xj57gNFIs1qvjsi/4eVGhmqfRjV8CsYLvZ3IUicOS9XU7Df+JMsulLEvZ3LKerww==
X-Received: by 2002:a63:490a:: with SMTP id w10mr6211582pga.286.1621359933556;
        Tue, 18 May 2021 10:45:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 29/50] mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:29 -0700
Message-Id: <20210518174450.20664-30-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 9d5743627604..94b2b207d391 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -702,7 +702,7 @@ static int mvumi_host_reset(struct scsi_cmnd *scmd)
 	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
 
 	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scmd->request->tag, scmd->cmnd[0], scmd->retries);
+			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
 
 	return mhba->instancet->reset_host(mhba);
 }
