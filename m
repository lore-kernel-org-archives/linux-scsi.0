Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F099C43333
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D7F22D2A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388848AbhASQj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733193AbhASQjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:39:46 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F799C061757;
        Tue, 19 Jan 2021 08:39:06 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a10so12778455ejg.10;
        Tue, 19 Jan 2021 08:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TViEghrC/Cs6u38J3ALVtIUKVtDin2EhWKR0WQxdnZk=;
        b=Zd3sQ5k7V8bL8Hmp4xi3Io2bgPcWHeZbytHCkstgZdx7QQJUuDh+Ym8O858lJsROFm
         42YwtZ5Tg7egxM/JPZCbjuWe76BrHA6/eZRPrBIr83gOyP17fdy+8bE7qdSoP4lBXVTj
         iiegDZ2qduvTt7UwHvTkQzGPMiob17URKPWpyHF6GTxm5/ULhw6CPHRSp3D8rM9Zj8QW
         FrHxQUIMqFBsWIJa8yPwYqb0vUDl0TmMwmR0kVWV9EvoyOWU50IJFXTYOKXpUNWqWiWI
         Rd9jlC+OKTVw4YkTBYOglt2Y7pvDROKzE9EVAq2JI/Xe7ZlWbPtL/vs+qI7R75yhiVnn
         zc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TViEghrC/Cs6u38J3ALVtIUKVtDin2EhWKR0WQxdnZk=;
        b=Il8n+Nr27QdJQO/8bdR6w0GvrkLyQUgtgZUKPha+Gg8HI+fgyRr/AM+ac62pw7742m
         V5VZuqjBks1hcOoKkyu9byXUBG2t/AG8Baz8fZxQwrxqTM4J4WSJi5wDdNnY2SHCBMg/
         yx0vu1oLY5Wjl7sqZ1Ui9BTAKqg0aSSl69yMk/KKBcZPqe3PMFwHZTDJDxSudul/0IBA
         AjFg1ms2pgNwrmOPZjttqJ2IN6tsiMQ7L6wfNAbJk3FvXw29napeDb2da46gLXvgyWlB
         Vrf0I/Ps1j2VjORHgvEmLj96KhhgIvZuxSWkBBuFjQUSsgtc3LiYUuFyqiCRYNKOu59l
         PeRg==
X-Gm-Message-State: AOAM531vlGnrm1tT9u9RzeROldSovJZo/IlfNCSM1wtS+GROxV+0Vc+e
        BwyUoss7SLqW48BksKOlbEA=
X-Google-Smtp-Source: ABdhPJy6FP+E4nmaBzWwj/OS5eCZM05fMtLY0jIgSHbZj5mKvwcnM3w2d1U6ByHGzQyKeqD+napqhQ==
X-Received: by 2002:a17:906:ae81:: with SMTP id md1mr3380304ejb.222.1611074344995;
        Tue, 19 Jan 2021 08:39:04 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:04 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/6] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Tue, 19 Jan 2021 17:38:44 +0100
Message-Id: <20210119163847.20165-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
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
index 501c617cecb9..d13c6eb2efcd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7295,10 +7295,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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

