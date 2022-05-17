Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0ADDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 19:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352717AbiEQT3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 15:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiEQT3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 15:29:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D810506E0;
        Tue, 17 May 2022 12:29:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ch13so36513618ejb.12;
        Tue, 17 May 2022 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=B+OmcYoxMJazhFsfhEsPMTADlWYge2PeB2sgM77GQIs=;
        b=TDqUD0F2+LdOw4vV4ai2pU+/QtEnnn319/DkmwDWVwQywtD1gOwM3JMJllsT/XxabY
         p6O+OEOLNMkSf2XWtb03tOEKAseuwUz3clZ0+0PA4Rf+jKsIjKIzJF/M0cGrQ+TqjmTP
         G+DaAKKdm84CbiNZ0cFQTd9mRoBefNe5Sr8lbrnTt3wqxFBqz7kEW01fZqGaDll14lyX
         loCSTzpwO0m+2ksEDIHX6jHbWtf9kOwj6ev2ERzpzU4ejvhERl0Gm5mBfFaKIOowiSlv
         2t+nNNS+28BrGFS+3HMSl9bscm8Ii9irJjuxjETx/V4lsj3kt3mlQ2zsy8Mo3upW71C/
         V5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B+OmcYoxMJazhFsfhEsPMTADlWYge2PeB2sgM77GQIs=;
        b=NcCSnNsW/WMGgeV8UC0FNVGAfG0qYxjJZko/AqumiTS52+d599asmtJDjtVOFwWUbF
         uzJJp3th6hzGAgGJApaYc5AI2m3FCwgG9ITXARFEiTDxFkNsPXozc5RUiEqk4l3j3Eg5
         R6NTOyZRF0qNm5aBX4XuuF/IAq3I+MUJGW9V7prOgDyLyx/0sAAYXUL3HOh4iQkF/yBy
         UT73GrfOtY9FjEdhHt4kFmlP1siUmnc3pnY66WWZLi0oe6PchhQ60FaUgV7OT1BlX0Dt
         IiZl9FyJ+n1wuNYThRInRPymwkh0OPuoYA9nW8hFde3G2esr/t+TNjAITPNfWd7F49/n
         19Lg==
X-Gm-Message-State: AOAM530hhWcKsVxmfgtD3sG2WWmrnxLGCl+oSuS6Y9ZGajjQVVGaUh3P
        WpWU0w2TfumFNmWaQiUmzWM=
X-Google-Smtp-Source: ABdhPJxb1R8AZGj5TtiOCrCwbpxUFNt4vSbBc414syg88KevVDPTJVBav7WdsWUHadySs6Wb3fMMqQ==
X-Received: by 2002:a17:906:753:b0:6fa:7525:45f7 with SMTP id z19-20020a170906075300b006fa752545f7mr20952520ejb.598.1652815757513;
        Tue, 17 May 2022 12:29:17 -0700 (PDT)
Received: from localhost (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id f3-20020a1709063f4300b006f3ef214e6esm31043ejj.212.2022.05.17.12.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 12:29:17 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: target: tcmu: Avoid holding XArray lock when calling lock_page
Date:   Tue, 17 May 2022 21:29:13 +0200
Message-Id: <20220517192913.21405-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In tcmu_blocks_release, lock_page() is called to prevent a race causing
possible data corruption. Since lock_page() might sleep, calling it
while holding XArray lock is a bug.

To fix the bug switch to XArray normal API by replacing the xas_for_each
with xa_for_each_range. Since normal API does its own handling of
XArray locking, now the xas_lock and xas_unlock around the loop are
obsolete.

While keeping the code short and simple, the switch to normal API slows
down the loop slightly, which is acceptable since tcmu_blocks_release is
not relevant for performance.

Fixes: bb9b9eb0ae2e ("scsi: target: tcmu: Fix possible data corruption")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b1fd06edea59..3deaeecb712e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1661,13 +1661,14 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 				unsigned long last)
 {
-	XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
 	struct page *page;
+	unsigned long dpi;
 	u32 pages_freed = 0;
 
-	xas_lock(&xas);
-	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
-		xas_store(&xas, NULL);
+	first = first * udev->data_pages_per_blk;
+	last = (last + 1) * udev->data_pages_per_blk - 1;
+	xa_for_each_range(&udev->data_pages, dpi, page, first, last) {
+		xa_erase(&udev->data_pages, dpi);
 		/*
 		 * While reaching here there may be page faults occurring on
 		 * the to-be-released pages. A race condition may occur if
@@ -1691,7 +1692,6 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 		__free_page(page);
 		pages_freed++;
 	}
-	xas_unlock(&xas);
 
 	atomic_sub(pages_freed, &global_page_count);
 
-- 
2.12.3

