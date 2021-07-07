Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910A3C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8197B61CCC
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhGGSqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhGGSqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:37 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE78C061762
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:43:56 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so1038833plf.12
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D6XRAuY/qlTjtwcXcEbweRU62gteERcsO/R3U9yidbo=;
        b=RWa7w5lmK5ToHOWKHaEWYNqyo/9RPV9ulEnMWys+M+KvTrBoSm7GcLtPlzdnw7GqeA
         5I3BveyWVZlgSqhSbHATU1D3oNh0v3RSvsiPpGIl+q47fAUrvbDh6KtChD/dXC/pf3kJ
         vWLN7Wjjc25PWBLApunC7F2gGxdTqEzeM+ll5jUdST+gh5ZtJnMEK3pGqBjcuDTn0zIr
         OUSobYTcDLsXnlQodgqF2kO2T/achUirzjo9NQyMiUaTJZFtgSCtW6J06f27J7cBC/FB
         aHi/StPUeXy5e4qS2sWwf90iuRvEKRtDOvFAtdylN6RaiYleYs1eLzuk9HYVnXVB7AHx
         z2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D6XRAuY/qlTjtwcXcEbweRU62gteERcsO/R3U9yidbo=;
        b=kiHQlekxMZZdIm+o595rLopIKsvUNQ178KvFov0TYM17/4nI1SdyBu8bA4SmzeWpbd
         FSGmp8ue9kz1RHxn6wEoO2yq5Bb6KN9PfdMOI3bJAPgil70qmY0FJyK77NmxxlLvCUK/
         tCt4t5q/uP8MZsUW+gBqbQRW4F4FCgvMtKaAR+aLnTFlj8Xx9oE1dN3rjGAjjg4zMx4u
         P/QbHjpz/2IoHfxEvxJmfELqwn2XOeeV8l74LhyYd0oZYzZqIgzWu8gBhPyXVs66Dgaf
         ZpR5pbZTUrMrnCUwxYm6gWXD/YBlHZY+V/S1T1H774O7tvtfZkTcS9ze9RbSfBOrK0Cs
         9lvg==
X-Gm-Message-State: AOAM532ANfQ6K7EkCz3lXfYBYmouBg/pDHseV3k1gMjhqkV1eNQ3tbe0
        DBnMMal9BufHCDa5W7r+bFf7UWwZU8o=
X-Google-Smtp-Source: ABdhPJxG/D5kGpe6XOI8/h1X8GUQOl1+VD8wxcbxIE/FsUB3uApUEbTfxTJVr5G649WoVm3vTSALhQ==
X-Received: by 2002:a17:902:8d92:b029:113:91e7:89d6 with SMTP id v18-20020a1709028d92b029011391e789d6mr22514127plo.85.1625683436064;
        Wed, 07 Jul 2021 11:43:56 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:43:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/20] lpfc: Fix NVME support reporting in log message
Date:   Wed,  7 Jul 2021 11:43:32 -0700
Message-Id: <20210707184351.67872-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NVME support indicator in log message 6422 is displaying a field
that was initialized but never set to indicate NVME support.  Remove
obsolete nvme_support element from the lpfc_hba structure and change
log message to display NVME support status as reported in SLI4 Config
Parameters mailbox command.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      | 1 -
 drivers/scsi/lpfc/lpfc_init.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 17028861234b..dd3ddfa5f761 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -922,7 +922,6 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 	uint8_t  fcp_embed_io;
-	uint8_t  nvme_support;	/* Firmware supports NVME */
 	uint8_t  nvmet_support;	/* driver supports NVMET */
 #define LPFC_NVMET_MAX_PORTS	32
 	uint8_t  mds_diags_support;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f3032e30c3e4..cf5bfd27058a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12241,7 +12241,6 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 					bf_get(cfg_xib, mbx_sli4_parameters),
 					phba->cfg_enable_fc4_type);
 fcponly:
-			phba->nvme_support = 0;
 			phba->nvmet_support = 0;
 			phba->cfg_nvmet_mrq = 0;
 			phba->cfg_nvme_seg_cnt = 0;
@@ -12299,7 +12298,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 			"6422 XIB %d PBDE %d: FCP %d NVME %d %d %d\n",
 			bf_get(cfg_xib, mbx_sli4_parameters),
 			phba->cfg_enable_pbde,
-			phba->fcp_embed_io, phba->nvme_support,
+			phba->fcp_embed_io, sli4_params->nvme,
 			phba->cfg_nvme_embed_cmd, phba->cfg_suppress_rsp);
 
 	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
-- 
2.26.2

