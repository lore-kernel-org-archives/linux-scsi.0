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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E289AC07E9E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15BB61CCC
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhGGSqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhGGSqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA24C061574
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 21so3059321pfp.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZX+01/RsrYeGVUO4Kq8ptwF8Yi7g6UA416e5Z9MjXPY=;
        b=bN5LgSDawzh2Q8dZTPFTq0/0XxebkqNIK7QcMNrdZKj9IbWdyN9ZGrMLFqN2KNwVxa
         4PFaldb9Dnx1o9FMf1aNRyiYk7PyVYQ7sb1k1AQ7ZU09QubUQYAhkzRkJ/X899J8Pv+c
         +nTp8wFtMqNBmRgBiOjI+8e7m6sL/gosgJfGVuUQeSDO1aYCNSFprNuEaBJ4D5ZD/K/B
         eKt3+hZ1L90w5avpFrCtwy5tAkPOMexK1wGNEtGRyXAYPxMbVk4KggvBuowKzvXj5c65
         jWs7+qJ1aIqxqnUYE/cbDnwLwhVn1eqT48W8YeI9drakEH6XIU1+9gQX67IsgHIrCu9p
         phCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZX+01/RsrYeGVUO4Kq8ptwF8Yi7g6UA416e5Z9MjXPY=;
        b=ZQhJQBBb5mo4pMXBdcdIxyRjghlnOIHit5gwi7bwGYuKwFWc13N7awghh/kzroffJm
         N7l/+nCtfDV5HebHIvr/7kBm4VlHehxnv2ewklZdqld+T4boKX1+3QH41I+6lPm61cxg
         SNAB6P2KN5dcDvrYCJyf1aG/WMqMyueEn0S5sqPDUQhR8Va8Po7v2mVCGUh3QdmXkDnk
         b53A47e3hajxLDoQu9+8C2zmaSoL8skw1KYVAO9HaJ0ueJEgipjbB/+EntLy9fZV++MX
         S93f5Hivt1dUSakjCdc1YieNVig+/Y9Vq5WepWYuXAusx1seXt/x+tb8xUELC4SRIPuv
         rz3g==
X-Gm-Message-State: AOAM533vPBHq6KRQGWMWwG5teTuqIo9uosPJann9maknCSSPJROaS4ox
        9NZ9L1XZFZRcZ0In1+l5waY1t6r2asA=
X-Google-Smtp-Source: ABdhPJwod9NGPRS2Tsaxm6Eu7mU7EECyuzQPHwxVjI8lnF+e0M46+x4o4LhsWcszG1gjdAPu4SOH/g==
X-Received: by 2002:a63:4242:: with SMTP id p63mr8170036pga.185.1625683443360;
        Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/20] lpfc: Clear outstanding active mailbox during PCI function reset
Date:   Wed,  7 Jul 2021 11:43:43 -0700
Message-Id: <20210707184351.67872-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mailbox commands sent via ioctl/bsg from user applications may be
interrupted from processing by a concurrently triggered PCI function
reset. The command will not generate a completion due to the reset.
This results in a user application hang waiting for the mailbox command
to complete.

Resolve by changing the function reset handler to detect that there was
an outstanding mailbox command and simulate a mailbox completion.
Add some additional debug when a mailbox command times out.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2d277979a56a..bd3742035e76 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1852,6 +1852,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 {
 	int rc;
 	uint32_t intr_mode;
+	LPFC_MBOXQ_t *mboxq;
 
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 	    LPFC_SLI_INTF_IF_TYPE_2) {
@@ -1871,11 +1872,19 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 				"Recovery...\n");
 
 	/* If we are no wait, the HBA has been reset and is not
-	 * functional, thus we should clear LPFC_SLI_ACTIVE flag.
+	 * functional, thus we should clear
+	 * (LPFC_SLI_ACTIVE | LPFC_SLI_MBOX_ACTIVE) flags.
 	 */
 	if (mbx_action == LPFC_MBX_NO_WAIT) {
 		spin_lock_irq(&phba->hbalock);
 		phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
+		if (phba->sli.mbox_active) {
+			mboxq = phba->sli.mbox_active;
+			mboxq->u.mb.mbxStatus = MBX_NOT_FINISHED;
+			__lpfc_mbox_cmpl_put(phba, mboxq);
+			phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+			phba->sli.mbox_active = NULL;
+		}
 		spin_unlock_irq(&phba->hbalock);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1abf63c85c4b..06ed8d0e6035 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8794,8 +8794,11 @@ static int
 lpfc_sli4_async_mbox_block(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
+	LPFC_MBOXQ_t *mboxq;
 	int rc = 0;
 	unsigned long timeout = 0;
+	u32 sli_flag;
+	u8 cmd, subsys, opcode;
 
 	/* Mark the asynchronous mailbox command posting as blocked */
 	spin_lock_irq(&phba->hbalock);
@@ -8813,12 +8816,37 @@ lpfc_sli4_async_mbox_block(struct lpfc_hba *phba)
 	if (timeout)
 		lpfc_sli4_process_missed_mbox_completions(phba);
 
-	/* Wait for the outstnading mailbox command to complete */
+	/* Wait for the outstanding mailbox command to complete */
 	while (phba->sli.mbox_active) {
 		/* Check active mailbox complete status every 2ms */
 		msleep(2);
 		if (time_after(jiffies, timeout)) {
-			/* Timeout, marked the outstanding cmd not complete */
+			/* Timeout, mark the outstanding cmd not complete */
+
+			/* Sanity check sli.mbox_active has not completed or
+			 * cancelled from another context during last 2ms sleep,
+			 * so take hbalock to be sure before logging.
+			 */
+			spin_lock_irq(&phba->hbalock);
+			if (phba->sli.mbox_active) {
+				mboxq = phba->sli.mbox_active;
+				cmd = mboxq->u.mb.mbxCommand;
+				subsys = lpfc_sli_config_mbox_subsys_get(phba,
+									 mboxq);
+				opcode = lpfc_sli_config_mbox_opcode_get(phba,
+									 mboxq);
+				sli_flag = psli->sli_flag;
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+						"2352 Mailbox command x%x "
+						"(x%x/x%x) sli_flag x%x could "
+						"not complete\n",
+						cmd, subsys, opcode,
+						sli_flag);
+			} else {
+				spin_unlock_irq(&phba->hbalock);
+			}
+
 			rc = 1;
 			break;
 		}
-- 
2.26.2

