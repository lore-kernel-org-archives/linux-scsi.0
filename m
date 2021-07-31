Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46F1C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE72960F35
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhGaHok (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Jul 2021 03:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGaHoj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jul 2021 03:44:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216B9C06175F;
        Sat, 31 Jul 2021 00:44:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t21so13753144plr.13;
        Sat, 31 Jul 2021 00:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OVTr4RHlnafMTThe6BOdvnTER0K+cVoQjOpy5dSFrGo=;
        b=RQ/v4gffX8Bzi6BWq4kPLZoQ4cY9tqm+UMcgr/rN2k7UYSgtb5AM9Kz4XHckTyajn1
         Yptrm4jgZte5O3h6tLp/pwpX4nsqnO5VO4dxuAXVfZmH1RA2e/IJm8L0Ydk/QdaVsNmb
         v2Z+h3HpNuy6HZrS5oXunddRlirl1Xrzq9NV98sgdvWeH+VZBf9df1eLP6pAyvC7F9v9
         Y+oKqhUvXnZl7W9K3sstsZteJNQSoMQInAqOueLjjxS5cGi2zxyOSBxCcbEFQKccfLBY
         nhy9X7ceEK/k3PbRRkm9Ey/KCT1/EkbycxOpzcpScg4nhw6ZdkVzqFFxMUroO631MJ54
         jqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OVTr4RHlnafMTThe6BOdvnTER0K+cVoQjOpy5dSFrGo=;
        b=EhFP+6qM+LE8jv4hVDSfSAmxxu2g1w8/pXoWgghKIAM0ERY0Dsd1oxgbAaN3fZlkL/
         cIyPC/9WBEwkfaH8syxz+EAh2lYWXuYr6gKC173UW8iRvk8e0l4Q0RQKeK/vLNFMQJ+6
         V0xkdxzwfmCb6AFGX3yJJ6ZRQtlnR1P6wX4xnRzM4sxz91RkGhokh97NSUSGshYCDI61
         wSGHW74hrG1PX+OKmpbq53ibAExFgtfOcwvi5gOswMt/Tr56ZSUPmDqq5n2Y7XNxoB6Y
         Ss0LMaACtEi3I6BDhSaapd5vQXuvsbyVOWaIPhWAbxsWp3KnP90kO6fn8tZKFEqV1Idc
         ms9Q==
X-Gm-Message-State: AOAM530fZbVtnU7T0w66NqfAqYoZ8vc5Af0H8f/yIoZaw5cOiomGEfxg
        rz7mzZDPPZj+eALZ0MfI6Yg=
X-Google-Smtp-Source: ABdhPJyYUyIqlICz+hWa2rP9J8+e4Lb4rL9Q7x6cMrvn18Av3AkzQHiDMt+u8FQDZp58+zRgTeITaA==
X-Received: by 2002:a17:902:e851:b029:12c:9284:8c2b with SMTP id t17-20020a170902e851b029012c92848c2bmr5317703plg.57.1627717473700;
        Sat, 31 Jul 2021 00:44:33 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id j25sm4635720pfe.198.2021.07.31.00.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 00:44:33 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] megaraid: fix possible uninitialized-variable access in megadev_ioctl()
Date:   Sat, 31 Jul 2021 00:44:10 -0700
Message-Id: <20210731074410.71376-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable pthru_dma_hndl is not initialized at the beginning of the
function megadev_ioctl(). It remains uninitialized if the variable
uioc.xferlen is zero at line 3275. However, it is accessed at line 3311:
  mc.xferaddr = (u32)data_dma_hndl;

To fix this possible bug, pthru_dma_hndl is initialized to zero at the
beginning of the function megadev_ioctl().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 56910e94dbf2..8b0676b862fb 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2975,7 +2975,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	mega_passthru	*pthru;		/* copy user passthru here */
 	dma_addr_t	pthru_dma_hndl;
 	void		*data = NULL;	/* data to be transferred */
-	dma_addr_t	data_dma_hndl;	/* dma handle for data xfer area */
+	dma_addr_t	data_dma_hndl = 0;	/* dma handle for data xfer area */
 	megacmd_t	mc;
 #if MEGA_HAVE_STATS
 	megastat_t	__user *ustats = NULL;
-- 
2.25.1

