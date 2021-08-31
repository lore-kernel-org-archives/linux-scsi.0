Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907E1C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 11:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 789326103E
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 11:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbhHaLmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 07:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241550AbhHaLmC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 07:42:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A49C061575;
        Tue, 31 Aug 2021 04:41:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k24so16361698pgh.8;
        Tue, 31 Aug 2021 04:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNvtjmtuCuwntapmsQE+swG67c7/x654S6z2sqahAYA=;
        b=PHVdWeKNgwNPLB8DS+dRnPhhb/4A0z4Q2dtaagSbnUeWMLP+hDgWE2ux+/oQ0iXvGA
         3enMElRG3YS7nnFqVEcQoerol7Zr5Oq0AdxCf9EyH60cFh+GLdo5r23lErUv4HcDynE0
         auTNy0XEZAto2KiRG7B2+llVhsPnuGaDX+8Io67iCMbo8zni81dcfsfodFxyCNV1LwEe
         XhwIcoldwYQrZ48jbGuOYXwp6amHgW8mIghxo7L/5hdnbClDXRWKDPZMAL1F5zl7MAxc
         KEZ4Nq8Nc0fpm2dV7lYqx4+XE1CJIqsIG2td0A8GEV/gju/ObD19zIWU5X9bQNvBUMWV
         wGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNvtjmtuCuwntapmsQE+swG67c7/x654S6z2sqahAYA=;
        b=DjHBxp3WcTdS69napfMRQsnDzZ1Um91v/+Udek8bmkBnRK2i7D+ijYAclp8UA1BcSb
         nVkuOQQ9gAzMVX3/Mz2+8kmE+RNGVrkLy7Q98tpAhaTMJYUDvzY3ihTmptTfBd4oii+C
         hvty6Ve5AxLWOfeV405RwHQKsVZsXwsrtEEfVk31EzLBqS3vCw725JFKMOY6qjGs6UM1
         oKEzPIhsir3j4OSSCvsSBXmBebdV7YvJCdLfHNLp07g9OBtaW4exGpFMeFImUWpT1Uy7
         1mgspsL9i3UAzTdLxDQa7LQ60NHJUXNK4b3vvrrHZYsdVeHveHa781jd5zt01q/InTCD
         S6WA==
X-Gm-Message-State: AOAM531iducjxMriF3Jtbx3ikpmGNc/RR4n8PznJrkOFb2CBUrzfxUaS
        nnC6XWxLkOHkTVkTCvWoh08=
X-Google-Smtp-Source: ABdhPJyA4VPBuldXgzSK3uuoFFnua8wsqpm+i46UtGqtLqLCqqv5w2mMrbHphi+TSDHpuGFtOpHMnw==
X-Received: by 2002:aa7:8116:0:b029:346:8678:ce26 with SMTP id b22-20020aa781160000b02903468678ce26mr28217223pfi.15.1630410066981;
        Tue, 31 Aug 2021 04:41:06 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j9sm20974895pgl.1.2021.08.31.04.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 04:41:06 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chi Minghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] scsi: lpfc: remove unneeded variable
Date:   Tue, 31 Aug 2021 04:40:58 -0700
Message-Id: <20210831114058.17817-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chi Minghao <chi.minghao@zte.com.cn>

Fix the following coccicheck REVIEW:
./drivers/scsi/lpfc/lpfc_scsi.c:1498:9-12 REVIEW Unneeded variable

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: Chi Minghao <chi.minghao@zte.com.cn>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fde1e874c7a..08a6ad79ceef 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1495,7 +1495,6 @@ static int
 lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		uint8_t *txop, uint8_t *rxop)
 {
-	uint8_t ret = 0;
 
 	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
@@ -1548,7 +1547,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 #endif
 
-- 
2.25.1

