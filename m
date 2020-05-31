Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42FFC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC2C20723
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcesK1Ne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgEaPIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgEaPIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:08:46 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF14C061A0E;
        Sun, 31 May 2020 08:08:45 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g9so5359348edr.8;
        Sun, 31 May 2020 08:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XfFxQBI1hPOPry/JuXbWihd/GAmGS10MEvt8RmVJwS0=;
        b=BcesK1Ne75IigMaHremht0iaqusswsHGHT9tJPaQklnxsHd7LtvD3K+cD1ZZRztg1P
         NTVi9uADk6YSUD84gn39hXiCCTJHJgpoaRbkWJEpASeEwWM+n9kbAmMwmssbE858CYEh
         rxDFNi62glqEjQxkRfrRfGS8BFhz59bW2jjyO6GKHQJyZb/A8HFEpl7xC/pRNrGpbJPR
         RMoMnPrLT/2iJJaDvsV5PatS2O/0KQaG5qzCq7MaLb9plTVdhsoblYiswdNTo4iwFTbL
         eY5bpKUZsduyp/AahqrkhHRW/PA6jqyqj0Lf7/jaHk8d6fxW76ftTVtW79cKM9vLne+C
         Jt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XfFxQBI1hPOPry/JuXbWihd/GAmGS10MEvt8RmVJwS0=;
        b=FHf1IsEm2GIBw4hmUXWBZ0abWk8FfoB5oJKjvVKjFg/ni0IeJRHVkWDPzUehUBUXIm
         UBb83rfuapjHw+YuiPek7d9eNUiTFvQREcrX4EgJcGwjkq9VoW+sYn85BvxggHI0vWf4
         11dC82oHpF+HlEEPmIjfPIwvMFP1jzI7F9xq+kCV0NHLBWk3d6zbLKjzNhZf2JmLrLtW
         9fKLW+ZvgUJaQcmNuDFcIKV7wazfSPd33FogT3kJSguidZJhv69uYOUHRFGzTJQU13hY
         kGJkpzd6/ecc/X8KuLzKZaRYaB25EyBQpvCrCH8wbP/eHtyrqWeOhSGD8c4wXtCpMhaB
         k3tg==
X-Gm-Message-State: AOAM532Xea2O8YzKM7Yz9GkfxBhSbcKYznuzEIOKkGXv4K/7qCqohfiU
        2G69kx8FKtVtb1PYKhBd4YI=
X-Google-Smtp-Source: ABdhPJzD7DThlgm2bToZ9bX0be79FFhNG72O9XlvQmhvhMH1ub1dew6bSdBSnd0029snFOoPR0JQlw==
X-Received: by 2002:aa7:d0c5:: with SMTP id u5mr17169914edo.51.1590937724457;
        Sun, 31 May 2020 08:08:44 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id a62sm9564928edf.38.2020.05.31.08.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 08:08:44 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] scsi: ufs: remove max_t in ufs_get_device_desc
Date:   Sun, 31 May 2020 17:08:27 +0200
Message-Id: <20200531150831.9946-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531150831.9946-1-huobean@gmail.com>
References: <20200531150831.9946-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For the UFS device, the maximum descriptor size is 255, max_t called
in ufs_get_device_desc() is useless.

Signed-off-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aca50ed39844..f57acfbf9d60 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6876,14 +6876,11 @@ static void ufs_fixup_device_setup(struct ufs_hba *hba)
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
 	int err;
-	size_t buff_len;
 	u8 model_index;
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
-			 QUERY_DESC_MAX_SIZE + 1);
-	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	desc_buf = kmalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
 		goto out;
-- 
2.17.1

