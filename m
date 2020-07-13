Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC13DC43464
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B810A2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GwaqYyas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgGMIB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgGMIAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E39C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so14775437wrv.9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z87wYd9sTBTgWM4PfTqIXybXjZhO9Ay2HDdpb30MaC4=;
        b=GwaqYyasb4pt/yHI52LPi50jk3NUPP3MzKPLGyyFAYOzsFv5RQ9x9cHPO3DwYBI3iZ
         rDv6pY8Z4eOxcB7/JyisfZmNnZQYVWncbRV+Ru/xxjVCkpUMxdetPt17OHDPELJ71078
         BlO8fuKQkTo1SHBYmslBIioZX3jyFpbDsKdueBT/ifKntd0mrWdIltyv07HO1raOLfDq
         OSAYGR7zAMC9F0C+HVnBqxE6IbCki+yTWuHoA4m5wbeLFcvNRs7Ns3y3q70PQDAkmAiK
         bbGA3YI/pPaXObK2kOrnV8VmBVff4mECwNNTqPhmNAH3oF0+pKnLZ41T0yblQBSmDW2c
         hRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z87wYd9sTBTgWM4PfTqIXybXjZhO9Ay2HDdpb30MaC4=;
        b=jhHAFOQuHtcw0VT4qbkfDp8Fe1XS5slHBRXrARrmLYAn9qRpq6afSVs+TsjcDQd1jF
         ZuNyvNi9Qz3ney0afsjBSrfUg2lhZ3OVJNthtz7QedziYqRdbub5X+eOsjPtZjmdKScy
         /Tf0ACNxcSlP5X3KPRKtqHr5/AMZweVM8wyHsUepKrsIcA7UzS+9hIRiy5o8lLd0GhGE
         HTTKdowaKQ0h2Tc/r6bFi8hAnoLhpItjsQqVu2IS4D3H1cH4s1P6oMBB7y2WLZ+KJUEw
         MkDgxWUENaogRngB7OF0YQC1Es2S3cpDUPeM4lRUQNCjq0V9Pudbr1Mg46yhUyQ6W3BH
         4CDA==
X-Gm-Message-State: AOAM532CD9eZTsDjVDBa+JosYsHujQKrV0DEH7FACG1AfTy6AKNYnXkW
        hvGal6ZCXkVp/vBV0jog7BqBHQ==
X-Google-Smtp-Source: ABdhPJynSOVL/D2X3SU25uKx1ust6+9067RXhrycucU2//FzcNI1aDi48MWlvMNIYiIDzTeBEO6Ppw==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr49585783wrj.14.1594627210957;
        Mon, 13 Jul 2020 01:00:10 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 03/24] scsi: aacraid: dpcsup: Fix logical bug when !DBG
Date:   Mon, 13 Jul 2020 08:59:40 +0100
Message-Id: <20200713080001.128044-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When DBG is not enabled FIB_COUNTER_INCREMENT() results in an
empty statement, leaving the contents of if() and else() empty.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/dpcsup.c: In function ‘aac_response_normal’:
 drivers/scsi/aacraid/dpcsup.c:105:50: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 105 | FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
 | ^
 drivers/scsi/aacraid/dpcsup.c: In function ‘aac_intr_normal’:
 drivers/scsi/aacraid/dpcsup.c:411:30: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 411 | aac_config.AsyncRecved);
 | ^

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/dpcsup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index a557aa629827e..25ebb94368f2c 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -99,10 +99,11 @@ unsigned int aac_response_normal(struct aac_queue * q)
 		}
 		if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) 
 		{
-	        	if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected))
+			if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected)) {
 				FIB_COUNTER_INCREMENT(aac_config.NoResponseRecved);
-			else 
+			} else {
 				FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
+			}
 			/*
 			 *	NOTE:  we cannot touch the fib after this
 			 *	    call, because it may have been deallocated.
@@ -403,12 +404,13 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 			if (hwfib->header.XferState &
 				cpu_to_le32(NoResponseExpected | Async)) {
 				if (hwfib->header.XferState & cpu_to_le32(
-					NoResponseExpected))
+					NoResponseExpected)) {
 					FIB_COUNTER_INCREMENT(
 						aac_config.NoResponseRecved);
-				else
+				} else {
 					FIB_COUNTER_INCREMENT(
 						aac_config.AsyncRecved);
+				}
 				start_callback = 1;
 			} else {
 				unsigned long flagv;
-- 
2.25.1

