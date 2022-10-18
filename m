Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58A0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJRUay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiJRUam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:30:42 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4586BD6E
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:32 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id n7so14961087plp.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWnttzuLG17GimzjQrTnKBKot+EDJDS/iAk03ZEeCQE=;
        b=kXaOj/boH3+Gccy718WQlk6pnX8FLJiyllR4BPp8634tlZW2wFoP0vQdqViXehkRVA
         yOnq9NvD4c7WDpWz5AoF17SMDhc8TyTtyI1A6MK8/BmYud78tjRiudl+TLLk1k4/oFY4
         d0cxvlLjEIF/ccn1NvmsyKesKWyPsMHssUbpgGcaTtKCH+hpk1YwVQeitd/yl4Ad6uUC
         C3GmUDxQ/r2AMsnp4fFxYIxdNXQHJP1vGdNf39i4Q9++MM1gSK+bYctpxtIJYX+gZAXD
         Qp0GQgd1cvm5bnwkbMoLjjubY5IGX7BAOB6vRy/D6qm3CZ8rAQ8w8OQfSsevW/l3AouS
         UUDA==
X-Gm-Message-State: ACrzQf03rBrV/+Ho0xj5eBr2NLte8D7jnM1VMS/JsmPwNitFvG4/ImZT
        M4AunvyO8+jYi11ASLdfUWg=
X-Google-Smtp-Source: AMsMyM64Rhzi+fao61WPSxfHYXQUwtvHIGtRUIuL/mBOq8I0/GOWnDMY8yrQiSlAFb+dDcWn1cgh8Q==
X-Received: by 2002:a17:90b:33ce:b0:20d:7450:6b49 with SMTP id lk14-20020a17090b33ce00b0020d74506b49mr5581318pjb.128.1666125031660;
        Tue, 18 Oct 2022 13:30:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 04/10] scsi: ufs: Remove an outdated comment
Date:   Tue, 18 Oct 2022 13:29:52 -0700
Message-Id: <20221018202958.1902564-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although the host lock had to be held by ufshcd_clk_scaling_start_busy()
callers when that function was introduced, that is no longer the case
today. Hence remove the comment that claims that callers of this function
must hold the host lock.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c8f0fe740005..bdee494381ca 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2013,7 +2013,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	destroy_workqueue(hba->clk_gating.clk_gating_workq);
 }
 
-/* Must be called with host lock acquired */
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
