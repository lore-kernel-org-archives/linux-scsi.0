Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35846C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139ED2098B
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TseZztWj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH1Rxt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgH1Rxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 13:53:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A3C061233
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:42 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id z15so12417plo.7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6kJrkOqIhUPLbDJEjgvg/myb8qkNDbKsmrMpQ/tHOw4=;
        b=TseZztWjqqSFGaom7dwnF5Xi/w9rbYux0BRGoopPvMHKkCL/2H9WkOFZGgxGNh20pM
         OfIGLTG8FIfwVYvNaqxB58zM6Mqp1SKgYbYmbLVkk75hceu4F4C9vo1Ykw2h64mFsysu
         7KCzThWt6Xn7lGv8icJ+FCk/9xBppenW2xmfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kJrkOqIhUPLbDJEjgvg/myb8qkNDbKsmrMpQ/tHOw4=;
        b=gGeCnv/CKKWBfrOpXAYoMVaWteiGnbpg14s2ovfsFztXqxh3M9ViuFhZ8claWXh2jc
         nbVCl1iHAX+hprjaL20qicMVcLY/XzW5waS+FFP1Sm2q5gsdlmGj1iwG0dIkFkXBAKwj
         V9A8rxE09IXWq4LzxMDx1tSIbZIrpdV3dXr4/3L0tmkGFVCZtgs5EKxyOESTMuTp1dwk
         /5doY4GUTTbrwfOrxCEKIqIGVR0KDLhGD5BSqy2HbNnT1AylS1JTQlIhf86LSzm6PTEe
         c6krpPzWY3+Fe29+fWMH1zmFdAmIp/xNeUhsC/8TIMvvwcDVXexG3WXDH6L4dvNj6dvO
         uk/Q==
X-Gm-Message-State: AOAM531kfrR88fYFzOMzJtjB9cyT9DK8aaImANa3fQGbFpxlGKisQmkW
        +q2+SbJt6wBKPphAZ0VaSVuEgJWey74fvZFpuc9h/JS4fTNExNp6LTjBXbmyvliSzx+71C5Qt9u
        yRZvOd5Hi3NHL2yRZHQ5xr3sXesvkgjSlrYUcJZ1xqvyxlOBXEUHwMqRrdPyFP3QZgRrgb0SboW
        0zHPc=
X-Google-Smtp-Source: ABdhPJzUqVXJw/J728dLG/BcFdyP9xrA+X7qr8H6MBsTRuQX71x1NENwKFTys4rMgorX51h1jYlnNQ==
X-Received: by 2002:a17:902:fe8e:: with SMTP id x14mr40924plm.85.1598637221133;
        Fri, 28 Aug 2020 10:53:41 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:40 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/4] lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
Date:   Fri, 28 Aug 2020 10:53:30 -0700
Message-Id: <20200828175332.130300-3-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is unable to successfully login with remote device. During
pt2pt login, the driver complete it's FLOGI request, with the
remote device having WWN precedence.  The remote device issues its own
(delayed) FLOGI after accepting the drivers, and upon transmitting the
FLOGI, immediately recognizes it has already processed the driver's
FLOGI thus it transitions to sending a PLOGI before waiting for an ACC
to its FLOGI.

In the driver, the FLOGI is received and an ACC sent, followed by the
PLOGI being received and an ACC sent. The issue is that the PLOGI
reception occurs before the response from the adapter from the FLOGI
ACC is received. Processing of the PLOGI sets state flags to perform
the REG_RPI mailbox command and proceed with the rest of discovery on
the port. The same completion routine used by both FLOGI and PLOGI is
generic in nature. One of the things it does is clear flags, and those
flags happen to drive the rest of discovery.  So what happened was the
PLOGI processing set the flags, the FLOGI ACC completion cleared them,
thus when the PLOGI ACC completes it doesn't see the flags and stops.

Fix by modifying the generic completion routine to not clear the rest
of discovery flag (NLP_ACC_REGLOGIN) unless the completion is also
associated with performing a mailbox command as part of it's handling.
For things such as FLOGI ACC, there isn't a subsequent action to perform
with the adapter, thus there is no mailbox cmd ptr. PLOGI ACC though
will perform REG_RPI upon completion, thus there is a mailbox cmd ptr.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
 drivers/scsi/lpfc/lpfc_els.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 48dc63f22cca..abc6200d8881 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4656,7 +4656,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
+		if (mbox)
+			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
+		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(shost->host_lock);
 
 		/* If the node is not being used by another discovery thread,
-- 
2.26.2

