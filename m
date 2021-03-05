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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9EBC433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD3D64F59
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCEKDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 05:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhCEKDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 05:03:51 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A7AC061574;
        Fri,  5 Mar 2021 02:03:51 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w18so1690288pfu.9;
        Fri, 05 Mar 2021 02:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hVEmTxN1/mqLbJZhppTs1tBr9kKu33Faj7BxFWSzlek=;
        b=N+rGjt01Tn1WTdwZpzph0jO9N5UCT0sCWUKQWqRZy8aQq+5CNTKTLkR8VDduBwgDsL
         6b1FBDK5gYpiyYRHWYVW0KVWT2tNF5sfTeYVcePwclq8nQ7HNVB6adEMkjt4443mE5Eu
         DK3jmf03Ph4vueHWPyo2BspEgINGALJdHE1Zqry6ZIjvfHK1f4D//BKjOwRnc4km3dBJ
         iuyRalT/pj1hvBz23OfTQ6/lYXn7gi+fhEN0EoZhD+VNxKPf2cqzC4QkddJd8X/DTudG
         hobXR+bD3XNEAzNPplqfJPfDfNFMutWuZjcAusf1BF+ZMAW111L5pEo4fzvPV5V6A3Tf
         vGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hVEmTxN1/mqLbJZhppTs1tBr9kKu33Faj7BxFWSzlek=;
        b=uiMAWWx4938bURD96mDQsMvoy/5/6sS3J7opi+2LHhCSxnsOzDsjFoZYSmirwKEiKc
         1gip9VkFzNptbBNHUOvMCQ0+C198qW7CRKSkoYogwxmgupLmb5DU8ac2fUbcSmpjpTso
         94j6GpN+brie2e38f2LTqTPgFLn1Nz3fgDL/yD3E0WqF2YTEDZ33JrZoJNu2Z3/9Avcl
         qBPzoKp4pAyMaZfFUacmSUc6ZcSk1elwm3LgSO6QdWtP4REudSaeqXXfrAeGbrSShqvw
         KlcpAbem9rlaTbQZMlnNIhT3RcO2xMfmSs7uKRbqz6wACu/j2X2T489mjI039ehHxwsQ
         TL1Q==
X-Gm-Message-State: AOAM533VJiFaHuSVKtV+9iDCzCVrLTcLC9jU/0IylzCo7L7p2IjM4D8b
        eiodndFay7XdvMmp5qoRl+A+nqJoR0O36j+J
X-Google-Smtp-Source: ABdhPJzo/tq44YXAVV3Je4T7SeOQMl6BhPMjup2b758SP37zBidxhkOyoG4VHDde242grVWAJL7CXg==
X-Received: by 2002:a63:ce15:: with SMTP id y21mr7886969pgf.4.1614938631331;
        Fri, 05 Mar 2021 02:03:51 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id e1sm1829137pjm.12.2021.03.05.02.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:03:50 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: ufs: fix error return code of ufshcd_set_clk_freq()
Date:   Fri,  5 Mar 2021 02:03:43 -0800
Message-Id: <20210305100343.14304-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the list of head is empty, no error return code of
ufshcd_set_clk_freq() is assigned.
To fix this bug, ret is assigned with -ENOENT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77161750c9fb..79899acb3ef6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -970,8 +970,10 @@ static int ufshcd_set_clk_freq(struct ufs_hba *hba, bool scale_up)
 	struct ufs_clk_info *clki;
 	struct list_head *head = &hba->clk_list_head;
 
-	if (list_empty(head))
+	if (list_empty(head)) {
+		ret = -ENOENT;
 		goto out;
+	}
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
-- 
2.17.1

