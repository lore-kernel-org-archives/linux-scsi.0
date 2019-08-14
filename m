Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E73CC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DD3420866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lez4ppzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfHNX5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43353 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfHNX5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so323011pfn.10
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mie60L+b4afBh/5RX1HitGuekoiiLHSbWEtWxkCgOrg=;
        b=Lez4ppzu2sOKJtx/mVRgawCsPYOsm1yQIrNOMNrBL/VR9RYjk8jZlEYatrHk5P7gm0
         N4Fy49TOVZTmWs3m8P1dO8TiqJLq13lV9homghTSfeibUaQOAK7BBX9IHpQoyf0mmhb2
         IcxRTQDUHKOMR65W9S5Tb+2b0cg0pQJm7KZuq/ZQfzgWm3cfQTkG5KhctwjSnkxGpfYR
         LT4DrLCgBQybri9FwidLPoGh84WfE6osEOJiNaTSPRofe5TY3bdCJGVXiK1IAFyMEaF9
         zwJqy6erecWthk88JJjVzFJiReJgD54guuZvoz9wHusCN15570qS7EX1xw36qHs0r3an
         XJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mie60L+b4afBh/5RX1HitGuekoiiLHSbWEtWxkCgOrg=;
        b=i0t3w3IoYKJE7I2/bz3tfn9RBgy7XqQ/27BkgPRJMs5kxvl9bayQ8W9agZyvTk8G68
         v5cKH58gQgDpfMcUTA6UHKZAIC1B08LhNxnR/nj0ogOyROYE/Odbb6PC7w9eWG1ubXGJ
         hlNuWupShd1gKwWd8X79hxac3ZLZTGXP4jBm0CSxU+uy+rKMuby2aD0d2BHe4kIw9Vpq
         0MuWt3lKDT5MpafuFvGwsfIl3t5AeAnuB6FpRkEiqI/lATiR00QRkNMtWn4sZvEzUYmI
         yO8r/Oj4CCLW2dvaD2XlFWCA5rpuJH84HHRdAv8089qiJ5f/vZbIYNa0cIsjmB+pbQpa
         iojQ==
X-Gm-Message-State: APjAAAWuzghUIZ4Tt9lcsu7m2HumiXigknPgGD25BNmJYxzDF0z/xayN
        yrINkJSLPJlfU4u5+qqkWglUrwgZ
X-Google-Smtp-Source: APXvYqz0sHdHM2d5E5QmKEQuLB+Ud2SRBX5od/xQ8Mn1dqoBmXdXsCrGqNVlQUvKjMCPONRaL4//8w==
X-Received: by 2002:a17:90a:d151:: with SMTP id t17mr438496pjw.60.1565827051581;
        Wed, 14 Aug 2019 16:57:31 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/42] lpfc: Fix irq raising in lpfc_sli_hba_down
Date:   Wed, 14 Aug 2019 16:56:42 -0700
Message-Id: <20190814235712.4487-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The adapter reset path (lpfc_sli_hba_down) is taking/releasing a
lock with irq. But, the path is already under the hbalock which
raised irq so it's unnecessary.

Convert to simple lock/unlock.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3e128ea01dc0..52704e709925 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10808,9 +10808,9 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 			pring = qp->pring;
 			if (!pring)
 				continue;
-			spin_lock_irq(&pring->ring_lock);
+			spin_lock(&pring->ring_lock);
 			list_splice_init(&pring->txq, &completions);
-			spin_unlock_irq(&pring->ring_lock);
+			spin_unlock(&pring->ring_lock);
 			if (pring == phba->sli4_hba.els_wq->pring) {
 				pring->flag |= LPFC_DEFERRED_RING_EVENT;
 				/* Set the lpfc data pending flag */
-- 
2.13.7

