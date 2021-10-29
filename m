Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A4AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE1261038
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhJ2TwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhJ2TwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:52:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9650DC061714;
        Fri, 29 Oct 2021 12:49:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m22so18274194wrb.0;
        Fri, 29 Oct 2021 12:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zw+xAQi1vOllHNGZ0lKvLTsj+zTxSyKFs+DjlxtroHs=;
        b=JtyC8fYwKr6upKV6EMNZHarq7+O6RsbVKbTq2wT/ZFR5FVWBP/waTAsj+YDU+re8N3
         xLsvnPu586xadRMz32oL4iL3b7xNcK8wFfXD6oxBI/7Sc24bhRfpsFBLNa2dGFqigIyV
         fooUtiY/XKB5PIe6Sq75MUqlqWyx8SwGpTrmBFYWTzxFMlEdm8fwIx2p8ucCQKVhZPWK
         pXHHhMXJjdv78b1DHyRcxpvPg+YnZ0SJKvwrLfBe1sLP3+3cbHoNo4Y7tTF5bTMr72zx
         f6KAb2+hcOMBCO+/W+MfSZ+xEYMC4QXBJiMTcg172RiM4I+CKECq8iRkg8T0A2XxouaU
         xkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zw+xAQi1vOllHNGZ0lKvLTsj+zTxSyKFs+DjlxtroHs=;
        b=XrgaC/G18sP6VhTtHwVPQK9jKG9MM246WmdlxHC8+lLdv4ECXLrOVBcCmjyQOBH6b0
         2m3HplygO5ogRo1S6S/HIqSj6exJMnwAyy53dG7OV/kZXpaDoDkiSCfut3kCYE0tvhV0
         qJ4uwwajlqquw7r1S8c+i53ljPVUuoFmPiZ7C8LFlEbF/5Jj3le/RTKp9G6SAn/MgvrI
         fsG/kuMdrF5IpUdOxs1eprxnhvUU085ZfIYxSAazUQlBXVOFuIli5eBbBV30eGlvYuAd
         v2ORzyKIf2dWhXSUyyIK0xTmomYfZ0poCBpfHf6IQpWNP9KOcgr7GyzBbQH4OX/Ww45m
         PTCw==
X-Gm-Message-State: AOAM533MJHxJk9MzQuY/e+G2mB+mMcROH7xs44d40S2mL+A/DBnD0PTY
        aU7dEBoQ65Bqm0N8wPHEuu4BWe2nJJYssw==
X-Google-Smtp-Source: ABdhPJy8CsLfwSf5QEv/TxfN+1BcSaDFXt7gChc0+YNC6uqot1BT3fXcBOLDP00AShwE5kI8we0Pug==
X-Received: by 2002:a05:6000:1091:: with SMTP id y17mr16537251wrw.312.1635536983249;
        Fri, 29 Oct 2021 12:49:43 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id r11sm6323365wro.93.2021.10.29.12.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:49:43 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] scsi: core: Ignore the UFSHPB preparation result
Date:   Fri, 29 Oct 2021 21:49:30 +0200
Message-Id: <20211029194931.293826-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029194931.293826-1-huobean@gmail.com>
References: <20211029194931.293826-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Ignore the UFSHPB preparation result and continue the original request if the
preparation fails

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d91a405fd181..a11248d89a7e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2740,12 +2740,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	err = ufshpb_prep(hba, lrbp);
-	if (err == -EAGAIN) {
-		lrbp->cmd = NULL;
-		ufshcd_release(hba);
-		goto out;
-	}
+	/*
+	 * Ignore the UHPPB preparation result and continue with the original
+	 * request if preperation fails.
+	 */
+	ufshpb_prep(hba, lrbp);
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
-- 
2.25.1

