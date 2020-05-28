Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775EAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CCF21548
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 12:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTw1j5U9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbgE1L4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 07:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388797AbgE1L4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 07:56:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E14C05BD1E;
        Thu, 28 May 2020 04:56:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j10so11989546wrw.8;
        Thu, 28 May 2020 04:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VqNPYxcU61E3GnlH8hcaNPEopADGrQrIHtoRm3vT2B0=;
        b=LTw1j5U9ak1ZTUN5UhfX6jsE6PRvPnyDu+bHcns9ELHJw/EJNA3juKzE342NAOD2aS
         r1CT2AYX356oH1TS0g/Pp0JId88gR6yuYstCrnAEzYxnGm3p+F2WT+8vv9Y5iayeje+r
         L48cRbhxn4Y6Z2ZY8AqjIQgKrGDe63xBAoH6cgrH3Mda9JUaStZ2CULvnbwYAATYOzzu
         L+Js6tXikhT8vielmdjEbfLJgrUNx3cRxAho5q0R2hUDa0+khVd2mii1sEAsV5bfdk8b
         vA6xFV5nFF3QHmo38cZ/T65/zcY1A0BHfcIZDBeOoUxW5H6DyKCBOE3JJGJo8cjc+NNv
         ag7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VqNPYxcU61E3GnlH8hcaNPEopADGrQrIHtoRm3vT2B0=;
        b=LXnTETb1thjq47XCeTCuYNoJFwmW69+OXVY1jrQqgewwsyR8GM6u7cJR+0MkRJdD1n
         D3jkaXUp1EDaxUOnJyPa0DU/xgK9ZEVBmezU/eI0DVXTnwiFFUDjr3N/hsc3IXrfeDIZ
         5KETy3ZYorW+wxCmS92BUV4gz5pv/htDZ2sHQ0m2hYQzsXRlE4W1gUjalIyenoRZcyNU
         1tw0o17ZMC0shIj6EMjrPJKH7/70Pu2oIAeZuHjY0TwVI9iPm2j6dJ8rYc8DX0z5W0HK
         Bv9Odhn0Y1ctA4zdDv289k2iNlWoyaO0ryP4lgdgX4OqGkuvVDWTxP9o5Wk8HYPQYRMj
         Fhhw==
X-Gm-Message-State: AOAM531QEQDaiJ9yAeTlFVyjXL2S6HozDFAAEjewqUKquAAW+PxWdWhe
        ibBjNb+po9+i//RDGDfFFTM=
X-Google-Smtp-Source: ABdhPJwy/sFWpTSzSSkV4rUegQazAk7efoLZrxui/23L4zWO2Str/dGKG/z8sT/PBSgrbU/SzwzR7g==
X-Received: by 2002:adf:82f8:: with SMTP id 111mr578870wrc.257.1590666999891;
        Thu, 28 May 2020 04:56:39 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id y37sm6589178wrd.55.2020.05.28.04.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:56:38 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
Date:   Thu, 28 May 2020 13:56:14 +0200
Message-Id: <20200528115616.9949-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528115616.9949-1-huobean@gmail.com>
References: <20200528115616.9949-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For the UFS device, the maximum descriptor size is 255, max_t called in
ufs_get_device_desc() is useless.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aca50ed39844..0f8c7e05df29 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6881,8 +6881,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
-			 QUERY_DESC_MAX_SIZE + 1);
+	buff_len = QUERY_DESC_MAX_SIZE + 1;
 	desc_buf = kmalloc(buff_len, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
-- 
2.17.1

