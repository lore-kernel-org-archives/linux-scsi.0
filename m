Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF33C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FAD6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhENVfp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:45 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:56072 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhENVfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:40 -0400
Received: by mail-pj1-f45.google.com with SMTP id gm21so518451pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DWgJ7rrYJ2TaqSweWO5hb7eNOrBJhRnfEehynKbfH4=;
        b=YXxeykZDZH0RXcVZ4UMZE6PDf6YlSyTk0d6wodHULnpef/H1x6Nr/eT56i9fUX2cpA
         KefzqkFRVTY4fQ9UQHFC2edlqRu2c+OTP70X0+AKrak7+eKdbmeEaBJEAvcV9FNrnHLm
         69jy1D5MUadoe2Kwc6R9kA/4rgZid7f20KhuFL/94xAQIIgWBgefGQ2j2QQmw5w/ny5n
         tjrKPBYY+N9w0weUUvNNq2ckKVYrfOwJdLkf9Vxkb1Q2TJ5VuK1VDcTqTJWfC7s/VDXv
         yeZbcZYNf2FWRLtypJ+FlmwhyFqgFiT5eW1ZKMQ75dOopIl/KjSgTbqO5CtuTnTzUE44
         m5pw==
X-Gm-Message-State: AOAM533Kufc91uiiCw50bZh7ipzj3pTpIPYxZO7j1dP8jt7pBLVw5o9a
        9iqOPkbDJHQpVd7oupnKPsQ=
X-Google-Smtp-Source: ABdhPJyj7BsXM8cL9u+d3Xriz+qyp3X1FbuyCsynSlGpN9bi+se6nJM1xCy0TB5dpv8abj9XdXrjlQ==
X-Received: by 2002:a17:902:da88:b029:ee:cd32:808e with SMTP id j8-20020a170902da88b02900eecd32808emr47767461plx.15.1621028068320;
        Fri, 14 May 2021 14:34:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 14/50] advansys: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:29 -0700
Message-Id: <20210514213356.5264-15-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 800052f10699..e9ec10c466f3 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7427,7 +7427,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Set the srb_tag to the command tag + 1, as
 	 * srb_tag '0' is used internally by the chip.
 	 */
-	srb_tag = scp->request->tag + 1;
+	srb_tag = blk_req(scp)->tag + 1;
 	asc_scsi_q->q2.srb_tag = srb_tag;
 
 	/*
@@ -7641,7 +7641,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      adv_req_t **adv_reqpp)
 {
-	u32 srb_tag = scp->request->tag;
+	u32 srb_tag = blk_req(scp)->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int ret;
