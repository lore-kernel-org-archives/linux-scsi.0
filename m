Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74892C5AE4A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 19:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbjKOTeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 14:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbjKOTeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 14:34:08 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0B9D53
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:34:02 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cc3bc5df96so371305ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:34:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700076842; x=1700681642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXoxudhApR8SDK00jSoOTCJpyTRuTNK9Kl71C71cvs0=;
        b=wPrZvktkcDaDigMypR/FHdkyjF9wx659Zi41c59oDoMnhsdZ7JkGyzYBL3WLlF8egt
         kpIh0QFPW7Y/4ukukeA9Ig/bukoqIDZc9cQdXePYjsT3NnA7Nx528FSE3Kv6LKGyqkNt
         1ugrTXFAMAQ8kC32Z03X3V1FvieUKX4Tcruv6n5wjch0TzrAS8btaAU06N7lX3/aYmq4
         EgOKPpcVyzLHBfW93D2/VsWpiBYx5FgOO+Ww5UCfjVoaQdJOigvzQRRbaWGZab+1mqxk
         prNfp9Rhaca144fkXw2Ks/G2PbUZZqQEwyJRDEsLTJ1OCkjOs/3vRercKOWN/SCgKcFG
         gjFw==
X-Gm-Message-State: AOJu0YxKdlJtz9i/4GevtGj3czcKfp4Ocxvd10ZECm8OhPL1aAhPr+P4
        VLVIz4noihw4B3QH8lZhNfc=
X-Google-Smtp-Source: AGHT+IHWA45g5ZC2gLpXwxDfl80cKkZNx8cvJjmxk81BwMfpiVg/q88+59HGhpFsQC0qQzOQS1qDIw==
X-Received: by 2002:a17:903:41cc:b0:1cc:e36a:8bb with SMTP id u12-20020a17090341cc00b001cce36a08bbmr8029850ple.25.1700076841950;
        Wed, 15 Nov 2023 11:34:01 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id b5-20020a170903228500b001cc32f46757sm7681800plh.107.2023.11.15.11.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 11:34:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH] scsi: ufs: core: Warn if the request tag is truncated
Date:   Wed, 15 Nov 2023 11:33:47 -0800
Message-ID: <20231115193359.2262044-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_prepare_utp_scsi_cmd_upiu() only uses the lowest eight bits of
lrbp->task_tag. Issue a runtime warning if this results in truncation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 68d7da02944f..21fe4b125081 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2720,6 +2720,8 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 		.command_set_type = UPIU_COMMAND_SET_TYPE_SCSI,
 	};
 
+	WARN_ON_ONCE(ucd_req_ptr->header.task_tag != lrbp->task_tag);
+
 	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
 
 	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
