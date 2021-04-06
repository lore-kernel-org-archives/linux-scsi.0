Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D751C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F52613D0
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 18:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244447AbhDFSGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 14:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhDFSGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 14:06:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26FCC06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 11:05:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so21273096ybw.7
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 11:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=teD1nbWDmR8uP6HF7dWyx6/qjSabmbVIqj89B7QTpIM=;
        b=Eo4OfR7J9uEJ1O7UiFQNtCPIHUT04yszhryQQIKxQAMGBGCR3O5UNW8bwUB0pnjEg5
         8pG+iuGEpFQ6EFN5nwZ5LBsMwy3rbDu+Z7lBJuEygjyFoaZqLkQDsQNId9tF7oCy+mbB
         5NA7Yfc9BE9SL7WP+0Txj4pfzBV8VJYiuhmArtq0zBV5xmorR7XMh/QSf4GJDaBulzD1
         nLCK/KHkv799fmjc2ScRbBvuaBcMAaRu3TMhWxcuSbpLcJ4h7Lg4/0Tp5a5paXrQ8+LS
         0IT4yDj8nQMVwoFS7LXNS/AgvH5AFpxhjdP7HrAf75/+6l2Y6bDc8SFc4Zr4/J1JrLdD
         9t3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=teD1nbWDmR8uP6HF7dWyx6/qjSabmbVIqj89B7QTpIM=;
        b=gEVTuroL9fME6xcBO6+1LMP8Re63GwxMzqs/askpC6z7nBskUB7BWb+a/C+/Ou01ym
         OP7/TClajnBpY0ec3BiHSB1y+H3TK2y4q4dZevmERXBkZO2798vmnWOjFVBylmyt8HMq
         Ua9O03j5hGsS4OCOM6WbcFt9nJ5grdR2htjTfCCsWOj6ALAsDsoRB5iD+sFbiGgIvgLF
         LYhjsZfatTTyAYHVn0x72y+22BgsmHcHlo6XcKmx9nt1y/LOumZWise0gy8CYHBfKlih
         sq0Vnx8sT8SNOGCqETj0R+G11m9fbQbT2GIqDW/9WgowBC53BlRH13x0HVmo+qnf5tPr
         +/8A==
X-Gm-Message-State: AOAM530YeatxxhTQNwbO3rRqDvM796J9FhYOdSECAa+Rs9i90zAG2ysw
        iRL/uzA5GWznyuaIRW7qNFukaKfaGdONDw==
X-Google-Smtp-Source: ABdhPJzSONE3JU+SpDL9G5e8YgnP6CB4IznsHb/HLDy4Wo3PC5lGY2zGHCCY2DNpHOrPB505QrJ/p/7gRHUzQA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:ff2:f4b8:7c38:13d7])
 (user=ipylypiv job=sendgmr) by 2002:a25:7c47:: with SMTP id
 x68mr45560292ybc.358.1617732354237; Tue, 06 Apr 2021 11:05:54 -0700 (PDT)
Date:   Tue,  6 Apr 2021 11:05:33 -0700
In-Reply-To: <20210406180534.1924345-1-ipylypiv@google.com>
Message-Id: <20210406180534.1924345-2-ipylypiv@google.com>
Mime-Version: 1.0
References: <20210406180534.1924345-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v2 1/2] scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mpi_uninit_check() takes longer for inbound doorbell register to be
cleared. Increased the timeout substantially so that the driver does not
fail to load.

Previously, the inbound doorbell wait time was mistakenly increased in
the mpi_init_check() instead of the mpi_uninit_check(). It is okay to
leave the mpi_init_check() wait time as is as these are timeout values
and if there is a failure, waiting longer is not an issue.

Fixes: e90e236250e9 ("scsi: pm80xx: Increase timeout for pm80xx
mpi_uninit_check")
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 84315560e8e1..c6b0834e3806 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1502,9 +1502,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 
 	/* wait until Inbound DoorBell Clear Register toggled */
 	if (IS_SPCV_12G(pm8001_ha->pdev)) {
-		max_wait_count = 4 * 1000 * 1000;/* 4 sec */
+		max_wait_count = 30 * 1000 * 1000; /* 30 sec */
 	} else {
-		max_wait_count = 2 * 1000 * 1000;/* 2 sec */
+		max_wait_count = 15 * 1000 * 1000; /* 15 sec */
 	}
 	do {
 		udelay(1);
-- 
2.31.1.295.g9ea45b61b8-goog

