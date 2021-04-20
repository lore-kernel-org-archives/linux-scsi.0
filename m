Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B3EC4360C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590ED613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhDTAK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:28 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:41964 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbhDTAKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:17 -0400
Received: by mail-pj1-f41.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso2541765pjn.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ThKmCLvSb5b7CcX87ZnES/lQx/lOyRDcDTlyIx+oiW0=;
        b=WswiLG22huj+O+L/48MwhRmA0BiYDruIZb4/3JF8FesbJAPxgOSFj825X2W+59FO/R
         dePWSE25A2ASxO/MHA4imF2ERprxHBDQOuBWFeglGKO0zaX0uTvTFwe2XO/8VKvF2yW6
         7CwgoTfvx9uD2e4Fa1AoVYGcQQgIGkXNmzOzKcSqe/ruyradeaPcUD66dCw/sSS4jzpR
         vxcekS4ZCoNxN5jdhyIv1BnMwDP9iriVuZVcCIift+l7ku8eLzjq0xXa4MkzIhjjjlAi
         lZIO8sb7/vpcccWKgWaqUfYCgMug7PqwOmCCDXcfPGIgZ47K6mj+zl1Wv9vUpTNov1gs
         zlig==
X-Gm-Message-State: AOAM530ZefHm/z0ut/1+Bi0F8q8z9oHRycEYODqL4xpubdgb+hMJ3xND
        eaqxibNUG2Q3C6a1JUyBMCM=
X-Google-Smtp-Source: ABdhPJztzPZtUFhAvArD/fDEzObhd/5wXcLdSe7wwBAMDMTBs+L5kLL0hmvN8j3fccAHB9pB6NTwEQ==
X-Received: by 2002:a17:902:e289:b029:eb:29e7:beda with SMTP id o9-20020a170902e289b02900eb29e7bedamr25874434plc.78.1618877386379;
        Mon, 19 Apr 2021 17:09:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 047/117] fc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:35 -0700
Message-Id: <20210420000845.25873-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2d4db2ae45db..d21301b4c7b2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -4153,9 +4153,9 @@ static int fc_bsg_host_dispatch(struct Scsi_Host *shost, struct bsg_job *job)
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
 	bsg_reply->reply_payload_rcv_len = 0;
-	bsg_reply->result = ret;
+	bsg_reply->status.combined = ret;
 	job->reply_len = sizeof(uint32_t);
-	bsg_job_done(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -4222,9 +4222,9 @@ static int fc_bsg_rport_dispatch(struct Scsi_Host *shost, struct bsg_job *job)
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
 	bsg_reply->reply_payload_rcv_len = 0;
-	bsg_reply->result = ret;
+	bsg_reply->status.combined = ret;
 	job->reply_len = sizeof(uint32_t);
-	bsg_job_done(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
