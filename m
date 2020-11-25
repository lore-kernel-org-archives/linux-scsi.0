Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ECCC56201
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 18:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B7820679
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 18:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZXqNxXMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbgKYSxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbgKYSxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 13:53:11 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5B3C0613D4;
        Wed, 25 Nov 2020 10:53:10 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id mc24so4477820ejb.6;
        Wed, 25 Nov 2020 10:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FIzwOFVQ1k+jVYEe0U8aYa7Gyp4yB3KJuyl4hIaoCp8=;
        b=ZXqNxXMmOFlbkMjG0kN2ad3TKs/sxB+I/1Ic8tTB9ggciP3YKxWp672Xr3JJLEr4SU
         V4SCcAoybtgEkVvJlMxKEEsK4uWj6ezJitxlVTBdVvLcM9n9XMnF4Y/h1W+CGZaFMV0+
         k5K2wrFhP2uFjumnZOtFbSIm71QQrkqYQuc6ZleTCgq80cJYgjFsB2WP1JLjVKQOUjLV
         16EibyVY1aYi8F+siWus9aZPeMGGPGVC17dOsHYslxpYXJZA7FsTQ8QCmFxN14/5uoqY
         Mqh+irp1aH7ywrhbxYgrKz4n/phpwc+bBYrEbIrX8UQ2e4MGGdZ0qoffRxlXm20rV8v3
         wRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FIzwOFVQ1k+jVYEe0U8aYa7Gyp4yB3KJuyl4hIaoCp8=;
        b=f12cJ757+gcgah47ZLTYrlceILP2+9ssetG2M9/mB8ac4krbfDHC8/X/pnb20X91jO
         umalRjWtZyIjVaDvKEM38CResuRqeV4Cri7RtV4A80CoXpYOCZ8F11MV3HG9yW6ZESo4
         Lo+0doUBfBFM94orfJV/gHgFuOhbN6I2ffvPEe4LKQc6kdkQDu+LW4zko2TR5i6EwDqB
         V3YBr+UULNH2KuNbzlDp6+FDLVVQ/yXckS+cygc/bhsIqJjUuCZbJYIcFRcD216gOrEC
         WptL2Bmc6eMdjrhvmhlwitdGEqPUAt25zWb4VO9IdnCV1xrjwCgusviBXj1JrUVLlJ0V
         MB7Q==
X-Gm-Message-State: AOAM532jjDTuo6WFvzzeGH+GFU5qgulcUZEKMxfgBJ/feUAx87j6fGPd
        tWiEg7gFglNExt9oP2dPQWfmfA0U6AL6iA==
X-Google-Smtp-Source: ABdhPJytiqJdiZvNgzxKDgU7MhwJcHTKmSPf4K60mIEtjExwSxlkf/KqXeTPZ560b6D0opyyOioLrg==
X-Received: by 2002:a17:906:490:: with SMTP id f16mr4389592eja.12.1606330389530;
        Wed, 25 Nov 2020 10:53:09 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee2a.dynamic.kabel-deutschland.de. [95.91.238.42])
        by smtp.gmail.com with ESMTPSA id v8sm1758070edt.3.2020.11.25.10.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:53:09 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: Remove unnecessary if condition in ufshcd_suspend()
Date:   Wed, 25 Nov 2020 19:53:00 +0100
Message-Id: <20201125185300.3394-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

In the case that auto_bkops_enable is false, which means auto bkops
has been disabled, so no need to call ufshcd_disable_auto_bkops().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80cbce414678..d169db41ee16 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8543,11 +8543,9 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
-		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
-		    !ufshcd_is_runtime_pm(pm_op)) {
+		if (!ufshcd_is_runtime_pm(pm_op))
 			/* ensure that bkops is disabled */
 			ufshcd_disable_auto_bkops(hba);
-		}
 
 		if (!hba->dev_info.b_rpm_dev_flush_capable) {
 			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
-- 
2.17.1

