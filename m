Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CF2C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389CB61440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhENVhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:16 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45022 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhENVhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:06 -0400
Received: by mail-pg1-f182.google.com with SMTP id y32so237569pga.11
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqOY8NOf3A/uVe1kfrH5HeRCTEoAD33kBspCQvlgDPI=;
        b=i2KC5ZTr6bEqkMNbuzunPkQ3nDmU7Ke1t0oeo25pBQtlkfYdFw0pjY1Cw13NzIa5I7
         EiGlKU21uUZfq2owgf1lB/b3jFDafuRuLIxApDZr0cEHWukn4qImzU7ibU15Q7tXg81x
         +Sum/e5SrmmFwSgr6Q1Cq2HD6x1sYmtrrn6iLx2baOSKGY4pTqbznhE6TzOkSTcVLGcc
         bSSSGOy5Wzxl70XfZPX5p/HeoScUCd/m31mH4D8vutxPg1ukcS5PicAbQZGf5o2VnhM5
         2uS4o8ZtCqexUB0BMHpNTdEP8Y/ymts0MdBlvYn8mqo7jjhSkRiDRcrSRTMbnv+tscv/
         U12w==
X-Gm-Message-State: AOAM533MSqVTYe3faSQpkIopeK3FlHTyG7P8Lf0x53zPqm1WFFei4TfH
        2iHH8db/mmQL9zVLDURnHFw=
X-Google-Smtp-Source: ABdhPJyh5vzTlBpClgCZajCM7BMYG6YtWNjfwzEd+gK6blpLY25POVffSJ69Ma+golRMRvFl7Huxcw==
X-Received: by 2002:a65:644d:: with SMTP id s13mr47957693pgv.362.1621028153684;
        Fri, 14 May 2021 14:35:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 12/50] NCR5380: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:18 -0700
Message-Id: <20210514213356.5264-64-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2ddbcaa667d1..cfeadbd98669 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if ((sun3scsi_dma_finish(rq_data_dir(blk_req(hostdata->connected))))) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
 		       instance->host_no);
 		BUG();
@@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);
 
 				if (count > 0) {
-					if (rq_data_dir(cmd->request))
+					if (rq_data_dir(blk_req(cmd)))
 						sun3scsi_dma_send_setup(hostdata,
 						                        cmd->SCp.ptr, count);
 					else
@@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);
 
 		if (count > 0) {
-			if (rq_data_dir(tmp->request))
+			if (rq_data_dir(blk_req(tmp)))
 				sun3scsi_dma_send_setup(hostdata,
 				                        tmp->SCp.ptr, count);
 			else
