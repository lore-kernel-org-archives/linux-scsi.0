Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB37BC32756
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 08:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE422085A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 08:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHv5Or8e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfHLIbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 04:31:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41586 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHLIbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 04:31:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so47434586pls.8;
        Mon, 12 Aug 2019 01:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GkXc2q6hrKT3n5tKIOqt3FKeJIiJ+UpY638YqYejrko=;
        b=nHv5Or8eGV6zJWYGj930jnePCX274A1UNwnrFU1OCWtmOI5K8gVQo46jqobYxJLJMG
         gyhR2Lm92hfXVz1M6QgpSeC6uv85D/MN1PNLsAGqRRFz2I29w6d90EMgFMzEXSRandZE
         RLEWH3SvOHQ/weg4HgPL1+c/yIMfNIvnBHCDweZ28QH14I0iKYFPb3bKqqYrXdrPpZdS
         bFKDkbazfc4NNmanPJmfRRmZgAeUmplIPxBzI3f+w71Wa4O+hzRpExcYpqNnnHcWLDLj
         1cQnfHGvR6EcL3MbZKIcODoSTSB4B+5gTB6YGGJwBVj4eyjOuSfWo+SjEKpeirDUXKbd
         dGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GkXc2q6hrKT3n5tKIOqt3FKeJIiJ+UpY638YqYejrko=;
        b=aOzmMdCMe2jHRkOaQ5G72l/R9qoLa5QTjl4z+mUUo22FHNQJvbhqhqqYozYhRpstb3
         uLl+Bd81leQw1GJQD+Vn6dCTQ57SLsG09ElEmLLcQxqdqs0AKLxumdL1eAo4ky5fmPqN
         u4FPbBOm5Nz5kkgu4E585zXhYjUljb5kstoHjAc5U4JpmEfWhnV1Iq+dJmDpGrFFKP4a
         Z4VL5cdR8Sd1Tvr4W2BH8seQoFrpcxmJgVWZHosNEOPiAv5ypXM4yo8KiwrxQvPMHR0X
         SWaMCi/9r6DCEImiZd4Tcg3AiX0ojsnVZTVjZ1Aq7R7dt2ORgvlsndZ+6WA6vSf3GjDr
         SIxg==
X-Gm-Message-State: APjAAAU6Iyv2EjKkAx9L008XyQzvHIprMQeD4sOhW8nxKnWg8Pn+J5DS
        34vvL9tyX7AjG8LcOxt6k5k=
X-Google-Smtp-Source: APXvYqzDrULP/oJzmzyREYSwdnYyvzp7mxxgjDbGZr1nn/ZwUPLGo0KeKQdor5FN7PQP5LRHg8vnbg==
X-Received: by 2002:a17:902:e30b:: with SMTP id cg11mr32341992plb.335.1565598711739;
        Mon, 12 Aug 2019 01:31:51 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id w2sm9100203pjr.27.2019.08.12.01.31.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 01:31:50 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH] scsi: lpfc: use spin_lock_irqsave instead of spin_lock_irq in IRQ context
Date:   Mon, 12 Aug 2019 16:31:34 +0800
Message-Id: <20190812083134.7033-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As spin_unlock_irq will enable interrupts.
Function lpfc_findnode_rpi is called from
    lpfc_sli_abts_err_handler (./drivers/scsi/lpfc/lpfc_sli.c)
 <- lpfc_sli_async_event_handler
 <- lpfc_sli_process_unsol_iocb
 <- lpfc_sli_handle_fast_ring_event
 <- lpfc_sli_fp_intr_handler
 <- lpfc_sli_intr_handler
 and lpfc_sli_intr_handler is an interrupt handler.
Interrupts are enabled in interrupt handler.
Use spin_lock_irqsave/spin_unlock_irqrestore instead of spin_(un)lock_irq
in IRQ context to avoid this.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 28ecaa7fc715..cf02c352b324 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6065,10 +6065,11 @@ lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
+	unsigned long flags;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, flags);
 	ndlp = __lpfc_findnode_rpi(vport, rpi);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	return ndlp;
 }
 
-- 
2.11.0

