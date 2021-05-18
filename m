Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904BBC4360C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74ECF61074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351240AbhERRqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:34 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:40915 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351200AbhERRqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:31 -0400
Received: by mail-pl1-f169.google.com with SMTP id n8so293159plf.7
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q36SflnryTrObAIdoPQMJHITJRxt4At+O2hiMdePM0I=;
        b=oHlRj7xQh9Yte/YlkKnxV3T7Y26nERBHZNO8fG3xvwzyo/eAE7TeFr3pzeWlyYT/3K
         ZKnxFSB2/mm2R7ZSU0/a+Ei7eGWzT6CfNSD5hVgXzMjdPTTBdY9IXTpXAOGvTxTIScET
         /xdVmsmTBiTB9pavaddtHRf1gSqNfNc9OQ9z/iRDypHbpQfoejqs9FQDLjxSSVmm3jrD
         FMyUVupPGM0GxbJnd22nGF2E2RCDz5bayo8IxPO1QEpr4wRFoOCI9NnrsC5Pki+70pH8
         5OavQ9Xw6cFXldPALCrV90bJt/BWlV2FZ7TvIxx4Ot0ROKRyrUaom58vlfLQbL8TSYAN
         zTvQ==
X-Gm-Message-State: AOAM531RJnCLY2m9tbACoKOWwkzZt72rAuOx8c6dtlOQ3P6q+uAOTmb6
        gnodJXvxso5r2uKaoAy3M2k=
X-Google-Smtp-Source: ABdhPJx/Kb01dwpJwQawC0GbZTZwyhp8UCAetWSZZYEJQ9N7FVC51VPYyn1Qq88z0rX6TBVHjeavPg==
X-Received: by 2002:a17:90b:1e46:: with SMTP id pi6mr6409781pjb.212.1621359913356;
        Tue, 18 May 2021 10:45:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 15/50] bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:15 -0700
Message-Id: <20210518174450.20664-16-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 43e8a1dafec0..5521469ce678 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1918,7 +1918,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	spin_unlock(&session->back_lock);
 
-	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(sc->request));
+	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(scsi_cmd_to_rq(sc)));
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
 		rc = -EINVAL;
