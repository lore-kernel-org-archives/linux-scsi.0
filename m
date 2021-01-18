Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6662F22228
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393961AbhARUVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389149AbhARUNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:13:24 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DEFC061574;
        Mon, 18 Jan 2021 12:12:44 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 6so25400151ejz.5;
        Mon, 18 Jan 2021 12:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gH+4Frr0s9M4PbdHZalRxKsdYMgIkqyHipMQ4MN8TGQ=;
        b=n82MKzZYTlqux0ENwULSnC03Od6KoHbR+sFrRCVvhYKTxSRkSEShhohkhJnq6hzBSP
         c9jWG6DbhxziIoY4xVq/xHS/6LC+ZwqXOjKv4r9Do4zvfniGCgO+UfUuvimDRQJ9HMqz
         VG+dn+IcYYWC16L/jtDB+0TQmRon9u7Y5hSDLhhY5Q8PwngG5m2SrAOKaS/ChMTcfiBq
         3kc2MyYdUkdvzEaNQNnkj96P1zVdsquV7hUlmqn5XpSY+vPzPd67ZX7Ax9/JkF09A2Jc
         hkmNe8tAm7oA2CfzEzb45U3R/ISXGUzHRVpAobFuFzy2GauPTV0C725igZEqMQKh2bCA
         mJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gH+4Frr0s9M4PbdHZalRxKsdYMgIkqyHipMQ4MN8TGQ=;
        b=Q+gM+YdvQS/ngAGn7EqPwJOaHBAL0QiOboMxH8cmRLUAqM93I94ZnNM4zS/2+3PwUj
         lUmedCeSV+0txcwuv/uLdHrEtfCr+sM2wxb2ku1UsYUliRbIhOCMQIxVCl3/m80lv4hW
         4TsN+HsSD2O9dUia+FPM2GuYnJDhgjAQJ5b9ij4uOzjgUuBa8s3//IME+PqlNY28syh/
         5gz+wQgSsCpOhdJLI8WwiELFXEhJI80t8H+uyuI/l4gdEaWNkLA9i2E8D2bOAOM7FN1A
         wjCc9seX/JxjObAEaYt7ka0fVh8JwDipMPXXbPjg5AJpmR4673wMBOr1JPxcGXBDw84w
         fOcA==
X-Gm-Message-State: AOAM532nXcgUtOH3lhVpQfoORT8o3ZuEXKOJ7TqpaT79bOJzQzh+gl+e
        6TrivR6m425fdC2ATzyDkXo=
X-Google-Smtp-Source: ABdhPJzmTvtHPN3ZUm421f9+5SSsCeltpdp+mjww6Z2gVgYMWzt5FMLnRRg9EqUg1Ruuva1QwZiaLw==
X-Received: by 2002:a17:906:2e04:: with SMTP id n4mr850802eji.289.1611000763080;
        Mon, 18 Jan 2021 12:12:43 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id bm12sm9992081ejb.117.2021.01.18.12.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:12:42 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: delete redundant if statement in ufshcd_intr()
Date:   Mon, 18 Jan 2021 21:12:33 +0100
Message-Id: <20210118201233.3043-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Once going into while-do loop, intr_status is already true,
this if-statement is redundant, remove it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9b387d6a2a25..5c6ee9394af3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6317,8 +6317,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	while (intr_status && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-		if (intr_status)
-			ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
 		if (enabled_intr_status)
 			retval |= ufshcd_sl_intr(hba, enabled_intr_status);
 
-- 
2.17.1

