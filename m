Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C465AC432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1E360FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhHIXEs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:48 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43525 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbhHIXEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:45 -0400
Received: by mail-pj1-f49.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so2405210pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LiOXrYiSEaQ0APiscDckVyE+quRgh1YmL8LN30mCp+w=;
        b=WH+CkLmnymArmBWavGwCcNIbxrd1D0oCQ6fj3u32nkfJv8VVIrRdqT5PKGJal+eAXk
         xDEOiut9U0Jts9hB7b3YeZ/T3kT17HzfIHjBYgv6rHihDQvgziAqP7PKitT8zKo/1koV
         xZnHwrbnJWrSu1OxOlcJJ3hy5LP5ZmeZuJXkKf8DdZLuj/Yt/DHhdHHBqGI1qWyuv/Nb
         rQQ1kyFX9MqRq2lNyFAzsK8GSudrX7p9bFvlJZ70Y3ozs9lcfDpAI11hdavTj/g8P21m
         X3kBI9on2Y3g4TeOCb5n/JUiOmw/C1TjQ9hk3wosn4rM7FEllYUoT3DNAU2tMvQ2Lic7
         8Xew==
X-Gm-Message-State: AOAM533fDl+Q6fmMkOeWQ4/XHZiOwcXq0Mimvc/qunANPJT334MV+mv/
        F1D1gM7Nl5xOko0ZLu/lDE8=
X-Google-Smtp-Source: ABdhPJznO9SbTla1Z1vrHPtMtfy4GYYqFo0POAB5GoOyHn/BGHg/5jUwUoDmwxd+yfA82tw1oQFPoA==
X-Received: by 2002:a17:902:7144:b029:12b:24ce:a83c with SMTP id u4-20020a1709027144b029012b24cea83cmr4187779plm.54.1628550263871;
        Mon, 09 Aug 2021 16:04:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:17 -0700
Message-Id: <20210809230355.8186-15-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index f3377e2ef5fb..ffb391967573 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7423,7 +7423,7 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Set the srb_tag to the command tag + 1, as
 	 * srb_tag '0' is used internally by the chip.
 	 */
-	srb_tag = scp->request->tag + 1;
+	srb_tag = scsi_cmd_to_rq(scp)->tag + 1;
 	asc_scsi_q->q2.srb_tag = srb_tag;
 
 	/*
@@ -7637,7 +7637,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      adv_req_t **adv_reqpp)
 {
-	u32 srb_tag = scp->request->tag;
+	u32 srb_tag = scsi_cmd_to_rq(scp)->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int ret;
