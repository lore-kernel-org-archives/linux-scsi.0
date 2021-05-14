Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F2C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F68B61440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhENVfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:55 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37723 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhENVfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:54 -0400
Received: by mail-pf1-f179.google.com with SMTP id c13so658472pfv.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBpDebaAugL9JvWwPHRHrVAjzLTctYjhzrp2WXlm6a4=;
        b=BQ9oZhO5CIv8m988K5TPcwGSC0pxTqI9TLU0QDcC/STsDHBdxAf9cVjY3+ehi1FgTB
         lWBTP1qAzGePegOC3ZNz/+IJ/V5hfwnd24N8gk9iQTanQ61kNb9lUQUzRQLuI3aec+iu
         csYvc09R3qq0Ny30Nk7Pi1Udd57xbo8u0jhk/Z723YaGq2QCgjr+RR5cnVEhWplDj1hM
         VoDxYgcEKWaOUzAXEeJdJ1fWDFuSKpRH54ecKEYm5k31yb3Z7g+PJzwe8Y+XdUDpoxhj
         mEVKiuD3CxstCFy61rXYgukktZSEu0I1mpGh+bmpYghATwHaa5dHhQbbD1ZKvuq9jWrh
         sqaA==
X-Gm-Message-State: AOAM532YsYA6Qg/LciMDHpzjaPuuxSnT0mx31DGgQzToh769bjhzbtb0
        z5SjeTQ2uPuKlQKEKH6KGLM=
X-Google-Smtp-Source: ABdhPJwzD/PGTylptQ+Awp7au860deFJc2vMz9Io4ch0cFkYpCSaVmG1LMdeVo54VvQsV+OXTdsUnw==
X-Received: by 2002:aa7:80d3:0:b029:28e:f117:4961 with SMTP id a19-20020aa780d30000b029028ef1174961mr48019585pfn.37.1621028082526;
        Fri, 14 May 2021 14:34:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 22/50] ibmvfc: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:37 -0700
Message-Id: <20210514213356.5264-23-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6540d48eb0e8..e8b4f72f9161 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1908,7 +1908,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
-	u32 tag_and_hwq = blk_mq_unique_tag(cmnd->request);
+	u32 tag_and_hwq = blk_mq_unique_tag(blk_req(cmnd));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag_and_hwq);
 	u16 scsi_channel;
 	int rc;
