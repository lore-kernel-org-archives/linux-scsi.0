Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D702CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D732089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeLcUkQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502569AbfJRVTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39306 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440269AbfJRVTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so4022480pgn.6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/4j4e0HI9J2WZnPNE+S/DjdSyQBA6C2TVWWVlanueFA=;
        b=MeLcUkQ0Q5qNUHvdyK6uZdi9ho+9cuNamDDvvKyEPUpcAAObHE8H1SmUVU0z5ZA1Mz
         501HNwR3GsTA1w77L9tBC5/IGxWuCVF2kP17IweF9pCVQ0EPDtNDgSJ3ha8zMVpKRG6I
         WWGgST+zzAdGVyYxsxocuUk6cwvxu0i3RXTJtpPCmT9+WXyF4Ip6FOSNV8EZu5qyET9Z
         LKIwd+muLu6s9WFtocUsGIA5QW8ZRIWrADS/bZFV0Gzg0T3vL1xuZRXXJxY5ngedI5tJ
         qdUUJ5M4wXUuHuMTUX81bmJ3SAtXP8+FzvZMW6kjlIzx6hyge0giQNTs97uDyqzz2kNG
         GvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/4j4e0HI9J2WZnPNE+S/DjdSyQBA6C2TVWWVlanueFA=;
        b=VZKfiNCuM+1+rIO1npJ7KIFhVxmAvPJwjEcRAna//cYMV8lUW5T9/As2iIOXEyqTsL
         Z3562PjA/u/6VAbEkcYE/wtE7tzM4zopuMsaYIGuw8+IlqzRFAQTc1NqBGFnwm8xyO79
         0i22HAvCaCJoYxb/GcWTgZwhbOs0ZyBgRBq8ZnNDdR2CE3aeENpTsS/3sYfTa+2r1cJT
         HNaGTZ1+0PUaq7HwMIG1dZg0/AvVuZjMT8V+cZAUaJQBNmfT61/d7HR89YcY8VFkS7o8
         g3f9zr//uVNne7ITgaUc+iJppyq0lPu3fdCempXdloXsTDfVF1LiCB2hfuu237QxnkNB
         4saA==
X-Gm-Message-State: APjAAAUPN2K7rP/w0TIHh1N2+ShuQap/EGqV3tnKLyEcjYoHczu1odRE
        nVJ770+ZiwBexoR9/KoV79n/A8lo
X-Google-Smtp-Source: APXvYqyJ+9ek7qVZP1pdW+8eQR2v4VT7yyRDyzZDUsp4/CfYMq565kBOMVY9gBdzOqXqc1c74eNdOg==
X-Received: by 2002:a63:2350:: with SMTP id u16mr367549pgm.103.1571433542410;
        Fri, 18 Oct 2019 14:19:02 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Zhangguanghui <zhang.guanghui@h3c.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/16] lpfc: Fix hardlockup in lpfc_abort_handler
Date:   Fri, 18 Oct 2019 14:18:22 -0700
Message-Id: <20191018211832.7917-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_abort_handler, the lock acquire order is
hbalock (irqsave), buf_lock (irq) and ring_lock (irq).
The issue is that in two places the locks are released
out of order - the buf_lock and the hbalock - resulting
in the cpu preemption/lock flags getting restored out of
order and deadlocking the cpu.

Fix the unlock order by fully releasing the hbalocks as well.

CC: Zhangguanghui <zhang.guanghui@h3c.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
Original patch sent by Zhangguanghui <zhang.guanghui@h3c.com>
Modified slightly as merged and tested at Emulex.
---
 drivers/scsi/lpfc/lpfc_scsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 13e3e14b43f9..e4ec2b99b583 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4848,20 +4848,21 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		ret_val = __lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
 						abtsiocb, 0);
 	}
-	/* no longer need the lock after this point */
-	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	if (ret_val == IOCB_ERROR) {
 		/* Indicate the IO is not being aborted by the driver. */
 		iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		lpfc_cmd->waitq = NULL;
 		spin_unlock(&lpfc_cmd->buf_lock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_sli_release_iocbq(phba, abtsiocb);
 		ret = FAILED;
 		goto out;
 	}
 
+	/* no longer need the lock after this point */
 	spin_unlock(&lpfc_cmd->buf_lock);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
-- 
2.13.7

