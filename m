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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AFBC2B9F4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0263361154
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 15:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhFSP7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Jun 2021 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhFSP7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jun 2021 11:59:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F72FC061574
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 08:56:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so9942906pjn.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Jun 2021 08:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1ONzaU53nYSx5RlCsS+G3TwAwpvq/A0t0Q5WYvYy8s=;
        b=rIifRX9HcVcpqG91akHtU7GFxJ4dgqG+NPl4UGelkZffFwn1ShEF3SnDNJBEcrcZ65
         aerRQ8Ts2xWP4uphLKh8eBqT3N2tt8iR7yjGBV4wuzghqt9vBJTmtV9hS559lfk+OqeO
         TbDK+Cd3KeFi36KFk632xV9+3K95d65R0Fg8tj54NWee/XBe6/Q6pymdYk0DaPq9dMtv
         LjxLzv7SoY1a3BRRKCJlhX6mHS9nfXiLPsX9agGPLjW6DORhsF2zLqG8K0aKSUxMkqLJ
         lgXXgzDcWH0HhnJDHphxXB55TFCWOBul7TRgJk9q/6vWm/jnDdEjdFdVxV+ixc+BGUYd
         MTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1ONzaU53nYSx5RlCsS+G3TwAwpvq/A0t0Q5WYvYy8s=;
        b=uG0QxzcTCFdNRPvY+A5CNEWqatuY0twzFTbo0oS8TFWnpFWyWCfxGvmipLTcshAcSJ
         mhSwVAryCd3gWygr5ktt4fGSZbhfYIe/nNDtPLMhPCgbOHk0C2wU3ITWhaUT+8I7vlCZ
         inMLNNXAojEHtxk3ol23GAGMu5HjZC82Cm8nocSGGMv78g3LNrlvBjn4Z/5BuIwZap/N
         uRWUIgL3kQ927HTxkrmmzT7FpvbAiwO7HRlBeGAEBbxOc9uiJ7BA/6eK1kYz/ChgBtCY
         MEXgPpfygUtvy2exLoXjXigwT1L+nU2vPY8WNSB0dBSzQJN0slK3iv1WlkBNC+7MCbBt
         6fFA==
X-Gm-Message-State: AOAM533r15kcVA/PzflOsm62hItXXmNago2m7wZvSu0/VOfKLOH1/cZW
        slqH56mimWIdJ3FQxHIfA14KStPowPo=
X-Google-Smtp-Source: ABdhPJzWkxUrt11KIgeR/GGhjT6l3XskLaVgC8UYXg4Cxjn7cnCaVJpYRCfPqNoAg48KYWZ314bhbA==
X-Received: by 2002:a17:90a:1d0e:: with SMTP id c14mr16336806pjd.171.1624118211892;
        Sat, 19 Jun 2021 08:56:51 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z9sm11240517pfa.2.2021.06.19.08.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 08:56:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     ram.vegesna@broadcom.com, dan.carpenter@oracle.com,
        James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH] elx: libefc_sli: fix anding with zero bit value
Date:   Sat, 19 Jun 2021 08:56:41 -0700
Message-Id: <20210619155641.19942-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

flags value is being set to constant and'd 0 which always results in 0

Remove the assignment line.

Fixes: 1628f5b4976f ("scsi: elx: libefc_sli: Populate and post different WQEs")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index fc24a50c5d6b..6c6c04e1b74d 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -2381,8 +2381,6 @@ sli_xmit_els_rsp64_wqe(struct sli4 *sli, void *buf, struct efc_dma *rsp,
 
 	els->ox_id = cpu_to_le16(params->ox_id);
 
-	els->flags2 |= SLI4_ELS_IOD & SLI4_ELS_REQUEST64_DIR_WRITE;
-
 	els->flags2 |= SLI4_ELS_QOSD;
 
 	els->cmd_type_wqec = SLI4_ELS_REQUEST64_CMD_GEN;
-- 
2.26.2

