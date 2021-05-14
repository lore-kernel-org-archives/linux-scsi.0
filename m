Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB4C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C924961442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhENVhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:19 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:39904 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhENVhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:08 -0400
Received: by mail-pg1-f174.google.com with SMTP id s22so254882pgk.6
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DWgJ7rrYJ2TaqSweWO5hb7eNOrBJhRnfEehynKbfH4=;
        b=e47nVQlDFObUeJr8IFd1YqNmeue6rG006jNhRJtpxgrKD2Nk3kUW9fKPFlb/ZP8e1G
         bcnuU3ca2a6LIzjK0aY+utDRkxevtHGDF5igUsw7GDcaAhUSQJjJLv/LOYHXKCGwAoiA
         pHujGGjT80ukXHdQmVgxU1dlAu+zinrD/pPAwftI4S2jX67uRKDB9o8NRVW+GAZrz90w
         b61hCObxn7NfUH0x1066pU6hx+KhO5ZoFydTlAWcEQcX9m9clOuODlb1CWsyaOBvaSM4
         w+Wo7Y4/7GhK1Rj8k2blI5e4FCcCLOV2FoQjN1wZMkS2LgZGsDjLqdc4t+NlVbxDBHaU
         FiOA==
X-Gm-Message-State: AOAM533SvKZQQPL0yha/fSnZteJZKCUU8VPDBWstQniXy+O0IocN9UFq
        YxvAahFxuC+lqIeyehcGyrE=
X-Google-Smtp-Source: ABdhPJwY3OwdVRfMhlOwCrOIkGAeleuClujpBr1bkdZUYt8ija9yMxzjpfyYSb493vj4DnErgJZRlg==
X-Received: by 2002:a65:550e:: with SMTP id f14mr20907385pgr.160.1621028156616;
        Fri, 14 May 2021 14:35:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 14/50] advansys: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:20 -0700
Message-Id: <20210514213356.5264-66-bvanassche@acm.org>
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
