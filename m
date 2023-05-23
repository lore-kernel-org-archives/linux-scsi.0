Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACBDC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbjEWSWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbjEWSWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6480A121
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae4048627aso6257585ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866140; x=1687458140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAfQ8b0tn94H81/5FybU8owxPv/I7hE3zdSO2lGGD1E=;
        b=eAVfrsiPiHXpvVYCGeOssmrEFkJrXcoMbChrgC490SUKW2yakTPyWEsXg3FmbSwG3e
         rB83qH0UeXxD8AoY3aPJzmIiXJdKrpEdabRERCM5PdC/p0xjkiEYoP10K7xHzEm9dD2+
         bgPu4zB+Ed/Kt5vg/YL79YUSziwdJj0CHfjegux8xU2vTJj3kR16JVDBkwMep/rkhTYC
         TZXW7duCVP9R7GgaW3jeMW2a1xOIfs7dNnB8vEXPeWI3GPpvPFkiJo+B41TlhlyH0NId
         xSHOjKhHno7tt9ZY3V0NgMTGLWDtosb7tNf/Z1c4177U/w+DFaF4NuXu0q77H6GgxTDe
         Ey2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866140; x=1687458140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gAfQ8b0tn94H81/5FybU8owxPv/I7hE3zdSO2lGGD1E=;
        b=BWP/Q8MHJaYY8lvjotKEi8KXcI5hqLbPx5u3Jhh42Llax03Vu10LF0ziub03oEJKFC
         TTS1+S2oL1HS2BtYppezG93+M4TBxkq8aYraRHe8mfN6aF/LhPDyEPWU1JzGKuoZzy3+
         4IbFMyq6Ps0pTWtFGAwx0ncZ0ovwEQnYneu58PGYvgufXujtArVEbRj/+WQSN/H7lSRp
         vU58qJ2N8n7c/dA6FYZQJfUwmal8T/Iq3HoXzF/RJcJ/o+j+JndOWGZVa5V/v0sXEvSn
         zahFL3rNxxwxq40nSCaE3dwGi3It6MFrd2RTLb8BNGq6KsBTtNpQqpJgQphpbWe/8CYa
         xKvw==
X-Gm-Message-State: AC+VfDyuzQ7XZpLIaf5xU+fINvZTCAOQEUmt9vKwJm5/IpshY7+8ddK6
        bkH6BCY9gb4A0ERFkh8abS4BuZ6Hxtg=
X-Google-Smtp-Source: ACHHUZ5lJDubQA+UGDBkw+FANAUQxcsd+C7+asahe/V3QNcQIecoPk7emfwAv+p+7Nv9wMZiizvGRw==
X-Received: by 2002:a17:902:d4c2:b0:1ac:656f:a68d with SMTP id o2-20020a170902d4c200b001ac656fa68dmr16281937plg.4.1684866139887;
        Tue, 23 May 2023 11:22:19 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:19 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/9] lpfc: Account for fabric domain ctlr device loss recovery
Date:   Tue, 23 May 2023 11:32:00 -0700
Message-Id: <20230523183206.7728-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pre-existing device loss recovery logic via the NLP_IN_RECOV_POST_DEV_LOSS
flag only handled Fabric Port Login, Fabric Controller, Management, and
Name Server addresses.

Fabric domain controllers fall under the same category for usage of the
NLP_IN_RECOV_POST_DEV_LOSS flag.  Add a default case statement to mark
an ndlp for device loss recovery.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f99b5c206cdb..a5c69d4bf2e0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -458,11 +458,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	if (ndlp->nlp_type & NLP_FABRIC) {
 		spin_lock_irqsave(&ndlp->lock, iflags);
 
-		/* In massive vport configuration settings or when the FLOGI
-		 * completes with a sequence timeout, it's possible
-		 * dev_loss_tmo fired during node recovery.  The driver has to
-		 * account for this race to allow for recovery and keep
-		 * the reference counting correct.
+		/* The driver has to account for a race between any fabric
+		 * node that's in recovery when dev_loss_tmo expires. When this
+		 * happens, the driver has to allow node recovery.
 		 */
 		switch (ndlp->nlp_DID) {
 		case Fabric_DID:
@@ -489,6 +487,17 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			    ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE)
 				recovering = true;
 			break;
+		default:
+			/* Ensure the nlp_DID at least has the correct prefix.
+			 * The fabric domain controller's last three nibbles
+			 * vary so we handle it in the default case.
+			 */
+			if (ndlp->nlp_DID & Fabric_DID_MASK) {
+				if (ndlp->nlp_state >= NLP_STE_PLOGI_ISSUE &&
+				    ndlp->nlp_state <= NLP_STE_REG_LOGIN_ISSUE)
+					recovering = true;
+			}
+			break;
 		}
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
 
-- 
2.38.0

