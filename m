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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542C8C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1842061937
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCVGgD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 02:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCVGfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 02:35:44 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337A3C061574;
        Sun, 21 Mar 2021 23:35:44 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 7so9524850qka.7;
        Sun, 21 Mar 2021 23:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=REf9f2QZB4ikpXS85G3oOY2hv23bhHqlbBZcJtbFjUY=;
        b=LblW35pc5mRJCc1Kxwedx+dZ59esjYuA9WmLibnP09zxtHYtIljM/WGm44OrhjjW2t
         nvv7ysRI0uYT39gepf3nCnE6YrHg6kdwT0PoE+vetUcbS+R3Uq55np/T3xcOJGhgdhXj
         vwETznfJ1CkWA+n8W/EKwyGYWkT4e761318emfiy1wNycqF0cZz/4uCsQfrefXc9WD6b
         TFIAs7guWar8gBBz5TrZTWHGwLmPqPNCbQzmy4qM544ZRFFZvv6QJoRq2ry56H9fVssi
         hg/6zyJI51IdeLC7LhHHpRP4JDADnHv+znkZSlxrPj6mKkMRvig79p5dxHJl/1yUAQ7z
         p3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=REf9f2QZB4ikpXS85G3oOY2hv23bhHqlbBZcJtbFjUY=;
        b=JufHM3czYMBCAdsw1Qghr33X5l46pEWtEoNtrD6FR7aubf4vgTc/ycm/ZFuExL6ZSU
         9HloZ3i6W5f9HL+Uu70d9wpXyhI1Ajd+urOF8AGg2TQvcDNOvsyR/XMtNgpyLMubjCKb
         MxXmP5M6dFVCfMOnQbLgwbU8HbGtHdPdc6w6XFuSAVsy1wTA1jsLi+ypdNfDQ9ZzWQMa
         UAJJO/jPNjbv+xzPbIwN2FWQgEf0JSf6+Pi3hIxd0Tdf/1FF0sXteIvs8WrYJMKZX7jP
         jz5q8COSRLZV/hiAILDBvp4aAxpURIzyqtGD2ZfqydB1FKfFWEUb66qju9LTP1V3AGtV
         x/0Q==
X-Gm-Message-State: AOAM5326t/XiJW6faHSsT+wcZwGpU3mSCHGizEKFfY9ZYfpOe17k28ii
        QFrcQE5u3FKwu9beNKkr7gM=
X-Google-Smtp-Source: ABdhPJwYkq0jsNPcn6ODMpQfQihX19f6PEcXylR080NypOI+Wsw08zOurqLsen2+X0gSAi618XwAPw==
X-Received: by 2002:a37:c13:: with SMTP id 19mr9308630qkm.210.1616394943528;
        Sun, 21 Mar 2021 23:35:43 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id i17sm5091495qtr.33.2021.03.21.23.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:35:42 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: bnx2fc: Fix a typo
Date:   Mon, 22 Mar 2021 12:05:30 +0530
Message-Id: <20210322063530.3588282-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/struture/structure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 16bb6d2f98de..8863a74e6c57 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1796,7 +1796,7 @@ static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba)
 /**
  * bnx2fc_ulp_get_stats - cnic callback to populate FCoE stats
  *
- * @handle:    transport handle pointing to adapter struture
+ * @handle:    transport handle pointing to adapter structure
  */
 static int bnx2fc_ulp_get_stats(void *handle)
 {
--
2.31.0

