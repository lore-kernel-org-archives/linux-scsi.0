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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B1DC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D31C610A4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhDJRbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbhDJRbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD210C06138B
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id z16so6184688pga.1
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gP9wNUXc4kAE6L7aFb9sd9dN4PP4N6os4PyM3+THgY0=;
        b=f+FQF125PLqDQWOVPkSfGMvcLOHADhuxHjzJMEyNbdhp944Fd9WtowwI8nmi/Wl7EX
         EDb7FbyzTSWefdVZT7JQHGM/VLjepYWqEfxkT56O4yVbrBWyKtjl/3++OPzS5vD9ml9E
         3RvQcr47yIyXaUw91EGZLr9Hae5Z65ZL1ljKAnsbXss690PxDPwxBesZ5/4Lo+Ecqs1a
         kekVzDooI00K6Ob/gUMKf/JuUbLEiegNQGD25wFvHV0pS3DOy812p5AEFjXtrOKJWHuP
         GlcfkpSxrgqUI0PmCB6MKNweIU12dJC3LIKMyd8QAENZj9feFqW/W4oBHSx0eQLs9sI+
         Hqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gP9wNUXc4kAE6L7aFb9sd9dN4PP4N6os4PyM3+THgY0=;
        b=WDJW4G8NDbyU6tCKYjm8Wv0bjvsxtgVxqMit1IGkpKDSQdAA6tLs6H9r/XZ6zrd9lD
         vt+IDvJGYg+zNryqM7826M/XRrZrzQblu8NxCquCVgJBwa2OWI0wMabClfOo3YVQ0o/M
         FvGeQDjLC8Mc6lOdEUDTgQpRHJ6VPkIajI5qlXvHkwI0hRSEvSlJvPdd9T3uoEJNQ9nf
         WfxD2zGdml3JxpAue5Q5RMLQqNtq6UJnqgtMiMEGcnnP633r+CiJNusF9c0yn/0XGVVd
         htHmVQfw+TDu2fiy5QHUB+xoJ4L0ismapz+KDrbkVFCLj3r0Gub4BqGo0GOm19Mac5va
         SdPQ==
X-Gm-Message-State: AOAM533atpBiG8ZoNCbJCrfKRl3Y7FPtf7dFvCVTGMHWD+/woobyZBUi
        LYO4McQ6wlFX9s3P1S0FcqL/appikMg=
X-Google-Smtp-Source: ABdhPJyTKpssMMXAJnLeSV+uJ29VL1E4VFrzG0JOIP3qz7n7h/AkrPriyU+0sT9fVx8WR2CB2FL0Yg==
X-Received: by 2002:a62:168b:0:b029:20d:69a5:189 with SMTP id 133-20020a62168b0000b029020d69a50189mr17521696pfw.57.1618075847334;
        Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:47 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/16] lpfc: Fix lack of device removal on port swaps with PRLIs
Date:   Sat, 10 Apr 2021 10:30:23 -0700
Message-Id: <20210410173034.67618-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During target port-swap testing with link flips, the initiator could
encounter PRLI errors.  If the target node disappears permanently, the
ndlp is found stuck in UNUSED state with ref count of 1. The rmmod of
the driver will hang waiting for this node to be freed.

While handling a link error in PRLI completion path, the code intends to
skip triggering the discovery state machine. However this is causing the
final reference release path to be skipped. This causes the node to be
stuck with ref count of 1

Fix by ensuring the code path triggers the device removal event on the
node state machine.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e71b37608f60..8a8d949979c8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2233,9 +2233,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp))
-			goto out;
-		else
+		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
-- 
2.26.2

