Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CB1C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649742072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EnuMeIkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgGMIBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgGMIAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EDCC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so12214194wmh.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xgee6VNOxowtnDCzKQ+Sz5+2OlEHHNxO9R7xXG9/C34=;
        b=EnuMeIkLRXbcHAmZyKSMoyDHXFlOUhJEv0EIOT8hrJcFl/4pELjdiQWPho0lPd23Rc
         jkUmAmhdgDgroJ1tQAfHaLUiaiPjjWH0EM1nK/vs8kblYcgOrXcwmezMWKFymkwy49fr
         nrOGwRmAZmwRzm3g92DMV0TLuHmE0WRqbOnig99I+y/pDUR2FDJox74V/4G6mSGcOMLX
         8S9ZQGOY5cBXgdItMs+L3tXdk/xkwckvx4cnMz1ZhmQUd3gYaZw6hfdd5rGLgleYv+0R
         9GdftZnknWdTor0YbOIl6hoDwlC0d/8nrtfxHLbU91EcUDWMpI+V9iLmQArUNNB8Dd4N
         6pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xgee6VNOxowtnDCzKQ+Sz5+2OlEHHNxO9R7xXG9/C34=;
        b=WNTOns3bMXyfDsn2KMGPUWCtRM65HeLiHT2SBmVh2Cw5F9d9Gy81yOxWZd6FBjkdGW
         7MUL9P6EqIZ0WPQ9skbTMCVUHuM/NGfsUVG8pP6CD9b5Rq4a/3Sjj3bHT94O1D4l/Clf
         NLuJ70K0JOKdy4QCd6Z81ECcdpfDSNvQmPPuBjGS8wGvEbN0k1ESgxDB6vJ0XyND4QWo
         iB3Bf6AIYt4KnzUbuAAE/1pXx3xRQvtyCC3/G168Xk6G+XeybM+OSe3UW4N85GxyQr/f
         TVQ5z0ULVwHFiYpzUsYx7h/N46JCMcPUu3wzVHLgZztggIgYtNY5h083N5xGUcLJ/BGL
         B6VQ==
X-Gm-Message-State: AOAM5334q8XTGPoGC72lFTuDsEKsYii3I8ZGSKmUpeB4+pnDzdVJmzhT
        aINv9kveZ4isKFyUNKjsHUSbyA==
X-Google-Smtp-Source: ABdhPJworCLuCDsiBSx9rWrhUHVut6jsWQTo/sIKqpn3toMKqCUhgHxPR+Gg8A9YO/7FbHOfZYdqFA==
X-Received: by 2002:a7b:c4d8:: with SMTP id g24mr16749450wmk.127.1594627213060;
        Mon, 13 Jul 2020 01:00:13 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 05/24] scsi: aacraid: dpcsup: Demote partially documented function header
Date:   Mon, 13 Jul 2020 08:59:42 +0100
Message-Id: <20200713080001.128044-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This should be populated by someone who knows the meaning of all the params.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'isAif' not described in 'aac_intr_normal'
 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'isFastResponse' not described in 'aac_intr_normal'
 drivers/scsi/aacraid/dpcsup.c:272: warning: Function parameter or member 'aif_fib' not described in 'aac_intr_normal'

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/dpcsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 749f8e740ece1..fbe334c59f376 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -258,7 +258,7 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 }
 
 
-/**
+/*
  *	aac_intr_normal	-	Handle command replies
  *	@dev: Device
  *	@index: completion reference
-- 
2.25.1

