Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A25C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9AE207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fi55ZS0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgGUQmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbgGUQmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD31C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so11571972wrh.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IxxdeV7kDOOLuCiwH8B9pnIrWXz+yoC7MHLRIwWlfSE=;
        b=fi55ZS0gMcsGNbPQ7bZEjO0p6noM4W+aMdmDBNrQfs3aO2J9efXsntciRp3e3FVdFV
         /4fJnHUQtkAZllAFG5F44YdU77QwwhEh5oCJ4Go/8eKXiFmuGMPQwrL8vgrszyDmMUn0
         qpIKAXN78PoWGmoIY9Dt8YpLIlVYJXuyC7cewqs/MvhI2QWXv5UXzyokbxUw0EuB4RyO
         T3r2TJwj3km8iigohAT4/mG+nBG7k5MNYA9mIymSTj1Q2h7qFBc3KpwyubuYmDfnPpaP
         geo/oAjmpy76PneUK61DKS5bu7l1/jugTAYUS1jYiWe0b/2S/ALPqRdTbVVIt1rayt4a
         o4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IxxdeV7kDOOLuCiwH8B9pnIrWXz+yoC7MHLRIwWlfSE=;
        b=qC519Iim7pPBWj2q2+GMJsAFSMkMK99ucDd/28RUyepeCyhoWvgoZYirIQewAKAhQ1
         wpSk+zXcKcciw7I/X5M1cr+H9RfsIUGBjjGjL/dKEGvh83ttp+O4N+sjHdZ/n8jAPP+k
         kSGGiZtDFh1wnkYtsLrznG9+51WKw2/M8mySyQzHBTIHGzBMdvZ//XQfMLVggEPekunh
         spUFZTULSwqysMOeUbdB5QkAaC6QI5OJtZLa3L/L/Jsgw9z5ra9PyzD7+NguHoLN5pO7
         U5/bDJUVyEAiVTPmbanovH08Il6XXhxVYWatY1SGTVDLnppzAcSMn4CEiMKBYg8wKmPe
         +LNQ==
X-Gm-Message-State: AOAM532UfM3jCSUNibZ0X8rpWzn4LHSUeXMg3GUlJluudZsfyfatf1xe
        U3EFHvWWUjU+vCQCTGT3v6Nmyg==
X-Google-Smtp-Source: ABdhPJxXhQWmwV5kz3iOwr7rifM1+PJcyTnRtaV9zGgyBJlt1R5JKJDv0hBc7XFZnHKSmNPT1/soHw==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr28344888wrq.189.1595349737054;
        Tue, 21 Jul 2020 09:42:17 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 13/40] scsi: qla4xxx: ql4_init: Check return value of pci_set_mwi()
Date:   Tue, 21 Jul 2020 17:41:21 +0100
Message-Id: <20200721164148.2617584-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pci_set_mwi() has 'warn_unused_result' so the result should be checked.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_init.c: In function ‘qla4xxx_pci_config’:
 drivers/scsi/qla4xxx/ql4_init.c:664:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]

And if 'status' is removed:

 drivers/scsi/qla4xxx/ql4_init.c: In function ‘qla4xxx_pci_config’:
 drivers/scsi/qla4xxx/ql4_init.c:666:2: warning: ignoring return value of ‘pci_set_mwi’, declared with attribute warn_unused_result [-Wunused-result]
 666 | pci_set_mwi(ha->pdev);
 | ^~~~~~~~~~~~~~~~~~~~~

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 82f6e7f3969ec..4afd43610f68f 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -665,6 +665,9 @@ void qla4xxx_pci_config(struct scsi_qla_host *ha)
 
 	pci_set_master(ha->pdev);
 	status = pci_set_mwi(ha->pdev);
+	if (status)
+		ql4_printk(KERN_WARNING, ha, "Failed to set MWI\n");
+
 	/*
 	 * We want to respect framework's setting of PCI configuration space
 	 * command register and also want to make sure that all bits of
-- 
2.25.1

