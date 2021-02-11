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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAB4C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA56964E55
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhBKXqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhBKXqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B19C06178B
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:56 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u143so4719490pfc.7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZL1LkwD18z6aGBFteC5gfoTijG8gZJiJAt/JaELU8k=;
        b=TPkWoXHr1j98gngpzFMpnu6WdpAA1bTJccdDuRofJB6GpELQqjHBg20Qr64V103PF0
         RQ4oXyGFCtiNKoO0X8EUjbylxeG7VA7kWUJ4zOfaf2Je0Pb6ZAxGLH1mjIxZoE46hkXw
         IKlelmzEFNSodHGZcS8b1HyJGTxxkTP267tjZWBzhU05+p35szdD83b2g2ltzvvz5iZs
         3cx5RbnEjID3UMp7DHjcFQ8KyoS6+Vm3m8xxBulg7cUJ25YYUJXh8GUhMXrk1nZTcaue
         pFgnMwBFBEcZ9TonGPw2FddgYEw21AhTHtQ8R8RMC9zgbj9oz2won0f1t0MUlBZXsxRj
         4QXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZL1LkwD18z6aGBFteC5gfoTijG8gZJiJAt/JaELU8k=;
        b=SthJxtwSVY1pHN7BzF3q/JOCNyikBN+PIHlqBAHSqg0pYFpFWfwV5KHx+M0268ZQwp
         93oPBxcXe2kSFYGwQu1yflx5XgqaDMF9ZnAL0Tvx0IloZvnfTj2mMJqkeqdpWFLPemmX
         zA2rCL2faM9YxUF3LPMkk+vP2VSXAhEu99TmHI0TuymDCL5C6rwUjQnZ0KM3Y6dbzycx
         bSnHP0mWaMU0HwIY0PuviiyLYkWnk8jusE8c0KQjJ9s7oydv+7o1HI2+XK164LQN+F7M
         Ul1m6e9yuIux/VPaX+agObopjAu2xrIeLCbAlXrI7r9x/cMynsEwxsYeir52NrBpDMcS
         uxMQ==
X-Gm-Message-State: AOAM5300RV/1r5HcnkdSBoE66UqOHF1aQO8iAqhzzCwnCMivxQrf5njS
        kMb1zdGTCO2NOHR84AJy8K/MHlqZNgY=
X-Google-Smtp-Source: ABdhPJwgNQDE9NHaHesI4zjwksUpLEjZPnuNeud6jzVduG7VKcCoR57tmQG5nA/JjzxLS1RVbcziHA==
X-Received: by 2002:a62:87c1:0:b029:1d6:2bf4:8699 with SMTP id i184-20020a6287c10000b02901d62bf48699mr172517pfe.79.1613087096059;
        Thu, 11 Feb 2021 15:44:56 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:55 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/22] lpfc: Fix pt2pt connection does not recover after LOGO
Date:   Thu, 11 Feb 2021 15:44:28 -0800
Message-Id: <20210211234443.3107-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a pt2pt setup, between 2 initiators, if one side issues a a LOGO, there
is no relogin attempt. The FC specs are grey in this area on which port
(higher wwn or not) is to re-login.

As there is no spec guidance, unconditionally re-PLOGI after the logout to
ensure a login is re-established.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 135d8e8a42ba..4918423960d6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -913,9 +913,14 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_type & NLP_NVME_TARGET) ||
+		(vport->fc_flag & FC_PT2PT))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node */
+		/* Only try to re-login if this is NOT a Fabric Node
+		 * AND the remote NPORT is a FCP/NVME Target or we
+		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
+		 * case for LOGO as a response to ADISC behavior.
+		 */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(&ndlp->lock);
-- 
2.26.2

