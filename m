Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED04C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA49207DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HOjBlIQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgGIRqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbgGIRqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437BDC08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f2so3272353wrp.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pP2tdu8A1HxZVI+uozY0df9nk/Y+k4UvHam72V3AaIk=;
        b=HOjBlIQW3V9/ieSrhgXZ2CuZd05AGRfyL5watxTrh18Od1QoPikv6mwTbjESssycgO
         x89pAqUhtiMUDhC8cAGCD+aYRw17aIKhWv/cvtN/XoQZPfdjHxM2Ob/LhIjLRQeA6nQ6
         LPmvd6zFFxlTH5y3sOAv7OY8eYWM2pzmJ7S6RmPCzL/FNL8l5g178cG5f2yy6RhXkNcb
         /BhzmQgbqlVMhQuC+et0xn4j5vPpMd0+LpaTfr/D+ttZ6OxBxMzQsRNOiHOh9aI1uFQO
         O7K+1TphYfN+lNgseM0qE12H6Aymd88qTmYK7EuLvusxf+PsSCPxYwB8C9qrmt15SeD4
         ImSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pP2tdu8A1HxZVI+uozY0df9nk/Y+k4UvHam72V3AaIk=;
        b=PvqDB5aJFLmMUCllIDVXbK6pQJ4ms2TAy59VhTU7NZGMg6qVA6VAZxX9+Rl7rKczvA
         SEQ1nPWxOeOBfQHSzyocLbdSH+E9tv5MewKv8hKSm27mp65dlcthGUJjlb6lSFMJWBpl
         q07GrfdobwzMZzJPMopNykvmtG0/muyEMl2Ykbmyx6A4IGjQownqb+9YHgN5R2OWzffy
         8/YyfomeqRRX4yCKmUdcULl51+hwoNz9hLcJTClksRkAmibdVKrUPOU4NhHkw+7RepgN
         RxPIoH2BQE8SrM1eQLCIUJspDAfHJHpVF9ZQqwTqTnzYWbOEtAvU1sd5G7OL5pErTLuP
         0jlg==
X-Gm-Message-State: AOAM530xOdGUG13kV8UzvCZfV2uHvp2uKUAfW3XzXyfv7yMj3QplZJQ+
        iSlUs+OT9cZYfAIQy3eVgznsdw==
X-Google-Smtp-Source: ABdhPJzScneAJUqO4lgPookL/z5Oqr9eS06jW1CjZ5o87jZtk4YDFmcwzq5frcqtB9jNumELbK1V0A==
X-Received: by 2002:adf:f203:: with SMTP id p3mr36428391wro.331.1594316763029;
        Thu, 09 Jul 2020 10:46:03 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 04/24] scsi: aacraid: dpcsup: Remove unused variable 'status'
Date:   Thu,  9 Jul 2020 18:45:36 +0100
Message-Id: <20200709174556.7651-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
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

