Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D9CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388844AbiEFD7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388857AbiEFD7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC16542
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:28 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c9so5544084plh.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=czsypJKtYYOrNNv4cfWap7C6jb0ZrdiKyEtTKEmYg9o=;
        b=Emnr2pCTIXMQ2UusVnAT8e4UK89Y0NMNmMkwmqfiE4fwcxt74y0tB+yCPKk+6AikaE
         W7bv+AY5nYV3SJRnb8IJksrZLaLbQ49r4rTMTbrsPaYoOEoE3aCy/fvlYqhLMBOUmkh5
         Zg9rZesDxUmKceFd2Xm2IIAJEuRu8C8kReefrsN9l95be231Dysbe/KtYhkOptUe3GRI
         gEaHNCZ7zigFW9awpuPbW1LKZgCiM3f5axjCaKFAJdJpvFM9IubXPxDPRr2zN15w5EFa
         eOIofg0UaaxXiCIvpOx8b0GwGDv0HTgA/XCckR2jYJ5AutjtBlZ+H6jxLe70H61ApaI1
         H06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=czsypJKtYYOrNNv4cfWap7C6jb0ZrdiKyEtTKEmYg9o=;
        b=Aqt0X0XWfIRlyF8gdFYS/2Tko+vHsNYR2KkwYBGOY7Q7oXYHmpgvABBb3gxCO6Q4GX
         sEDjhV3zDp/PlwnQW1K9db5U7NfkfvKESbBy6Po7+Pq73UWRUtElz5wAWN1IyQLVfOZJ
         1+RN5Ha3qXIgPSOfPseR1JlEVUAuiq1tpRHrLasaQL/zuWz/C6LN4dORzpqmECgYMXzJ
         TSwYq2Z76JZBMBGifSOun4AUCVspsulZP6LWivs9YtxI3W4tZBDBeXmkdVYIBWd8IzmW
         J50BQVcxgMqOK9UpO8o+X/imCwURlISDlh4tecnW45OZUgC1pgLp477wHh8xEMGli/QA
         SdIQ==
X-Gm-Message-State: AOAM5300d2eKr0KTBpMpTNSEGe11xkrdyfADCMH0Q31UrEc/y+wzd7/S
        4ySF8MY6nHPe5C9CK4u0XpoOSV7/lks=
X-Google-Smtp-Source: ABdhPJxsgqJbbkNK17jaGgEHk4mbuiynZxZyaFPL9CzRKhjWu2qRux4lGX5K5GO1MrAnrk63lnO3DA==
X-Received: by 2002:a17:90a:cc6:b0:1d2:9a04:d29e with SMTP id 6-20020a17090a0cc600b001d29a04d29emr1860565pjt.136.1651809328197;
        Thu, 05 May 2022 20:55:28 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/12] lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
Date:   Thu,  5 May 2022 20:55:08 -0700
Message-Id: <20220506035519.50908-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The prior patch that moved from iocb elements to explicit wqe elements
missed a name change.

Correct __lpfc_sli_release_iocbq_s4() to reference wqe rather than iocb

Fixes: a680a9298e7b ("scsi: lpfc: SLI path split: Refactor lpfc_iocbq")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index aba06794146d..d2900ac8de9d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1373,7 +1373,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
+	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-- 
2.26.2

