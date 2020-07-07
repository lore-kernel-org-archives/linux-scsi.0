Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9EAC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC652075B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dBcHaJgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgGGOBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGOBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:01 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355AEC061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:01 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so46585551wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLWYFu8kb1BK0vYr47DoG19cZZy4irme69VcrjTwQ6E=;
        b=dBcHaJgD24aprqBmfheHZZJ/02Un4ePwTgSuWV0qJltGAhKjZJ+jax2Rsz4WQvNMtl
         H3tshEqaE10oB9P9UPfJ+0JHokUGzwrnD/TWTdFkDhSdm/UCYiNJ755SDJi1rbvyWqtg
         zk+K/Qb6/6K5QO+pBmYAMjCKVyUFD2o2NLTCmKg3oiU0g58EMzJ4wCB8Rhj8SaeLGS4k
         csnB4Y7CWjhJy/Dgu5RYFaQOaw6Zmz/17F8Ynx5A//PAdRG7t3u2KZ2VTxynKul48+rl
         TPIHaQhDL1AeiEMRzucUS8l4+Xr60IOFu214FcMPh3XBa1ZAr6Tcc+BuJCuZqJ0Q27i8
         s+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLWYFu8kb1BK0vYr47DoG19cZZy4irme69VcrjTwQ6E=;
        b=HpM5WC1RCXv/FwvX0mDyjqyxTaR4Hj4EW6HJuFMQ/baGP4E9TeuXQpH1Zjwsinli0T
         Aqu10BYTw2joYk0cPh+IQTbtbuAgxnv/LWeU2zywMQk3UJj1i/2YilqPWTkLm1ic2H4R
         z/NG0nBnijFWwL/ZGqko0+DPQGZb/MFNwTKu9MsfgODTSzzS1/kcmus+/cKkWRu3HO/l
         aCTXBHkXgQYZTpZJVYcr+jBz3EfNgAznjHlmkWG4PdxFzehbkbT056rhlYHlx2pLlbLN
         QuK6niXPPVCdhOXvZKaroymy1IEYt8OY7waFKlo08quUvY3U4wgDj/pKVe9Mhq+U7cAa
         oPzw==
X-Gm-Message-State: AOAM533+09TySn/UH7U5aU/szkNtmsSKRtwjlzFLtRqqh0CoLjSwuKAR
        vsVrBS5+o/CTV98wyUpY+jsJIw==
X-Google-Smtp-Source: ABdhPJzFeqLsqMW/HY0+6KXgycLe3ZNW1nII6mHUP330UVnEIVjP/xD19B92OtkG/G51zwQoFxazfg==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4280907wmh.176.1594130459913;
        Tue, 07 Jul 2020 07:00:59 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:00:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 01/10] scsi: megaraid: megaraid_mm: Strip excess function param description
Date:   Tue,  7 Jul 2020 15:00:46 +0100
Message-Id: <20200707140055.2956235-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_mm.c:105: warning: Excess function parameter 'inode' description in 'mraid_mm_ioctl'

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_mm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index e83163c668845..8df53446641ac 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -95,7 +95,6 @@ mraid_mm_open(struct inode *inode, struct file *filep)
 
 /**
  * mraid_mm_ioctl - module entry-point for ioctls
- * @inode	: inode (ignored)
  * @filep	: file operations pointer (ignored)
  * @cmd		: ioctl command
  * @arg		: user ioctl packet
-- 
2.25.1

