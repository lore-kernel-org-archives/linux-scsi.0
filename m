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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5733EC1B087
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1F9238E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgLGTCg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 14:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLGTCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 14:02:35 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7AEC061794;
        Mon,  7 Dec 2020 11:01:49 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c7so14895509edv.6;
        Mon, 07 Dec 2020 11:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JP1KbsTDJ6+27xjF0RNyzQSeaQ6homnwiR986DQNgmA=;
        b=Mswaq6UwKbX/zLSLRb34hPp0oZzWU08IgRH3ZTZ+Q5p+n8xGpJhQuzlxX6yg62ZQ5d
         7OdCvXIa4pOAzr8PdcEvv3n06pXZarSD0J/pJWUB4TWBrDNCXCIXqZ3xghMQk1N68+62
         O27H90yE28g6vEi5QCUto93ZA7jOsBf0crSux+/xeu9PsUNiWcOn5SLRR0SDX/nzuEri
         Y0Sn/Gnh8QcKVPEpkH8SC0fzW2aUoZLK+9TUHsIk/Zcg8UYCXPIk70uFXnPnqHpIaXFx
         xwR1qew13m77FsvjhXU/8RVKuJw9VsEATsv4XoP5LZjmf15G8ULqFm9MulPI6MU5fy+1
         YX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JP1KbsTDJ6+27xjF0RNyzQSeaQ6homnwiR986DQNgmA=;
        b=K02rGXbnSxjBJWWX+ao+s4/49/ysW4myDFY6Y8sZwvIxgCkCzAzBxitDRM8gDy2bAT
         U0x7ZEVKN4eUigTExaBoo5hKGPXXZhIqBiRt+5YFxmoFP54/6vEe5DCTYTlprpn89JAa
         dtouX0/MmtiqbJV4ODPDExcIQmHr0aUR/rfeTgK14YJ7MhsJvzBx440wM0sjQP171fwP
         EAmi7c3t8R9clecOOBKvWdma7nY3pqv8+LRUVIQdch1oLUm2nVw+GKuOxCigG8bxz/aR
         rZglkkQ2QO8bHb+dmBhiTQc5b0q4d3+toEKpDb3a+YYsE1T4xKZzcgLmp1G9qBRFzV5V
         KSTg==
X-Gm-Message-State: AOAM530ltBf6wu1PABK4ahdh5a+emHobpJk6TXvv7Ak3NV3yukhmBn41
        VrMEsP4Av9MmOu8VI2GtjL8=
X-Google-Smtp-Source: ABdhPJzkKLnZUS5zE+Q3O9GJ78uuMk+jkOh5JBBZZUi8VqfNJB7HIg37bHwjxXwQC+ZNekgrlXNFAA==
X-Received: by 2002:a50:d6d3:: with SMTP id l19mr15786709edj.376.1607367708470;
        Mon, 07 Dec 2020 11:01:48 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id b9sm13479631eju.8.2020.12.07.11.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 11:01:48 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: ufs: Remove an unused macro definition POWER_DESC_MAX_SIZE
Date:   Mon,  7 Dec 2020 20:01:36 +0100
Message-Id: <20201207190137.6858-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207190137.6858-1-huobean@gmail.com>
References: <20201207190137.6858-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

No user uses POWER_DESC_MAX_SIZE, remove it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 311d5f7a024d..527ba5c00097 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -330,7 +330,6 @@ enum {
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
 
-#define POWER_DESC_MAX_SIZE			0x62
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
 
 /* Attribute  bActiveICCLevel parameter bit masks definitions */
-- 
2.17.1

