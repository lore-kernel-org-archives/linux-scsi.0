Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCABC432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C2C61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbhHETT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:26 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:38672 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbhHETTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:20 -0400
Received: by mail-pj1-f45.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so17277822pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q36SflnryTrObAIdoPQMJHITJRxt4At+O2hiMdePM0I=;
        b=cPqmrqwhao26Vh7OlkGv5bxvPSHuNOG7ZX3B2WOMbyFouwa3RgXVdKn96AD4JEzhNI
         mMxByQD6OzIwR/QlMbgF2RZzDlShcl0Ozjhbc7xs2WHAl6MGT9/QeeaY1RPPH3UK4Z5O
         65y5vDc4oJtT9LT0CFJbOjf6qBzP0IFVbH2SQuiGcmAhoayLqLSXRx+wfhjQGlOF3xbG
         JsJvsRRY7tucTQW13L+QLIrifA4haKMde6190qSUMno81ip2tYN8Z4bkJ7sAHaz96Uqh
         I40Hx9j6mbvIqcgMJYNiTdcQ3606b3IIzywLU1ks9HreyAcpUwbDirvkji9UCFXEzxmX
         tZXQ==
X-Gm-Message-State: AOAM533ZHee7jjH3v1lIhxP7QjaYOox4Ee1WsfaVexZYRWl+fo/6FU6z
        pvQSbTv9y3dCGkI4WnW/ujM=
X-Google-Smtp-Source: ABdhPJwHYTysltJ7SlmmHC8NDapsXkAaVjWSG+HG6copYz5z1WzQ9DuzKdd9yQIHE0RaKPH1/R85Ww==
X-Received: by 2002:a17:90b:17c3:: with SMTP id me3mr16457575pjb.203.1628191143843;
        Thu, 05 Aug 2021 12:19:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 16/52] bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:52 -0700
Message-Id: <20210805191828.3559897-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
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
