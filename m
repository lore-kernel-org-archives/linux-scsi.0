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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEFBC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 09:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8438D64E6B
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 09:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhCEJyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 04:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhCEJxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 04:53:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C22C061574;
        Fri,  5 Mar 2021 01:53:41 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e6so1011331pgk.5;
        Fri, 05 Mar 2021 01:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7FJN1yXD2KjrfWNVdxSrjDvC3rk3uoWzc3xW08We2sw=;
        b=tBZYKNB6GYpMpsryJpUZamtR1miRrhHykgxsJ03o3q6HDO8Rlap9lypSyPP7nin3+C
         ls1DS18EzmG1HF/0e9SAuiY84D5cwx8BHujP6Jr9rKTec9I9NAEHoPiouLu4YCY50z8i
         lvgMCysUSLgbrOBIa4RTeBpWwDQKkc+ehiezCIN4Fyb8vF7Kaq6e17caWdYapp32L4Um
         NkCuKrLtyB0v5I+T96taF5YsHa3kWmTy93kgZA2Z0P7A7WmWCNAyU8ozyaXIy6O4PQ/q
         rQ0BCxHrLVoYfLo4A32gvZ36bMJSl9gGnn4RUcLHuSJheyfrUxH6FlVex/hN1BbpHm/t
         dHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7FJN1yXD2KjrfWNVdxSrjDvC3rk3uoWzc3xW08We2sw=;
        b=Wup1zvpA1Qu8wK1YEKkRVfdM9Og8R3Iyca9h6o9TJ4FsAAS3LQurkRd9drKqKEb+Tx
         z/oPfjujy4Z6ahVG3PMC5R/oQPeY9uURz6qDn3Tw6R+np07bXEizzb+tw9L3AKn641gJ
         FtfGS5ncztppZX73jOg0i0KplTEx2VSAsL1kL+tt6OKUFAzvSMDSpmmgx77m2kqis+mV
         GmblvxptalNbkSkJPr8VBe0d5smC5bWsjTI+HNyqxLXU3FAnZ2VbnUAYaJPDeTDDzkFP
         4Dk0vuwaKZMCiAY7L0OHX+U4MJgn5JlrLVeRUPzC3wCr+F2/ASWcrJnsQI9T3mPt1cWr
         /qJA==
X-Gm-Message-State: AOAM53179iykDzaPUJ0is5MirngdkBKiVkWXnqV897QNgxD2BMezBCTu
        YTOo/iDhXIXtDtJ3Ll54RpM=
X-Google-Smtp-Source: ABdhPJwlSkRDrqWX8SDeiossCefcEuBYXiq47R2L2JXY0eTu0R6EW49NOjOhwEJeEdHD05NwCaMbBA==
X-Received: by 2002:a65:6641:: with SMTP id z1mr7608100pgv.399.1614938021232;
        Fri, 05 Mar 2021 01:53:41 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id c6sm2018154pfc.94.2021.03.05.01.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:53:40 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: ufs: fix error return code of ufshcd_init_clocks()
Date:   Fri,  5 Mar 2021 01:53:32 -0800
Message-Id: <20210305095332.13928-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the list of head is empty, no error return code of
ufshcd_init_clocks() is assigned.
To fix this bug, ret is assigned with -ENOENT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77161750c9fb..6a3e47d8f98f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8273,8 +8273,10 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct list_head *head = &hba->clk_list_head;
 
-	if (list_empty(head))
+	if (list_empty(head)) {
+		ret = -ENOENT;
 		goto out;
+	}
 
 	list_for_each_entry(clki, head, list) {
 		if (!clki->name)
-- 
2.17.1

