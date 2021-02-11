Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21DCC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9592D64E4B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBKXqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBKXqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:13 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BBBC06178A
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:55 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e12so4199842pls.4
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zhDbERjnRmiM49WXN7dEXqlbpcDkCM0b4Sdwvgro+1c=;
        b=ahYGaw9mq4w0b6ruKubyaHKp/+Yut3Aq2lOVKUbKUo2SMEboleQsBqoH9biS8nFN7+
         rFu5oNE3Piehostg9y/e80P2WlScOW5dJaS6iXqKsx9EMrkoaG2qcyOJ5twGGV0DAaVS
         sApeWsufySCbJqE11a/zDAvsSSEcZ9B22dOnxb38eQQ4FNUDVp+DRbWUZfxaIs29WMJ0
         BMo75E1rPXqs7PjLN9SGtkJDfK9v27TNNmUGUN93lg4UB4ypAIi7IfZzl2o5Vvc7jJeC
         8pon7isL1U9ifIbZfP3CO3eszgNwXo6EMLDN1U+u5Kj4Jdua5iFENFcfAB5Z8ZI1h9w+
         j4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zhDbERjnRmiM49WXN7dEXqlbpcDkCM0b4Sdwvgro+1c=;
        b=QhTpOoYbX7EVgUhpPRc/DZgPYvmhpp6SMovX9sk7dRX2Ty/OjSvjlvtCSw+IMEJp1G
         a8svX24mMDl3Ze7LwLDCqMQr46AJJyIpIdZo1CSW4kQrN1HU5cqKldX0Es3GIsLMqB7a
         43dQBCfbBY7nFfDr5KFdYNgMhXCILtnPW8+A7zOgokogiN6EzRByqDsXpziQFschaqrs
         pXiyoyhmrfJTr7XagzVeu49lR0kCRJIv2OHmsL4MtqmATPA1IhXMt2hu+bDWmgoQRIZ3
         PcTeGpqTaDBcChgqxnUJWLgALho78BdFRqqdsS1eWhIevVxfpXhdBliBTSh4K/anxXBJ
         4QIw==
X-Gm-Message-State: AOAM531BHE1xEB+bK4ukupVq9qvqU8B1ZzXQBbX/FAAbECjqjC7wOi1P
        +iQQA1eEOPZncGrlYlstJHbPjlBG8jQ=
X-Google-Smtp-Source: ABdhPJzj/SWUEW5KsH73EugigUQF1US6plFTBoutoeLEXaNv3cfwWQ1aZVrXMgIedizB35BC09HxVw==
X-Received: by 2002:a17:902:bd0a:b029:e0:612:ad38 with SMTP id p10-20020a170902bd0ab02900e00612ad38mr514050pls.30.1613087095414;
        Thu, 11 Feb 2021 15:44:55 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/22] lpfc: Fix lpfc_els_retry() possible null pointer dereference
Date:   Thu, 11 Feb 2021 15:44:27 -0800
Message-Id: <20210211234443.3107-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver crashed in lpfc_debugfs_disc_trc() due to null ndlp pointer.
In some calling cases, the ndlp is null and the did is looked up.

Fix by using the local did variable that is set appropriately based
on ndlp value.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 780b4c1e98eb..788cb5d9054c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3823,7 +3823,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Retry ELS:       wd7:x%x wd4:x%x did:x%x",
-		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4], ndlp->nlp_DID);
+		*(((uint32_t *)irsp) + 7), irsp->un.ulpWord[4], did);
 
 	switch (irsp->ulpStatus) {
 	case IOSTAT_FCP_RSP_ERROR:
-- 
2.26.2

