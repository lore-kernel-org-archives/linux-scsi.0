Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A51EC433E8
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7422080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qy0EsRHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgGWMY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbgGWMY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:24:56 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E231CC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:55 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f1so4425834wro.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7dnMCO3O7GWoEhpbi22iSF6SZebDl2BeuDMdc7cp9fI=;
        b=Qy0EsRHgGsQAG/Sjohwyb0UEINUjI26GTuGt0maBG/rSohVeuyGgXngFFOxD+uDcc9
         JpUn/jP6ivol2esKfmNSeEMEbPDORThVBi6ZKA2DE1zm/mvjL3MYceytPPf9asN/ZsBt
         md9wB/BQrFkmcZh7pRodZLkBY80Vgl9dvoQCJa/h66Ug+75oTzYeZkPPcfUEirU1YkqR
         KFyGEC59BcksYRSYONQPHiW7dPaiMxEKHSphQ1yymwqvv5CsSGpfy2vBWi9bwncRoZsV
         IzCRABJPY/jfBK0N5GAfoTqF0I+RxdsRuU8uHwucusH1A5f+NUonnZor48KRQE0fDcWq
         A7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7dnMCO3O7GWoEhpbi22iSF6SZebDl2BeuDMdc7cp9fI=;
        b=XaNTbAt1zA2g57YMQIrH172yg3QkZP0EZsVCaMThLgsvMUKQ/AofyI5Y2ifme14Opi
         nHrzXjYU8+DDLV2mtV3oCYwZVcDTEBUW2Ip/59i9pV4sdmdzF1HR96eKUCE/P+XK13mp
         +7FSIVpxa2ioxyfi6d5RV6dwILRMSHSV7U8kcwnbwU5VCMY6Ysy9HmwFrgGIxoJ+HS/D
         072QtipI21OwS9sMf2elU3zS3nUOEMKxyfM1/UdfTPVpUbHym2JCxG99QQtlih0PA3bE
         Y+vXsijm7oKrEELnTWCqRx8wcLjc37tMQsyjtm47zpJ9aym3LZDC0Y8zwjU0/EUrNzt5
         qFag==
X-Gm-Message-State: AOAM533d7lv6nVgIv4EmnZfzLUTq89cY4gU39d6ysRNycfrb5UEYd5ud
        0XKIJcJDksPuuZwcIFzBtu55jg==
X-Google-Smtp-Source: ABdhPJxvJtb9jfW8iP6bc5G3PPp6fA3LbXTfHuuM3/YmpiAPWdEPQQh60ILfJ1qd8H/5g1F7ndgHxw==
X-Received: by 2002:adf:8b1a:: with SMTP id n26mr4102997wra.182.1595507094598;
        Thu, 23 Jul 2020 05:24:54 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:24:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>
Subject: [PATCH 04/40] scsi: bnx2i: bnx2i_init: Fix parameter misnaming in function header
Date:   Thu, 23 Jul 2020 13:24:10 +0100
Message-Id: <20200723122446.1329773-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2i/bnx2i_init.c:83: warning: Function parameter or member 'dev' not described in 'bnx2i_identify_device'
 drivers/scsi/bnx2i/bnx2i_init.c:83: warning: Excess function parameter 'cnic' description in 'bnx2i_identify_device'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2i/bnx2i_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 4ebcda8d95004..6018cdd177022 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -73,7 +73,7 @@ DEFINE_PER_CPU(struct bnx2i_percpu_s, bnx2i_percpu);
 /**
  * bnx2i_identify_device - identifies NetXtreme II device type
  * @hba: 		Adapter structure pointer
- * @cnic:		Corresponding cnic device
+ * @dev:		Corresponding cnic device
  *
  * This function identifies the NX2 device type and sets appropriate
  *	queue mailbox register access method, 5709 requires driver to
-- 
2.25.1

