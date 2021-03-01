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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310D1C43333
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17FE26506F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhCARWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbhCARTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:13 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA6C06178C
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z11so2624984plg.10
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbatkMSVbUopcokVxWAhNn1UtR3b4MgPK5z4aAf7LtE=;
        b=LGHrtNvSySFXJR8nFlIAvJ1h/A7zgZQhOh0ZTVLiaKUNYj8uwwb3eqAGZdlXkWUJOt
         s4N3ibyuGJ1knjHIvzL140qJ2sPUC5V1cX0dsPigQq5Vt+9A2ElmdGRna/Zrq4vEyjPF
         xURSJsDLT6pnAPTiWV3w4SFBW8NtPunaenw7tzSdcsq4LdYbNlbQYOspWWDvtbptD+Ig
         /WlFOSJ4N9vHjL8IELPLjZikN8sbClnIBdSpm86IQQSxSpED41QWBeHKooDQeF+eEjEO
         Bzae7RVkBLftfjnCRVydXvqK+YARoLFTdOrignDNiRH5OWDhRBn0XbMTMipaqHZ3wvUE
         pgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbatkMSVbUopcokVxWAhNn1UtR3b4MgPK5z4aAf7LtE=;
        b=CZBmQn4/wIZocsYGOGWZn3Sscu98Di95BfTtvqxL4s1s7l4FqYudnH64P8tnx1lNv1
         Fy6+G2d0RhgRAoc5qhY6LVr57XMd+Aca/9MLf6MzRBUIomIfUDMn6kIx9mFcDcdILNpA
         iFiLCqFFayRXzaOIvVPowZO8qDnjPvjkNL7OWZjmYpkkjHkAXJSKG4HndJDOkdVqyFpm
         2WWw2vgn3zz1cyPtlA2JqUWg0EDfVbGgkoIkzfztnSQPK1eB1ptr+uFtBZdKYFFgd6rf
         HkfY0Sg/p2ef2nY0RXgG6SPk2Syu8sLiOr6VFLbIz3umYFhkyXR7r+3akJsks4a05ZsL
         AXVg==
X-Gm-Message-State: AOAM532HpTwYjDut/veNkLlHZrTbJqB3zkayjpvntm2WJELLDFnnMt/Z
        k4RfS3b5HGyCaQcsHTPtMt00oobO6ks=
X-Google-Smtp-Source: ABdhPJx6cW2J+gznrFWXSzEWN+6TYBTUAjY24mZTCbGdmJb039CoB6IZ9lQlSKuNdqp6VigoY8i51A==
X-Received: by 2002:a17:90b:92:: with SMTP id bb18mr18143611pjb.40.1614619110421;
        Mon, 01 Mar 2021 09:18:30 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 06/22] lpfc: Fix lpfc_els_retry() possible null pointer dereference
Date:   Mon,  1 Mar 2021 09:18:05 -0800
Message-Id: <20210301171821.3427-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
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
index 27e2f8136f73..e0454c53267b 100644
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

