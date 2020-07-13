Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CF1C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173D720758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T25D/GMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgGMIB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbgGMIAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:13 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E28C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:13 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so12195030wmo.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pP2tdu8A1HxZVI+uozY0df9nk/Y+k4UvHam72V3AaIk=;
        b=T25D/GMsB39AVB8zaj0fkfFfLQfl94lJWTgRAgINBwXbZiUobiHylWdAWUPQs8NY8N
         EShGivuuRwzNISqkHq72H232buFA86x7FJbnJwaBY15gfAPUL9UmQgoVLaRWeV0N27Fh
         +GE98AadqTYNvYOzxbqDTVnZqtPEcog70oO07lMstzCPA9yfer7jlkjtB+Gpn3kRNYQe
         43wEbibn9ETIws2gFpdqQWVHRJhhHOOcPAp6WhvN2j00IPhBzcrj7eVDtaT1oiSdyv+L
         4FgUomueMl9EFtSuf+TxU4tHwzXC9EuaSG8scl6nFLRD1A0506fnEkI30SFinOJd30Av
         p2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pP2tdu8A1HxZVI+uozY0df9nk/Y+k4UvHam72V3AaIk=;
        b=s8AuNe9ROiGvBCuVGa8/6k+iSqUbah/ZRCMWohUAPBHdY0Udjn/T8v3dDQMP7vA6iF
         1eIeel05pAMoz4rqzhmzwwkDGmCCrNX9HIs86GVEQaaDQ9gXYzVvLlSLibi2TKmXtfDW
         14eySlis2ZAPGH6GDi6yWbbsECKP4e+A+rtdS0u9rVlvtc8utI5RmtpL7TkKfA8yna4f
         wgJcK/ptdBrn9H8M2chWZSDQosl2XYe2JGN3kA/SEZHTLoGQ6sMWB50YgDd18+l+RJBI
         /y0yOPySiA4RcSF+qpMds6GQws67Hm6Ko3mjTluFUfjai3d222mer65DzAadX8D5oN4W
         YT3g==
X-Gm-Message-State: AOAM531K3NIWrpTItkipp9fHqgNcD/EMSp2HhAUTUuwvbSzKS4sDQPrU
        +5W5tfOp+lcD1wvpaagoDHI4gQ==
X-Google-Smtp-Source: ABdhPJwbYSCcZOO51jq37iaczvD9Q+QdxeBeGKK9d1pd9ae9EwI3EogsrpqZBIGpovgyMaYtLZ1dlw==
X-Received: by 2002:a1c:a70d:: with SMTP id q13mr18717862wme.55.1594627211989;
        Mon, 13 Jul 2020 01:00:11 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 04/24] scsi: aacraid: dpcsup: Remove unused variable 'status'
Date:   Mon, 13 Jul 2020 08:59:41 +0100
Message-Id: <20200713080001.128044-5-lee.jones@linaro.org>
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

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/dpcsup.c: In function ‘aac_aif_callback’:
 drivers/scsi/aacraid/dpcsup.c:232:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
 232 | int status;
 | ^~~~~~

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/dpcsup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 25ebb94368f2c..749f8e740ece1 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -230,7 +230,6 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 	struct fib *fibctx;
 	struct aac_dev *dev;
 	struct aac_aifcmd *cmd;
-	int status;
 
 	fibctx = (struct fib *)context;
 	BUG_ON(fibptr == NULL);
@@ -250,7 +249,7 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 	cmd = (struct aac_aifcmd *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(AifReqEvent);
 
-	status = aac_fib_send(AifRequest,
+	aac_fib_send(AifRequest,
 		fibctx,
 		sizeof(struct hw_fib)-sizeof(struct aac_fibhdr),
 		FsaNormal,
-- 
2.25.1

