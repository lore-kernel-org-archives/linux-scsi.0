Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12D2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3B2075B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdsgjP2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgGFJT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 05:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgGFJTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 05:19:25 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E748C061794;
        Mon,  6 Jul 2020 02:19:25 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lx13so22954292ejb.4;
        Mon, 06 Jul 2020 02:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lchUO1dlDfUYCYrUAqvNoMb8oBzYvbwPwcFLBL/UWM8=;
        b=hdsgjP2hE8yxjHEjYbHidV9MmgUg2X8wLco4PI2MV4THSoaLVuAxVibtoJ/7MdT0le
         kSLbc7Ke2zi0m40r4i+TMctLB1V8+WYs1hAOs3fgKcQcBJ2hOYYcG8l74YafFHkBjHIT
         akYHK/Lz51XpPiZJmmsE3pkyPEtgCkqqNa14TXSc8rACURMT1c/vBY5TT6qaiuH9fnYl
         xd64Tygyv7TLEqTwQodBVss80qPg4bMipzM16WVN4z3aHWZg+byY9t/7U4d9ek0X0hNr
         DYVhM/6c5hyGgtapHebdwbGhsE+FWFQlUcNfZVJrFELFMi5vFzyJtUwJhtu5+wVsy77t
         imcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lchUO1dlDfUYCYrUAqvNoMb8oBzYvbwPwcFLBL/UWM8=;
        b=oHP2xbtulwhAyDLS7ybVu+mFBEdkqMHLzC7QLEcjs4RX+zco2kynRF1Buj9coDdXaN
         haYY+NABC7Hr+/FhVOqOwIGbEL39BndRtADeaHZVz57OoJW7Luqh6Ad0y4bkrSbfPhOW
         1opAGmTXWERcxQfuh+FlFSr6r03OHe2GlavLlykXH9trR1+XGFNHL08HOWjSynlu3PoW
         5iHwowaHubInPFRMy/wAEm3mCqaGwf06RYVcykgTWTb7IOICR4Nbau8iTgNwuGT1kZaP
         JeHOcRxuBMnQeJwgt/4cOadvkwgsmo/qMdPyhscGqon4oc+3wKlhos03d1HrSVbiEQrL
         eFQA==
X-Gm-Message-State: AOAM533Sb43D/hMEC72ZjvygWBUUG9DWr0z4KTUsWX9MVf1k+pv1o8zg
        R9301Cto7FnXIJkt5+VJv5k=
X-Google-Smtp-Source: ABdhPJxpdvG7Y1T+/SfT/eLp8ctUJncfeDiIOqgWi6ZkRfuFvfNr2HxlP92Ub7FGcIabbNuCaewyJA==
X-Received: by 2002:a17:906:b0d3:: with SMTP id bk19mr45172900ejb.167.1594027163884;
        Mon, 06 Jul 2020 02:19:23 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id d23sm15975386eja.27.2020.07.06.02.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 02:19:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] scsi: ufs: change ufshcd_comp_devman_upiu() to ufshcd_compose_devman_upiu()
Date:   Mon,  6 Jul 2020 11:19:05 +0200
Message-Id: <20200706091905.12885-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200706091905.12885-1-huobean@gmail.com>
References: <20200706091905.12885-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_comp_devman_upiu() alwasy make me confuse that it is a request
completion calling function. Change it to ufshcd_compose_devman_upiu().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 173deee37e26..96d830bb900f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2368,12 +2368,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
+ * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
  */
-static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrbp)
 {
 	u32 upiu_flags;
 	int ret = 0;
@@ -2564,7 +2565,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 
-	return ufshcd_comp_devman_upiu(hba, lrbp);
+	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
 static int
-- 
2.17.1

