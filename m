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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C87C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37D664F6E
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhCEKIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 05:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhCEKIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 05:08:19 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC43C061574;
        Fri,  5 Mar 2021 02:08:19 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n10so1031313pgl.10;
        Fri, 05 Mar 2021 02:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FaAijpHPImNv0WD5I90hcG5zei5rslAfFjyFTmWsex0=;
        b=VBmc0tfANQgzpVv05QM+6UYYd8SeCk5aJBZ4A/6123VzWZX0ul2hiNd8E4/wvYUI3u
         0WuD+IxtkcDBySqwPg6BXL1jZC0nOpvrsrOwM2Qr7LZQmy1ky0LQrz00R7hL8zE2CR3A
         PqWifwgEnIrxE+CS8v2n3hsziRd1rxL9Aiwll4PcxOEts76DJTDy9uZB86A8qV/BFi7q
         TPy1UuY1ElxOh3YJBwlKagKVwVJAPWBSzvmMlzYorqieAHgfOh51qoCVAWhLybDDNaWO
         AqzqM1JfmZuC/XTNCsmupetGaX+hvAirKsbVrHSjjOZQ8SxdGiXs0TrOpSN7UAbVPtB0
         d9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FaAijpHPImNv0WD5I90hcG5zei5rslAfFjyFTmWsex0=;
        b=Ko7027NjlbHzNEW0rhdkKWJxLYKT3e+v9+GaoHqtPb8o3Wv+fV5Ktp/4h1V5BKeN2X
         yBcjjgZV3bJBBDzP59FYQsDNAIufHOnqSXJ8Go2SZNLS8nLwfCiNqlxBOKl2l/7XPs+2
         cW84Zag5KGOxQEQHBmjXXjRSII68dkmCFwIl8jppB+fyu9U+Gf54zPOV+ZcFa4h9T5Xm
         FO07yx+ue4TQtrtdHBt3dMnutUCW48abtqae2RB/NoFww0JvjPlRFZFY4A/kj15wa6vA
         ja/Vr5NY9usIpIetfrntgVeM4ud1F/hZw4Yh5kq7yvVU+y/NnMwMXFZhnP3TVkeLg+Xe
         FgCw==
X-Gm-Message-State: AOAM532EKefZJf0W/vkVgDO+NOC29pTzp2+I4bBJWw03sSBQJ58HfCKq
        WqJtsmnBuPtmyxVs1aPVbx0=
X-Google-Smtp-Source: ABdhPJx4UlLJ5AkOXamjUfQze5idZeGQHUqNnDBvGz228s1sf28UxFaM8BMWlmt+bJrtYUny4pu7pQ==
X-Received: by 2002:a63:170e:: with SMTP id x14mr7847290pgl.245.1614938899393;
        Fri, 05 Mar 2021 02:08:19 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id t17sm2134571pgk.25.2021.03.05.02.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:08:18 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, krzk@kernel.org, kwmad.kim@samsung.com,
        beanhuo@micron.com, weiyongjun1@huawei.com,
        stanley.chu@mediatek.com
Cc:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: ufs: fix error return code of exynos_ufs_get_clk_info()
Date:   Fri,  5 Mar 2021 02:07:59 -0800
Message-Id: <20210305100759.14500-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the list of head is empty, no error return code of
exynos_ufs_get_clk_info() is assigned.
To fix this bug, ret is assigned with -ENOENT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 267943a13a94..d67652e5cc34 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -264,8 +264,10 @@ static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
 	u8 div = 0;
 	int ret = 0;
 
-	if (list_empty(head))
+	if (list_empty(head)) {
+		ret = -ENOENT;
 		goto out;
+	}
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR(clki->clk)) {
-- 
2.17.1

