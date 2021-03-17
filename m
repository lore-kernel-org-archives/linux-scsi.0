Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D4DC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32DBC64F73
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCQJL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhCQJLh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F14BC061763
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo829872wmq.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PdNAYGEf3HErZd1qMy9Fio2Q6mTHXUXt55dWtvm2uqs=;
        b=KoI4pQgLlCN8e9y0ULjwArxZGVHgE65tgmu+pIBdoAfjkPAL3ETIwM5PA8C8HqEj5i
         OmAmH+Cja8knY9rm+oohq/XjrAyFZ+P1xuNAvAvSKdzq5v+J3O8q0+oj5wxMb1/vtC52
         b7p4uHR6Ba3P7Kg9KGScByrPQh/Hph7zja8aQvLMGzs5ddXwZ2deqKiHCrOGPd/m/6Fp
         KfS1/9KbSe9sH7DaL7l64Vsbx0vsrKX01XDy5vT0eHLLwUPGYI/2wRPHxPehm8RF4l5R
         15LzwLhmvGUw3qQ+FV7JDEJUhJQnfbupA2HA+ivw8zt4lFm83z45Kdw/nrCliL/iMTX2
         6tNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PdNAYGEf3HErZd1qMy9Fio2Q6mTHXUXt55dWtvm2uqs=;
        b=C23d1RaIP61yomueOz3e6V5og2sp01/u0eBvcKq3mek03PxDMA4bq8/TZhpjhssffS
         0wbCkGEP5UqLz5URDjGOEbvU8PyvMalwHrQQxPZIwyqIivxunXB/NaJ39TUgoEcKv2ls
         ndcsSFgnawiCH02EMung3ycQ5dKR4DiFcvFcLJ7niRQQ8OU2K8gRUQcZpYraKG+YmuMR
         GGZ6u8/EwACPfJ7P07yakOAVGG7rCRfjvpW2cI6GXI3fXFN1obffZTO5BBeB7YEp9dm+
         V6sre4KM23W1dsrS3fZjskseUSvLEwutHMl4UAdiIXuYwlfMQYn0unbFd6XXPRNLEqbf
         xA9Q==
X-Gm-Message-State: AOAM531O1t+tqs2AVR3rHXn611e11LlOZYjr8N5n3FAudm0pXj8NyGqa
        Dzv+lDl347nZFE4pqtoOSr2s4Q==
X-Google-Smtp-Source: ABdhPJwKnx+JQa5kLVp55k1jrbwyMuKQk8QBlnUzaKW+0g0lPwZTWljk9O1RUtO4MIuVoV3n8ds4KA==
X-Received: by 2002:a05:600c:3546:: with SMTP id i6mr2682279wmq.104.1615972296229;
        Wed, 17 Mar 2021 02:11:36 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 8/8] scsi: nsp32: Correct expected types in debug print formatting
Date:   Wed, 17 Mar 2021 09:11:25 +0000
Message-Id: <20210317091125.2910058-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/nsp32.c: In function ‘nsp32_setup_sg_table’:
 drivers/scsi/nsp32.c:879:6: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘unsigned int’ [-Wformat=]
 drivers/scsi/nsp32.c:280:69: note: in definition of macro ‘nsp32_msg’
 drivers/scsi/nsp32.c:879:52: note: format string is defined here
 drivers/scsi/nsp32.c: In function ‘nsp32_detect’:
 drivers/scsi/nsp32.c:2719:6: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘int’ [-Wformat=]
 drivers/scsi/nsp32.c:280:69: note: in definition of macro ‘nsp32_msg’
 drivers/scsi/nsp32.c:2719:22: note: format string is defined here
 drivers/scsi/nsp32.c:2719:6: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 6 has type ‘int’ [-Wformat=]
 drivers/scsi/nsp32.c:280:69: note: in definition of macro ‘nsp32_msg’
 drivers/scsi/nsp32.c:2719:28: note: format string is defined here
 drivers/scsi/nsp32.c: In function ‘nsp32_suspend’:
 drivers/scsi/nsp32.c:3267:23: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 6 has type ‘pm_message_t’ {aka ‘struct pm_message’} [-Wformat=]
 drivers/scsi/nsp32.c:280:69: note: in definition of macro ‘nsp32_msg’
 drivers/scsi/nsp32.c:3267:56: note: format string is defined here

Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: gotom@debian.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/nsp32.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 54abda4d07c64..134bbd2d8b667 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -876,7 +876,7 @@ static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 
 			if (le32_to_cpu(sgt[i].len) > 0x10000) {
 				nsp32_msg(KERN_ERR,
-					"can't transfer over 64KB at a time, size=0x%lx", le32_to_cpu(sgt[i].len));
+					"can't transfer over 64KB at a time, size=0x%x", le32_to_cpu(sgt[i].len));
 				return FALSE;
 			}
 			nsp32_dbg(NSP32_DEBUG_SGLIST,
@@ -2716,7 +2716,7 @@ static int nsp32_detect(struct pci_dev *pdev)
 	res = request_region(host->io_port, host->n_io_port, "nsp32");
 	if (res == NULL) {
 		nsp32_msg(KERN_ERR, 
-			  "I/O region 0x%lx+0x%lx is already used",
+			  "I/O region 0x%x+0x%x is already used",
 			  data->BaseAddress, data->NumAddress);
 		goto free_irq;
         }
@@ -3264,7 +3264,8 @@ static int nsp32_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 
-	nsp32_msg(KERN_INFO, "pci-suspend: pdev=0x%p, state=%ld, slot=%s, host=0x%p", pdev, state, pci_name(pdev), host);
+	nsp32_msg(KERN_INFO, "pci-suspend: pdev=0x%p, state.event=%x, slot=%s, host=0x%p",
+		  pdev, state.event, pci_name(pdev), host);
 
 	pci_save_state     (pdev);
 	pci_disable_device (pdev);
-- 
2.27.0

