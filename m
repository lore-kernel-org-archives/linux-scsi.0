Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0A7C43142
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B0B064F44
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCQI6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCQI5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E759C061764
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso2908706wmi.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PdNAYGEf3HErZd1qMy9Fio2Q6mTHXUXt55dWtvm2uqs=;
        b=WEpXnUaFpXspOAzsNexbf8blhw8/xw01ijWzUfXpFPr7UPTnwZ6OxFfKC04ZgjXK0/
         MUaN2LCKoMFfpwP4Pfbx4wfJ5GMJ/hMWrLGt58SC6PwP7AdaCAvSjTZ3uSSw/3vn62AH
         VkewkDjIA6IDYcpbqPVvwXCx8X7UNNA0176HAELpDaVeqQ5ShWuTlCvYrhtiqUpmpzPX
         G+VLGzB6+0rTEKKoNbzUJcdtTsQRjpHbDVceFc4foOfgV8ndulOn0n+ICOjSW/Y31a9K
         9nMWfaa42Ckz4URi2hFdwcxK4k/bEo+vNfM20iwQpGiNxfD3UWFZRjZt+5uIUOObWjgZ
         tYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PdNAYGEf3HErZd1qMy9Fio2Q6mTHXUXt55dWtvm2uqs=;
        b=Iei9zE5mRE/9kGp0e7e3631bbzwdg+0/4QJyNw+inE9Z0YBaS7BMA96j+4TCPIdeYg
         Ty2VK0eMwPlFLt9XFTHZOr5hfT5z7WYQCT1sFpELrxSGxyYD76QGrMSmiks4d3n0Cysb
         gvv4DND/Qa0f9ChmWoOv6T4pAJuuJzavtDNwZKFnM1/VdufdLjjiXI62BYXsns2UpKe5
         IN7jVfv89DIOO+OjuRIMCfxH4VMZkWhi16Cnxnkfz2uW3nUSCcwP/5enjoMYXGOJoIjR
         1H+SWqV3GK3l8UM5FDXf3z/QkUfDo/BiK+Ilv0zRKFJjCZOUpQN5NUR88eEa9/Hg5aPq
         qpXw==
X-Gm-Message-State: AOAM532tcIRau6PkEm1cEfxhSKWXh1Bxy+YY2FJx4mtVLkQWUQ+mm/da
        VH7fEh7lMcLXUTWGVVNUD4HTIQ==
X-Google-Smtp-Source: ABdhPJxllcQNzhNpec6x4Nun9qbZbU27gKPs+/PsHAY9MXuJFcbPBC54Y73ZQVMASMTBdoT731fy4g==
X-Received: by 2002:a1c:7406:: with SMTP id p6mr2600517wmc.103.1615971443185;
        Wed, 17 Mar 2021 01:57:23 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gotom@debian.org, linux-scsi@vger.kernel.org
Subject: [PATCH 18/18] scsi: nsp32: Correct expected types in debug print formatting
Date:   Wed, 17 Mar 2021 08:57:01 +0000
Message-Id: <20210317085701.2891231-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
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

