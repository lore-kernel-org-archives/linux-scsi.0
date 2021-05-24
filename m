Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B710FC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA4B61151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhEXDKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:52 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:37792 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhEXDKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:50 -0400
Received: by mail-pl1-f173.google.com with SMTP id u7so5341377plq.4
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXPFyN7HL/YvhI+SDs8OvanjEXM60MW2yKKeGDCzmRM=;
        b=iSkLD62troK+3G7Cdw5i/CuElnk+hClX2w+tGcSsOm+ouCNboisqs/lMcyGMqGhW7X
         1QlzvQqxN3KqGL5CEVQzsARYtEn94OdM+L1y7rGD4nUBWnIOpMouL1obeRtP/qRZJI/v
         lN2HTTNllKcfO6S0ymugKuBsVajXa8VFnqDV6uEisPkM20cO+dhaWOawKnTstMae3BsR
         oSyHvBYkFWKoRZmYU/VEpKFClsOXfd+NAXkgTm1+eOdjBmnQhdIS0/6FljQlmQNL7szP
         IZM194R/LmovvZFaezpjIVfoh4lytUHtAd29x8X/nd/2ICStmBlcfxEi9hPsmfbWiyWY
         eiGA==
X-Gm-Message-State: AOAM530SCfZtYlUhcGCr9TUTCXoKpzU+5U8xHx6xPffQRTw5xkvVfm3y
        ku9uKmy6t2GCw1caWx2oAc8=
X-Google-Smtp-Source: ABdhPJxmEbM3o8VHf7khlhenRwPzWtXyFtBQ4CAnkFukxpceLlQLPIos0yAQUgd9cGEbEhIsJVPgNA==
X-Received: by 2002:a17:90a:ee88:: with SMTP id i8mr21877531pjz.131.1621825762348;
        Sun, 23 May 2021 20:09:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 12/51] NCR5380: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:17 -0700
Message-Id: <20210524030856.2824-13-bvanassche@acm.org>
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
 drivers/scsi/NCR5380.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2ddbcaa667d1..47502f63a167 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if ((sun3scsi_dma_finish(rq_data_dir(scsi_cmd_to_rq(hostdata->connected))))) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
 		       instance->host_no);
 		BUG();
@@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);
 
 				if (count > 0) {
-					if (rq_data_dir(cmd->request))
+					if (rq_data_dir(scsi_cmd_to_rq(cmd)))
 						sun3scsi_dma_send_setup(hostdata,
 						                        cmd->SCp.ptr, count);
 					else
@@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);
 
 		if (count > 0) {
-			if (rq_data_dir(tmp->request))
+			if (rq_data_dir(scsi_cmd_to_rq(tmp)))
 				sun3scsi_dma_send_setup(hostdata,
 				                        tmp->SCp.ptr, count);
 			else
