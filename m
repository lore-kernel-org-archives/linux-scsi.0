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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F98C2BBCA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAADE23716
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgLOXOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731267AbgLOXG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C969C0617A6;
        Tue, 15 Dec 2020 15:05:35 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v22so22812834edt.9;
        Tue, 15 Dec 2020 15:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U7gSLsQcFEBe8WcOSAmmf0rsSetrSeSprNaqCiGaY3w=;
        b=p7QZrjOWEW1fKm2OJzcU0KfGZJMFzjwomRtDwiT6mPvlxnm2fz8Mg21qMrtI/Sc8mc
         bQ5pubBuIQzwQdz3V4QOw7i0A5kwtqA7p41k0oRZRzZti5KBwDA64TPqxX00hrVV0J4M
         WUnlIjsSWJVE/bfD5q4/NRN/BjgoYEj8FO7CnAjTHugtijJny151JHZ3jHgQ/z26abQ1
         St5vhcznMdYM50kdZCN2qzShyYbxyvcnD81bWqW0QFCnY4IqLDcySVao0IE9esRCMElo
         jpr7Crk4vN3AGwWB8G23+UjXTCWS5mX6LhvAAorD2gd2W73CRVqq1EwQtDCkPgXSrKJh
         4pXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U7gSLsQcFEBe8WcOSAmmf0rsSetrSeSprNaqCiGaY3w=;
        b=MrtbYM9jivun2mEbAFYTgI6kp6++skyARctAyv2vasxQfgPe3S6tBIxUjwcQZhr+0F
         nEPTDIS8KFq9e77d2Xkky3ynrZZ1YU5QmgeYQoZwTMNYfR2k0omLWLYL8QOxvuLquV2m
         nIgqGZcR/+AJWDSkV3G0gaxLHNmbpdfdrKvDBkR463HcE6BcmI1TS6pzYG/9g7ohY74w
         nVWvauaMxJ9gv8s2Qxv0kwk977Fr2wQ2NbYljvqtpmp5fkX4fivH/paAepvPA/Zbyrv9
         uxrk6Ic0yhXKfzBtFJXGDRbA1rVLGYVP7wIzV9JCOIPEPDMX3R6eetfafRB3DaXATgqc
         Uq7A==
X-Gm-Message-State: AOAM532XJDgktQ5JDMga0vhQBANg8ZfqtBAgsSLgiustc5dd9mq+Axe6
        0Gx5WHeLLCvY114/STrizBffLFiAxQxLGg==
X-Google-Smtp-Source: ABdhPJzlbCm1Ix7xpZSKUCODk/9+hASTPRadOFNIXfBJn/05Q8v99p12SqQqW4/kudJzfllprV8nKA==
X-Received: by 2002:aa7:c0d6:: with SMTP id j22mr16783093edp.31.1608073533984;
        Tue, 15 Dec 2020 15:05:33 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:33 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/7] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Wed, 16 Dec 2020 00:05:15 +0100
Message-Id: <20201215230519.15158-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5e1dcf4de67e..6a5532b752aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7232,10 +7232,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

