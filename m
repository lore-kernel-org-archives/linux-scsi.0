Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0958C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C0322482
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbhAELgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbhAELgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:36:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620FBC061798;
        Tue,  5 Jan 2021 03:35:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g20so40837133ejb.1;
        Tue, 05 Jan 2021 03:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TuL9l7cd5XEdbcY4qpiIgEMuqT0kqAcHNj9mtN4Z6Qw=;
        b=HnatRHw4Hu2CoP1S4xtJuUpRrO8B73K+GMOzp2r9iQbGHrK9NuA4MUY79vlcB9E3p/
         8PHeiHjQU7FYc3Ueh7+oN6F4VEUzKG/FVqeQnpsEBN9uQSS7PN8tW04yFnlO0YeE23iM
         UdqXBBwbdOxoOmsFOvVfoxTwqN+S2rwMatTSsGsDggqk+SPOV7VfNia2bFmJnbDkwL5v
         E04lunrZLxkQKrV6Hql5NWZBAqq71Rtgli5QAkXYjJkiSXwHrtu3gvGF0WUFENiLkcRi
         KpmCk/f7VGbTzbSPM5emf8X9ApZpYIALrfLnSZT998COj0qdZRIN1L9XbBvYjKT500GH
         0nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TuL9l7cd5XEdbcY4qpiIgEMuqT0kqAcHNj9mtN4Z6Qw=;
        b=o0fn5Nqk9jcpmIodozupCvkEeTrtgz2hDQZrwUZ1WQMy55MKeKSY6LoryCP1mf9OLx
         G2bCHQbDUyMxOQv5paogD6hF1GpH8YXtz3I8p/mVj8i9qAAgEX+3hmubQAorbMRiKcYh
         CRvyrC3Zbx1Lt6qd6Me9+KeOJ4nCQd208S2ZEI1VDLdpckPejbRSYYkJkatSFRciX6Zm
         mJXLsippKnagmCT0LNtq8BfBwWJgOHoUE4PDxw+KVa2hl8HPrwcMww4xDw7BxcbgR50o
         9cbvDQ8C7DUnyVfxNNrxicgwfxrFxu+sO1GKjFRdCd9/Tr2rK/HQPRNMhS2Z57WLkVyc
         4Twg==
X-Gm-Message-State: AOAM533tNYyebEA1WGCy1AsOFJLmsFaH1J1BR/LYeuIRtckIKkTVmoYH
        UuoFL1Frp/fPMNvUA71ul6c=
X-Google-Smtp-Source: ABdhPJybWWePsyd+lgxPzLDgoi2GPAUkvQZnKlydZInI+JkHdD03ywNn1muZgWwgmbX86cWEohejwQ==
X-Received: by 2002:a17:906:af75:: with SMTP id os21mr71076265ejb.330.1609846504202;
        Tue, 05 Jan 2021 03:35:04 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:35:03 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
Date:   Tue,  5 Jan 2021 12:34:45 +0100
Message-Id: <20210105113446.16027-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
for the TM response, let TM UPIU trace print its TM response UPIU.

Acked-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6ccf71ab3b9c..4df17005e398 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -341,8 +341,12 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
-			&descp->input_param1);
+	if (str_t == UFS_TM_SEND)
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
+				  &descp->input_param1);
+	else
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
+				  &descp->output_param1);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
-- 
2.17.1

