Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF6CC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8802C20738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nTK6Gzvx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgGGOBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgGGOBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7412C08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:07 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l2so45149520wmf.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+O/0d2wA9ZSFy1o93OfBEO3S/Is3leUo2WVahG+2iA4=;
        b=nTK6GzvxFufmNCuaB/22HJzPW+ctnvIE8XhiHfh2DBolWX8XmkjKWKRNr6mcxfuVz8
         2WFBe65mFhxIVpnvZUmNUjMcVuK2FTAFkp+J3gGwUC4AlolozrT3b/Fbb60/HtruCkDS
         ZFMYuIBgwEfx3BrXjKfO5OG2bHyOu5swAPB9FW8MB2jhMHzER4Ho4vK4bfgYXhLqaoVt
         jMEq9w6X5RaHLgoHJVqa5MNFhySGuagwInfbdzMqtS0MAMRVCSCE9jr1+nW/vN1kcAH3
         A2d47G3UPS0UAasKFBCDbKN1r8wQWyWvO/k/t37a8JY9yAFqotKwsU1CLWNDeGzhIv7P
         W0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+O/0d2wA9ZSFy1o93OfBEO3S/Is3leUo2WVahG+2iA4=;
        b=XqbKzF3ltYp9F2sUYpAZi+ZECyx/Q1YMWZn+3hF5ZHHkfcjT2PoJRzexzNoSA7XhjS
         h2sbADEGuzSzIohn7ZzET59AbxCubHVDq/J/x41pqM8Esbz/AnWF5Q+7NY8AUCAlJk2i
         y8ihpWVJ6WeTN4q4uTphySBPTKedIysvEOyA23V3Z7UQR/0aZSTp+fT/LSN0yDsdn6Ao
         sgUeSNFvZdYkrRBCCIXI9LFVPtRXvEr6ruWQd1zbGa3pf+YqaD4P+gwq5le+hhcaTjFp
         oJMnQ3S5b8BdM4DPoMjTPMAphkWr+hQovWCXRnr+l1A7N1PUnspCH8a8cYo4ESF5xzZt
         JRnQ==
X-Gm-Message-State: AOAM531v4hK4/IUuy+ljEJ5jOwXLTnxwPlI9D79p7hj7S5Ra/XNzeAQH
        ztfJSan5wg8SLOzDQSyqSqaLhA==
X-Google-Smtp-Source: ABdhPJzjM2K9XAyP9w+5m7Z7UU2SGA9mOLFx1eo+L5yKfK4NKKE8aJpkHASyHiSvhRZcJmp0gwpGkg==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4281624wmh.176.1594130466648;
        Tue, 07 Jul 2020 07:01:06 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Juergen E. Fischer" <fischer@norbit.de>
Subject: [PATCH 06/10] scsi: aha152x: Remove unused variable 'ret'
Date:   Tue,  7 Jul 2020 15:00:51 +0100
Message-Id: <20200707140055.2956235-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks to be unused since 2014.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aha152x.c: In function ‘datai_run’:
 drivers/scsi/aha152x.c:2033:9: warning: variable ‘data’ set but not used [-Wunused-but-set-variable]
 2033 | int data;
 | ^~~~

Cc: "Juergen E. Fischer" <fischer@norbit.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aha152x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 90f97df1c42a4..d8e19afa7a140 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2030,8 +2030,7 @@ static void datai_run(struct Scsi_Host *shpnt)
 				    fifodata, GETPORT(FIFOSTAT));
 			SETPORT(DMACNTRL0, ENDMA|_8BIT);
 			while(fifodata>0) {
-				int data;
-				data=GETPORT(DATAPORT);
+				GETPORT(DATAPORT);
 				fifodata--;
 				DATA_LEN++;
 			}
-- 
2.25.1

