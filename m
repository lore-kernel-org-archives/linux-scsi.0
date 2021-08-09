Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABA8C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31EE61002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhHIXFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:00 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:36862 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbhHIXEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:48 -0400
Received: by mail-pl1-f180.google.com with SMTP id f3so7719612plg.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q36SflnryTrObAIdoPQMJHITJRxt4At+O2hiMdePM0I=;
        b=LROHAHhjwmI4fiNkIAgZfKVqRkI07hVzQoeed8sQNiSpGr5U0uf+mZghzN4ITUQec7
         pRcdj33EHcMibUhPHXQxJZsRnU7nb5yl0v0f2vulVh5NRbCRtsPiZZIf1rlyhz6azBsP
         EAt8DDl+i+GJnLwkDZoG3mF2Yz+YBe6U79Z92B9XgrH7sfDbMyIz/+n/t0/BynACprlf
         PLyGH5nFWnCyD63YljI55oH57t3Qw2jVXo/fBHPOzDhH9nfUfaezBtcpZFoo+GjvhJTy
         WjVjoRdER2ETpPXZr/Wk4J1C04ufbLbCjgzVGJ3ZoIFIan/1aJMtWxitdcltit/zx2Nd
         NqAA==
X-Gm-Message-State: AOAM531GnbL1Ax4Z2S8AW6VQeKybI9bAUqJEEadi9qMHKTgdMyCiGgRu
        4YbKXhMS4o6qACL64a3RUo4=
X-Google-Smtp-Source: ABdhPJy9RtTJfu3hRyHBys5+ZePxuXbGI5HKkzqcNdDvbdlhejcM3KP9+ocLgORbNlklKZq/N4Kg4w==
X-Received: by 2002:aa7:961d:0:b029:3bc:dbdd:7a9b with SMTP id q29-20020aa7961d0000b02903bcdbdd7a9bmr25959290pfg.32.1628550266792;
        Mon, 09 Aug 2021 16:04:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 16/52] bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:19 -0700
Message-Id: <20210809230355.8186-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
