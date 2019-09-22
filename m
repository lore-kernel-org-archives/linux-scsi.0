Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28E5C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84EE720820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kT7KvcgY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfIVD7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:24 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40010 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfIVD7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:24 -0400
Received: by mail-oi1-f193.google.com with SMTP id k9so4987067oib.7
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5uByuQfmU72DILq8G8vM07e52H8+P40QlWgkMqYO8yA=;
        b=kT7KvcgYUkutlSakex7cZzUy+ybICf3mHQSBfoYpUFrkPNMToGUjmeG0fm1K7uLsHK
         V3ZEWq0wrsOWEbQfBLeFAYojzkANM4cixGFuf3nqpBuq8H6XDjrOhtglBvX+Pg+cing0
         6FZWWhUauU6J2j/ZsBULLAFg5FuWbxhlVEFtN5fqOcNczXSuKyHSdMAZ9/qRQLkE0T54
         8g0ogybvqv2jI9EuX2Rbst4bIJfB1jFESD6G2O3GkAgvqrMeMGhKUMYT8CzlaRwiHp9q
         2S0gugREbJWjJ9O6fi+4mDRIBLxYb+nFp3SWypljFJnlRXmgPRyJhccgjp3KMpYJ2ZEf
         HlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5uByuQfmU72DILq8G8vM07e52H8+P40QlWgkMqYO8yA=;
        b=UYNjpvlbXiepDW6WckdXpvcUoHHlOicmluiviX9Lq3UoPRAEuKLrUT9PqRStOs01aY
         sD5aUmedW+lXN+i7vzZLRCqSFrfThcV80IIcJ4/m3zMf82vMIt7WQ068Ra53asp9tNdk
         WdtwXjj+Q46Y0x1eORGH1KaUc+mDzSbZWDp56meylqK+AJQ4ixo++M6E4IxNvFeO87Qi
         2CeN7zDism94Ih8/UqCm+PFmSeXbjmJdJcnxoDV2DvwlaAj8UwWugxSRq6qEVnVQCZjP
         5tb3TNtQ9dj9nAMGYZrIAfcXhcGFPJf4yOaVpu2K7xUHpcIy5XjS7vQrbd/EDOVsMVkZ
         0YGg==
X-Gm-Message-State: APjAAAXpyrjyQiEbaNImNmvRDg7cDSqFBbCabnVgmcOEKviQ9dgZ2dDa
        cHG4PfoL5/FbxmipGJzRnbyMGnAS
X-Google-Smtp-Source: APXvYqxT770PQ9L07o6Yqxwl7RehreGIOBPga6tlPwvyZa9tTgwoZIH7QhoE3hCPfiVHUZbULzfT9Q==
X-Received: by 2002:aca:eb09:: with SMTP id j9mr9483455oih.105.1569124762778;
        Sat, 21 Sep 2019 20:59:22 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/20] lpfc: Fix locking on mailbox command completion
Date:   Sat, 21 Sep 2019 20:58:53 -0700
Message-Id: <20190922035906.10977-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Symptoms were seen of the driver not having valid data for
mailbox commands. After debugging, the following sequence was
found:
The driver maintains a port-wide pointer of the mailbox command
that is currently in execution. Once finished, the port-wide
pointer is cleared (done in lpfc_sli4_mq_release()). The next
mailbox command issued will set the next pointer and so on.
The mailbox response data is only copied if there is a valid
port-wide pointer.
In the failing case, it was seen that a new mailbox command was
being attempted in parallel with the completion.  The parallel
path was seeing the mailbox no long in use (flag check under lock)
and thus set the port pointer.  The completion path had cleared
the active flag under lock, but had not touched the port pointer.
The port pointer is cleared after the lock is released. In this
case, the completion path cleared the just-set value by the
parallel path.

Fix by making the calls that clear mbox state/port pointer
while under lock.  Also slightly cleaned up the error path.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 24d6779a99f8..313441a3c4cf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13165,13 +13165,19 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 	/* Setting active mailbox pointer need to be in sync to flag clear */
 	phba->sli.mbox_active = NULL;
+	if (bf_get(lpfc_trailer_consumed, mcqe))
+		lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	/* Wake up worker thread to post the next pending mailbox command */
 	lpfc_worker_wake_up(phba);
+	return workposted;
+
 out_no_mqe_complete:
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (bf_get(lpfc_trailer_consumed, mcqe))
 		lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
-	return workposted;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return false;
 }
 
 /**
-- 
2.13.7

