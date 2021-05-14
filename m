Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8A3C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBF261442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhENVhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:21 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:45016 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhENVhK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:10 -0400
Received: by mail-pg1-f170.google.com with SMTP id y32so237685pga.11
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIIFvRIv7OLSpsGdeLExpFVQyXxiBLPv0iUfrznOEYQ=;
        b=FwVbwGQdpHbFTPFQDajBa5lOB732/Wthr0Tt8osDxCTFPJdtOKjs3F5ZeAY8UZwmkI
         PKBsuVK6pUEqX11/qgbSEUQpJEzFg/8tvzKBsjpkGkW74wnImhd+FkTo4mKLGQEAvfXc
         C/iuHck9BX7Rwg3PZYSbDqmDLLQaNwnTw7pVo8ZnwX2/urFFS+3iZs8puaHCO+I+K2ie
         al5D0uBPADAHfA7z0KhVpM8LHFLurWFQOWmIHTSclPV90h1auen3a8Vd637PU8HcwzZs
         rxunAJOrnkwJTk7roYlhL3ElQ9t0IuLCCCp+KFXczAkEL9OhhvXf2xYJVddeFStGvxUz
         zYuw==
X-Gm-Message-State: AOAM531d+U22iOE6e99Kk7ahQsnwcT8yEjn96nDhE4TdbbXAg00GAAn3
        w5DyqfBRyZc/bcrDd3jy40A=
X-Google-Smtp-Source: ABdhPJxV6M+YX7GZfoqB2ftcoB17pHbbVF9YFYvUh5t28vRGYmPtF9zsJojSX9nq+o35rIABXJmMLw==
X-Received: by 2002:a63:2542:: with SMTP id l63mr50456290pgl.128.1621028158416;
        Fri, 14 May 2021 14:35:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 15/50] bnx2i: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:21 -0700
Message-Id: <20210514213356.5264-67-bvanassche@acm.org>
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
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 43e8a1dafec0..70e9a8e6329d 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1918,7 +1918,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 
 	spin_unlock(&session->back_lock);
 
-	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(sc->request));
+	p = &per_cpu(bnx2i_percpu, blk_mq_rq_cpu(blk_req(sc)));
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
 		rc = -EINVAL;
