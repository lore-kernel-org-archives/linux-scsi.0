Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946B4C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F33F64F42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCQJNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCQJMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA12C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e9so995693wrw.10
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+02nW2PCCLBAyTUDbzKGlxZllc8oSt5ULWtL7I/vEo0=;
        b=cTTi5LmX6VahXgRKVRGD5W5vktQwvHyWromSFIZbDUbKKC8WcwJWRsZgTD5g1y8QgJ
         mxWgu7mmNQfduLkX/GOYaAHoxej51MY/Aczry9GcFTeXZULPPhxSvO7YY/v2D2G/PHsv
         ZHsMEu3Jm1pvSndWEPqCZ+FXPSKAjQrVeAsPfEaYpqJAkmDP4ysx2tPy4zewHxTwXUXb
         bFfCRbOpDYS5GeXSqU7JlzAnx2I58ZhOKmxGxzoX27ADuuZPTKHpBB6IVGjiEZZwNw3N
         OfoG4z4sAmw28Wnz+xSx8TCngOS8RSPeyWgHMR9ka9FKYDfWOzS2RZbxlBuQ5mF3BeX3
         5bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+02nW2PCCLBAyTUDbzKGlxZllc8oSt5ULWtL7I/vEo0=;
        b=Wds+9RBN0LqxRBrBPIxBNwLjKKZRtWHj8CTVPI+kCYsT4nqZ7Gms7EVpozSH4i3GCZ
         IR33KsSD8cbrLsuzmFHzZSTNAtzb2QVblSSXCZim7pVkLrrqvV1px1lMHGBJJkMzBcfr
         s1kwfKBWcNT2Srbvmk8Ef5UFWjpnhciW0jBuX/PNti83adVsSObZS4gvvaSNyjtrk4QU
         cRkNTPcuTofn/jI1gQKru+5yGYAv/PcOkzokzSgPqswAItHJ9zMOt+oquHWw7Z/ObJXu
         QR38jbIzxlMZlE7f1lmdI02jNucQLXPPCkGZjYn2QS+hXza2PaLKe5RajD/Y33hqJeh8
         L3tw==
X-Gm-Message-State: AOAM532yjMCyOZp/HpIMOn63A+P8adr9Hhlh2FwPjhG6Iwurs6gHdprz
        zHxK0C34YJZYEyTNyHT4u/iJng==
X-Google-Smtp-Source: ABdhPJyU45kX2/PlxruLrGXwhwH6nAexQ69XI7I/JBevUAPcSR1P/Jpqui2zWNpkzg0+WIwHOR1tLA==
X-Received: by 2002:adf:b30f:: with SMTP id j15mr3359420wrd.132.1615972362691;
        Wed, 17 Mar 2021 02:12:42 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:42 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marvell <jyli@marvell.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 03/36] scsi: mvumi: Fix formatting and doc-rot issues
Date:   Wed, 17 Mar 2021 09:11:57 +0000
Message-Id: <20210317091230.2912389-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mvumi.c:191: warning: Function parameter or member 'sg_count' not described in 'mvumi_make_sgl'
 drivers/scsi/mvumi.c:1301: warning: Function parameter or member 'ob_frame' not described in 'mvumi_complete_cmd'
 drivers/scsi/mvumi.c:2084: warning: Function parameter or member 'shost' not described in 'mvumi_queue_command'
 drivers/scsi/mvumi.c:2084: warning: Excess function parameter 'done' description in 'mvumi_queue_command'

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Marvell <jyli@marvell.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mvumi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 71b6a1f834cd7..f41982a4b3abd 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -182,7 +182,7 @@ static void mvumi_release_mem_resource(struct mvumi_hba *mhba)
  * @mhba:		Adapter soft state
  * @scmd:		SCSI command from the mid-layer
  * @sgl_p:		SGL to be filled in
- * @sg_count		return the number of SG elements
+ * @sg_count:		return the number of SG elements
  *
  * If successful, this function returns 0. otherwise, it returns -1.
  */
@@ -1295,6 +1295,7 @@ static unsigned char mvumi_start(struct mvumi_hba *mhba)
  * mvumi_complete_cmd -	Completes a command
  * @mhba:			Adapter soft state
  * @cmd:			Command to be completed
+ * @ob_frame:			Command response
  */
 static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 					struct mvumi_rsp_frame *ob_frame)
@@ -2076,8 +2077,8 @@ static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
 
 /**
  * mvumi_queue_command -	Queue entry point
+ * @shost:			Scsi host to queue command on
  * @scmd:			SCSI command to be queued
- * @done:			Callback entry point
  */
 static int mvumi_queue_command(struct Scsi_Host *shost,
 					struct scsi_cmnd *scmd)
-- 
2.27.0

